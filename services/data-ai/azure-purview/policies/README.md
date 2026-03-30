# Policy Coverage: Azure Purview

**Service**: Azure Purview
**Category**: Data & AI
**Last Updated**: 2026-03-27

---

## Overview

Azure Purview provides unified data governance and cataloging for federal data estates. These policies enforce defense-in-depth: no public network access (Private Endpoint only), managed identity for credential-free data source scanning, and diagnostic settings for comprehensive audit logging. Custom policies supplement limited built-in coverage.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-purview-public-access-v1` | Deny/Audit | SC-7 | High |
| `audit-purview-managed-identity-v1` | Audit | IA-2 | High |
| `audit-purview-diagnostic-settings-v1` | AuditIfNotExists | AU-12 | Medium |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-azure-purview-v1` | All 3 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Limited built-in coverage exists per R-001. Built-in policies only Audit; custom policies provide Deny enforcement for public access. Managed Identity and diagnostic settings enforcement require custom policies.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- CIS Azure Benchmark (no dedicated DISA STIG per R-002)

---

## File Structure

```text
services/data-ai/azure-purview/policies/
├── definitions/
│   ├── deny-purview-public-access-v1.json
│   ├── audit-purview-managed-identity-v1.json
│   └── audit-purview-diagnostic-settings-v1.json
├── initiatives/
│   └── fedramp-high-azure-purview-v1.json
├── built-in-references.md
└── README.md                ← this file
```
