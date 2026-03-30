# Policy Coverage: Azure AI Foundry

**Service**: Azure AI Foundry
**Category**: Data & AI
**Last Updated**: 2026-03-27

---

## Overview

Azure AI Foundry provides a unified platform for building, training, and deploying AI models using Hub/Project architecture. These policies enforce defense-in-depth: no public network access (Private Endpoint or managed VNet only), managed identity authentication, and diagnostic settings for comprehensive audit logging. Custom policies supplement partial built-in coverage from generic Machine Learning Services policies.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-aifoundry-public-access-v1` | Deny/Audit | SC-7 | High |
| `audit-aifoundry-managed-identity-v1` | Audit | IA-2 | High |
| `audit-aifoundry-diagnostic-settings-v1` | AuditIfNotExists | AU-12 | Medium |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-azure-ai-foundry-v1` | All 3 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Some built-in coverage exists via generic Machine Learning Services policies per R-001. Custom policies provide AI Foundry-specific kind filtering (Hub/Project) and Deny enforcement where built-in only Audit.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- CIS Azure Benchmark (no dedicated DISA STIG per R-002)

---

## File Structure

```text
services/data-ai/azure-ai-foundry/policies/
├── definitions/
│   ├── deny-aifoundry-public-access-v1.json
│   ├── audit-aifoundry-managed-identity-v1.json
│   └── audit-aifoundry-diagnostic-settings-v1.json
├── initiatives/
│   └── fedramp-high-azure-ai-foundry-v1.json
├── built-in-references.md
└── README.md                ← this file
```
