# Logging Configuration: Azure Purview

**Service**: Azure Purview (Microsoft.Purview/accounts)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate)

---

## Log Collection Architecture

Azure Purview diagnostic logs are forwarded to the centralized Log Analytics workspace via Azure Monitor diagnostic settings. ScanStatusLogEvent captures scan execution results, DataSensitivityLogEvent captures sensitive data classification discoveries, and Security captures authentication and authorization events.

```
Azure Purview → Diagnostic Settings → Log Analytics Workspace
```

---

## Diagnostic Log Categories

All diagnostic log categories below MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| ScanStatusLogEvent | Scan execution results: scan start, completion, failure, data source details, scan rule set applied, and records scanned | EL2 | AU-2, AU-3, AU-12 |
| DataSensitivityLogEvent | Sensitive data classification discoveries: classification type (SSN, credit card, etc.), affected asset, and sensitivity label applied | EL2 | AU-2, AU-3, AU-12 |
| Security | Authentication events, authorization decisions, administrative operations, collection access changes, and role assignments | EL2 | AU-2, AU-3, AU-12 |

### Metrics

| Metric Category | Description | OMB M-21-31 Tier | NIST Control |
|----------------|-------------|-------------------|--------------|
| AllMetrics | Scan count, scan duration, data map capacity utilization, API request count | EL1 | SI-4 |

---

## ScanStatusLogEvent Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `operationName` | Scan operation (ScanStarted, ScanCompleted, ScanFailed, ScanCancelled) | AU-3 |
| `resultType` | Scan result (Succeeded, Failed, Cancelled) | AU-3 |
| `properties.dataSourceName` | Name of the registered data source being scanned | AU-3 |
| `properties.scanName` | Name of the scan configuration | AU-3 |
| `properties.scanRulesetName` | Classification rule set applied during scan | AU-3 |
| `properties.assetsDiscovered` | Number of assets discovered during the scan | AU-3, SI-4 |
| `properties.assetsClassified` | Number of assets classified during the scan | AU-3, SI-4 |
| `durationMs` | Scan duration in milliseconds | SI-4 |

## DataSensitivityLogEvent Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `properties.assetName` | Name of the asset where sensitive data was discovered | AU-3 |
| `properties.classificationName` | Classification type applied (e.g., SSN, Credit Card Number, Government ID) | AU-3 |
| `properties.sensitivityLabel` | Sensitivity label applied to the asset | AU-3 |
| `properties.assetType` | Type of data asset (Blob, SQL Table, etc.) | AU-3 |
| `properties.collectionName` | Purview collection containing the asset | AU-3 |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The Purview account resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.Purview/accounts
Name: "{purview_account_name}-diag"
Destination: Log Analytics workspace (shared)
Log Categories:
  - ScanStatusLogEvent: Enabled
  - DataSensitivityLogEvent: Enabled
  - Security: Enabled
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
| Scan Failure | ScanStatusLogEvent where resultType == "Failed" | Sev 2 (Warning) | SOC + Data Governance Team | AU-6, SI-4 |
| Sensitive Data Discovered | DataSensitivityLogEvent where classificationName contains "SSN" or "Government ID" or "Credit Card" | Sev 2 (Warning) | SOC + Data Governance Team + Privacy Officer | AU-6, SI-4 |
| Unauthorized Collection Access | Security where resultType == "Failure" and httpStatusCode == 401 or 403 | Sev 1 (Error) | SOC + Incident Response | AC-3, IA-2, SI-4 |
| Root Collection Admin Activation | Security where operationName contains "CollectionAdmin" and scope is root collection | Sev 2 (Warning) | SOC | AC-2, AC-6 |
| Data Source Registration Change | Security where operationName contains "DataSource/write" or "DataSource/delete" | Sev 2 (Warning) | SOC + Data Governance Team | CM-3, SI-4 |
| High Scan Failure Rate | ScanStatusLogEvent where resultType == "Failed" count > 5 in 1 hour | Sev 1 (Error) | SOC + Data Governance Team | SI-4 |

---

## Log Query Examples

### Scan Failures
```kusto
PurviewScanStatusLogs
| where OperationName == "ScanFailed"
| project TimeGenerated, Properties.dataSourceName, Properties.scanName, Properties.errorMessage
| order by TimeGenerated desc
```

### Sensitive Data Classification Discoveries
```kusto
PurviewDataSensitivityLogs
| where Properties.classificationName has_any ("SSN", "Government ID", "Credit Card")
| project TimeGenerated, Properties.assetName, Properties.classificationName, Properties.sensitivityLabel, Properties.collectionName
| order by TimeGenerated desc
```

### Unauthorized Access Attempts
```kusto
PurviewSecurityLogs
| where ResultType == "Failure"
| where HttpStatusCode == 401 or HttpStatusCode == 403
| project TimeGenerated, CallerIpAddress, OperationName, ResultType, Identity
| order by TimeGenerated desc
```

### Root Collection Admin Activity
```kusto
PurviewSecurityLogs
| where OperationName has "CollectionAdmin"
| project TimeGenerated, CallerIpAddress, OperationName, Identity, Properties
| order by TimeGenerated desc
```

### Scan Summary by Data Source
```kusto
PurviewScanStatusLogs
| summarize
    TotalScans = count(),
    SuccessfulScans = countif(ResultType == "Succeeded"),
    FailedScans = countif(ResultType == "Failed"),
    AvgDurationMs = avg(DurationMs)
  by Properties.dataSourceName, bin(TimeGenerated, 1d)
| order by FailedScans desc
```

### Data Source Registration Changes
```kusto
PurviewSecurityLogs
| where OperationName has_any ("DataSource/write", "DataSource/delete")
| project TimeGenerated, CallerIpAddress, OperationName, Identity, ResultType
| order by TimeGenerated desc
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Purview monitoring | https://learn.microsoft.com/en-us/azure/purview/tutorial-purview-audit-logs-diagnostics |
| 2 | Azure Purview diagnostic logs | https://learn.microsoft.com/en-us/azure/purview/tutorial-purview-audit-logs-diagnostics |
| 3 | Azure Purview Private Endpoints | https://learn.microsoft.com/en-us/azure/purview/catalog-private-link-end-to-end |
| 4 | OMB M-21-31 logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
