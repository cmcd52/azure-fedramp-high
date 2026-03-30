# Logging Configuration: Event Hubs

**Service**: Event Hubs (Microsoft.EventHub/namespaces)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate) for operational logs, EL3 (Advanced) for security events (VNet connection, CMK operations)

---

## Log Collection Architecture

Azure Event Hubs diagnostic logs are forwarded to the centralized Log Analytics workspace via Azure Monitor diagnostic settings. Nine log categories provide comprehensive visibility: operational events, Kafka protocols, VNet connectivity, CMK operations, runtime auditing, and application metrics.

```
Event Hubs Namespace → Diagnostic Settings → Log Analytics Workspace
```

---

## Diagnostic Log Categories

All diagnostic log categories below MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| ArchiveLogs | Event Hubs Capture operations: capture execution, errors, and throughput for event archival to Blob Storage or ADLS Gen2 | EL2 | AU-2, AU-3, AU-12 |
| OperationalLogs | Namespace operations: management actions, errors, and warnings including throttling events | EL2 | AU-2, AU-3, AU-12 |
| AutoScaleLogs | Auto-inflate scaling events: throughput unit changes, scaling triggers | EL2 | AU-2, AU-12, SI-4 |
| KafkaCoordinatorLogs | Kafka protocol coordinator logs: consumer group management, partition rebalancing | EL2 | AU-2, AU-12 |
| KafkaUserErrorLogs | Kafka client error logs: authentication failures, protocol errors, consumer group issues | EL2 | AU-2, AU-3, AU-12 |
| EventHubVNetConnectionEvent | Virtual network and Private Endpoint connection events: accepted, rejected, and failed connections | EL3 | AU-2, AU-3, AU-12, SC-7 |
| CustomerManagedKeyUserLogs | CMK operation logs: key access, rotation, wrapping/unwrapping events, and failures | EL3 | AU-2, AU-3, AU-12, SC-13 |
| RuntimeAuditLogs | Data plane runtime audit: send, receive, and management operations with caller identity | EL2 | AU-2, AU-3, AU-12 |
| ApplicationMetricsLogs | Application-level metrics: throughput, latency, message counts, and consumer lag | EL2 | AU-2, SI-4 |

### Metrics

| Metric Category | Description | OMB M-21-31 Tier | NIST Control |
|----------------|-------------|-------------------|--------------|
| AllMetrics | Incoming/outgoing messages, bytes, requests, throttled requests, errors, connections, processing units utilization | EL1 | SI-4 |

---

## RuntimeAuditLogs Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `operationName` | Data plane operation (Send, Receive, CreateConsumerGroup, etc.) | AU-3 |
| `resultType` | Operation result (Success, Failure) | AU-3 |
| `callerIpAddress` | Source IP of the client | AU-3 |
| `identity` | Caller identity (managed identity principal, SAS key name, or user UPN) | AU-3, IA-2 |
| `properties.EventHubName` | Target Event Hub name | AU-3 |
| `properties.ConsumerGroup` | Consumer group name (for receive operations) | AU-3 |
| `properties.PartitionId` | Partition accessed | AU-3 |
| `properties.AuthType` | Authentication type (AAD, SAS, Anonymous) | AU-3, IA-2 |
| `httpStatusCode` | HTTP status code for REST operations | AU-3 |

## EventHubVNetConnectionEvent Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `properties.Action` | Connection action (Accept, Reject, Deny) | AU-3, SC-7 |
| `properties.AddressIp` | Client IP address | AU-3 |
| `properties.SubnetId` | Source subnet when applicable | AU-3, SC-7 |
| `properties.Message` | Connection event description | AU-3 |

## CustomerManagedKeyUserLogs Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `operationName` | Key operation (WrapKey, UnwrapKey, GetKey) | AU-3, SC-13 |
| `resultType` | Key operation result (Success, Failure) | AU-3 |
| `properties.KeyVersion` | Key version used | AU-3, SC-13 |
| `properties.StatusCode` | Key Vault response status code | AU-3 |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The Event Hubs namespace resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.EventHub/namespaces
Name: "{namespace_name}-diag"
Destination: Log Analytics workspace (shared)
Log Categories:
  - ArchiveLogs: Enabled
  - OperationalLogs: Enabled
  - AutoScaleLogs: Enabled
  - KafkaCoordinatorLogs: Enabled
  - KafkaUserErrorLogs: Enabled
  - EventHubVNetConnectionEvent: Enabled
  - CustomerManagedKeyUserLogs: Enabled
  - RuntimeAuditLogs: Enabled
  - ApplicationMetricsLogs: Enabled
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
| Throttling Events | OperationalLogs where resultType contains "Throttled" OR AllMetrics where ThrottledRequests > 0 | Sev 2 (Warning) | SOC + Application Team | SI-4 |
| CMK Rotation Failure | CustomerManagedKeyUserLogs where resultType == "Failure" | Sev 1 (Error) | SOC + Security Team | SC-13, SI-4 |
| Namespace Health Degradation | AllMetrics where ServerErrors > 10 in 5 minutes | Sev 1 (Error) | SOC + Application Team | SI-4 |
| SAS Token Usage (Production) | RuntimeAuditLogs where properties.AuthType == "SAS" | Sev 1 (Error) | SOC | IA-2, AC-3 |
| VNet Connection Rejected | EventHubVNetConnectionEvent where properties.Action == "Reject" or "Deny" | Sev 2 (Warning) | SOC | SC-7, SI-4 |
| Unauthorized Access Attempt | RuntimeAuditLogs where resultType == "Failure" and httpStatusCode == 401 or 403 | Sev 1 (Error) | SOC + Incident Response | AC-3, IA-2, SI-4 |
| Capture Failure | ArchiveLogs where resultType == "Failure" | Sev 2 (Warning) | SOC + Application Team | AU-11, SI-4 |
| Kafka Authentication Failure | KafkaUserErrorLogs where operation contains "Auth" and resultType == "Failure" | Sev 2 (Warning) | SOC | IA-2, SI-4 |

---

## Log Query Examples

### Throttling Events
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.EVENTHUB"
| where Category == "OperationalLogs"
| where ResultDescription has "throttl"
| project TimeGenerated, Resource, OperationName, ResultDescription, CallerIPAddress
| order by TimeGenerated desc
```

### CMK Operation Failures
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.EVENTHUB"
| where Category == "CustomerManagedKeyUserLogs"
| where ResultType == "Failure"
| project TimeGenerated, Resource, OperationName, ResultType, properties_s
| order by TimeGenerated desc
```

### SAS Token Usage Detection (Should Not Occur in Production)
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.EVENTHUB"
| where Category == "RuntimeAuditLogs"
| extend AuthType = tostring(parse_json(properties_s).AuthType)
| where AuthType == "SAS"
| project TimeGenerated, Resource, OperationName, CallerIPAddress, AuthType
| order by TimeGenerated desc
```

### VNet Connection Rejections
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.EVENTHUB"
| where Category == "EventHubVNetConnectionEvent"
| extend Action = tostring(parse_json(properties_s).Action)
| where Action in ("Reject", "Deny")
| project TimeGenerated, Resource, Action, CallerIPAddress, properties_s
| order by TimeGenerated desc
```

### Namespace Health — Server Errors
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.EVENTHUB"
| where Category == "OperationalLogs"
| where ResultType == "ServerError" or ResultType == "InternalServerError"
| summarize ErrorCount = count() by Resource, bin(TimeGenerated, 5m)
| where ErrorCount > 10
| order by ErrorCount desc
```

### Event Hub Throughput Summary
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.EVENTHUB"
| where Category == "RuntimeAuditLogs"
| extend EventHubName = tostring(parse_json(properties_s).EventHubName)
| summarize
    SendCount = countif(OperationName == "Send"),
    ReceiveCount = countif(OperationName == "Receive")
  by EventHubName, bin(TimeGenerated, 1h)
| order by SendCount desc
```

### Capture Operation Status
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.EVENTHUB"
| where Category == "ArchiveLogs"
| summarize
    TotalCaptures = count(),
    SuccessCount = countif(ResultType == "Succeeded"),
    FailCount = countif(ResultType == "Failed")
  by Resource, bin(TimeGenerated, 1h)
| order by FailCount desc
```

### Unauthorized Access Attempts
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.EVENTHUB"
| where Category == "RuntimeAuditLogs"
| where httpStatusCode_d == 401 or httpStatusCode_d == 403
| project TimeGenerated, Resource, OperationName, CallerIPAddress, ResultType, httpStatusCode_d
| order by TimeGenerated desc
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Event Hubs monitoring | https://learn.microsoft.com/en-us/azure/event-hubs/monitor-event-hubs-reference |
| 2 | Azure Event Hubs diagnostic logs | https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-diagnostic-logs |
| 3 | Azure Event Hubs CMK encryption | https://learn.microsoft.com/en-us/azure/event-hubs/configure-customer-managed-key |
| 4 | Azure Event Hubs network security | https://learn.microsoft.com/en-us/azure/event-hubs/network-security |
| 5 | OMB M-21-31 logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
