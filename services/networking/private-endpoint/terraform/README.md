# Terraform Module: Private Endpoint

**Service**: Private Endpoint
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Deploys an Azure Private Endpoint with DNS zone group configuration. This is the shared PE pattern consumed by all service modules requiring Private Endpoint connectivity. Each service module passes its resource ID, sub-resource name, subnet, and Private DNS Zone to this reusable module.

### Important Notes

- **Reusable Pattern**: This module is called by each service module — it is not deployed standalone.
- **DNS Zone Group**: Automatically registers the PE's private IP in the specified Private DNS Zone.
- **Subnet NSG**: The PE subnet must have an NSG and `privateEndpointNetworkPolicies` enabled (managed by the VNet module).
- **Manual Approval**: Some services (third-party) require manual PE connection approval. Set `is_manual_connection = true`.
- **Diagnostics**: PE connection state is logged via the parent resource's diagnostic settings, not the PE itself.

---

## Required Inputs

| Variable | Type | Description | NIST Control |
|----------|------|-------------|--------------|
| `environment` | `string` | `production` or `lower` | — |
| `location` | `string` | Azure region | — |
| `resource_group_name` | `string` | Target resource group | — |
| `endpoint_name` | `string` | Private Endpoint name | — |
| `resource_id` | `string` | Target Azure resource ID | SC-7 |
| `subresource_name` | `string` | Sub-resource (blob, vault, sites, etc.) | SC-7 |
| `subnet_id` | `string` | PE subnet ID | SC-7 |
| `private_dns_zone_id` | `string` | Private DNS Zone ID | SC-7, SC-20 |

## Optional Inputs

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | `map(string)` | `{}` | Resource tags |
| `log_analytics_workspace_id` | `string` | `null` | Not used (contract variable) |
| `key_vault_key_id` | `string` | `null` | Not applicable |
| `is_manual_connection` | `bool` | `false` | Manual PE approval |
| `request_message` | `string` | `"..."` | Approval message |

## Outputs

| Output | Description |
|--------|-------------|
| `resource_id` | Private Endpoint resource ID |
| `resource_name` | Private Endpoint name |
| `private_endpoint_id` | Same as resource_id |
| `diagnostic_setting_id` | `null` (logged via parent resource) |
| `private_ip_address` | PE private IP address |
| `network_interface_id` | PE NIC resource ID |
| `private_dns_zone_group_id` | DNS zone group ID |
