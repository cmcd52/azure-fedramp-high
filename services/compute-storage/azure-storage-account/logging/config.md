# Logging Configuration: Azure Storage Account

**Service**: Azure Storage Account
**Category**: Compute & Storage
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate) for data plane operations, EL3 (Advanced) for delete operations

---

## Log Collection Architecture

Storage Account diagnostic logs are forwarded per sub-service (blob, queue, table, file) to the centralized Log Analytics workspace via Azure Monitor diagnostic settings. Each sub-service has its own diagnostic setting to capture StorageRead, StorageWrite, and StorageDelete categories independently.

```
Storage Account (blob)  → Diagnostic Settings → Log Analytics Workspace
Storage Account (queue) → Diagnostic Settings → Log Analytics Workspace
Storage Account (table) → Diagnostic Settings → Log Analytics Workspace
Storage Account (file)  → Diagnostic Settings → Log Analytics Workspace
Storage Account          → Diagnostic Settings → Log Analytics Workspace (metrics)
```

---

## Diagnostic Log Categories

All diagnostic log categories below MUST be enabled for EACH sub-service (blob, queue, table, file).

### Per Sub-Service Categories

| Log Category | Description | OMB M-21-31 Tier | NIST Control |
|-------------|-------------|-------------------|--------------|
| StorageRead | Read operations (Get, List, Head) against the sub-service | EL2 | AU-2, AU-3, AU-12 |
| StorageWrite | Write operations (Put, Post, Patch) against the sub-service | EL2 | AU-2, AU-3, AU-12 |
| StorageDelete | Delete operations (Delete, Purge) against the sub-service | EL3 | AU-2, AU-3, AU-12 |

### Metrics

| Metric Category | Description | OMB M-21-31 Tier | NIST Control |
|----------------|-------------|-------------------|--------------|
| Transaction | Transaction count, latency, availability per sub-service and account | EL1 | SI-4 |

---

## Sub-Service Coverage Matrix

| Sub-Service | StorageRead | StorageWrite | StorageDelete | Transaction Metrics |
|-------------|:-----------:|:------------:|:-------------:|:-------------------:|
| Blob | ✓ | ✓ | ✓ | ✓ |
| Queue | ✓ | ✓ | ✓ | ✓ |
| Table | ✓ | ✓ | ✓ | ✓ |
| File | ✓ | ✓ | ✓ | ✓ |
| Account | — | — | — | ✓ |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys 5 diagnostic settings in `terraform/main.tf` — one for account-level metrics and one per sub-service (blob, queue, table, file).

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
| Anonymous Access Attempt | StorageRead/StorageWrite where authentication type == "Anonymous" | Sev 1 (Error) | SOC + Incident Response | AC-3, SC-7, SI-4 |
| Delete Spike | StorageDelete count > 100 in 5 minutes per storage account | Sev 1 (Error) | SOC + Data Team | AU-6, SI-4 |
| Shared Key Usage Attempt | StorageRead/StorageWrite where authentication type == "AccountKey" (in production) | Sev 2 (Warning) | SOC | AC-3, IA-2 |
| Failed Authorization | StorageRead/StorageWrite where status code == 403 count > 10 in 5 minutes | Sev 2 (Warning) | SOC | AC-3, SI-4 |
| Unusually High Egress | Transaction metrics where egress > threshold | Sev 2 (Warning) | SOC + Data Team | SI-4 |
| CMK Key Not Available | Storage Account encryption status shows key unavailable | Sev 1 (Error) | SOC + Key Vault Team | SC-12, SC-28 |

---

## Log Query Examples

### Anonymous Access Attempts
```kusto
StorageBlobLogs
| where AuthenticationType == "Anonymous"
| summarize AttemptCount = count() by AccountName, CallerIpAddress, OperationName, bin(TimeGenerated, 5m)
| where AttemptCount > 0
| order by AttemptCount desc
```

### Delete Operations Spike
```kusto
StorageBlobLogs
| where OperationName has "Delete"
| summarize DeleteCount = count() by AccountName, CallerIpAddress, bin(TimeGenerated, 5m)
| where DeleteCount > 100
| order by DeleteCount desc
```

### Shared Key Usage (Should Not Occur in Production)
```kusto
StorageBlobLogs
| where AuthenticationType == "AccountKey" or AuthenticationType == "SAS"
| project TimeGenerated, AccountName, OperationName, CallerIpAddress, AuthenticationType
| order by TimeGenerated desc
```

### Failed Authorization Attempts
```kusto
StorageBlobLogs
| where StatusCode == 403
| summarize FailedCount = count() by AccountName, CallerIpAddress, OperationName, bin(TimeGenerated, 5m)
| where FailedCount > 10
| order by FailedCount desc
```

### Data Exfiltration Indicator (High Egress)
```kusto
StorageBlobLogs
| where OperationName == "GetBlob"
| summarize TotalEgress = sum(ResponseBodySize) by AccountName, CallerIpAddress, bin(TimeGenerated, 1h)
| where TotalEgress > 1073741824  // > 1 GB in 1 hour
| order by TotalEgress desc
```

### Cross-Sub-Service Activity Summary
```kusto
union StorageBlobLogs, StorageQueueLogs, StorageTableLogs, StorageFileLogs
| summarize OperationCount = count() by Category, OperationName, StatusCode, bin(TimeGenerated, 1h)
| order by OperationCount desc
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Storage monitoring | https://learn.microsoft.com/en-us/azure/storage/blobs/monitor-blob-storage |
| 2 | Azure Storage diagnostic logs | https://learn.microsoft.com/en-us/azure/storage/blobs/monitor-blob-storage-reference |
| 3 | Storage Analytics logging | https://learn.microsoft.com/en-us/azure/storage/common/storage-analytics-logging |
| 4 | OMB M-21-31 logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
