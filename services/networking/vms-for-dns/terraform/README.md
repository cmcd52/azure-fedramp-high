# Terraform Module: VMs for DNS (Windows Server 2022)

**Service**: VMs for DNS
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Deploys Windows Server 2022 Datacenter VMs for DNS forwarding with FedRAMP High compliant defaults: host-based encryption, Secure Boot + vTPM, FIPS mode, Azure Monitor Agent, Guest Configuration extension for STIG compliance, IaaS Antimalware, data collection rules, and private NIC only (no public IP — Bastion for access).

### Important Notes

- **OS**: Windows Server 2022 Datacenter Azure Edition
- **Encryption**: Host-based encryption (`encryption_at_host_enabled = true`) — encrypts OS, temp, and data disk caches
- **FIPS Mode**: Enabled via Custom Script Extension setting `FipsAlgorithmPolicy` registry key. Requires reboot.
- **STIG**: Guest Configuration extension assesses Windows Server 2022 DISA STIG (V1R5+)
- **Access**: No public IP — all administrative access via Azure Bastion
- **Antimalware**: Microsoft IaaS Antimalware with real-time protection and weekly full scans
- **Monitoring**: Azure Monitor Agent + Data Collection Rule for Windows Event Logs and performance counters

---

## Required Inputs

| Variable | Type | Description | NIST Control |
|----------|------|-------------|--------------|
| `environment` | `string` | `production` or `lower` | — |
| `location` | `string` | Azure region | — |
| `resource_group_name` | `string` | Target resource group | — |
| `log_analytics_workspace_id` | `string` | Shared Log Analytics workspace ID | AU-2, AU-12 |
| `subnet_id` | `string` | VM subnet ID (no internet route) | SC-7 |
| `vm_name` | `string` | VM name (max 15 chars) | — |
| `admin_username` | `string` | Local admin username (sensitive) | IA-2, IA-5 |
| `admin_password` | `string` | Local admin password (sensitive) | IA-5 |

## Optional Inputs

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | `map(string)` | `{}` | Resource tags |
| `vm_size` | `string` | `Standard_D2s_v5` | VM size |
| `private_dns_zone_id` | `string` | `null` | Not used (contract variable) |
| `key_vault_key_id` | `string` | `null` | Not used (host encryption instead) |

## Outputs

| Output | Description |
|--------|-------------|
| `resource_id` | VM resource ID |
| `resource_name` | VM name |
| `private_endpoint_id` | `null` (not applicable) |
| `diagnostic_setting_id` | NIC diagnostic setting ID |
| `private_ip_address` | VM private IP |
| `network_interface_id` | NIC resource ID |
| `system_assigned_identity_principal_id` | VM managed identity principal ID |
| `data_collection_rule_id` | DCR resource ID |
