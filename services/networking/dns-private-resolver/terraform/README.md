# Terraform Module: DNS Private Resolver

**Service**: DNS Private Resolver
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Deploys an Azure DNS Private Resolver with FedRAMP High compliant defaults: inbound endpoint for VNet DNS query reception, outbound endpoint for conditional forwarding to on-premises DNS servers, forwarding ruleset with domain-specific rules, VNet link, and diagnostic settings to the shared Log Analytics workspace.

### Important Notes

- **Subnets**: Inbound and outbound endpoints require dedicated subnets with delegation `Microsoft.Network/dnsResolvers`. Minimum subnet size is /28. Subnets must be separate.
- **Hub VNet**: The resolver must be deployed in the hub VNet. Spoke VNets resolve DNS via VNet peering.
- **On-Prem Forwarding**: Forwarding rules route specific domain queries to on-prem DNS servers via ExpressRoute/VPN.
- **Inbound IP**: The inbound endpoint IP is used as the custom DNS server for VNet DNS settings.

---

## Required Inputs

| Variable | Type | Description | NIST Control |
|----------|------|-------------|--------------|
| `environment` | `string` | `production` or `lower` | — |
| `location` | `string` | Azure region | — |
| `resource_group_name` | `string` | Target resource group | — |
| `log_analytics_workspace_id` | `string` | Shared Log Analytics workspace ID | AU-2, AU-12 |
| `resolver_name` | `string` | DNS Private Resolver name | — |
| `virtual_network_id` | `string` | Hub VNet resource ID | SC-7 |
| `inbound_subnet_id` | `string` | Subnet for inbound endpoint (delegation required) | SC-7, SC-20 |
| `outbound_subnet_id` | `string` | Subnet for outbound endpoint (delegation required) | SC-20, SC-21 |

## Optional Inputs

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | `map(string)` | `{}` | Resource tags |
| `forwarding_rules` | `list(object)` | `[]` | On-prem domain forwarding rules |
| `subnet_id` | `string` | `null` | Not used (contract variable) |
| `private_dns_zone_id` | `string` | `null` | Not used (contract variable) |
| `key_vault_key_id` | `string` | `null` | Not applicable |

## Outputs

| Output | Description |
|--------|-------------|
| `resource_id` | DNS Private Resolver resource ID |
| `resource_name` | DNS Private Resolver name |
| `private_endpoint_id` | `null` (not applicable) |
| `diagnostic_setting_id` | Diagnostic setting resource ID |
| `inbound_endpoint_id` | Inbound endpoint resource ID |
| `inbound_endpoint_ip` | Inbound endpoint private IP (use as DNS server) |
| `outbound_endpoint_id` | Outbound endpoint resource ID |
| `forwarding_ruleset_id` | Forwarding ruleset resource ID |
