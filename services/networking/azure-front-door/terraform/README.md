# Terraform Module: Azure Front Door (Premium)

**Service**: Azure Front Door
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Deploys an Azure Front Door Premium profile with FedRAMP High compliant defaults: WAF policy with OWASP and bot protection rules, TLS 1.2 minimum, HTTPS-only origin connections, HTTP-to-HTTPS redirect, and diagnostic settings to the shared Log Analytics workspace.

### Important Notes

- **SKU**: Premium tier is required for managed WAF rule sets (DefaultRuleSet, BotManagerRuleSet) and Private Link to origin connectivity.
- **WAF Mode**: Prevention
- **Private Link to Origin**: Optional — enabled when `origin_private_link_resource_id` is provided. Connects Front Door to the origin via Microsoft backbone instead of public internet.
- **Custom Domains**: Custom domain with managed certificate can be added as a separate resource after initial deployment.

---

## Required Inputs

| Variable | Type | Description | NIST Control |
|----------|------|-------------|--------------|
| `location` | `string` | Azure region for Private Link | — |
| `resource_group_name` | `string` | Target resource group | — |
| `log_analytics_workspace_id` | `string` | Shared Log Analytics workspace ID | AU-2, AU-12 |
| `profile_name` | `string` | Front Door profile name | — |
| `waf_policy_name` | `string` | WAF policy name | SC-7, SI-4 |
| `endpoint_name` | `string` | Front Door endpoint name | — |
| `origin_host_name` | `string` | Origin FQDN (must support HTTPS) | SC-8 |

## Optional Inputs

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | `map(string)` | `{}` | Resource tags |
| `subnet_id` | `string` | `null` | Not directly used by Front Door |
| `private_dns_zone_id` | `string` | `null` | DNS zone for Private Link to origin |
| `key_vault_key_id` | `string` | `null` | Key Vault key for custom domain cert |
| `health_probe_path` | `string` | `"/"` | Origin health probe path |
| `origin_private_link_resource_id` | `string` | `null` | Origin resource ID for Private Link |
| `origin_private_link_target_type` | `string` | `null` | Private Link target type |

## Outputs

| Output | Description |
|--------|-------------|
| `resource_id` | Azure Resource ID of the Front Door profile |
| `resource_name` | Name of the Front Door profile |
| `private_endpoint_id` | Always `null` — Private Link is per-origin |
| `diagnostic_setting_id` | Resource ID of the diagnostic setting |
| `endpoint_fqdn` | FQDN of the Front Door endpoint |
| `waf_policy_id` | Resource ID of the WAF policy |
| `profile_resource_guid` | UUID of the Front Door profile |

---
