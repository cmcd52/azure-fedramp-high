# Policy Coverage: DNS Private Resolver

**Service**: DNS Private Resolver
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Azure DNS Private Resolver provides inbound and outbound DNS resolution within the hub virtual network. These policies enforce VNet integration and forwarding rule configuration to meet FedRAMP High secure name resolution and boundary protection requirements.

> **Note (per R-001)**: Custom policies are required — Azure DNS Private Resolver has minimal built-in policy coverage.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `audit-dnsresolver-vnet-link-v1` | Audit | SC-7, SC-20 | High |
| `audit-dnsresolver-forwarding-rules-v1` | Audit | SC-20, SC-21 | Medium |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-dns-private-resolver-v1` | All 2 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Minimal built-in coverage — custom policies supplement for FedRAMP High requirements.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- DISA STIG: No STIG available for Azure DNS Private Resolver (per R-002)

---

## File Structure

```text
services/networking/dns-private-resolver/policies/
├── definitions/
│   ├── audit-dnsresolver-vnet-link-v1.json
│   └── audit-dnsresolver-forwarding-rules-v1.json
├── initiatives/
│   └── fedramp-high-dns-private-resolver-v1.json
├── built-in-references.md
└── README.md                ← this file
```
