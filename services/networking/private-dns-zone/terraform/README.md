# Terraform Module: Private DNS Zone

**Service**: Private DNS Zone
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Deploys an Azure Private DNS Zone with VNet link to the hub virtual network. This is the reusable per-service pattern for additional Private DNS Zones beyond the common zones deployed by `shared/terraform/private-dns-zones/`.

### Important Notes

- **Shared vs. Per-Service**: Common privatelink zones (blob, vault, etc.) are deployed via `shared/terraform/private-dns-zones/`. This module creates additional service-specific zones.
- **VNet Link**: Hub VNet link is always created. Additional spoke VNet links can be specified via `additional_vnet_links`.
- **Auto-Registration**: Only applicable for non-privatelink zones (e.g., `contoso.internal`).
- **Query Logging**: Private DNS Zones have limited native diagnostic settings. DNS query logging is achieved via DNS Private Resolver integration.

---

## Required Inputs

| Variable | Type | Description | NIST Control |
|----------|------|-------------|--------------|
| `environment` | `string` | `production` or `lower` | — |
| `location` | `string` | Azure region (tagging) | — |
| `resource_group_name` | `string` | Target resource group | — |
| `zone_name` | `string` | Private DNS Zone name | SC-20 |
| `virtual_network_id` | `string` | Hub VNet resource ID | SC-7 |

## Optional Inputs

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | `map(string)` | `{}` | Resource tags |
| `log_analytics_workspace_id` | `string` | `null` | Log Analytics workspace (limited use) |
| `auto_registration_enabled` | `bool` | `false` | Auto-register VM DNS records |
| `additional_vnet_links` | `list(object)` | `[]` | Spoke VNet links |
| `subnet_id` | `string` | `null` | Not used (contract variable) |
| `private_dns_zone_id` | `string` | `null` | Not applicable (contract variable) |
| `key_vault_key_id` | `string` | `null` | Not applicable |

## Outputs

| Output | Description |
|--------|-------------|
| `resource_id` | Private DNS Zone resource ID |
| `resource_name` | Private DNS Zone name |
| `private_endpoint_id` | `null` (not applicable) |
| `diagnostic_setting_id` | `null` (limited native diagnostics) |
| `zone_id` | Zone ID for PE DNS zone group configuration |
| `hub_vnet_link_id` | Hub VNet link resource ID |
