# Policy Coverage: VMs for DNS

**Service**: VMs for DNS (Windows Server 2022)
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Windows Server 2022 virtual machines serve as DNS forwarders in the hub network, complementing the DNS Private Resolver. These policies enforce disk encryption, Guest Configuration for STIG compliance assessment, diagnostic settings for log collection, and public IP prohibition to meet FedRAMP High requirements for compute security, configuration management, audit generation, and boundary protection.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-vm-disk-encryption-v1` | Deny/Audit | SC-28 | High |
| `audit-vm-guest-configuration-v1` | Audit | CM-6 | High |
| `audit-vm-diagnostic-settings-v1` | Audit | AU-12 | Medium |
| `deny-vm-public-ip-v1` | Deny/Audit | SC-7 | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-vms-for-dns-v1` | All 4 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Extensive built-in coverage for VMs including disk encryption, Guest Configuration, endpoint protection, and vulnerability assessment. Custom policies target DNS VM-specific requirements.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- DISA STIG: Windows Server 2022 STIG V1R5+ (per FR-025)

---

## File Structure

```text
services/networking/vms-for-dns/policies/
├── definitions/
│   ├── deny-vm-disk-encryption-v1.json
│   ├── audit-vm-guest-configuration-v1.json
│   ├── audit-vm-diagnostic-settings-v1.json
│   └── deny-vm-public-ip-v1.json
├── initiatives/
│   └── fedramp-high-vms-for-dns-v1.json
├── built-in-references.md
└── README.md                ← this file
```
