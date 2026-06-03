# Production vs. Lower Environment Configuration Delta

**FR**: FR-035 | **SC**: SC-014
**NIST 800-53**: CM-2, CM-6, PL-2, SA-8
**Constitution**: v8.0.0 — All GA Azure Commercial Services
**Last Updated**: 2026-05-12

---

## Overview

This document defines the justified configuration deviations between the **Production** and **Lower (test/dev)** environments for all in-scope Azure services. Production configurations are the primary deliverable and represent the full FedRAMP High compliant baseline. Lower environment configurations relax specific controls where full production parity is unnecessary for non-production data, while maintaining a minimum compliance floor.

---

## Minimum Lower Environment Baseline (NON-NEGOTIABLE)

The following controls MUST match production in the lower environment — no deviations permitted:

| Control Area | Requirement | NIST 800-53 | Rationale |
|-------------|-------------|-------------|-----------|
| **Encryption in transit** | TLS 1.2+ enforced on all endpoints | SC-8, SC-13 | Protects credentials and tokens in transit regardless of data sensitivity |
| **Diagnostic logging** | All diagnostic categories routed to Log Analytics workspace | AU-2, AU-3, AU-12 | Security event visibility required for incident detection in all environments |
| **Log retention** | 12 months online, 18 months total | AU-11 | FedRAMP High retention applies to all environments |
| **MFA** | Multi-factor authentication for all interactive users | IA-2(1), IA-2(2) | Identity compromise in lower env could pivot to production |
| **Conditional Access** | Same Conditional Access policies as production | AC-2, AC-3 | Consistent access controls prevent policy bypass through lower environment |
| **RBAC** | Least-privilege role assignments | AC-6 | Prevents privilege creep; lower env should not grant broader access |
| **Managed Identity** | Service-to-service authentication via Managed Identity | IA-2, IA-5 | No shared secrets in any environment |
| **Private DNS resolution** | Services resolve via Private DNS Zones | SC-7 | DNS integrity required in all environments |

---

## Permitted Deviations

### Category 1: Azure Policy Effect Relaxation

| Setting | Production Value | Lower Value | Justification | Risk | NIST 800-53 |
|---------|-----------------|-------------|---------------|------|-------------|
| Policy effect — encryption at rest (CMK) | `Deny` | `Audit` | Lower environment uses platform-managed keys (PMK) to avoid Key Vault operational overhead for non-sensitive test data | Non-production data encrypted with PMK (AES-256) instead of CMK; acceptable for test data with no CUI | SC-28 |
| Policy effect — network isolation | `Deny` | `Audit` | Developers may need temporary public access for debugging; private endpoint requirement remains enforced via Terraform defaults | Temporary public exposure possible if developer overrides default; mitigated by non-sensitive data classification | SC-7 |
| Policy effect — advisory controls (tagging, naming) | `Audit` | `Audit` | No deviation — same in both environments | None | CM-8 |

### Category 2: Encryption at Rest Key Management

| Setting | Production Value | Lower Value | Justification | Risk | NIST 800-53 |
|---------|-----------------|-------------|---------------|------|-------------|
| Encryption key source | Customer-managed key (CMK) via Key Vault | Platform-managed key (PMK) | CMK requires dedicated Key Vault, key rotation procedures, and RBAC configuration; PMK provides equivalent AES-256 encryption without operational overhead for non-production data | Data at rest still encrypted with FIPS 140-2 validated AES-256; key custody shifts to Microsoft | SC-28, SC-12 |
| Key rotation | Automated 90-day rotation via Key Vault policy | N/A (platform-managed) | No customer-managed keys to rotate in lower environment | Microsoft manages key lifecycle; acceptable for non-CUI data | SC-12(1) |

### Category 3: Network Configuration

| Setting | Production Value | Lower Value | Justification | Risk | NIST 800-53 |
|---------|-----------------|-------------|---------------|------|-------------|
| Private Endpoint | Required (enforced via Deny policy) | Required (enforced via Terraform default; policy set to Audit) | Private endpoints remain configured by default in Terraform modules; Audit policy allows override for debugging scenarios | Developer could temporarily disable PE; mitigated by diagnostic logging capturing the configuration change | SC-7 |
| Public network access | `false` (blocked) | `false` (default) — overridable | Default matches production; developer can temporarily enable for troubleshooting | Time-limited public exposure; non-sensitive test data only | SC-7 |
| ExpressRoute | Required for all traffic | Required for all traffic | No deviation — same network path | None | SC-7 |

### Category 4: Compute and Scale

| Setting | Production Value | Lower Value | Justification | Risk | NIST 800-53 |
|---------|-----------------|-------------|---------------|------|-------------|
| SKU tier / size | Production-grade (Premium, Standard_D-series, etc.) | Minimum viable (Basic, Standard_B-series where available) | Cost optimization for non-production workloads | Reduced performance; acceptable for test scenarios | N/A (operational) |
| Redundancy | Zone-redundant / geo-redundant | Locally redundant (LRS) | Lower environment does not require high availability | Data loss risk in lower env acceptable; no production data | CP-6, CP-7 |
| Backup frequency | Per-service RPO (typically daily or more frequent) | Reduced frequency or disabled | Non-production data is ephemeral; backup overhead unnecessary | Test data loss acceptable | CP-9 |

---

## Per-Service Override Template

When a specific service requires additional lower-environment deviations beyond the categories above, document them using this format:

| Service | Setting | Production Value | Lower Value | Justification | Risk | NIST 800-53 |
|---------|---------|-----------------|-------------|---------------|------|-------------|
| _service-name_ | _setting_ | _prod-value_ | _lower-value_ | _rationale_ | _residual-risk_ | _control-id_ |

### Documented Per-Service Overrides

| Service | Setting | Production Value | Lower Value | Justification | Risk | NIST 800-53 |
|---------|---------|-----------------|-------------|---------------|------|-------------|
| Azure Storage Account | Shared access keys | Disabled (`shared_access_key_enabled = false`) | Disabled | No deviation — RBAC-only access in both environments | None | AC-3 |
| Key Vault | Soft delete retention | 90 days | 7 days (minimum) | Reduces storage costs in lower env; test secrets are ephemeral | Shorter recovery window for accidental deletion; acceptable for test keys | CP-9 |
| SQL Database | Transparent Data Encryption (TDE) | CMK via Key Vault | Service-managed key | CMK overhead unnecessary for test databases with synthetic data | TDE still active with Microsoft-managed key (AES-256) | SC-28 |
| Cosmos DB | Multi-region writes | Enabled | Disabled (single region) | Cost optimization; geo-redundancy unnecessary for test data | Single-region failure could affect test workloads; acceptable | CP-6 |

---

## Validation Criteria (SC-014)

The following assertions MUST hold for any lower environment deployment:

1. **Encryption in transit**: `terraform plan` output shows `minimum_tls_version = "1.2"` (or equivalent) for every resource.
2. **Diagnostic logging**: Every resource has a `azurerm_monitor_diagnostic_setting` block routing to the lower environment's Log Analytics workspace.
3. **Identity controls**: MFA, Conditional Access, and RBAC configurations are identical between production and lower (managed at the Entra ID level, not per-resource).
4. **Managed Identity**: Every resource that supports `identity` blocks has `type = "SystemAssigned"` (or `"SystemAssigned, UserAssigned"`).
5. **No deviation undocumented**: Any setting that differs from production MUST appear in this document with justification and risk assessment.

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | NIST 800-53 Rev 5 CM-2 (Baseline Configuration) | https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final |
| 2 | FedRAMP System Security Plan Template | https://www.fedramp.gov/documents-templates/ |
| 3 | Azure Policy effects | https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effects |
| 4 | Azure encryption at rest overview | https://learn.microsoft.com/en-us/azure/security/fundamentals/encryption-atrest |
| 5 | Azure Private Endpoint overview | https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview |
