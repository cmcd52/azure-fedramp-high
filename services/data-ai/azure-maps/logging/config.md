# Logging Configuration: Azure Maps

**Service**: Azure Maps (Microsoft.Maps/accounts)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL1 (Basic) — limited diagnostic categories available

---

## Log Collection Architecture

Azure Maps diagnostic logs are forwarded to the centralized Log Analytics workspace via Azure Monitor diagnostic settings. Azure Maps provides limited diagnostic categories compared to other Azure AI services — only the Audit category is available, which captures API access events.

```
Azure Maps → Diagnostic Settings → Log Analytics Workspace
```

---

## Diagnostic Log Categories

All diagnostic log categories below MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| Audit | API access events: authentication, authorization, map tile requests, geocoding, routing, and search operations | EL1 | AU-2, AU-3, AU-12 |

### Metrics

| Metric Category | Description | OMB M-21-31 Tier | NIST Control |
|----------------|-------------|-------------------|--------------|
| AllMetrics | Request count, latency, error rate, availability, data egress | EL1 | SI-4 |

> **Note**: Azure Maps has limited diagnostic categories compared to Cognitive Services or Machine Learning Services. Only the Audit category is available. OMB M-21-31 EL1 (Basic) is the maximum achievable tier. This is documented in the controls baseline as a service limitation.

---

## Audit Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `operationName` | Maps API operation (Render.GetMapTile, Search.GetSearchAddress, Route.GetRouteDirections, etc.) | AU-3 |
| `resultType` | Success or failure | AU-3 |
| `callerIpAddress` | Source IP of the API caller | AU-3 |
| `identity` | Caller identity (managed identity principal ID, shared key hash, or SAS token) | AU-3, IA-2 |
| `httpStatusCode` | HTTP response status code | AU-3 |
| `durationMs` | Request duration in milliseconds | SI-4 |
| `properties.apiCategory` | Maps API category (Render, Search, Route, Spatial, etc.) | AU-3 |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The Maps account resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.Maps/accounts
Name: "{maps_account_name}-diag"
Destination: Log Analytics workspace (shared)
Log Categories:
  - Audit: Enabled
Metrics:
  - AllMetrics: Enabled
```

---

## Retention

| Tier | Retention Period | Justification |
|------|-----------------|---------------|
| Hot (Log Analytics) | 365 days (production) / 30 days (lower) | Active query and alerting |
| Archive (Storage Account) | 548 days (production) | FedRAMP AU-11 audit record retention |

---

## Alert Rules

The following alerts MUST be configured in the shared monitoring infrastructure:

| Alert Name | Condition | Severity | Action Group | NIST Control |
|-----------|-----------|----------|-------------|--------------|
| Unusual Query Volume | AllMetrics where request count > 3x baseline in 15 minutes | Sev 2 (Warning) | SOC + Application Team | SI-4 |
| Unauthorized Auth Attempt | Audit where httpStatusCode == 401 or 403 | Sev 1 (Error) | SOC + Incident Response | AC-3, IA-2, SI-4 |
| Shared Key Usage in Production | Audit where authentication type is shared key (not Entra ID) | Sev 1 (Error) | SOC | IA-2 |
| High Error Rate | Audit where httpStatusCode >= 500 count > 10 in 5 minutes | Sev 2 (Warning) | SOC + Application Team | SI-4 |

---

## Log Query Examples

### Unauthorized Authentication Attempts
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.MAPS"
| where Category == "Audit"
| where httpStatusCode_d == 401 or httpStatusCode_d == 403
| project TimeGenerated, Resource, CallerIPAddress, OperationName, ResultType, httpStatusCode_d
| order by TimeGenerated desc
```

### Unusual Query Volume Detection
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.MAPS"
| where Category == "Audit"
| summarize RequestCount = count() by Resource, bin(TimeGenerated, 15m)
| order by RequestCount desc
```

### Shared Key Usage Detection (Should Not Occur in Production)
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.MAPS"
| where Category == "Audit"
| where properties_s has "SharedKey" or properties_s has "subscription-key"
| project TimeGenerated, Resource, CallerIPAddress, OperationName, properties_s
| order by TimeGenerated desc
```

### API Usage by Category
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.MAPS"
| where Category == "Audit"
| extend ApiCategory = tostring(parse_json(properties_s).apiCategory)
| summarize RequestCount = count(), AvgLatency = avg(DurationMs) by ApiCategory, bin(TimeGenerated, 1h)
| order by RequestCount desc
```

### Error Rate by Operation
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.MAPS"
| where Category == "Audit"
| where httpStatusCode_d >= 400
| summarize ErrorCount = count() by OperationName, httpStatusCode_d, bin(TimeGenerated, 5m)
| where ErrorCount > 5
| order by ErrorCount desc
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Maps monitoring reference | https://learn.microsoft.com/en-us/azure/azure-maps/monitor-maps |
| 2 | Azure Maps authentication | https://learn.microsoft.com/en-us/azure/azure-maps/azure-maps-authentication |
| 3 | Azure Maps security baseline | https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/azure-maps-security-baseline |
| 4 | OMB M-21-31 logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
