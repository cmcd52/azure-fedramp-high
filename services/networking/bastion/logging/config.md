# Logging Configuration: Azure Bastion

**Service**: Azure Bastion (Standard SKU)
**Category**: Networking
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL3 (Advanced) — all Bastion events are privileged access events

---

## Diagnostic Categories

All available Azure Bastion diagnostic log categories MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| BastionAuditLogs | All Bastion session events including session start, session end, user identity (UPN), target VM resource ID, target VM IP, connection protocol (RDP/SSH), session duration, and connection result (success/failure) | EL3 | AU-2, AU-3, AU-12 |

### BastionAuditLogs Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `operationName` | Session operation (SessionStarted, SessionEnded, SessionFailed) | AU-3 |
| `userName` | Entra ID UPN of the connecting user | AU-3 |
| `userAgent` | Client user agent string (browser or native client) | AU-3 |
| `sessionStartTime` | UTC timestamp of session initiation | AU-3 |
| `sessionEndTime` | UTC timestamp of session termination | AU-3 |
| `targetVMIPAddress` | Private IP of the target VM | AU-3 |
| `targetResourceId` | Azure Resource ID of the target VM | AU-3 |
| `protocol` | Connection protocol (SSH or RDP) | AU-3 |
| `clientIpAddress` | Source IP of the admin user | AU-3 |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The Bastion host resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.Network/bastionHosts
Name: "{bastion_name}-diag"
Destination: Log Analytics workspace (shared)
Log Categories:
  - BastionAuditLogs — Enabled
Metrics: AllMetrics — Enabled
```

---

## Retention

| Tier | Retention Period | Justification |
|------|-----------------|---------------|
| Hot (Log Analytics) | 90 days | Active query and alerting |
| Archive (Storage Account) | 7 years | FedRAMP AU-11 audit record retention; privileged access records |

---

## Alert Rules

The following alerts MUST be configured in the shared monitoring infrastructure:

| Alert Name | Condition | Severity | Action Group | NIST Control |
|-----------|-----------|----------|-------------|--------------|
| Session From Unusual Location | BastionAuditLogs where clientIpAddress not in known admin IP ranges | Sev 1 (Error) | SOC + Incident Response | AC-17, SI-4 |
| Excessive Session Count | BastionAuditLogs where operationName == "SessionStarted" count > 20 per user per hour | Sev 2 (Warning) | SOC | AC-2, SI-4 |
| Session to Unauthorized VM | BastionAuditLogs where targetResourceId not in approved VM list | Sev 1 (Error) | SOC + Incident Response | AC-3, AC-17 |
| Failed Session Attempts | BastionAuditLogs where operationName == "SessionFailed" count > 5 per user in 15 minutes | Sev 1 (Error) | SOC | AC-7, SI-4 |
| After-Hours Session | BastionAuditLogs where sessionStartTime outside business hours (M-F 6AM-8PM ET) | Sev 3 (Informational) | Security Team | AC-17, AU-6 |

---

## Log Query Examples

### Active Sessions
```kusto
MicrosoftAzureBastionAuditLogs
| where OperationName == "SessionStarted"
| where TimeGenerated > ago(24h)
| project TimeGenerated, UserName, ClientIpAddress, TargetVMIPAddress, Protocol = Message
| order by TimeGenerated desc
```

### Failed Session Attempts
```kusto
MicrosoftAzureBastionAuditLogs
| where OperationName == "SessionFailed"
| summarize FailureCount = count() by UserName, ClientIpAddress, bin(TimeGenerated, 15m)
| where FailureCount > 3
| order by FailureCount desc
```

### Sessions From Unknown IPs
```kusto
let knownAdminIPs = dynamic(["10.0.0.0/8", "172.16.0.0/12"]);
MicrosoftAzureBastionAuditLogs
| where OperationName == "SessionStarted"
| where not(ipv4_is_in_any_range(ClientIpAddress, knownAdminIPs))
| project TimeGenerated, UserName, ClientIpAddress, TargetVMIPAddress
| order by TimeGenerated desc
```
