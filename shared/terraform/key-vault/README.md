# Key Vault Module

Deploys an Azure Key Vault configured as a FedRAMP High compliant centralized store for CMK keys, secrets, and certificates.

## Security Controls

| Control | Implementation |
|---------|---------------|
| SC-12, SC-13, SC-28 | Premium SKU for FIPS 140-2 Level 2 software / Level 3 HSM-backed keys |
| AC-3, AC-6 | RBAC authorization only, no access policies |
| SC-7 | Private Endpoint, public access disabled (production), network ACLs default deny |
| AU-2, AU-12 | AuditEvent + AllMetrics diagnostic settings to Log Analytics |
| CP-9 | Soft-delete (90 days) and purge protection enabled |
| OMB M-21-31 EL3 | All Key Vault audit events forwarded to Log Analytics |

## Usage

```hcl
module "key_vault" {
  source = "../../shared/terraform/key-vault"

  environment          = "production"
  location             = "usgovvirginia"
  resource_group_name  = "rg-shared"
  key_vault_name       = "kv-shared-prod"
  tenant_id            = data.azurerm_client_config.current.tenant_id

  log_analytics_workspace_id = module.log_analytics.resource_id
  subnet_id                  = module.vnet.private_endpoint_subnet_id
  private_dns_zone_id        = module.dns.vault_dns_zone_id

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
| key_vault_name | string | Yes | Key Vault name (3-24 chars, alphanumeric + hyphens) |
| tenant_id | string | Yes | Azure AD tenant ID |
| log_analytics_workspace_id | string | Yes | Log Analytics workspace for diagnostics |
| subnet_id | string | No | Subnet for Private Endpoint |
| private_dns_zone_id | string | No | DNS zone for PE registration |
| tags | map(string) | No | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| resource_id | Key Vault resource ID |
| resource_name | Key Vault name |
| private_endpoint_id | Private Endpoint resource ID |
| diagnostic_setting_id | Diagnostic setting resource ID |
| vault_uri | Key Vault URI for use by other modules |
