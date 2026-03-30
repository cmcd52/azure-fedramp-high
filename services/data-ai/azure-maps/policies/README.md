# Policy Coverage: Azure Maps

**Service**: Azure Maps
**Category**: Data & AI
**Last Updated**: 2026-03-27

---

## Overview

Azure Maps provides geospatial APIs for map rendering, geocoding, routing, and spatial analysis in federal applications. Azure Maps has **LIMITED policy enforcement options** — the service does NOT support Private Endpoint and is primarily governed by application-level controls. Custom policies enforce managed identity authentication (preferred over shared key) and CORS restrictions. Compensating controls (IP restrictions, managed identity auth, Front Door WAF) are documented as a FedRAMP exception for SC-7.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `audit-maps-managed-identity-v1` | Audit | IA-2 | High |
| `audit-maps-cors-restrictions-v1` | Audit | AC-4 | Medium |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-azure-maps-v1` | All 2 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Azure Maps has LIMITED built-in policy coverage. Most governance is achieved through application-level controls and compensating mechanisms per R-001.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- CIS Azure Benchmark (no dedicated DISA STIG per R-002)

---

## File Structure

```text
services/data-ai/azure-maps/policies/
├── definitions/
│   ├── audit-maps-managed-identity-v1.json
│   └── audit-maps-cors-restrictions-v1.json
├── initiatives/
│   └── fedramp-high-azure-maps-v1.json
├── built-in-references.md
└── README.md                ← this file
```
