# Security Control Baseline: Azure Monitor / Log Analytics

**Service**: Azure Monitor / Log Analytics
**Category**: Networking
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Monitor and Log Analytics form the centralized audit and monitoring platform for the FedRAMP High environment. The shared Log Analytics workspace (deployed by `shared/terraform/log-analytics/`) is the primary destination for all diagnostic logs, Azure Activity Logs, and agent-collected telemetry. This module deploys the additional monitoring infrastructure: action groups for alerting, activity log alerts for critical events, and data export rules for long-term archive to storage.

Azure Monitor is unique in that it is both a monitored service AND the monitoring infrastructure. Its compliance posture directly impacts the integrity of the entire FedRAMP audit boundary — a compromised or misconfigured monitoring platform undermines all other service audit controls.

**Configuration method**: Terraform (`terraform/main.tf`) deploys action groups, activity log alerts, and data export rules. The core Log Analytics workspace is managed by `shared/terraform/log-analytics/`.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Log Analytics Contributor | Workspace resource (via PIM) | Manages workspace configuration, data collection rules, and saved queries. JIT activation required. | AC-2, AC-3, AC-6 |
| Log Analytics Reader | Workspace resource | Read-only access to query logs and view workspace configuration. Standing assignment for auditors and analysts. | AC-3, AU-6 |
| Monitoring Contributor | Resource group (via PIM) | Manages action groups, alert rules, and diagnostic settings. JIT activation required. | AC-2, AC-3, AC-6 |
| Monitoring Reader | Resource group | Read-only access to metrics, alerts, and diagnostic settings for NOC team. Standing assignment. | AU-6 |
| Microsoft Sentinel Contributor | Workspace resource (via PIM) | Manages Sentinel workbooks, analytics rules, and incidents. JIT activation required. | AC-2, AC-3, AC-6, IR-4 |

### Data Access Security

- **Workspace-context access**: Users with workspace-level permissions can query ALL data in the workspace. Use for SOC analysts and auditors who need cross-service correlation.
- **Resource-context access**: Users with read access to a specific resource can query that resource's logs in the workspace without broader workspace access. Use for service teams.
- **Table-level RBAC**: Restrict access to sensitive tables (e.g., `SecurityEvent`, `SigninLogs`) using table-level RBAC. SOC team only.
- NIST: AC-3, AC-6

### Managed Identity

- Type: Not directly applicable — Azure Monitor is a platform service
- Data export rule: Uses workspace identity for storage account access
- NIST: IA-2

---

## Network Security Controls

### Private Link (Azure Monitor Private Link Scope — AMPLS)

- **Requirement**: Azure Monitor Private Link Scope SHOULD be configured for environments requiring all monitoring traffic to traverse private networks
- **Scope**: AMPLS links Log Analytics workspaces and Application Insights components to a private endpoint
- **Limitation**: AMPLS has a limit of 50 resources per scope — plan capacity accordingly
- **Configuration**: Managed separately from this module — see network architecture documentation
- NIST: SC-7

### Public Endpoint

- Status: Azure Monitor is a platform service with public endpoints for data ingestion and query
- Mitigation: Configure workspace to require AMPLS for ingestion and query when private-only network access is required
- Data in transit: TLS 1.2+ enforced for all Azure Monitor API and agent communications
- NIST: SC-7, SC-8

---

## Encryption Controls

### Encryption at Rest

- **Default**: Azure Monitor encrypts all data at rest using Microsoft-managed keys (AES-256)
- **CMK (optional)**: Customer-managed key encryption available via Log Analytics dedicated cluster. Key stored in Azure Key Vault.
- **Scope**: CMK encrypts all data ingested into the workspace — queries, alerts, and saved searches also encrypted
- **Policy**: `audit-loganalytics-cmk-encryption-v1` audits workspaces without CMK
- NIST: SC-28

### Encryption in Transit

- Protocol: TLS 1.2+ for all Azure Monitor API, agent, and data ingestion communications
- Azure Monitor Agent: Communicates over TLS 1.2 to Azure Monitor data collection endpoints
- NIST: SC-8, SC-13

---

## Retention Controls

### Workspace Retention

- **Minimum**: 365 days online retention (enforced by `deny-loganalytics-retention-minimum-v1` policy)
- **Recommended**: 365 days online + archive to storage for 7 years total
- **Policy**: Deny effect prevents workspace creation/update with retention below 365 days
- NIST: AU-11

### Archive Retention

- **Mechanism**: Log Analytics data export rule exports to Azure Storage Account
- **Storage retention**: 18 months minimum in storage (immutable blob storage recommended)
- **Total retention**: 7 years (365 days online + 6 years archived) for FedRAMP AU-11
- NIST: AU-11

### OMB M-21-31 Alignment

Azure Monitor is the platform that implements OMB M-21-31 logging tiers:

| OMB Tier | Description | Retention | Implementation |
|----------|------------|-----------|----------------|
| EL0 | No logging | N/A | Not acceptable for FedRAMP High |
| EL1 | Basic | 90 days | Minimum baseline |
| EL2 | Intermediate | 365 days | Standard activity and resource logs |
| EL3 | Advanced | 365 days + archive | Security events, authentication, network flows |

---

## Logging & Monitoring Controls

- Self-monitoring: Workspace cannot send its own diagnostic logs to itself — forward to secondary workspace or use Azure Monitor Agent
- Activity Log: All subscription-level events forwarded to Log Analytics
- Action group alerts: Resource deletion, role assignment changes, policy violations
- Data export: Archive to storage for long-term retention
- OMB M-21-31 tier: EL2 for platform monitoring
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| AU-2 | Audit Events | Activity Log captures all subscription events; diagnostic settings per service | Activity Log diagnostic settings; per-service diagnostic settings |
| AU-3 | Content of Audit Records | Activity Log includes who, what, when, where, outcome; resource logs include service-specific detail | Log Analytics query: AzureActivity schema |
| AU-6 | Audit Review, Analysis, and Reporting | Action group alerts for critical events; Sentinel analytics rules; saved queries | Terraform: activity log alerts, action group |
| AU-11 | Audit Record Retention | 365 days online (policy enforced); 7 years total via data export to storage | deny-loganalytics-retention-minimum-v1 policy; data export rule |
| AU-12 | Audit Generation | Azure Monitor Agent collects VM logs; diagnostic settings for PaaS; Activity Log for platform | Terraform: DCR, diagnostic settings, Activity Log |
| AU-16 | Cross-Organizational Audit Logging | Data export to storage enables cross-boundary audit sharing | Data export rule |
| SC-28 | Protection of Information at Rest | CMK encryption for workspace data (optional); storage encryption for archive | audit-loganalytics-cmk-encryption-v1 policy |
| AC-2 | Account Management | Activity log alerts on role assignment changes; SigninLogs for authentication events | Terraform: role_assignment alert |
| IR-4 | Incident Handling | Action group notifications to SOC; Sentinel incident creation | Action group with email/SMS receivers |

## DISA STIG Mapping

No published DISA STIG for Azure Monitor / Log Analytics. Compensating controls: NIST 800-53 AU family applied directly, workspace retention policy enforcement, CMK encryption audit, Activity Log diagnostic settings verification.

---

## Additional Framework Mappings

| Framework | Control | Implementation |
|-----------|---------|----------------|
| DFARS 252.204-7012 | Adequate security for CUI | Centralized logging with retention and encryption |
| CMMC 2.0 L2 | AU.L2-3.3.1 | System-level auditing via Azure Monitor |
| OMB M-21-31 | EL2/EL3 | Platform monitoring with tiered retention |
