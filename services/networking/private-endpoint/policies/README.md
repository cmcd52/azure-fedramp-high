# Policy Coverage: Private Endpoint

**Service**: Private Endpoint
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Azure Private Endpoints are the primary network isolation mechanism for FedRAMP High. Every supported Azure service must use Private Endpoints to ensure traffic traverses the Microsoft backbone instead of public internet. These policies enforce PE deployment, DNS zone group configuration, and NSG on PE subnets.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-privateendpoint-required-v1` | Deny/Audit | SC-7 | High |
| `audit-privateendpoint-dns-configured-v1` | Audit | SC-7, SC-20 | High |
| `audit-privateendpoint-nsg-v1` | Audit | SC-7 | Medium |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-private-endpoint-v1` | All 3 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Many built-in "should use private link" policies exist per service (per R-001). Custom policies supplement for DNS zone group and NSG enforcement.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- DISA STIG: No STIG available for Azure Private Endpoints (per R-002)

---

## File Structure

```text
services/networking/private-endpoint/policies/
├── definitions/
│   ├── deny-privateendpoint-required-v1.json
│   ├── audit-privateendpoint-dns-configured-v1.json
│   └── audit-privateendpoint-nsg-v1.json
├── initiatives/
│   └── fedramp-high-private-endpoint-v1.json
├── built-in-references.md
└── README.md                ← this file
```
