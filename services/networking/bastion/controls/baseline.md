# Security Control Baseline: Azure Bastion

**Service**: Azure Bastion (Standard SKU)
**Category**: Networking
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Bastion provides secure, browser-based (HTML5) and native client RDP/SSH access to virtual machines without exposing them to the public internet. Bastion is the **only permitted method for administrative VM access** in the FedRAMP High environment per Constitution Principle VI. No direct RDP/SSH from the internet, VPN-based RDP/SSH, or jump box patterns are permitted.

Standard SKU is required for session recording, native client support (az network bastion tunnel), IP-based connection, and shareable link features. These capabilities are essential for FedRAMP High audit trail and privileged access management requirements.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the Bastion host, public IP, NSG, and diagnostic settings.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Bastion Contributor | Resource group (via PIM) | Manages Bastion host configuration. JIT activation required. | AC-2, AC-3, AC-6 |
| Virtual Machine User Login | Target VM (via PIM) | Allows standard user RDP/SSH via Bastion. JIT activation required. | AC-2, AC-17 |
| Virtual Machine Administrator Login | Target VM (via PIM) | Allows admin RDP/SSH via Bastion. JIT activation with approval required. | AC-2, AC-6(1), AC-17 |
| Reader | Resource group | Read-only access for auditors. Standing assignment. | AC-3, AU-6 |

### Managed Identity

- Type: Not applicable — Bastion authenticates users via Entra ID; the Bastion service itself uses platform-managed identity
- Service-to-service: Bastion connects to target VMs via Azure backbone using the user's Entra ID credentials
- NIST: N/A

---

## Session Recording

### Standard SKU Feature

- **Availability**: Standard SKU only (Basic SKU does not support session recording)
- **Scope**: All RDP and SSH sessions through Bastion are recorded
- **Storage**: Session recordings stored in Azure Storage Account (encrypted at rest)
- **Retention**: Per AU-11 retention policy (7 years)
- **Access**: Security team only; protected by RBAC and audit logging
- NIST: AU-3, AU-12

---

## NSG Rules for AzureBastionSubnet

### Inbound Rules

| Priority | Name | Source | Destination | Port | Protocol | Action | Purpose |
|----------|------|--------|-------------|------|----------|--------|---------|
| 120 | AllowHttpsInbound | Internet | * | 443 | TCP | Allow | User connection to Bastion |
| 130 | AllowGatewayManagerInbound | GatewayManager | * | 443 | TCP | Allow | Bastion control plane |
| 140 | AllowAzureLoadBalancerInbound | AzureLoadBalancer | * | 443 | TCP | Allow | Health probes |
| 150 | AllowBastionHostCommunication | VirtualNetwork | VirtualNetwork | 8080, 5701 | * | Allow | Bastion data plane |

### Outbound Rules

| Priority | Name | Source | Destination | Port | Protocol | Action | Purpose |
|----------|------|--------|-------------|------|----------|--------|---------|
| 100 | AllowSshRdpOutbound | * | VirtualNetwork | 22, 3389 | * | Allow | SSH/RDP to target VMs |
| 110 | AllowAzureCloudOutbound | * | AzureCloud | 443 | TCP | Allow | Azure service communication |
| 120 | AllowBastionCommunicationOutbound | VirtualNetwork | VirtualNetwork | 8080, 5701 | * | Allow | Bastion data plane |
| 130 | AllowHttpOutbound | * | Internet | 80 | TCP | Allow | Certificate validation (CRL/OCSP) |

NIST: SC-7

---

## Public IP (Approved Exception)

- **Requirement**: Azure Bastion architecturally requires a public IP address on the AzureBastionSubnet
- **Exception justification**: Bastion is a PaaS service that terminates TLS-encrypted HTML5 sessions at the public endpoint. No direct RDP/SSH ports are exposed. The public IP is protected by:
  - NSG with restrictive inbound rules (HTTPS only from Internet)
  - Azure DDoS Protection (inherited from VNet DDoS Protection Plan)
  - TLS 1.2 encryption on all sessions
  - Entra ID authentication required for all sessions
- **Documentation**: Tagged as `approved-exception = "public-ip-required-by-bastion-architecture"` in Terraform
- NIST: SC-7 (compensating controls documented)

---

## Network Controls

### No DISA STIG

- Per R-002: No DISA STIG exists for Azure Bastion
- Compensating controls: NIST 800-53 controls applied directly, CIS Azure benchmark networking sections, Microsoft security baseline documentation

---

## NIST 800-53 Control Mapping

| Control | Implementation | Evidence |
|---------|---------------|----------|
| AC-17 | Bastion is the only permitted remote admin access method; Entra ID authentication required; PIM for privileged VM roles | Terraform: azurerm_bastion_host; Constitution Principle VI |
| SC-7 | AzureBastionSubnet with restrictive NSG; no direct RDP/SSH from internet; TLS-encrypted sessions | Terraform: NSG rules; public IP approved exception documented |
| AU-3 | Session recording captures user identity, target VM, commands, and session duration | Standard SKU; BastionAuditLogs diagnostic category |
| AU-12 | Diagnostic settings forward BastionAuditLogs to Log Analytics | Terraform: azurerm_monitor_diagnostic_setting |

---
