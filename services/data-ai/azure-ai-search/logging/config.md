# Logging Configuration: Azure AI Search

**Service**: Azure AI Search (Microsoft.Search/searchServices)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate) for operation logs

---

## Log Collection Architecture

Azure AI Search diagnostic logs are forwarded to the centralized Log Analytics workspace via Azure Monitor diagnostic settings. OperationLogs capture all search service operations including queries, indexing, and administrative actions.

```
Azure AI Search → Diagnostic Settings → Log Analytics Workspace
```

---

## Diagnostic Log Categories

All diagnostic log categories below MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| OperationLogs | All search service operations: queries, indexing operations, index management, data source connections, skillset executions, and administrative configuration changes | EL2 | AU-2, AU-3, AU-12 |

### Metrics

| Metric Category | Description | OMB M-21-31 Tier | NIST Control |
|----------------|-------------|-------------------|--------------|
| AllMetrics | Search latency, query volume, indexing document count, throttled queries, skill execution count | EL1 | SI-4 |

---

## OperationLogs Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `operationName` | Search operation (Query.Search, Indexing.Index, ServiceStats, etc.) | AU-3 |
| `resultType` | Operation result (Success, Failure) | AU-3 |
| `callerIpAddress` | Source IP of the API caller | AU-3 |
| `identity` | Caller identity (managed identity, API key hash, or user UPN) | AU-3, IA-2 |
| `properties.Description` | Operation description and details | AU-3 |
| `durationMs` | Request duration in milliseconds | SI-4 |
| `httpStatusCode` | HTTP response status code | AU-3 |
| `properties.Query` | Search query text (for query operations) | AU-3 |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The Search service resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.Search/searchServices
Name: "{search_service_name}-diag"
Destination: Log Analytics workspace (shared)
Log Categories:
  - OperationLogs: Enabled
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
| Index Corruption | OperationLogs where operationName == "Indexing.Index" and resultType == "Failure" with error indicating corruption | Sev 1 (Error) | SOC + Data Team | SC-28, SI-4 |
| Query Failure Rate | OperationLogs where operationName == "Query.Search" and resultType == "Failure" count > 50 in 5 minutes | Sev 2 (Warning) | SOC + Application Team | SI-4 |
| Throttling Events | AllMetrics where ThrottledSearchQueriesPercentage > 10% | Sev 2 (Warning) | SOC + Application Team | SI-4 |
| Unauthorized Access Attempt | OperationLogs where httpStatusCode == 401 or 403 | Sev 1 (Error) | SOC + Incident Response | AC-3, SI-4 |
| Index Data Deletion | OperationLogs where operationName has "Delete" for index operations | Sev 2 (Warning) | SOC + Data Team | AU-6, SI-4 |

---

## Log Query Examples

### Query Failure Analysis
```kusto
AzureDiagnostics
| where ResourceType == "SEARCHSERVICES"
| where Category == "OperationLogs"
| where OperationName == "Query.Search" and ResultType == "Failure"
| summarize FailureCount = count() by Resource, CallerIPAddress, bin(TimeGenerated, 5m)
| where FailureCount > 10
| order by FailureCount desc
```

### Indexing Operation Failures
```kusto
AzureDiagnostics
| where ResourceType == "SEARCHSERVICES"
| where Category == "OperationLogs"
| where OperationName has "Indexing" and ResultType == "Failure"
| project TimeGenerated, Resource, OperationName, CallerIPAddress, Description_s, httpStatusCode_d
| order by TimeGenerated desc
```

### Throttled Queries
```kusto
AzureMetrics
| where ResourceProvider == "MICROSOFT.SEARCH"
| where MetricName == "ThrottledSearchQueriesPercentage"
| where Average > 10
| project TimeGenerated, Resource, Average, Maximum
| order by TimeGenerated desc
```

### Unauthorized Access Attempts
```kusto
AzureDiagnostics
| where ResourceType == "SEARCHSERVICES"
| where Category == "OperationLogs"
| where httpStatusCode_d == 401 or httpStatusCode_d == 403
| summarize AttemptCount = count() by Resource, CallerIPAddress, OperationName, bin(TimeGenerated, 5m)
| order by AttemptCount desc
```

### Search Latency Analysis
```kusto
AzureDiagnostics
| where ResourceType == "SEARCHSERVICES"
| where Category == "OperationLogs"
| where OperationName == "Query.Search" and ResultType == "Success"
| extend LatencyMs = DurationMs
| summarize P50 = percentile(LatencyMs, 50), P95 = percentile(LatencyMs, 95), P99 = percentile(LatencyMs, 99) by Resource, bin(TimeGenerated, 1h)
| order by TimeGenerated desc
```

### Administrative Configuration Changes
```kusto
AzureDiagnostics
| where ResourceType == "SEARCHSERVICES"
| where Category == "OperationLogs"
| where OperationName has_any ("CreateIndex", "DeleteIndex", "CreateDataSource", "CreateSkillset", "UpdateIndex")
| project TimeGenerated, Resource, OperationName, CallerIPAddress, ResultType
| order by TimeGenerated desc
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure AI Search monitoring | https://learn.microsoft.com/en-us/azure/search/monitor-azure-cognitive-search |
| 2 | Azure AI Search diagnostic logs | https://learn.microsoft.com/en-us/azure/search/search-monitor-logs |
| 3 | Azure AI Search metrics | https://learn.microsoft.com/en-us/azure/search/search-monitor-logs-powerbi |
| 4 | OMB M-21-31 logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
