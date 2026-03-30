# Policy Coverage: Event Hubs

**Service**: Event Hubs
**Category**: Data & AI
**Last Updated**: 2026-03-27

---

## Overview

Azure Event Hubs provides real-time event streaming and ingestion for federal workloads. These policies enforce defense-in-depth: no public network access (Private Endpoint only), TLS 1.2 minimum for all connections, and managed identity / RBAC authentication (no SAS keys in production). Custom policies supplement partial built-in coverage.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-eventhubs-public-access-v1` | Deny/Audit | SC-7 | High |
| `deny-eventhubs-minimum-tls-v1` | Deny/Audit | SC-8 | High |
| `audit-eventhubs-managed-identity-v1` | Audit | IA-2, AC-3 | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-event-hubs-v1` | All 3 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Some built-in coverage exists per R-001. Built-in policies only Audit; custom policies provide Deny enforcement for public access and TLS. Managed Identity / RBAC authentication requires custom policy.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- CIS Azure Benchmark (no dedicated DISA STIG per R-002)

---

## File Structure

```text
services/data-ai/event-hubs/policies/
├── definitions/
│   ├── deny-eventhubs-public-access-v1.json
│   ├── deny-eventhubs-minimum-tls-v1.json
│   └── audit-eventhubs-managed-identity-v1.json
├── initiatives/
│   └── fedramp-high-event-hubs-v1.json
├── built-in-references.md
└── README.md                ← this file
```
