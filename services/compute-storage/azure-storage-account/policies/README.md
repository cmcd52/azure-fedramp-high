# Policy Coverage: Azure Storage Account

**Service**: Azure Storage Account
**Category**: Compute & Storage
**Last Updated**: 2026-03-27

---

## Overview

Azure Storage Accounts provide blob, queue, table, and file storage for federal workloads. These policies enforce comprehensive security: no public access, customer-managed key encryption in production, TLS 1.2 minimum, HTTPS-only transfer, and shared key access disabled (RBAC only). Custom Deny policies supplement strong built-in coverage.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-storageaccount-public-access-v1` | Deny/Audit | SC-7 | High |
| `deny-storageaccount-cmk-encryption-v1` | Deny/Audit | SC-28, SC-13 | High |
| `deny-storageaccount-minimum-tls-v1` | Deny/Audit | SC-8 | High |
| `deny-storageaccount-https-only-v1` | Deny/Audit | SC-8 | High |
| `deny-storageaccount-shared-key-disabled-v1` | Deny/Audit | AC-3 | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-azure-storage-account-v1` | All 5 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Strong built-in coverage per R-001 for Storage Account security. Custom policies provide Deny enforcement and FIPS cipher suite considerations.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- CIS Azure Benchmark (no dedicated DISA STIG per R-002)

---

## File Structure

```text
services/compute-storage/azure-storage-account/policies/
├── definitions/
│   ├── deny-storageaccount-public-access-v1.json
│   ├── deny-storageaccount-cmk-encryption-v1.json
│   ├── deny-storageaccount-minimum-tls-v1.json
│   ├── deny-storageaccount-https-only-v1.json
│   └── deny-storageaccount-shared-key-disabled-v1.json
├── initiatives/
│   └── fedramp-high-azure-storage-account-v1.json
├── built-in-references.md
└── README.md                ← this file
```
