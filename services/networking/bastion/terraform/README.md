# Terraform Module: Azure Bastion Host

**Service**: Azure Bastion
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Deploys an Azure Bastion host (Standard SKU) with FedRAMP High compliant defaults: session recording support, AzureBastionSubnet with restrictive NSG, and diagnostic settings to the shared Log Analytics workspace. Bastion is the only permitted method for administrative VM access per Constitution Principle VI.

### Important Notes

- **Public IP**: Required by Bastion architecture — this is an approved exception to the "no public IP" principle. Protected by NSG, DDoS protection, and TLS-encrypted HTML5 sessions.
- **Subnet**: Must be deployed in a subnet named exactly `AzureBastionSubnet`. This is an Azure platform requirement.
- **SKU**: Standard SKU is required for session recording, native client support, and IP-based connection features.
- **File Copy**: Disabled in production environments for data exfiltration prevention.

---

## Required Inputs

| Variable | Type | Description | NIST Control |
|----------|------|-------------|--------------|
| `environment` | `string` | `production` or `lower` | — |
| `location` | `string` | Azure region (US for FedRAMP) | — |
| `resource_group_name` | `string` | Target resource group | — |
| `log_analytics_workspace_id` | `string` | Shared Log Analytics workspace ID | AU-2, AU-12 |
| `subnet_id` | `string` | AzureBastionSubnet resource ID | SC-7 |
| `bastion_name` | `string` | Bastion host name | — |

## Optional Inputs

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | `map(string)` | `{}` | Resource tags |
| `private_dns_zone_id` | `string` | `null` | Not used by Bastion |
| `key_vault_key_id` | `string` | `null` | Not used by Bastion |

## Outputs

| Output | Description |
|--------|-------------|
| `resource_id` | Azure Resource ID of the Bastion host |
| `resource_name` | Name of the Bastion host |
| `private_endpoint_id` | Always `null` — Bastion uses public IP |
| `diagnostic_setting_id` | Resource ID of the diagnostic setting |
| `public_ip_id` | Resource ID of the Bastion public IP |
| `nsg_id` | Resource ID of the AzureBastionSubnet NSG |
| `dns_name` | DNS name of the Bastion host |

---
