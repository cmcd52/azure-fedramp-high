# Log Analytics Workspace Module

Deploys a centralized Azure Log Analytics workspace configured as the FedRAMP High compliant logging destination for all Azure services. Includes Microsoft Sentinel integration for OMB M-21-31 EL3 advanced analytics.

## Security Controls

| Control | Implementation |
|---------|---------------|
| AU-2, AU-12 | Centralized audit event collection from all Azure services |
| AU-3 | Full audit record content via diagnostic settings |
| AU-6 | Microsoft Sentinel (SecurityInsights) for audit review and analysis |
| AU-11 | 365-day retention in production (FR-030) |
| SC-7 | Internet ingestion/query disabled in production; AMPLS Private Endpoint |
| SC-12, SC-13 | CMK encryption with Key Vault managed keys |
| SC-28 | Encryption at rest (CMK production, platform key lower) |

## Usage

```hcl
module "log_analytics" {
  source = "../../shared/terraform/log-analytics"

  environment         = "production"
  location            = "usgovvirginia"
  resource_group_name = "rg-logging"
  workspace_name      = "law-central-prod"

  subnet_id           = module.vnet.private_endpoint_subnet_id
  private_dns_zone_id = module.dns.monitor_dns_zone_id
  key_vault_key_id    = module.key_vault.cmk_key_id

  tags = {
    environment          = "production"
    compliance-framework = "FedRAMP-High"
    owner                = "platform-team"
  }
}
```

## Inputs

| Name | Type | Required | Description |
|------|------|----------|-------------|
| environment | string | Yes | `production` or `lower` |
| location | string | Yes | Azure region (US only for FedRAMP) |
| resource_group_name | string | Yes | Target resource group |
| workspace_name | string | Yes | Log Analytics workspace name (3-63 chars) |
| tags | map(string) | No | Resource tags |
| key_vault_key_id | string | No | CMK key ID for encryption (production) |
| subnet_id | string | No | Subnet for AMPLS Private Endpoint |
| private_dns_zone_id | string | No | DNS zone for PE registration |

## Outputs

| Name | Description |
|------|-------------|
| resource_id | Workspace resource ID (consumed by all modules as `log_analytics_workspace_id`) |
| resource_name | Workspace name |
| private_endpoint_id | Private Endpoint resource ID (null if not deployed) |
| diagnostic_setting_id | Diagnostic setting resource ID (null — self-monitoring not possible) |
| workspace_id | GUID workspace ID for agent configuration |
| primary_shared_key | Primary shared key for agent configuration (sensitive) |

## Notes

- **Self-monitoring limitation**: A Log Analytics workspace cannot send its own diagnostic logs to itself. Consider a secondary workspace or Event Hubs for workspace audit logs (AU-9).
- **CMK encryption**: Full CMK requires a dedicated Log Analytics cluster at 500 GB/day commitment tier. For smaller workloads, `cmk_for_query_forced` provides query-level CMK encryption.
- **Sentinel**: The SecurityInsights solution is always deployed for OMB M-21-31 EL3 compliance regardless of environment tier.
