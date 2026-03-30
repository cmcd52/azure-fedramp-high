# Policy Coverage: Azure OpenAI

**Service**: Azure OpenAI
**Category**: Data & AI
**Last Updated**: 2026-03-27

---

## Overview

Azure OpenAI provides large language model capabilities for federal workloads. These policies enforce defense-in-depth: no public network access (Private Endpoint only), managed identity authentication (no API keys in production), and content filtering for responsible AI. Custom policies supplement partial built-in coverage from generic Cognitive Services policies.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-openai-public-access-v1` | Deny/Audit | SC-7 | High |
| `audit-openai-managed-identity-v1` | Audit | IA-2 | High |
| `audit-openai-content-filtering-v1` | Audit | SI-4 | Medium |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-azure-openai-v1` | All 3 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Some built-in coverage exists via generic Cognitive Services policies per R-001. Custom policies provide OpenAI-specific kind filtering and content filtering enforcement.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- CIS Azure Benchmark (no dedicated DISA STIG per R-002)

---

## File Structure

```text
services/data-ai/azure-openai/policies/
├── definitions/
│   ├── deny-openai-public-access-v1.json
│   ├── audit-openai-managed-identity-v1.json
│   └── audit-openai-content-filtering-v1.json
├── initiatives/
│   └── fedramp-high-azure-openai-v1.json
├── built-in-references.md
└── README.md                ← this file
```
