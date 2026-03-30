# Logging Configuration: Private Endpoint

**Service**: Private Endpoint
**Category**: Networking
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL1 (Basic) for PE configuration changes

---

## Diagnostic Categories

Azure Private Endpoints have limited native diagnostic log support. PE connection state and utilization are logged via the **parent resource's** diagnostic settings, not the PE itself.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| Activity Log | PE creation, deletion, connection approval/rejection — captured via Azure Activity Log | EL1 | AU-2, AU-3, AU-12 |
| NSG Flow Logs | Network traffic to/from the PE network interface — captured via NSG flow logs on the PE subnet | EL2 | AU-2, AU-3, AU-12, SC-7 |

> **Important**: PE connection state (connected, disconnected, pending) and data transfer metrics are available via the parent resource's diagnostic settings. For example, Storage Account diagnostics will show PE connection status in their metrics.

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace (Activity Log + NSG flow logs) | Per `shared/terraform/log-analytics/` |

**Configuration method**: Activity Log diagnostic settings are configured at the subscription level. NSG flow logs are configured on the PE subnet's NSG. PE connection diagnostics are part of the parent resource's diagnostic settings.

### Configuration Note

```
Resource: Microsoft.Network/privateEndpoints
Native Diagnostic Settings: Limited — no dedicated PE log categories
PE Configuration Tracking: Via Azure Activity Log (subscription-level)
Network Traffic Logging: Via NSG Flow Logs on PE subnet
PE Connection State: Via parent resource diagnostic settings
```

---

## Retention

| Tier | Retention Period | Justification |
|------|-----------------|---------------|
| Hot (Log Analytics) | 90 days | Active query and alerting |
| Archive (Storage Account) | 7 years | FedRAMP AU-11 audit record retention |

---

## Alert Rules

The following alerts MUST be configured in the shared monitoring infrastructure:

| Alert Name | Condition | Severity | Action Group | NIST Control |
|-----------|-----------|----------|-------------|--------------|
| PE Connection State Change | Activity Log where PE connection state changes from "Approved" to "Disconnected" or "Rejected" | Sev 1 (Error) | NOC + Network Team | SC-7, SI-4 |
| PE Deleted | Activity Log where operationName contains "privateEndpoints/delete" | Sev 1 (Error) | SOC + Network Team | SC-7, CM-3 |
| PE Created Without DNS Zone Group | Activity Log where PE created and no subsequent DNS zone group creation within 5 minutes | Sev 2 (Warning) | Network Team | SC-7, SC-20 |

---

## Log Query Examples

### Private Endpoint Creation/Deletion Activity
```kusto
AzureActivity
| where ResourceProvider == "MICROSOFT.NETWORK"
| where OperationNameValue has "PRIVATEENDPOINTS"
| where ActivityStatusValue == "Success"
| project TimeGenerated, Caller, OperationNameValue, ResourceGroup, Resource
| order by TimeGenerated desc
```

### PE Connection State Changes
```kusto
AzureActivity
| where ResourceProvider == "MICROSOFT.NETWORK"
| where OperationNameValue has "PRIVATEENDPOINTCONNECTIONS"
| project TimeGenerated, Caller, OperationNameValue, ResourceGroup, Resource, Properties
| order by TimeGenerated desc
```

### NSG Flow Logs for PE Subnet Traffic
```kusto
AzureNetworkAnalytics_CL
| where SubType_s == "FlowLog"
| where Subnet_s contains "pe-subnet"
| summarize TotalFlows = count(), AllowedFlows = countif(FlowStatus_s == "A"), DeniedFlows = countif(FlowStatus_s == "D") by DestIP_s, DestPort_d, bin(TimeGenerated, 5m)
| order by TotalFlows desc
```
