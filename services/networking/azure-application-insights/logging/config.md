# Logging Configuration: Azure Application Insights

**Service**: Azure Application Insights
**Category**: Networking
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-3, AU-6, AU-12
**OMB M-21-31**: EL1 (Basic) for operational telemetry

---

## Diagnostic Categories

Application Insights collects application performance telemetry across 11 diagnostic categories. ALL categories below MUST be forwarded to the centralized Log Analytics workspace via diagnostic settings.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| AppAvailabilityResults | Results from availability (ping) tests configured for the application | EL1 | AU-3, AU-12 |
| AppBrowserTimings | Client-side browser performance timings (page load, network latency) | EL1 | AU-3 |
| AppDependencies | Outbound dependency calls (HTTP, SQL, Azure services) with duration and success/failure | EL1 | AU-3, AU-12 |
| AppEvents | Custom events emitted by application code | EL1 | AU-3, AU-12 |
| AppExceptions | Unhandled and handled exceptions with stack traces | EL1 | AU-3, AU-6 |
| AppMetrics | Pre-aggregated performance metrics (request rate, response time, failure rate) | EL1 | AU-3 |
| AppPageViews | Page view telemetry from browser-side SDK | EL1 | AU-3 |
| AppPerformanceCounters | Server performance counters (CPU, memory, GC) | EL1 | AU-3 |
| AppRequests | Inbound HTTP requests with response code, duration, and success/failure | EL1 | AU-3, AU-12 |
| AppSystemEvents | Application Insights system events (sampling changes, data cap reached) | EL1 | AU-3 |
| AppTraces | Application trace/log messages emitted via SDK (ILogger, TrackTrace) | EL1 | AU-3, AU-12 |

---

## Telemetry Flow

```
Application SDK → Application Insights Component → Log Analytics Workspace
                  (workspace-based mode)              (shared, centralized)
```

- **SDK**: Application Insights SDK (or auto-instrumentation agent) collects telemetry
- **Component**: Workspace-based Application Insights component receives and processes telemetry
- **Workspace**: All data forwarded to shared Log Analytics workspace for unified query and retention

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace (workspace-based App Insights) | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the Application Insights component with `workspace_id` pointing to the shared Log Analytics workspace. Diagnostic settings in `terraform/main.tf` forward all 11 categories to the same workspace.

### Configuration Note

```
Resource: Microsoft.Insights/components
Mode: Workspace-based (linked to shared Log Analytics workspace)
Application Type: web
Local Authentication: Disabled (Entra ID only)
Sampling Percentage: Configurable (default: 100%)
Daily Data Cap: Configurable (default: 10 GB)
Diagnostic Settings:
  Categories: AppAvailabilityResults, AppBrowserTimings, AppDependencies,
              AppEvents, AppExceptions, AppMetrics, AppPageViews,
              AppPerformanceCounters, AppRequests, AppSystemEvents, AppTraces
  Destination: Log Analytics workspace
```

---

## Retention

| Tier | Retention Period | Justification |
|------|-----------------|---------------|
| Hot (Log Analytics via workspace) | 365 days | FedRAMP AU-11 (workspace retention policy) |
| Component-level | 90 days | Application Insights default; workspace retention takes precedence |
| Archive (Storage Account via workspace export) | 7 years | FedRAMP AU-11 audit record retention |

---

## Alert Rules

The following alerts MUST be configured for application health and security monitoring:

| Alert Name | Condition | Severity | Action Group | NIST Control |
|-----------|-----------|----------|-------------|--------------|
| Exception Rate Spike | AppExceptions count > baseline by 200% in 5-minute window | Sev 2 (Warning) | Application Team + SOC | AU-6, SI-4 |
| Availability Test Failure | AppAvailabilityResults where success == false for 2+ consecutive checks | Sev 1 (Error) | Application Team + Operations | AU-6 |
| Dependency Failure Rate | AppDependencies where success == false rate > 10% in 5-minute window | Sev 2 (Warning) | Application Team | AU-6 |
| Response Time Degradation | AppRequests where duration > P95 baseline by 300% | Sev 3 (Informational) | Application Team | AU-6 |
| Daily Data Cap Warning | AppSystemEvents where data cap at 80% threshold | Sev 3 (Informational) | Operations | AU-6 |
| Authentication Failure Spike | AppRequests where resultCode in (401, 403) count > threshold | Sev 2 (Warning) | SOC + Application Team | AU-6, IA-2 |

---

## Log Query Examples

### Exception Rate by Type
```kusto
AppExceptions
| where TimeGenerated > ago(1h)
| summarize ExceptionCount = count() by ExceptionType = type, ProblemId = problemId
| order by ExceptionCount desc
| take 20
```

### Availability Test Results
```kusto
AppAvailabilityResults
| where TimeGenerated > ago(24h)
| summarize SuccessCount = countif(success == true),
            FailureCount = countif(success == false)
            by Name = name, bin(TimeGenerated, 1h)
| extend SuccessRate = round(100.0 * SuccessCount / (SuccessCount + FailureCount), 2)
| order by TimeGenerated desc
```

### Slow Dependencies
```kusto
AppDependencies
| where TimeGenerated > ago(1h)
| where duration > 5000
| project TimeGenerated, Name = name, Target = target, Duration = duration, Success = success, ResultCode = resultCode
| order by Duration desc
| take 50
```

### Failed Requests by Endpoint
```kusto
AppRequests
| where TimeGenerated > ago(1h)
| where success == false
| summarize FailureCount = count() by Name = name, ResultCode = resultCode
| order by FailureCount desc
```

### Authentication Failures (401/403)
```kusto
AppRequests
| where TimeGenerated > ago(24h)
| where resultCode in ("401", "403")
| summarize FailureCount = count() by Url = url, ResultCode = resultCode, bin(TimeGenerated, 1h)
| order by FailureCount desc
```

### Custom Event Analysis
```kusto
AppEvents
| where TimeGenerated > ago(24h)
| summarize EventCount = count() by Name = name
| order by EventCount desc
| take 20
```
