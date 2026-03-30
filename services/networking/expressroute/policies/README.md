# Policy Coverage: ExpressRoute

**Service**: ExpressRoute
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

ExpressRoute provides dedicated private connectivity between on-premises networks and Azure. These policies verify that ExpressRoute circuits are configured with encryption (MACsec on ExpressRoute Direct) and private peering only, meeting FedRAMP High boundary protection and cryptographic requirements.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `audit-expressroute-encryption-enabled-v1` | Audit | SC-8, SC-13 | High |
| `audit-expressroute-private-peering-v1` | Audit | SC-7 | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-expressroute-v1` | All 2 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Built-in policies cover resiliency and deployment model but not encryption or peering configuration. Custom policies required per R-001.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- DISA STIG: No STIG available for ExpressRoute (per R-002)

---

## File Structure

```text
services/networking/expressroute/policies/
├── definitions/
│   ├── audit-expressroute-encryption-enabled-v1.json
│   └── audit-expressroute-private-peering-v1.json
├── initiatives/
│   └── fedramp-high-expressroute-v1.json
├── built-in-references.md
└── README.md                ← this file
```
