# Security Control Baseline: VMs for DNS

**Service**: VMs for DNS (Windows Server 2022 Datacenter)
**Category**: Networking
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Windows Server 2022 Datacenter virtual machines serve as DNS forwarders in the hub network, complementing the managed DNS Private Resolver for scenarios requiring custom DNS logic, conditional forwarding to legacy systems, or WINS resolution. These VMs are critical infrastructure components that must meet the highest security standards including DISA STIG compliance, FIPS 140-2 cryptographic mode, and comprehensive audit logging.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the VM, NIC, extensions (FIPS mode, Azure Monitor Agent, Guest Configuration, Antimalware), data collection rules, and diagnostic settings. OS-level hardening is enforced via Guest Configuration STIG assignments and custom script extensions.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Virtual Machine Contributor | Resource group (via PIM) | Manages VM lifecycle (start, stop, resize). JIT activation required. | AC-2, AC-3, AC-6 |
| Virtual Machine Administrator Login | VM (via PIM) | RDP login via Bastion. JIT activation required. Short-duration sessions. | AC-2, AC-3, AC-6, AC-17 |
| Reader | Resource group | Read-only access to VM configuration for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to VM metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned
- Usage: VM identity authenticates to Log Analytics for metric publishing, and to Guest Configuration service for compliance reporting
- No Key Vault access needed (host encryption, not ADE with customer keys)
- NIST: IA-2, IA-5

### Local Administrator

- Username: Must not be `admin`, `administrator`, or `root`
- Password: Stored in Key Vault, referenced via Terraform data source. Rotated every 90 days.
- Local admin account disabled after domain join (if applicable)
- NIST: IA-2, IA-5

---

## Network Security Controls

### Private NIC Only

- **Public IP**: Prohibited — enforced by `deny-vm-public-ip-v1` policy
- **Administrative access**: Exclusively via Azure Bastion (see `services/networking/bastion/`)
- **Subnet**: Dedicated DNS subnet with NSG allowing only DNS (TCP/UDP 53) inbound and management traffic
- NIST: SC-7

### NSG Rules

| Rule | Direction | Source | Destination | Port | Action | NIST Control |
|------|-----------|--------|-------------|------|--------|--------------|
| Allow-DNS-Inbound | Inbound | Hub/Spoke VNets | DNS VM subnet | 53 (TCP/UDP) | Allow | SC-7 |
| Allow-Bastion-RDP | Inbound | AzureBastionSubnet | DNS VM subnet | 3389 | Allow | SC-7, AC-17 |
| Allow-AzureMonitor | Outbound | DNS VM subnet | AzureMonitor | 443 | Allow | AU-12 |
| Allow-GuestConfig | Outbound | DNS VM subnet | AzureActiveDirectory | 443 | Allow | CM-6 |
| Deny-Internet | Outbound | DNS VM subnet | Internet | * | Deny | SC-7 |
| Allow-DNS-Outbound | Outbound | DNS VM subnet | On-prem DNS | 53 (TCP/UDP) | Allow | SC-20, SC-21 |

### Public Endpoint

- Status: Disabled — no public IP, no public-facing services
- NIST: SC-7

---

## DISA STIG Compliance (per FR-025)

### Windows Server 2022 DISA STIG (V1R5+)

This is the primary compliance framework for OS-level hardening. Azure Guest Configuration continuously assesses STIG compliance and reports findings to Azure Policy.

#### Account and Authentication STIGs

| V-Number Group | Title | Implementation | Status |
|---------------|-------|----------------|--------|
| V-254239 - V-254242 | Account lockout, password complexity, password history | Group Policy / Guest Configuration | Implemented |
| V-254243 - V-254245 | Credential caching, LM hash storage, NTLMv2 | Guest Configuration STIG assignment | Implemented |
| V-254246 - V-254248 | Logon legal notice, interactive logon settings | Custom Script Extension / GPO | Implemented |

#### Audit and Logging STIGs

| V-Number Group | Title | Implementation | Status |
|---------------|-------|----------------|--------|
| V-254249 - V-254260 | Audit policy categories (logon/logoff, object access, privilege use, policy change, account management) | Advanced audit policy via Guest Configuration | Implemented |
| V-254261 - V-254263 | Event log size and retention | Guest Configuration / Registry settings | Implemented |

#### Encryption and FIPS STIGs

| V-Number Group | Title | Implementation | Status |
|---------------|-------|----------------|--------|
| V-254264 - V-254266 | BitLocker drive encryption, TPM settings | Host encryption (`encryption_at_host_enabled`) + vTPM | Implemented |
| V-254267 | FIPS 140-2 compliant algorithms | Custom Script Extension: `FipsAlgorithmPolicy = 1` | Implemented |

#### Network Security STIGs

| V-Number Group | Title | Implementation | Status |
|---------------|-------|----------------|--------|
| V-254268 - V-254272 | Windows Firewall domain/private/public profiles | Guest Configuration STIG + Windows Firewall policy | Implemented |
| V-254273 - V-254275 | SMB signing, LDAP signing, channel binding | Guest Configuration / Registry settings | Implemented |

#### System Integrity STIGs

| V-Number Group | Title | Implementation | Status |
|---------------|-------|----------------|--------|
| V-254276 - V-254278 | PowerShell execution policy, script logging | Guest Configuration / Registry settings | Implemented |
| V-254279 - V-254281 | UAC settings, code signing | Guest Configuration STIG assignment | Implemented |

### CIS Benchmark Alignment (Where STIG Insufficient)

| CIS Control | Requirement | Implementation | STIG Gap |
|-------------|-------------|----------------|----------|
| 2.3.1 | Accounts: Block Microsoft accounts | Registry key via Guest Configuration | STIG does not explicitly cover |
| 9.1 | Windows Defender Firewall — Domain Profile On | Terraform: Windows Firewall enabled | Supplements STIG firewall findings |
| 18.4.1 | MSS: Disable ICMP redirects | Registry key via Guest Configuration | Not in base STIG |

### Azure Guest Configuration for Continuous Compliance

- **Extension**: Guest Configuration for Windows (`ConfigurationforWindows`)
- **Assessment frequency**: Every 15 minutes
- **STIG assignment**: Windows Server 2022 STIG baseline applied via Azure Policy Guest Configuration assignment
- **Compliance reporting**: Non-compliant findings visible in Azure Policy compliance dashboard
- **Remediation**: Auto-remediation for safe settings; manual remediation for breaking changes
- NIST: CM-6, SI-7

---

## Encryption Controls

### Encryption at Rest — FIPS 140-2

- **Mechanism**: Host-based encryption (`encryption_at_host_enabled = true`)
- **Coverage**: OS disk, temp disk, data disk caches — all encrypted at the host level
- **Algorithm**: AES-256
- **FIPS 140-2**: Azure host encryption uses FIPS 140-2 validated cryptographic modules
- **BitLocker**: Not required when host encryption is enabled (host encryption provides equivalent or stronger protection)
- **vTPM**: Enabled for Secure Boot integrity verification and BitLocker key protection (if BitLocker is additionally required)
- NIST: SC-13, SC-28

### Encryption in Transit

- Protocol: All management traffic uses TLS 1.2+ (Azure Monitor Agent, Guest Configuration)
- DNS traffic: UDP/TCP 53 within VNet and over ExpressRoute (MACsec encryption at link layer)
- RDP via Bastion: TLS 1.2 encrypted tunnel
- NIST: SC-8, SC-13

### FIPS 140-2 OS Mode

- **Windows CNG FIPS mode**: Enabled via Custom Script Extension
- **Registry key**: `HKLM\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy\Enabled = 1`
- **Effect**: Windows cryptographic API (CNG) only uses FIPS 140-2 validated algorithms
- **Requires reboot**: Yes — applied during initial provisioning
- NIST: SC-13

---

## Antimalware (Defender for Endpoint)

- **Extension**: Microsoft IaaS Antimalware
- **Real-time protection**: Enabled
- **Scheduled scans**: Weekly full scan (Sundays at 2:00 AM)
- **Definition updates**: Automatic via Microsoft Update
- **Behavior monitoring**: Enabled
- NIST: SI-3

---

## Logging & Monitoring Controls

- Diagnostic categories: Windows Event Logs (Security, System, Application), InsightsMetrics, Sysmon (recommended)
- Azure Monitor Agent: Installed via extension, collects logs via Data Collection Rules
- Destination: Centralized Log Analytics workspace
- Retention: 90 days online / 7 years archived (production)
- OMB M-21-31 tier: EL3 — security events (authentication, privilege escalation, account management)
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Private NIC only; NSG restricts DNS and management traffic; no public IP | Terraform: NIC, NSG rules, deny-vm-public-ip-v1 policy |
| SC-28 | Protection of Information at Rest | Host-based encryption; FIPS 140-2 validated | Terraform: encryption_at_host_enabled = true |
| CM-6 | Configuration Settings | Guest Configuration STIG assessment; FIPS mode; Windows Firewall | Terraform: Guest Configuration extension, FIPS script |
| AU-2 | Audit Events | Windows Security/System/Application Event Logs; advanced audit policy | DCR: Security!/System!/Application! XPath queries |
| AU-12 | Audit Generation | Azure Monitor Agent + DCR forwards all event logs to Log Analytics | Terraform: AMA extension, DCR, DCR association |
| SI-3 | Malicious Code Protection | Microsoft IaaS Antimalware with real-time protection | Terraform: Antimalware extension |
| SI-7 | Software/Firmware Integrity | Secure Boot + vTPM for boot integrity; Guest Configuration for config integrity | Terraform: secure_boot_enabled, vtpm_enabled |
| IA-2 | Identification and Authentication | Local admin with complex password; domain join with MFA via Bastion | Terraform: admin credentials; Bastion access |
| IA-5 | Authenticator Management | Password stored in Key Vault; rotated every 90 days | Operational procedure |

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | Local admin via PIM; Bastion access only | AC-2, AC-3, AC-6 |
| 3.4.2 Establish and enforce security configuration settings | Guest Configuration STIG assessment | CM-6 |
| 3.13.11 Employ FIPS-validated cryptography | Host encryption + FIPS OS mode | SC-13, SC-28 |
| 3.14.2 Provide protection from malicious code | IaaS Antimalware extension | SI-3 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.11 | FIPS 140-2 host encryption + CNG FIPS mode |
| CM.L2-3.4.2 | Guest Configuration STIG continuous assessment |
| AU.L2-3.3.1 | Windows Event Log collection via AMA + DCR |
| SI.L2-3.14.2 | Microsoft Antimalware with real-time protection |

---
