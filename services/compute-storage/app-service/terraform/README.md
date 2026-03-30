# Terraform Module: App Service

## Overview

Deploys an Azure Linux Web App on a Premium App Service Plan with FedRAMP High compliant defaults.

## Usage

```hcl
module "app_service" {
  source = "./services/compute-storage/app-service/terraform"

  environment                = "production"
  location                   = "usgovvirginia"
  resource_group_name        = "rg-app-service-prod"
  log_analytics_workspace_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.OperationalInsights/workspaces/law-shared"
  app_service_plan_name      = "asp-myapp-prod"
  app_name                   = "app-myapp-prod"
  subnet_id                  = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/virtualNetworks/.../subnets/pe-subnet"
  private_dns_zone_id        = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
  vnet_integration_subnet_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/virtualNetworks/.../subnets/vnet-int-subnet"
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
| `app_service_plan_name` | string | App Service Plan name |
| `app_name` | string | Web App name |

## Optional Inputs

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | map(string) | `{}` | Resource tags |
| `subnet_id` | string | `null` | PE subnet ID |
| `private_dns_zone_id` | string | `null` | PE DNS zone ID |
| `key_vault_key_id` | string | `null` | Not used (contract compliance) |
| `sku_name` | string | `P1v3` | ASP SKU (Premium required) |
| `vnet_integration_subnet_id` | string | `null` | VNet integration subnet |
| `app_settings` | map(string) | `{}` | App settings (no secrets) |

## Outputs

| Output | Description |
|--------|-------------|
| `resource_id` | Web App resource ID |
| `resource_name` | Web App name |
| `private_endpoint_id` | PE resource ID |
| `diagnostic_setting_id` | Diagnostic setting ID |
| `app_service_plan_id` | ASP resource ID |
| `default_hostname` | Web App hostname |
| `system_assigned_identity_principal_id` | Managed identity principal ID |

## NIST 800-53 Control Coverage

| Control | Implementation |
|---------|----------------|
| SC-7 | VNet integration + Private Endpoint |
| SC-8 | HTTPS-only, TLS 1.2 |
| SC-13 | TLS 1.2 FIPS-validated modules |
| SC-28 | Platform-managed encryption at rest |
| IA-2 | System-assigned managed identity |
| AU-12 | Diagnostic settings to Log Analytics |
