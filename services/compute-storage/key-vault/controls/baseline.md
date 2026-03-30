# Security Control Baseline: Key Vault

**Service**: Key Vault (Premium SKU)
**Category**: Compute & Storage
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Key Vault provides centralized management of cryptographic keys, secrets, and certificates for federal workloads. Key Vault enforces defense-in-depth security: Premium SKU for FIPS 140-2 Level 2 (software-protected keys) and Level 3 (HSM-backed keys via Managed HSM), RBAC-only authorization, soft-delete with purge protection, Private Endpoint for network isolation, and comprehensive audit logging of all vault operations.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the Key Vault with security properties, Private Endpoint, and diagnostic settings. The shared Key Vault is deployed by `shared/terraform/key-vault/`; this module provides the per-service pattern for service-specific vaults.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Key Vault Administrator | Key Vault (via PIM) | Full management of keys, secrets, certificates, and vault settings. JIT activation with approval required. | AC-2, AC-3, AC-6 |
| Key Vault Secrets Officer | Key Vault (via PIM) | Manage secrets (create, update, delete). JIT activation required. | AC-2, AC-3, AC-6 |
| Key Vault Secrets User | Key Vault | Read-only access to secret values for application managed identities. Standing assignment. | AC-3 |
| Key Vault Crypto Officer | Key Vault (via PIM) | Manage keys (create, rotate, delete). JIT activation required. | AC-2, AC-3, AC-6, SC-12 |
| Key Vault Crypto User | Key Vault | Perform cryptographic operations (encrypt, decrypt, wrap, unwrap) for application managed identities. Standing assignment. | AC-3, SC-12 |
| Key Vault Crypto Service Encryption User | Key Vault | Read key metadata and perform wrap/unwrap for CMK encryption (Storage Account, Disk Encryption). Standing assignment for service identities. | AC-3, SC-12, SC-28 |
| Key Vault Certificates Officer | Key Vault (via PIM) | Manage certificates. JIT activation required. | AC-2, AC-3, AC-6 |
| Reader | Resource group | Read-only access to Key Vault configuration for auditors. Standing assignment. | AC-3, AU-6 |

### Managed Identity

- Type: System-assigned (for applications accessing vault) + User-assigned (for CMK service encryption)
- Usage: Application services authenticate to Key Vault via managed identity and RBAC roles — no access keys or connection strings
- CMK consumers: Storage Accounts, Disk Encryption, and other services use User-assigned identity with Key Vault Crypto Service Encryption User role
- NIST: IA-2, IA-5

### Access Model: RBAC-Only

- Access policies: **Disabled** — RBAC authorization enabled (`enable_rbac_authorization = true`)
- All data plane access via Entra ID authentication + RBAC roles
- Eliminates legacy access policy model with overly broad permissions
- Enforced by policy: `deny-keyvault-rbac-auth-v1`
- NIST: AC-3, AC-6

---

## Network Security Controls

### Private Endpoint

- Status: Required
- Private DNS Zone: `privatelink.vaultcore.azure.net`
- All data plane traffic flows exclusively through Private Endpoint
- NIST: SC-7

### Network Rules

- Default action: **Deny** — no public network access
- Bypass: Azure Services (for trusted Azure service access, e.g., Azure Backup)
- Public network access: Disabled in production, enabled in lower for development tooling
- NIST: SC-7

---

## Cryptographic Controls — FIPS 140-2

### Key Protection Levels

| Key Type | Protection Level | FIPS 140-2 Level | Vault Type | Use Case |
|----------|-----------------|------------------|------------|----------|
| Software-protected keys | Premium SKU software vault | Level 2 | Standard Key Vault (Premium) | General-purpose keys, secrets, certificates |
| HSM-backed keys | Premium SKU with HSM import | Level 2 | Standard Key Vault (Premium) | CMK encryption keys, high-value secrets |
| Managed HSM keys | Dedicated HSM pool | Level 3 | Managed HSM | Highest assurance: payment processing, PKI root keys |

### Key Rotation Policy

| Key Category | Rotation Frequency | Method | NIST Control |
|--------------|--------------------|--------|--------------|
| CMK encryption keys | Annual (365 days) | Key Vault auto-rotation policy | SC-12 |
| Service-specific secrets | Per-service requirement (90 days typical) | Application-managed or Key Vault rotation | SC-12, IA-5 |
| TLS certificates | Before expiration (90 days notice) | Key Vault certificate auto-renewal or manual | SC-12, SC-8 |
| HSM root keys | Per security policy | Manual with dual-control | SC-12, SC-13 |

### Key Expiration

- All keys MUST have an expiration date set — enforced by `audit-keyvault-key-expiration-v1` policy
- Secrets SHOULD have an expiration date aligned with rotation schedule
- Certificates have inherent expiration via X.509 validity period
- NIST: SC-12

---

## Data Protection

### Soft-Delete

- Retention: 90 days
- All deleted vaults, keys, secrets, and certificates are recoverable during retention period
- Enforced by policy: `deny-keyvault-soft-delete-v1`
- NIST: CP-9

### Purge Protection

- Status: **Enabled** — prevents permanent deletion during soft-delete retention period
- Even Key Vault Administrators cannot purge objects during retention
- Enforced by policy: `deny-keyvault-purge-protection-v1`
- NIST: CP-9

---

## Logging & Monitoring Controls

- Diagnostic categories: AuditEvent, AzurePolicyEvaluationDetails, AllMetrics
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: EL3 for ALL Key Vault events (critical cryptographic material)
- Alert rules: Key deleted, secret accessed by unexpected principal, certificate expiration, purge attempt
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-12 | Cryptographic Key Establishment & Management | Premium SKU; FIPS 140-2 Level 2/3; key rotation policy; key expiration | Terraform: sku_name = premium; Policy: audit-keyvault-key-expiration-v1 |
| SC-13 | Cryptographic Protection | FIPS 140-2 validated modules; HSM-backed keys available | Terraform: Premium SKU; R-004 |
| SC-28 | Protection of Information at Rest | Keys, secrets, certificates encrypted at rest in FIPS 140-2 HSM | Platform guarantee |
| AC-3 | Access Enforcement | RBAC authorization; least privilege roles; no access policies | Terraform: enable_rbac_authorization; Policy: deny-keyvault-rbac-auth-v1 |
| AC-6 | Least Privilege | Fine-grained RBAC roles (Secrets User, Crypto User, etc.); PIM JIT | RBAC role assignments |
| CP-9 | System Backup | Soft-delete (90 days); purge protection enabled | Terraform: soft_delete_retention_days, purge_protection_enabled; Policies: deny-keyvault-soft-delete-v1, deny-keyvault-purge-protection-v1 |

---

## DISA STIG Mapping

No published DISA STIG for Azure Key Vault. Compensating controls: NIST 800-53 controls + CIS Azure Benchmark (per R-002).

*"No published DISA STIG for this service. Compensating controls: NIST 800-53 + CIS Benchmark."*

### CIS Azure Benchmark Alignment

| CIS Control | Requirement | Implementation | Status |
|-------------|-------------|----------------|--------|
| 8.1 | Ensure that the expiration date is set on all keys | Key expiration policy + audit policy | Implemented |
| 8.2 | Ensure that the expiration date is set on all secrets | Secret rotation schedule | Implemented |
| 8.4 | Ensure the key vault is recoverable | Soft-delete + purge protection | Implemented |
| 8.5 | Enable role-based access control for Key Vault | RBAC authorization enabled | Implemented |
| 8.6 | Ensure that private endpoints are used for Key Vault | Private Endpoint deployed | Implemented |
| 8.7 | Ensure that logging for Key Vault is enabled | AuditEvent diagnostic logs | Implemented |

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | RBAC-only; Entra ID auth; PIM JIT | AC-2, AC-3, AC-6 |
| 3.1.2 Limit system access to authorized functions | Fine-grained Key Vault RBAC roles | AC-3, AC-6 |
| 3.13.10 Establish and manage cryptographic keys | Key Vault key management; rotation policies; FIPS 140-2 | SC-12, SC-13 |
| 3.13.11 Employ FIPS-validated cryptography | Premium SKU FIPS 140-2 Level 2/3 | SC-13 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.10 | Key Vault key rotation and lifecycle management |
| SC.L2-3.13.11 | FIPS 140-2 validated HSM-backed keys |
| AC.L2-3.1.1 | RBAC-only access; PIM JIT activation |
| CP.L2-3.8.9 | Soft-delete and purge protection for recovery |

### OMB M-21-31 (Logging Maturity)

- Target tier: EL3 for ALL Key Vault events
- Achieved tier: EL3 — AuditEvent captures all access, modification, and deletion events

---
