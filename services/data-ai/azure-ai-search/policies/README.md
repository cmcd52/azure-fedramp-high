# Policy Coverage: Azure AI Search

**Service**: Azure AI Search
**Category**: Data & AI
**Last Updated**: 2026-03-27

---

## Overview

Azure AI Search provides full-text search, semantic ranking, and vector search over federal data. These policies enforce defense-in-depth: no public network access (Private Endpoint only), managed identity authentication, and TLS 1.2 minimum for encrypted communications. Custom Deny policies supplement built-in Audit-level coverage.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-aisearch-public-access-v1` | Deny/Audit | SC-7 | High |
| `audit-aisearch-managed-identity-v1` | Audit | IA-2 | High |
| `deny-aisearch-minimum-tls-v1` | Deny/Audit | SC-8 | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-azure-ai-search-v1` | All 3 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Built-in coverage exists for Audit-level policies. Custom policies provide Deny enforcement for public access and TLS minimum, plus managed identity requirement.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- CIS Azure Benchmark (no dedicated DISA STIG per R-002)

---

## File Structure

```text
services/data-ai/azure-ai-search/policies/
├── definitions/
│   ├── deny-aisearch-public-access-v1.json
│   ├── audit-aisearch-managed-identity-v1.json
│   └── deny-aisearch-minimum-tls-v1.json
├── initiatives/
│   └── fedramp-high-azure-ai-search-v1.json
├── built-in-references.md
└── README.md                ← this file
```
