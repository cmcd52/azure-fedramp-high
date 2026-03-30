# Terraform Module: ExpressRoute Circuit

**Service**: ExpressRoute
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Deploys an Azure ExpressRoute circuit with FedRAMP High compliant defaults: Premium SKU, private peering with MD5 BGP authentication, and diagnostic settings to the shared Log Analytics workspace.

### Important Notes

- **Private Endpoint**: NOT applicable — ExpressRoute IS the dedicated private connectivity. It does not deploy as a resource inside a VNet.
- **MACsec Encryption**: MACsec (802.1AE) Layer 2 encryption is available on **ExpressRoute Direct** only and is configured on the port resource, not the circuit. MACsec configuration is documented in `controls/baseline.md`.
- **SKU**: Premium tier is required for cross-region VNet peering and higher route limits in FedRAMP High environments.

---

## Required Inputs

| Variable | Type | Description | NIST Control |
|----------|------|-------------|--------------|
| `environment` | `string` | `production` or `lower` | — |
| `location` | `string` | Azure region (US for FedRAMP) | — |
| `resource_group_name` | `string` | Target resource group | — |
| `log_analytics_workspace_id` | `string` | Shared Log Analytics workspace ID | AU-2, AU-12 |
| `circuit_name` | `string` | ExpressRoute circuit name | — |
| `service_provider_name` | `string` | Provider (e.g., Equinix, AT&T) | — |
| `peering_location` | `string` | Peering location (e.g., Washington DC) | — |
| `peer_asn` | `number` | Peer BGP ASN for private peering | SC-7 |
| `primary_peer_address_prefix` | `string` | Primary /30 CIDR for peering | SC-7 |
| `secondary_peer_address_prefix` | `string` | Secondary /30 CIDR for peering | SC-7 |
| `vlan_id` | `number` | VLAN ID for private peering | SC-7 |

## Optional Inputs

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | `map(string)` | `{}` | Resource tags |
| `subnet_id` | `string` | `null` | Not used by ExpressRoute |
| `private_dns_zone_id` | `string` | `null` | Not used by ExpressRoute |
| `key_vault_key_id` | `string` | `null` | Not used by ExpressRoute |
| `bandwidth_in_mbps` | `number` | `1000` | Circuit bandwidth |
| `sku_family` | `string` | `"MeteredData"` | MeteredData or UnlimitedData |
| `shared_key` | `string` | `null` | MD5 key for BGP authentication |

## Outputs

| Output | Description |
|--------|-------------|
| `resource_id` | Azure Resource ID of the ExpressRoute circuit |
| `resource_name` | Name of the ExpressRoute circuit |
| `private_endpoint_id` | Always `null` — not applicable for ExpressRoute |
| `diagnostic_setting_id` | Resource ID of the diagnostic setting |
| `service_key` | Service key for provider provisioning (sensitive) |
| `service_provider_provisioning_state` | Provider provisioning state |

---
