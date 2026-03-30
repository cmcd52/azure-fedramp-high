# Built-in Policy References: VMs for DNS

**Service**: VMs for DNS (Windows Server 2022)
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Virtual Machine Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Virtual machines should encrypt temp disks, caches, and data flows between Compute and Storage resources | `0961003e-5a0a-4549-abde-af6a37f2724d` | Audit/Deny | SC-28 | Disk encryption |
| Guest Configuration extension should be installed on machines | `ae89ebca-1c92-4898-ac2c-9f63decb045c` | Audit | CM-6 | Guest Configuration |
| Virtual machines should have the Log Analytics agent installed | `a70ca396-0a34-413a-88e1-b956c1e683be` | Audit | AU-12 | Log collection |
| Network interfaces should not have public IPs | `83a86fba-7f58-4b90-8de4-1e1bf5d8b3fe` | Deny/Audit | SC-7 | No public IP |
| Windows machines should meet requirements for 'Security Options - Accounts' | `951af2fa-529b-416e-ab6e-066fd85ac459` | Audit | AC-2, IA-2 | STIG alignment |
| Windows machines should meet requirements for 'Audit Policy - Account Logon' | `3cf2ab00-13f1-4d0c-8971-2ac904541a7e` | Audit | AU-2 | Audit policy |
| Endpoint protection should be installed on machines | `1f7c564c-0a90-4d44-b7e1-9d456cffaee8` | Audit | SI-3 | Antimalware |
| System updates should be installed on your machines | `86b3d65f-7626-441e-b690-81a8b71cff60` | Audit | SI-2 | Patch management |
| Machines should have vulnerability assessment findings resolved | `501541f7-f7e7-4cd6-868c-4190fdad3ac9` | Audit | RA-5 | Vulnerability scanning |

### Guest Configuration Policies (Windows STIG)

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Windows machines should meet STIG requirements | Multiple per STIG category | Audit | CM-6, SC-28, AC-2, AU-2 | DISA STIG compliance |

> **Note**: The FedRAMP High built-in initiative (`d5264498-16f4-418a-b659-fa7ef418175f`) includes many VM-related policies. Custom policies supplement coverage specific to DNS VM requirements.

---

## Custom Policy Requirement (per R-001)

Custom policy definitions supplement built-in policies for DNS VM-specific enforcement:

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-vm-disk-encryption-v1` | Deny/Audit | SC-28 | Host-based encryption required |
| `audit-vm-guest-configuration-v1` | Audit | CM-6 | Guest Configuration extension for STIG assessment |
| `audit-vm-diagnostic-settings-v1` | Audit | AU-12 | Azure Monitor Agent for log collection |
| `deny-vm-public-ip-v1` | Deny/Audit | SC-7 | No public IP on DNS VMs |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Virtual Machine documentation | https://learn.microsoft.com/en-us/azure/virtual-machines/overview |
| 2 | Azure Disk Encryption for Windows VMs | https://learn.microsoft.com/en-us/azure/virtual-machines/disk-encryption-overview |
| 3 | Azure Guest Configuration documentation | https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview |
| 4 | Azure Policy built-in definitions for Compute | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#compute |
| 5 | DISA Windows Server 2022 STIG | https://public.cyber.mil/stigs/downloads/ |
| 6 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
