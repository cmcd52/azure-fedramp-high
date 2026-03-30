# Security Control Baseline: Azure Storage Account

**Service**: Azure Storage Account
**Category**: Compute & Storage
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Storage Account provides blob, queue, table, and file storage services for federal workloads. Storage Accounts enforce defense-in-depth security: customer-managed key (CMK) encryption in production with FIPS 140-2 validated modules, no public access, HTTPS-only, TLS 1.2, RBAC-only access (shared key disabled), blob versioning and soft-delete for data protection, and Private Endpoint for network isolation.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the Storage Account with security properties, Private Endpoint for blob, and diagnostic settings for all four sub-services (blob, queue, table, file).

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Storage Blob Data Contributor | Storage Account (via PIM) | Read/write blob data. JIT activation required. | AC-2, AC-3, AC-6 |
| Storage Blob Data Reader | Storage Account | Read-only blob access for application managed identities. Standing assignment. | AC-3 |
| Storage Account Contributor | Resource group (via PIM) | Manages Storage Account configuration. JIT activation required. | AC-2, AC-3, AC-6 |
| Reader | Resource group | Read-only access to Storage Account configuration for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to Storage metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned (for Storage Account) + User-assigned (for CMK access)
- Usage: Application services authenticate to Storage via managed identity and RBAC roles — no access keys or SAS tokens
- CMK identity: User-assigned identity with Key Vault Crypto Service Encryption User role for CMK key access
- NIST: IA-2, IA-5

### Access Model: RBAC-Only

- Shared key access: **Disabled** in production (`shared_access_key_enabled = false`)
- SAS tokens: Not available when shared key is disabled
- All data plane access via Entra ID authentication + RBAC roles
- Eliminates root-level access risk from shared keys
- NIST: AC-3, AC-6

---

## Network Security Controls

### Private Endpoint

- Status: Required
- Private DNS Zone: `privatelink.blob.core.windows.net` (additional zones per sub-service)
- All data plane traffic flows exclusively through Private Endpoint
- NIST: SC-7

### Network Rules

- Default action: **Deny** — no public network access
- Bypass: Azure Services (for trusted Azure service access)
- No IP rules or VNet rules — Private Endpoint only
- NIST: SC-7

### Firewall / NSG Rules

| Rule | Direction | Source | Destination | Port | Action | NIST Control |
|------|-----------|--------|-------------|------|--------|--------------|
| Allow-Storage-PE-Inbound | Inbound | VNet/Spoke | PE subnet | 443 | Allow | SC-7 |
| Deny-Public-Storage | Inbound | Internet | Storage Account | * | Deny | SC-7 |

### Public Endpoint

- Status: Disabled — network rules default deny, no public IP rules
- NIST: SC-7

---

## Encryption Controls

### Encryption at Rest — FIPS 140-2

- Algorithm: AES-256
- **Production**: Customer-Managed Key (CMK) via Azure Key Vault
  - Key Vault backed by FIPS 140-2 Level 2 validated HSM
  - Key rotation: Automatic via Key Vault rotation policy (90 days)
  - Key type: RSA-2048 or RSA-3072
  - FIPS 140-2 Certificate: Azure Storage Service Encryption (per R-004)
- **Lower**: Platform-Managed Key (PMK) — Azure manages encryption keys
  - PMK uses same FIPS 140-2 validated modules, organization key control not required
- Infrastructure encryption: Recommended for double encryption (AES-256 at both service and infrastructure layers)
- NIST: SC-13, SC-28

### Encryption in Transit

- Protocol: TLS 1.2+ (minimum enforced via `min_tls_version`)
- HTTPS-only: Enforced via `enable_https_traffic_only = true`
- FIPS 140-2: Azure Storage TLS uses FIPS 140-2 validated cryptographic modules
- Cipher suites: FIPS-approved only (managed by Azure platform)
- NIST: SC-8, SC-13
- NIST SP 800-52 Rev 2: TLS 1.2 compliant

---

## Data Protection

### Blob Versioning

- Enabled: All blob writes create a new version
- Enables point-in-time recovery and audit trail for data changes
- NIST: SC-28, AU-12

### Soft-Delete

- Blob soft-delete: 90 days (production) / 7 days (lower)
- Container soft-delete: 90 days (production) / 7 days (lower)
- Enables recovery from accidental or malicious deletion
- NIST: SC-28, CP-9

---

## Logging & Monitoring Controls

- Diagnostic categories: StorageRead, StorageWrite, StorageDelete (per blob, queue, table, file)
- Metrics: Transaction (per sub-service and account level)
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: EL2 for data plane reads/writes, EL3 for delete operations
- Alert rules: Anonymous access attempt, delete spike, shared key usage attempt
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Private Endpoint; network rules deny all; no public access | Terraform: PE, network_rules, allow_nested_items_to_be_public = false |
| SC-8 | Transmission Confidentiality | HTTPS-only, TLS 1.2 minimum | Terraform: enable_https_traffic_only, min_tls_version; Policy: deny-storageaccount-https-only-v1, deny-storageaccount-minimum-tls-v1 |
| SC-13 | Cryptographic Protection | CMK via Key Vault (FIPS 140-2 HSM); TLS 1.2 FIPS modules | Terraform: customer_managed_key; Policy: deny-storageaccount-cmk-encryption-v1 |
| SC-28 | Protection of Information at Rest | AES-256 CMK encryption; blob versioning; soft-delete | Terraform: CMK, blob_properties |
| AC-3 | Access Enforcement | RBAC-only (shared key disabled); least privilege via data roles | Terraform: shared_access_key_enabled = false; Policy: deny-storageaccount-shared-key-disabled-v1 |
| AU-12 | Audit Generation | StorageRead/Write/Delete for all 4 sub-services | Terraform: diagnostic settings for blob, queue, table, file |

---

## DISA STIG Mapping

No published DISA STIG for Azure Storage Account. Compensating controls: NIST 800-53 controls + CIS Azure Benchmark (per R-002).

*"No published DISA STIG for this service. Compensating controls: NIST 800-53 + CIS Benchmark."*

### CIS Azure Benchmark Alignment

| CIS Control | Requirement | Implementation | Status |
|-------------|-------------|----------------|--------|
| 3.1 | Ensure Storage Account secure transfer is enabled | `enable_https_traffic_only = true` | Implemented |
| 3.2 | Ensure Storage Account default network access rule is deny | `network_rules.default_action = Deny` | Implemented |
| 3.7 | Ensure public access level is disabled for Storage Accounts | `allow_nested_items_to_be_public = false` | Implemented |
| 3.8 | Ensure default network access rule is deny | Network rules default deny | Implemented |
| 3.9 | Ensure trusted Microsoft services are allowed | `bypass = ["AzureServices"]` | Implemented |
| 3.12 | Ensure Storage logging is enabled for Blob service | Diagnostic settings enabled | Implemented |

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | RBAC-only; shared key disabled; Entra ID auth | AC-2, AC-3, AC-6 |
| 3.1.2 Limit system access to authorized functions | Storage data roles (Blob Data Reader/Contributor) | AC-3, AC-6 |
| 3.13.8 Implement cryptographic mechanisms for CUI in transit | HTTPS-only, TLS 1.2 | SC-8, SC-13 |
| 3.13.11 Employ FIPS-validated cryptography | CMK via FIPS 140-2 HSM; TLS 1.2 FIPS modules | SC-13, SC-28 |
| 3.13.16 Protect CUI at rest | AES-256 CMK encryption | SC-28 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.8 | HTTPS-only, TLS 1.2 minimum |
| SC.L2-3.13.11 | FIPS 140-2 validated CMK encryption |
| SC.L2-3.13.16 | AES-256 CMK at rest encryption |
| AC.L2-3.1.1 | RBAC-only access (shared key disabled) |
| AU.L2-3.3.1 | StorageRead/Write/Delete logging for all sub-services |

### EO 14028 / OMB M-22-09 (Zero Trust)

- RBAC-only access — no shared keys or SAS tokens
- Private Endpoint — no public access
- Entra ID authentication integrates with Conditional Access for zero-trust data access
- NIST SP 800-207 tenet: Per-resource access policies, no implicit trust

### OMB M-21-31 (Logging Maturity)

- Target tier: EL2 for data plane reads/writes, EL3 for delete operations
- Achieved tier: EL2/EL3 — StorageRead, StorageWrite, StorageDelete collected per sub-service

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Storage documentation | https://learn.microsoft.com/en-us/azure/storage/common/storage-introduction |
| 2 | Azure Storage encryption with CMK | https://learn.microsoft.com/en-us/azure/storage/common/customer-managed-keys-overview |
| 3 | Azure Storage Private Endpoints | https://learn.microsoft.com/en-us/azure/storage/common/storage-private-endpoints |
| 4 | Azure Storage RBAC roles | https://learn.microsoft.com/en-us/azure/storage/blobs/authorize-access-azure-active-directory |
| 5 | FIPS 140-2 validated modules for Azure | https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-fips-140-2 |
| 6 | CIS Azure Benchmark | https://www.cisecurity.org/benchmark/azure |
