# Built-in Policy References: Key Vault

**Service**: Key Vault
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Key Vault Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Key vaults should have soft delete enabled | `1e66c121-a66a-4b1f-9b83-0fd5c6b4b4e3` | Audit | CP-9 | Soft-delete |
| Key vaults should have purge protection enabled | `0b60c0b2-2dc2-4e1c-b5c9-abbed971de53` | Deny/Audit | CP-9 | Purge protection |
| Azure Key Vault should disable public network access | `405c5871-3e91-4644-8a63-58e19d68ff5b` | Audit | SC-7 | Network isolation |
| Key Vault keys should have an expiration date | `152b15f7-8e1f-4c1f-ab71-8c010ba5dbc0` | Audit | SC-12 | Key lifecycle |
| Key Vault secrets should have an expiration date | `98728c90-32c7-4049-8429-847dc0f4fe37` | Audit | SC-12 | Secret lifecycle |
| Key Vault certificates should have an expiration date | `f772fb64-8e40-40ad-87bc-7706e1986e81` | Audit | SC-12 | Certificate lifecycle |
| Azure Key Vault Managed HSM should have purge protection enabled | `c39ba22d-4428-4149-b981-70acb31fc006` | Audit | CP-9 | Managed HSM |
| Key vaults should use private link | `a6abeaec-4d90-4a02-805f-6b26c4d3fbe9` | AuditIfNotExists | SC-7 | Private Endpoint |
| Resource logs in Key Vault should be enabled | `cf820ca0-f99e-4f3e-84fb-66e913812d21` | AuditIfNotExists | AU-12 | Diagnostic logs |
| Key Vault should use RBAC permission model | `12d4fa5e-1f9f-4c21-97a9-b99b3c6611b4` | Audit | AC-3, AC-6 | RBAC authorization |
| Certificates should use allowed key types | `1151cede-290b-4ba0-8b38-0ad145ac888f` | Audit | SC-13 | Key type |
| Keys should be backed by a hardware security module (HSM) | `587c79fe-dd04-4a5e-9d0b-f89598c7261b` | Audit | SC-13 | HSM-backed keys |

### Key Vault Diagnostics & Monitoring

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Resource logs in Key Vault should be enabled | `cf820ca0-f99e-4f3e-84fb-66e913812d21` | AuditIfNotExists | AU-12 | Audit logging |
| Azure Defender for Key Vault should be enabled | `0e6763cc-5078-4e64-889d-ff4d6a59f94e` | Audit | SI-4 | Threat detection |

> **Note**: Strong built-in coverage exists per R-001. Custom policies provide Deny enforcement where built-in only Audit, ensuring preventive controls for soft-delete, purge protection, and RBAC authorization.

---

## Custom Policy Requirement (per R-001)

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-keyvault-soft-delete-v1` | Deny/Audit | CP-9 | Soft-delete required (Deny enforcement) |
| `deny-keyvault-purge-protection-v1` | Deny/Audit | CP-9 | Purge protection required (Deny enforcement) |
| `deny-keyvault-rbac-auth-v1` | Deny/Audit | AC-3, AC-6 | RBAC authorization required (Deny enforcement) |
| `audit-keyvault-key-expiration-v1` | Audit | SC-12 | Keys must have expiration date |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Key Vault documentation | https://learn.microsoft.com/en-us/azure/key-vault/general/overview |
| 2 | Azure Key Vault security features | https://learn.microsoft.com/en-us/azure/key-vault/general/security-features |
| 3 | Azure Key Vault soft-delete | https://learn.microsoft.com/en-us/azure/key-vault/general/soft-delete-overview |
| 4 | Azure Key Vault Private Endpoint | https://learn.microsoft.com/en-us/azure/key-vault/general/private-link-service |
| 5 | Azure Policy built-in definitions for Key Vault | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#key-vault |
| 6 | FIPS 140-2 validated modules for Azure | https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-fips-140-2 |
| 7 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
