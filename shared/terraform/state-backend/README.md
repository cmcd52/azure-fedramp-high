# Terraform State Backend Module

Deploys an Azure Storage Account configured as a FedRAMP High compliant Terraform remote state backend.

## Security Controls

| Control | Implementation |
|---------|---------------|
| SC-12, SC-13, SC-28 | CMK encryption at rest (production), platform key (lower) |
| SC-7 | Private Endpoint, no public access |
| SC-8 | TLS 1.2 minimum |
| AC-3 | RBAC-only access, shared keys disabled |
| AU-3, AU-6, AU-12 | Diagnostic settings to Log Analytics |
| CM-3 | Blob versioning enabled |
| CP-9 | Soft-delete with 30-day retention |

## Usage

```hcl
module "state_backend" {
  source = "../../shared/terraform/state-backend"

  environment          = "production"
  location             = "eastus"
  resource_group_name  = "rg-tfstate"
  storage_account_name = "stterraformstate"

  log_analytics_workspace_id = module.log_analytics.resource_id
  subnet_id                  = module.vnet.private_endpoint_subnet_id
  private_dns_zone_id        = module.dns.blob_dns_zone_id
  key_vault_key_id           = module.key_vault.cmk_key_id
  encryption_identity_id     = azurerm_user_assigned_identity.cmk.id

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
| storage_account_name | string | Yes | Storage account name (3-24 lowercase alphanum) |
| log_analytics_workspace_id | string | No | Log Analytics workspace for diagnostics |
| subnet_id | string | No | Subnet for Private Endpoint |
| private_dns_zone_id | string | No | DNS zone for PE registration |
| key_vault_key_id | string | No | CMK key ID (production) |
| encryption_identity_id | string | No | UAI for CMK access |
| tags | map(string) | No | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| resource_id | Storage account resource ID |
| resource_name | Storage account name |
| private_endpoint_id | Private Endpoint resource ID |
| diagnostic_setting_id | Diagnostic setting resource ID |
| container_name | State container name |
| primary_blob_endpoint | Primary blob endpoint URL |
