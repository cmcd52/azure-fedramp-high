# Logging Configuration: Private DNS Zone

**Service**: Private DNS Zone
**Category**: Networking
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL1 (Basic) for zone configuration changes

---

## Diagnostic Categories

Azure Private DNS Zones have limited native diagnostic log support. DNS query logging is achieved through DNS Private Resolver integration, not directly from the zone resource.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| Activity Log | Zone creation, deletion, record set changes, VNet link modifications — captured via Azure Activity Log (not diagnostic settings) | EL1 | AU-2, AU-3, AU-12 |

> **Important**: DNS query logs (which client queried which domain) are NOT available as a diagnostic setting on Private DNS Zones. Query logging is achieved via the DNS Private Resolver (see `services/networking/dns-private-resolver/logging/config.md`).

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace (via Activity Log diagnostic settings) | Per `shared/terraform/log-analytics/` |

**Configuration method**: Activity Log diagnostic settings route zone modification events to Log Analytics. This is configured at the subscription level, not per-resource. DNS query logging requires DNS Private Resolver integration.

### Configuration Note

```
Resource: Microsoft.Network/privateDnsZones
Native Diagnostic Settings: Limited — no query-level logs available
Zone Change Tracking: Via Azure Activity Log (subscription-level diagnostic setting)
DNS Query Logging: Via DNS Private Resolver (services/networking/dns-private-resolver/)
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
| DNS Zone Record Modified | Activity Log where operationName contains "privateDnsZones/write" or "recordSets/write" | Sev 3 (Informational) | Security Team | AU-12, CM-3 |
| DNS Zone Deleted | Activity Log where operationName contains "privateDnsZones/delete" | Sev 1 (Error) | SOC + Network Team | AU-12, CM-3 |
| VNet Link Modified | Activity Log where operationName contains "virtualNetworkLinks/write" or "virtualNetworkLinks/delete" | Sev 2 (Warning) | Network Team | SC-7, CM-3 |

---

## Log Query Examples

### Zone Record Modifications
```kusto
AzureActivity
| where ResourceProvider == "MICROSOFT.NETWORK"
| where OperationNameValue has "PRIVATEDNSZONES"
| where ActivityStatusValue == "Success"
| project TimeGenerated, Caller, OperationNameValue, ResourceGroup, Resource
| order by TimeGenerated desc
```

### VNet Link Changes
```kusto
AzureActivity
| where ResourceProvider == "MICROSOFT.NETWORK"
| where OperationNameValue has "VIRTUALNETWORKLINKS"
| where ActivityStatusValue == "Success"
| project TimeGenerated, Caller, OperationNameValue, ResourceGroup, Resource
| order by TimeGenerated desc
```

### Failed Zone Operations (Unauthorized)
```kusto
AzureActivity
| where ResourceProvider == "MICROSOFT.NETWORK"
| where OperationNameValue has "PRIVATEDNSZONES"
| where ActivityStatusValue == "Failed"
| project TimeGenerated, Caller, OperationNameValue, ActivityStatusValue, Properties
| order by TimeGenerated desc
```
