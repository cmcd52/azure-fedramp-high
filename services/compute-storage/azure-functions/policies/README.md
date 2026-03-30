# Policy Coverage: Azure Functions

**Service**: Azure Functions
**Category**: Compute & Storage
**Last Updated**: 2026-03-27

---

## Overview

Azure Functions provides serverless compute for event-driven workloads. These policies enforce HTTPS-only access, TLS 1.2 minimum, and managed identity for service-to-service authentication. Custom Deny policies supplement built-in Audit policies for critical controls.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-functions-https-only-v1` | Deny/Audit | SC-8 | High |
| `deny-functions-minimum-tls-v1` | Deny/Audit | SC-8, SC-13 | High |
| `deny-functions-managed-identity-v1` | Deny/Audit | IA-2 | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-azure-functions-v1` | All 3 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Built-in coverage for HTTPS, TLS, managed identity, VNet integration, and Private Endpoint. Custom policies provide Deny enforcement where built-in only Audit.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2

---

## File Structure

```text
services/compute-storage/azure-functions/policies/
├── definitions/
│   ├── deny-functions-https-only-v1.json
│   ├── deny-functions-minimum-tls-v1.json
│   └── deny-functions-managed-identity-v1.json
├── initiatives/
│   └── fedramp-high-azure-functions-v1.json
├── built-in-references.md
└── README.md                ← this file
```
