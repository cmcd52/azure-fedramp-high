# Logging Configuration: VMs for DNS

**Service**: VMs for DNS (Windows Server 2022 Datacenter)
**Category**: Networking
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL3 (Advanced) for security events (auth, privilege escalation, account management)

---

## Log Collection Architecture

VM log collection uses **Azure Monitor Agent (AMA)** with **Data Collection Rules (DCR)** to forward Windows Event Logs, performance counters, and custom logs to the centralized Log Analytics workspace. AMA replaces the legacy Log Analytics agent (MMA).

```
VM → Azure Monitor Agent → Data Collection Rule → Log Analytics Workspace
```

---

## Windows Event Log Categories

All Windows Event Log categories below MUST be collected and forwarded to Log Analytics.

| Log Category | XPath Query | OMB M-21-31 Tier | NIST Control |
|-------------|-------------|-------------------|--------------|
| Security | `Security!*` | EL3 | AU-2, AU-3, AU-12 |
| System | `System!*` | EL2 | AU-2, AU-12 |
| Application (Errors/Warnings/Critical) | `Application!*[System[(Level=1 or Level=2 or Level=3)]]` | EL2 | AU-2, AU-12 |

### Security Event Log Subcategories (EL3)

| Subcategory | Event IDs (Key) | Description | NIST Control |
|-------------|----------------|-------------|--------------|
| Account Logon | 4624, 4625, 4648 | Successful/failed logon, explicit credentials | AU-2, IA-2 |
| Account Management | 4720, 4722, 4723, 4724, 4725, 4726 | User account created, enabled, password change, deleted | AU-2, AC-2 |
| Privilege Use | 4672, 4673, 4674 | Special privilege assigned, privileged service called | AU-2, AC-6 |
| Policy Change | 4719, 4739 | System audit policy changed, domain policy changed | AU-2, CM-6 |
| Object Access | 4663, 4656 | Object access attempt | AU-2, AC-3 |
| Process Creation | 4688 | New process created (with command-line logging) | AU-2, SI-4 |
| Logon/Logoff | 4634, 4647 | Account logoff, user-initiated logoff | AU-2 |

---

## Azure Monitor Agent Categories

| Category | Stream | Description | OMB M-21-31 Tier | NIST Control |
|----------|--------|-------------|-------------------|--------------|
| InsightsMetrics | Microsoft-InsightsMetrics | CPU, memory, disk, network performance counters | EL1 | SI-4 |
| Event | Microsoft-Event | Windows Event Log forwarding | EL3 | AU-2, AU-12 |

---

## Sysmon (Recommended)

Sysmon is RECOMMENDED for detailed process, network, and file system telemetry beyond standard Windows Event Logs.

| Sysmon Event | Event ID | Description | OMB M-21-31 Tier | NIST Control |
|-------------|----------|-------------|-------------------|--------------|
| Process Create | 1 | Process creation with hashes and command line | EL3 | AU-2, SI-4 |
| Network Connection | 3 | TCP/UDP network connections | EL3 | AU-2, SC-7 |
| File Create | 11 | File creation events | EL2 | AU-2, SI-7 |
| Registry Modification | 13 | Registry value set events | EL3 | AU-2, CM-6 |
| DNS Query | 22 | DNS query events (process-level DNS visibility) | EL3 | AU-2, SC-20 |

> **Installation**: Sysmon is deployed via Custom Script Extension or DSC. Sysmon configuration should use a security-focused config (e.g., SwiftOnSecurity Sysmon config adapted for FedRAMP).

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the Azure Monitor Agent extension and Data Collection Rule in `terraform/main.tf`. The DCR defines XPath queries for Windows Event Logs and performance counter sampling.

### Data Collection Rule Configuration

```
Resource: Data Collection Rule
Name: "{vm_name}-dcr"
Data Sources:
  Windows Event Log:
    - Security!*
    - System!*
    - Application!*[System[(Level=1 or Level=2 or Level=3)]]
  Performance Counters:
    - \Processor(_Total)\% Processor Time
    - \Memory\% Committed Bytes In Use
    - \LogicalDisk(_Total)\% Free Space
    - \Network Interface(*)\Bytes Total/sec
  Sampling: 60 seconds
Destinations:
  - Log Analytics workspace (shared)
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
| Failed Login | SecurityEvent where EventID == 4625 count > 5 in 5 minutes per source IP | Sev 1 (Error) | SOC + Incident Response | IA-2, SI-4 |
| New Service Installed | SecurityEvent where EventID == 7045 | Sev 2 (Warning) | SOC | SI-7, CM-6 |
| Firewall Rule Change | SecurityEvent where EventID == 4946 or EventID == 4947 | Sev 2 (Warning) | Network Team + SOC | SC-7, CM-6 |
| STIG Drift Detected | GuestConfigurationAssignment where complianceStatus == "NonCompliant" | Sev 2 (Warning) | Security Team | CM-6, SI-7 |
| Privilege Escalation | SecurityEvent where EventID == 4672 from non-admin account | Sev 1 (Error) | SOC + Incident Response | AC-6, SI-4 |
| Account Created/Deleted | SecurityEvent where EventID in (4720, 4726) | Sev 2 (Warning) | Security Team | AC-2 |
| Process Anomaly (Sysmon) | Sysmon EventID 1 where process hash not in allowlist | Sev 2 (Warning) | SOC | SI-4, SI-7 |
| DNS Query Anomaly (Sysmon) | Sysmon EventID 22 where QueryName matches threat intelligence | Sev 1 (Error) | SOC + Incident Response | SC-20, SI-4 |

---

## Log Query Examples

### Failed Logon Attempts
```kusto
SecurityEvent
| where EventID == 4625
| summarize FailedCount = count() by TargetAccount, IpAddress, bin(TimeGenerated, 5m)
| where FailedCount > 5
| order by FailedCount desc
```

### Privilege Escalation Events
```kusto
SecurityEvent
| where EventID == 4672
| project TimeGenerated, Account, LogonType, PrivilegeList
| order by TimeGenerated desc
```

### New Services Installed
```kusto
SecurityEvent
| where EventID == 7045
| project TimeGenerated, Computer, ServiceName = EventData
| order by TimeGenerated desc
```

### STIG Compliance Status
```kusto
GuestConfigurationResources
| where type == "microsoft.guestconfiguration/guestconfigurationassignments"
| where name contains "WindowsServer2022"
| project name, complianceStatus, lastComplianceStatusChecked, resourceGroup
| order by lastComplianceStatusChecked desc
```

### Firewall Rule Changes
```kusto
SecurityEvent
| where EventID in (4946, 4947, 4948, 4950)
| project TimeGenerated, Computer, EventID, Activity
| order by TimeGenerated desc
```

### Account Management Events
```kusto
SecurityEvent
| where EventID in (4720, 4722, 4723, 4724, 4725, 4726)
| project TimeGenerated, Computer, EventID, Activity, TargetAccount, SubjectAccount
| order by TimeGenerated desc
```
