# Security Control Baseline: Event Hubs

**Service**: Event Hubs (Microsoft.EventHub/namespaces)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Event Hubs provides real-time event streaming and ingestion for federal workloads — supporting millions of events per second with low latency. The service enforces defense-in-depth security: Premium tier with Private Endpoint-only access, TLS 1.2 minimum, RBAC-based authentication (no SAS keys in production), customer-managed key encryption with infrastructure encryption, zone redundancy, auto-inflate for scaling, Event Hubs Capture for encrypted archival, and comprehensive diagnostic logging across nine log categories.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the Event Hubs namespace, Private Endpoint, CMK encryption, and diagnostic settings. Event Hubs, consumer groups, and Capture configuration are managed separately.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Azure Event Hubs Data Owner | Namespace (via PIM) | Full control over Event Hubs data operations including consumer groups. JIT activation required. | AC-2, AC-3, AC-6 |
| Azure Event Hubs Data Sender | Event Hub | Send events to specific Event Hubs for application managed identities. Standing assignment. | AC-3 |
| Azure Event Hubs Data Receiver | Event Hub / Consumer Group | Receive events from specific Event Hubs for application managed identities. Standing assignment. | AC-3 |
| Contributor | Resource group (via PIM) | Manage Event Hubs namespace configuration and scaling. JIT activation required. | AC-2, AC-3, AC-6 |
| Reader | Resource group | Read-only access for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned
- Usage: Application services authenticate to Event Hubs via managed identity and RBAC roles — no SAS tokens
- Supported roles: Event Hubs Data Sender, Event Hubs Data Receiver, Event Hubs Data Owner
- NIST: IA-2, IA-5

### Authentication Model: RBAC Only (Production)

- SAS keys: **Disabled** in production (`local_authentication_enabled = false`)
- All data plane operations authenticated via Entra ID bearer tokens with Event Hubs Data Sender/Receiver roles
- Enables conditional access policies, MFA for interactive users, and audit logging of caller identity
- NIST: IA-2, AC-3

### No SAS Keys in Production

- SAS tokens provide broad access without per-identity tracking
- Compromised SAS tokens cannot be individually revoked — only namespace key regeneration
- RBAC with managed identity provides per-identity audit trail and fine-grained access control
- Policy `audit-eventhubs-managed-identity-v1` enforces managed identity configuration
- NIST: AC-3, AC-6, IA-2

---

## Network Security Controls

### Private Endpoint

- Status: Required
- Private DNS Zone: `privatelink.servicebus.windows.net`
- All event sending and receiving traffic flows exclusively through Private Endpoint
- NIST: SC-7

### Network Rules

- Default action: **Deny** — no public network access
- Public network access: Disabled (`public_network_access_enabled = false`)
- Trusted services: Enabled for Azure platform services (Event Grid, Stream Analytics, IoT Hub)
- No IP rules or VNet rules — Private Endpoint only
- NIST: SC-7

---

## Encryption Controls

### Encryption at Rest

- Default: Platform-managed keys (AES-256)
- Optional: Customer-managed key via Key Vault (with infrastructure encryption enabled)
- Infrastructure encryption: Double encryption — data encrypted with both platform and customer keys
- Event data: All events encrypted at rest in Event Hubs storage
- FIPS 140-2: Azure Event Hubs uses FIPS 140-2 validated cryptographic modules
- NIST: SC-13, SC-28

### Encryption in Transit

- Protocol: TLS 1.2+ for all AMQP, Kafka, and HTTPS connections
- Minimum TLS version: 1.2 (enforced via Terraform and policy)
- FIPS 140-2: Azure TLS uses FIPS 140-2 validated cryptographic modules
- NIST: SC-8, SC-13

---

## Event Hubs Capture (Event Archival)

### Capture Configuration

- Destination: Azure Blob Storage or Azure Data Lake Storage Gen2
- Encryption: Captured events encrypted at rest in destination storage (follows storage account encryption — CMK supported)
- Format: Avro format with schema
- Retention: Configurable per Event Hub
- NIST: SC-28 (encrypted archival), AU-11 (audit record retention)

---

## Zone Redundancy

- Status: Enabled (Premium tier default)
- Availability zones: Namespace replicated across 3 availability zones
- Event data: Automatically replicated for high availability
- NIST: CP-6 (alternate storage site), CP-10 (information system recovery)

---

## Logging & Monitoring Controls

- Diagnostic categories: ArchiveLogs, OperationalLogs, AutoScaleLogs, KafkaCoordinatorLogs, KafkaUserErrorLogs, EventHubVNetConnectionEvent, CustomerManagedKeyUserLogs, RuntimeAuditLogs, ApplicationMetricsLogs
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: EL2 for operational; EL3 for VNet connection and CMK events
- Alert rules: Throttling events, CMK rotation failure, namespace health degradation, SAS token usage
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Private Endpoint; public access disabled; network rules default deny | Terraform: public_network_access_enabled = false, PE; Policy: deny-eventhubs-public-access-v1 |
| SC-8 | Transmission Confidentiality | TLS 1.2 minimum for AMQP, Kafka, HTTPS | Terraform: minimum_tls_version = "1.2"; Policy: deny-eventhubs-minimum-tls-v1 |
| SC-13 | Cryptographic Protection | FIPS 140-2 validated modules; CMK with infrastructure encryption | Terraform: CMK resource |
| SC-28 | Protection of Information at Rest | CMK encryption; infrastructure double encryption; Capture to encrypted storage | Terraform: CMK + Capture |
| IA-2 | Identification and Authentication | Managed identity; SAS keys disabled in production | Terraform: identity, local_authentication_enabled; Policy: audit-eventhubs-managed-identity-v1 |
| AC-3 | Access Enforcement | RBAC with Data Sender/Receiver roles; no SAS keys in production | RBAC assignments |
| AU-12 | Audit Generation | 9 diagnostic log categories | Terraform: diagnostic settings |

---

## DISA STIG Mapping

No published DISA STIG for Azure Event Hubs. Compensating controls: NIST 800-53 controls + CIS Azure Benchmark (per R-002).

*"No published DISA STIG for this service. Compensating controls: NIST 800-53 + CIS Benchmark."*

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | RBAC with Data Sender/Receiver roles; SAS keys disabled; managed identity auth | AC-2, AC-3, IA-2 |
| 3.5.1 Identify system users | Entra ID authentication; managed identity caller tracking in audit logs | IA-2 |
| 3.13.8 Implement cryptographic mechanisms for CUI in transit | TLS 1.2 for AMQP, Kafka, and HTTPS | SC-8, SC-13 |
| 3.13.11 Employ FIPS-validated cryptography | FIPS 140-2 validated TLS and encryption modules | SC-13 |
| 3.13.16 Protect confidentiality of CUI at rest | CMK encryption with infrastructure double encryption | SC-28 |
| 3.14.6 Monitor organizational systems | 9 diagnostic log categories; VNet and CMK event monitoring | SI-4, AU-12 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.8 | TLS 1.2 for all Event Hubs connections |
| SC.L2-3.13.11 | FIPS 140-2 validated cryptographic modules |
| SC.L2-3.13.16 | CMK + infrastructure encryption at rest |
| AC.L2-3.1.1 | RBAC auth; no SAS keys in production |
| SI.L2-3.14.6 | 9 diagnostic categories + VNet/CMK monitoring |
| AU.L2-3.3.1 | Comprehensive Event Hubs logging |

### OMB M-21-31 (Logging Maturity)

- Target tier: EL2 for operational, EL3 for security events
- Achieved tier: EL2/EL3 — All 9 log categories collected

---
