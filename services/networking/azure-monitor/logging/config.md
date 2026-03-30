# Logging Configuration: Azure Monitor / Log Analytics

**Service**: Azure Monitor / Log Analytics
**Category**: Networking
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-11, AU-12
**OMB M-21-31**: EL2 (Intermediate) for platform monitoring

---

## Activity Log Categories

Azure Activity Log captures subscription-level events. ALL categories below MUST be forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| Administrative | Resource creation, update, deletion; RBAC changes; deployment operations | EL2 | AU-2, AU-3, AU-12 |
| Security | Microsoft Defender for Cloud alerts and recommendations | EL2 | AU-2, AU-6, SI-4 |
| ServiceHealth | Service incidents, planned maintenance, health advisories | EL1 | AU-2 |
| Alert | Azure Monitor alert activations | EL2 | AU-2, AU-6 |
| Recommendation | Azure Advisor recommendations | EL1 | AU-2 |
| Policy | Azure Policy evaluation results (compliance, deny, audit) | EL2 | AU-2, CM-6 |
| Autoscale | Autoscale engine events | EL1 | AU-2 |
| ResourceHealth | Resource health status changes | EL1 | AU-2 |

---

## Self-Monitoring Note

> **Critical**: A Log Analytics workspace cannot send its own diagnostic logs to itself. This creates a monitoring gap for the primary audit infrastructure. Mitigations:
>
> 1. **Secondary workspace**: Forward workspace diagnostic logs to a dedicated secondary Log Analytics workspace for monitoring-of-monitoring
> 2. **Azure Monitor Agent**: For workspace-level metrics, use Azure Monitor metrics which are available without diagnostic settings
> 3. **Activity Log**: Workspace configuration changes (retention updates, CMK changes) are captured in the Activity Log, which IS forwarded to the workspace
> 4. **Data export monitoring**: Monitor the data export rule health via Azure Monitor metrics on the workspace resource

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace (Activity Log + service diagnostics) | Per `shared/terraform/log-analytics/` |
| Production | Archive storage account (data export for 18-month retention) | Per `terraform/main.tf` data export rule |

**Configuration method**: Activity Log diagnostic settings are configured at the subscription level. Service-level diagnostic settings are configured per service module. Data export rule is configured in `terraform/main.tf`. Action groups and alert rules are configured in `terraform/main.tf`.

### Configuration Note

```
Resource: Microsoft.OperationalInsights/workspaces (platform)
Activity Log Diagnostic Setting:
  Categories: Administrative, Security, ServiceHealth, Alert, Recommendation, Policy, Autoscale, ResourceHealth
  Destination: Log Analytics workspace
Data Export Rule:
  Tables: SecurityEvent, AzureActivity, SigninLogs, AuditLogs, Syslog, Heartbeat
  Destination: Archive storage account
  Retention: 18 months minimum
```

---

## Retention

| Tier | Retention Period | Justification |
|------|-----------------|---------------|
| Hot (Log Analytics) | 365 days | FedRAMP AU-11 online retention; active query and alerting |
| Archive (Storage Account) | 18 months | Extended retention for incident investigation |
| Cold (Storage Account) | 7 years total | FedRAMP AU-11 audit record retention |

---

## Alert Rules

The following alerts MUST be configured for monitoring platform health and security events:

| Alert Name | Condition | Severity | Action Group | NIST Control |
|-----------|-----------|----------|-------------|--------------|
| Resource Deletion | Activity Log: resource group or critical resource deleted | Sev 1 (Error) | SOC + Operations | AU-6, AU-12 |
| Role Assignment Change | Activity Log: roleAssignments/write operation | Sev 2 (Warning) | SOC + Security Team | AU-6, AC-2 |
| Policy Violation | Activity Log: Policy category, warning level | Sev 2 (Warning) | Security Team | AU-6, CM-6 |
| Workspace Query Failure | Log Analytics workspace: query execution failures spike | Sev 2 (Warning) | Operations | AU-6 |
| Data Ingestion Anomaly | Log Analytics workspace: data ingestion rate drops below baseline or spikes unexpectedly | Sev 2 (Warning) | Operations + SOC | AU-6, SI-4 |
| Workspace Capacity Threshold | Log Analytics workspace: daily data cap approaching 80% threshold | Sev 3 (Informational) | Operations | AU-6 |
| Data Export Failure | Data export rule: export failures or latency exceeding threshold | Sev 2 (Warning) | Operations | AU-11 |

---

## Log Query Examples

### Activity Log — Resource Deletions
```kusto
AzureActivity
| where OperationNameValue has "delete"
| where ActivityStatusValue == "Success"
| project TimeGenerated, Caller, OperationNameValue, ResourceGroup, ResourceId
| order by TimeGenerated desc
```

### Activity Log — Role Assignment Changes
```kusto
AzureActivity
| where OperationNameValue == "Microsoft.Authorization/roleAssignments/write"
| project TimeGenerated, Caller, OperationNameValue, Properties_d
| order by TimeGenerated desc
```

### Activity Log — Policy Non-Compliance
```kusto
AzureActivity
| where CategoryValue == "Policy"
| where ActivityStatusValue == "Succeeded"
| project TimeGenerated, Caller, OperationNameValue, Properties_d
| order by TimeGenerated desc
```

### Workspace Data Ingestion Volume
```kusto
Usage
| where TimeGenerated > ago(24h)
| summarize DataIngested_MB = sum(Quantity) by DataType, bin(TimeGenerated, 1h)
| order by DataIngested_MB desc
```

### Data Export Health
```kusto
LAQueryLogs
| where TimeGenerated > ago(1h)
| where ResponseCode != 200
| summarize FailureCount = count() by bin(TimeGenerated, 5m)
| where FailureCount > 0
```

### Heartbeat — Agent Health
```kusto
Heartbeat
| summarize LastHeartbeat = max(TimeGenerated) by Computer, OSType
| where LastHeartbeat < ago(5m)
| project Computer, OSType, LastHeartbeat, TimeSinceLastHeartbeat = now() - LastHeartbeat
| order by TimeSinceLastHeartbeat desc
```
