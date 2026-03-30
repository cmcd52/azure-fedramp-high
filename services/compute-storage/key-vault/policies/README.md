# Policy Coverage: Key Vault

**Service**: Key Vault
**Category**: Compute & Storage
**Last Updated**: 2026-03-27

---

## Overview

Azure Key Vault provides centralized management of cryptographic keys, secrets, and certificates for federal workloads. These policies enforce defense-in-depth: soft-delete and purge protection for recoverability, RBAC authorization for least privilege access control, and key expiration for cryptographic lifecycle management. Custom Deny policies supplement strong built-in coverage.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-keyvault-soft-delete-v1` | Deny/Audit | CP-9 | High |
| `deny-keyvault-purge-protection-v1` | Deny/Audit | CP-9 | High |
| `deny-keyvault-rbac-auth-v1` | Deny/Audit | AC-3, AC-6 | High |
| `audit-keyvault-key-expiration-v1` | Audit | SC-12 | Medium |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-key-vault-v1` | All 4 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Strong built-in coverage per R-001 for Key Vault security. Custom policies provide Deny enforcement for soft-delete, purge protection, and RBAC authorization.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- CIS Azure Benchmark (no dedicated DISA STIG per R-002)

---

## File Structure

```text
services/compute-storage/key-vault/policies/
├── definitions/
│   ├── deny-keyvault-soft-delete-v1.json
│   ├── deny-keyvault-purge-protection-v1.json
│   ├── deny-keyvault-rbac-auth-v1.json
│   └── audit-keyvault-key-expiration-v1.json
├── initiatives/
│   └── fedramp-high-key-vault-v1.json
├── built-in-references.md
└── README.md                ← this file
```
