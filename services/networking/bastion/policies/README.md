# Policy Coverage: Azure Bastion

**Service**: Azure Bastion
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Azure Bastion is the only permitted method for administrative VM access in the FedRAMP High environment per Constitution Principle VI. These policies enforce Standard SKU (required for session recording and audit features) and diagnostic settings configuration to meet FedRAMP High boundary protection and audit generation requirements.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-bastion-sku-standard-v1` | Deny/Audit | SC-7 | High |
| `audit-bastion-diagnostic-settings-v1` | AuditIfNotExists | AU-12 | Medium |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-bastion-v1` | All 2 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Built-in policy covers diagnostic settings. Custom policy required for SKU enforcement per R-001.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- DISA STIG: No STIG available for Azure Bastion (per R-002)

---

## File Structure

```text
services/networking/bastion/policies/
├── definitions/
│   ├── deny-bastion-sku-standard-v1.json
│   └── audit-bastion-diagnostic-settings-v1.json
├── initiatives/
│   └── fedramp-high-bastion-v1.json
├── built-in-references.md
└── README.md                ← this file
```
