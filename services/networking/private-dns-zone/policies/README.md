# Policy Coverage: Private DNS Zone

**Service**: Private DNS Zone
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Azure Private DNS Zones provide internal name resolution for Private Endpoints and internal services within the hub-spoke network topology. These policies enforce VNet link association and prevent misconfigured A records pointing to public IP addresses to meet FedRAMP High boundary protection and secure name resolution requirements.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `audit-privatednszones-vnet-link-v1` | Audit | SC-7 | High |
| `deny-privatednszones-public-records-v1` | Deny/Audit | SC-7 | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-private-dns-zone-v1` | All 2 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: One built-in policy for VNet link enforcement exists. Many service-specific "Configure to use private DNS zones" DeployIfNotExists policies are available per-service.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- DISA STIG: No STIG available for Azure Private DNS Zones (per R-002)

---

## File Structure

```text
services/networking/private-dns-zone/policies/
├── definitions/
│   ├── audit-privatednszones-vnet-link-v1.json
│   └── deny-privatednszones-public-records-v1.json
├── initiatives/
│   └── fedramp-high-private-dns-zone-v1.json
├── built-in-references.md
└── README.md                ← this file
```
