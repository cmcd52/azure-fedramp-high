# Policy Coverage: AI Speech Service

**Service**: AI Speech Service
**Category**: Data & AI
**Last Updated**: 2026-03-27

---

## Overview

Azure AI Speech Service provides speech-to-text, text-to-speech, speech translation, and speaker recognition capabilities for federal workloads. These policies enforce defense-in-depth: no public network access (Private Endpoint only) and managed identity authentication (no API keys in production). Custom policies supplement partial built-in coverage from generic Cognitive Services policies.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-speech-public-access-v1` | Deny/Audit | SC-7 | High |
| `audit-speech-managed-identity-v1` | Audit | IA-2 | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-ai-speech-service-v1` | All 2 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Some built-in coverage exists via generic Cognitive Services policies per R-001. Custom policies provide SpeechServices-specific kind filtering and Deny enforcement where built-in only Audit.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- CIS Azure Benchmark (no dedicated DISA STIG per R-002)

---

## File Structure

```text
services/data-ai/ai-speech-service/policies/
├── definitions/
│   ├── deny-speech-public-access-v1.json
│   └── audit-speech-managed-identity-v1.json
├── initiatives/
│   └── fedramp-high-ai-speech-service-v1.json
├── built-in-references.md
└── README.md                ← this file
```
