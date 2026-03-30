# Security Control Baseline: Azure Purview

**Service**: Azure Purview (Microsoft.Purview/accounts)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Purview provides unified data governance — data cataloging, classification, lineage tracking, and access policies — for federal data estates. The service enforces defense-in-depth security: Private Endpoint-only access (account, portal, and ingestion endpoints), system-assigned managed identity for credential-free data source scanning, managed VNet isolation for scan runtime, platform-managed encryption with TLS 1.2, and comprehensive diagnostic logging for scan status, data sensitivity discovery, and security events.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the Purview account, three Private Endpoints (account, portal, ingestion), and diagnostic settings. Data source registration, scan rules, and collection hierarchy are managed separately via the Purview governance portal or API.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Purview Data Source Administrator | Root collection (via PIM) | Register and manage data sources for scanning. JIT activation required. | AC-2, AC-3, AC-6 |
| Purview Data Reader | Collection | Read-only access to data catalog metadata for application managed identities and analysts. Standing assignment. | AC-3 |
| Purview Data Curator | Collection (via PIM) | Edit and curate metadata, classifications, and glossary terms. JIT activation required. | AC-2, AC-3, AC-6 |
| Root Collection Admin | Root collection (via PIM) | Full administrative control over Purview collections, role assignments, and account settings. JIT activation required. Break-glass only. | AC-2, AC-3, AC-6 |
| Reader | Resource group | Read-only access for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned
- Usage: Purview authenticates to data sources (Azure Blob, SQL, Cosmos DB, ADLS Gen2) via managed identity — no stored credentials
- Scanning: Credential-free scanning eliminates the need for Key Vault–stored connection strings
- NIST: IA-2, IA-5

### Data Governance Boundary Controls

- Root collection admin: Restricted to break-glass accounts via PIM JIT activation
- Collection hierarchy: Mirrors organizational boundaries — each collection inherits parent RBAC unless overridden
- Data source registration: Only Purview Data Source Administrator role can register scanning targets
- Cross-collection access: Explicitly denied by default — users see only collections to which they are assigned
- NIST: AC-3, AC-6

---

## Network Security Controls

### Private Endpoints (Multiple Required)

Azure Purview requires **three** Private Endpoints for fully private connectivity:

| PE Sub-resource | Purpose | Private DNS Zone | NIST Control |
|----------------|---------|-----------------|--------------|
| `account` | Purview account API access (governance operations) | `privatelink.purview.azure.com` | SC-7 |
| `portal` | Purview Studio (governance portal) browser access | `privatelink.purviewstudio.azure.com` | SC-7 |
| `ingestion` | Managed storage (blob, queue) and Event Hubs namespace for scan data ingestion | `privatelink.blob.core.windows.net` | SC-7 |

- Status: Required
- Without all three PEs, scanning and portal access will fail when public access is disabled
- NIST: SC-7

### Network Rules

- Public network access: **Disabled** (`public_network_enabled = false`)
- Managed VNet: Enabled for scan runtime isolation — Purview scans execute in a Microsoft-managed VNet
- All governance, portal, and ingestion traffic flows exclusively through Private Endpoints
- NIST: SC-7

---

## Data Source Scanning Security

### Credential-Free Scanning

- Authentication: System-assigned managed identity for all supported data sources
- No connection strings or passwords stored in Purview or Key Vault
- Supported sources: Azure Blob Storage, ADLS Gen2, Azure SQL, Cosmos DB, Synapse Analytics
- NIST: IA-2, IA-5

### Scan Runtime Isolation

- Managed VNet: Scans execute in a Microsoft-managed virtual network
- No customer VNet integration required for scan runtime
- Scan traffic to data sources flows through managed PE connections
- NIST: SC-7

---

## Encryption Controls

### Encryption at Rest

- Default: Platform-managed keys (AES-256)
- Purview metadata catalog: Encrypted at rest with platform-managed keys
- Managed storage (scan results): Platform-managed encryption
- FIPS 140-2: Azure Purview uses FIPS 140-2 validated cryptographic modules
- NIST: SC-13, SC-28

### Encryption in Transit

- Protocol: TLS 1.2+ for all API and portal interactions
- Scanning connections: TLS 1.2 for data source connectivity
- FIPS 140-2: Azure TLS uses FIPS 140-2 validated cryptographic modules
- NIST: SC-8, SC-13

---

## Logging & Monitoring Controls

- Diagnostic categories: ScanStatusLogEvent, DataSensitivityLogEvent, Security
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: EL2
- Alert rules: Scan failure, sensitive data discovered, unauthorized collection access
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Three Private Endpoints (account, portal, ingestion); public access disabled; managed VNet scanning | Terraform: public_network_enabled = false, PEs; Policy: deny-purview-public-access-v1 |
| SC-8 | Transmission Confidentiality | TLS 1.2 for all API, portal, and scanning connections | Platform guarantee |
| IA-2 | Identification and Authentication | System-assigned managed identity; credential-free scanning | Terraform: identity; Policy: audit-purview-managed-identity-v1 |
| AU-12 | Audit Generation | ScanStatusLogEvent, DataSensitivityLogEvent, Security diagnostic logs | Terraform: diagnostic settings; Policy: audit-purview-diagnostic-settings-v1 |
| AC-3 | Access Enforcement | Collection-based RBAC; root collection admin via PIM | Purview collection hierarchy |
| AC-6 | Least Privilege | PIM JIT for administrative roles; read-only standing assignments only | Purview RBAC + PIM |

---

## DISA STIG Mapping

No published DISA STIG for Azure Purview. Compensating controls: NIST 800-53 controls + CIS Azure Benchmark (per R-002).

*"No published DISA STIG for this service. Compensating controls: NIST 800-53 + CIS Benchmark."*

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | Collection-based RBAC; PIM JIT for admin roles | AC-2, AC-3, IA-2 |
| 3.5.1 Identify system users | Entra ID authentication; managed identity for scanning | IA-2 |
| 3.13.8 Implement cryptographic mechanisms for CUI in transit | TLS 1.2 for all connections | SC-8, SC-13 |
| 3.13.11 Employ FIPS-validated cryptography | FIPS 140-2 validated TLS and encryption modules | SC-13 |
| 3.14.6 Monitor organizational systems | Scan status, data sensitivity, and security logging | SI-4, AU-12 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.8 | TLS 1.2 for all governance and scanning interactions |
| SC.L2-3.13.11 | FIPS 140-2 validated cryptographic modules |
| AC.L2-3.1.1 | Collection RBAC; managed identity for scanning |
| SI.L2-3.14.6 | Scan status + data sensitivity + security logging |
| AU.L2-3.3.1 | ScanStatusLogEvent, DataSensitivityLogEvent, Security logging |

### OMB M-21-31 (Logging Maturity)

- Target tier: EL2
- Achieved tier: EL2 — ScanStatusLogEvent, DataSensitivityLogEvent, Security collected

---
