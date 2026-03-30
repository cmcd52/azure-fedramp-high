# Logging Configuration: Azure Functions

**Service**: Azure Functions (Linux Function App)
**Category**: Compute & Storage
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate) for function execution logs

---

## Log Collection Architecture

Function App diagnostic logs are forwarded directly to the centralized Log Analytics workspace via Azure Monitor diagnostic settings. Application Insights integration provides additional telemetry for function invocation tracing.

```
Function App → Diagnostic Settings → Log Analytics Workspace
Function App → Application Insights → Log Analytics Workspace (optional)
```

---

## Diagnostic Log Categories

All diagnostic log categories below MUST be enabled and forwarded to Log Analytics.

| Log Category | Description | OMB M-21-31 Tier | NIST Control |
|-------------|-------------|-------------------|--------------|
| FunctionAppLogs | Function execution logs including invocation details, errors, warnings, and custom trace output | EL2 | AU-2, AU-3, AU-12 |

### Metrics

| Metric Category | Description | OMB M-21-31 Tier | NIST Control |
|----------------|-------------|-------------------|--------------|
| AllMetrics | Function execution count, duration, success/failure rate, memory usage | EL1 | SI-4 |

### Application Insights Telemetry (Recommended)

| Telemetry Type | Description | OMB M-21-31 Tier | NIST Control |
|---------------|-------------|-------------------|--------------|
| Requests | HTTP trigger invocation metrics and traces | EL2 | AU-2, AU-12 |
| Dependencies | External service call traces (Storage, Service Bus, SQL) | EL2 | AU-2, SI-4 |
| Exceptions | Unhandled exception details with stack traces | EL2 | AU-2, SI-4 |
| Traces | Custom trace messages from function code | EL2 | AU-2, AU-12 |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting in `terraform/main.tf` targeting the shared Log Analytics workspace.

---

## Retention

| Tier | Retention Period | Justification |
|------|-----------------|---------------|
| Hot (Log Analytics) | 90 days (production) / 30 days (lower) | Active query and alerting |
| Archive (Storage Account) | 548 days (production) | FedRAMP AU-11 audit record retention |

---

## Alert Rules

The following alerts MUST be configured in the shared monitoring infrastructure:

| Alert Name | Condition | Severity | Action Group | NIST Control |
|-----------|-----------|----------|-------------|--------------|
| Function Execution Failure Rate | FunctionAppLogs where ResultCode != 0 count > 10 in 5 minutes per function | Sev 1 (Error) | SOC + App Team | SI-4, AU-6 |
| Runtime Exception | FunctionAppLogs where Level == "Error" and Exception != "" | Sev 1 (Error) | SOC + App Team | SI-4 |
| Function Timeout | AllMetrics where Duration > function timeout threshold | Sev 2 (Warning) | App Team | SI-4 |
| High Memory Usage | AllMetrics where MemoryWorkingSet > 80% of plan limit | Sev 2 (Warning) | App Team | SI-4 |
| Function Key Regeneration | Activity Log where operation == "Microsoft.Web/sites/host/functionkeys/write" | Sev 2 (Warning) | SOC | IA-5, CM-3 |

---

## Log Query Examples

### Function Execution Failures
```kusto
FunctionAppLogs
| where Level == "Error" or ResultCode != "0"
| summarize FailureCount = count() by FunctionName, bin(TimeGenerated, 5m)
| where FailureCount > 10
| order by FailureCount desc
```

### Function Execution Duration (Slow Functions)
```kusto
FunctionAppLogs
| where FunctionInvocationId != ""
| summarize AvgDuration = avg(DurationMs), MaxDuration = max(DurationMs) by FunctionName, bin(TimeGenerated, 1h)
| where AvgDuration > 30000
| order by AvgDuration desc
```

### Unhandled Exceptions
```kusto
FunctionAppLogs
| where Level == "Error" and ExceptionDetails != ""
| project TimeGenerated, FunctionName, Message, ExceptionDetails
| order by TimeGenerated desc
```

### Function Invocation Trend
```kusto
FunctionAppLogs
| where FunctionInvocationId != ""
| summarize InvocationCount = dcount(FunctionInvocationId) by FunctionName, bin(TimeGenerated, 1h)
| render timechart
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Functions monitoring | https://learn.microsoft.com/en-us/azure/azure-functions/functions-monitoring |
| 2 | Azure Functions diagnostics | https://learn.microsoft.com/en-us/azure/azure-functions/functions-diagnostics |
| 3 | Application Insights for Azure Functions | https://learn.microsoft.com/en-us/azure/azure-functions/functions-monitoring?tabs=cmd#enable-application-insights-integration |
| 4 | OMB M-21-31 logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
