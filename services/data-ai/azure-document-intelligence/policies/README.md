# Policy Coverage: Azure Document Intelligence

**Service**: Azure Document Intelligence
**Category**: Data & AI
**Last Updated**: 2026-03-27

---

## Overview

Azure Document Intelligence (formerly Form Recognizer) provides AI-powered document processing capabilities for extracting text, key-value pairs, tables, and structures from federal documents. These policies enforce defense-in-depth: no public network access (Private Endpoint only), managed identity authentication, and network isolation to protect PII and sensitive data in processed documents. Custom policies supplement partial built-in coverage from generic Cognitive Services policies.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-docintel-public-access-v1` | Deny/Audit | SC-7 | High |
| `audit-docintel-managed-identity-v1` | Audit | IA-2 | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-azure-document-intelligence-v1` | All 2 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Some built-in coverage exists via generic Cognitive Services policies per R-001. Custom policies provide FormRecognizer-specific kind filtering and Deny enforcement where built-in only Audit.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- CIS Azure Benchmark (no dedicated DISA STIG per R-002)

---

## File Structure

```text
services/data-ai/azure-document-intelligence/policies/
├── definitions/
│   ├── deny-docintel-public-access-v1.json
│   └── audit-docintel-managed-identity-v1.json
├── initiatives/
│   └── fedramp-high-azure-document-intelligence-v1.json
├── built-in-references.md
└── README.md                ← this file
```
