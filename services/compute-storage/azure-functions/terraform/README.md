# Terraform Module: Azure Functions

## Overview

Deploys an Azure Linux Function App on a Premium App Service Plan with FedRAMP High compliant defaults.

## Usage

```hcl
module "azure_functions" {
  source = "./services/compute-storage/azure-functions/terraform"

  environment                = "production"
  location                   = "usgovvirginia"
  resource_group_name        = "rg-functions-prod"
  log_analytics_workspace_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.OperationalInsights/workspaces/law-shared"
  function_plan_name         = "asp-func-prod"
  function_app_name          = "func-myapp-prod"
  storage_account_name       = "stfuncprod001"
  storage_account_access_key = "..."
  subnet_id                  = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/virtualNetworks/.../subnets/pe-subnet"
  private_dns_zone_id        = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
  tags = {
    environment          = "production"
    compliance-framework = "FedRAMP-High"
    owner                = "platform-team"
  }
}
```

## Required Inputs

| Variable | Type | Description |
|----------|------|-------------|
| `environment` | string | `production` or `lower` |
| `location` | string | Azure region (US only) |
| `resource_group_name` | string | Target resource group |
| `log_analytics_workspace_id` | string | Log Analytics workspace ID |
| `function_plan_name` | string | App Service Plan name |
| `function_app_name` | string | Function App name |
| `storage_account_name` | string | Linked Storage Account name |
| `storage_account_access_key` | string | Storage Account access key |

## Optional Inputs

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | map(string) | `{}` | Resource tags |
| `subnet_id` | string | `null` | PE subnet ID |
| `private_dns_zone_id` | string | `null` | PE DNS zone ID |
| `key_vault_key_id` | string | `null` | Not used (contract compliance) |
| `sku_name` | string | `EP1` | ASP SKU (Premium required) |
| `dotnet_version` | string | `8.0` | .NET runtime version |
| `app_settings` | map(string) | `{}` | App settings |

## Outputs

| Output | Description |
|--------|-------------|
| `resource_id` | Function App resource ID |
| `resource_name` | Function App name |
| `private_endpoint_id` | PE resource ID |
| `diagnostic_setting_id` | Diagnostic setting ID |
| `function_plan_id` | ASP resource ID |
| `default_hostname` | Function App hostname |
| `system_assigned_identity_principal_id` | Managed identity principal ID |

## NIST 800-53 Control Coverage

| Control | Implementation |
|---------|----------------|
| SC-7 | Private Endpoint |
| SC-8 | HTTPS-only, TLS 1.2 |
| IA-2 | System-assigned managed identity |
| AU-12 | Diagnostic settings to Log Analytics |
