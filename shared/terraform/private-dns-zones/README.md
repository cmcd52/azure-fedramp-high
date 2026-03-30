# Private DNS Zones — FedRAMP High

Shared Terraform module that deploys all required `privatelink.*` DNS zones for in-scope services and links them to the hub virtual network.

## NIST 800-53 Controls

| Control | Implementation |
|---------|---------------|
| **SC-7** (Boundary Protection) | Private DNS ensures service traffic resolves to private endpoints, never public IPs |
| **SC-20** (Secure Name/Address Resolution — Authoritative) | Azure-managed authoritative DNS zones for privatelink domains |
| **SC-21** (Secure Name/Address Resolution — Recursive) | VNet links enable recursive resolution through hub network |

## DNS Zones Deployed

| Key | Zone | Service |
|-----|------|---------|
| `storage` | `privatelink.blob.core.windows.net` | Azure Storage |
| `keyvault` | `privatelink.vaultcore.azure.net` | Key Vault |
| `monitor` | `privatelink.monitor.azure.com` | Azure Monitor |
| `log_analytics_oms` | `privatelink.oms.opinsights.azure.com` | Log Analytics (OMS) |
| `log_analytics_ods` | `privatelink.ods.opinsights.azure.com` | Log Analytics (ODS) |
| `log_analytics_agent` | `privatelink.agentsvc.azure-automation.net` | Log Analytics (Agent) |
| `app_service` | `privatelink.azurewebsites.net` | App Service / Functions |
| `ai_search` | `privatelink.search.windows.net` | Azure AI Search |
| `openai` | `privatelink.openai.azure.com` | Azure OpenAI |
| `cognitive_services` | `privatelink.cognitiveservices.azure.com` | Document Intelligence / Speech |
| `purview` | `privatelink.purview.azure.com` | Azure Purview |
| `purview_studio` | `privatelink.purviewstudio.azure.com` | Purview Studio |
| `event_hubs` | `privatelink.servicebus.windows.net` | Event Hubs |
| `container_registry` | `privatelink.azurecr.io` | Azure Container Registry |

## Usage

```hcl
module "private_dns_zones" {
  source = "../../shared/terraform/private-dns-zones"

  environment         = "prod"
  location            = "usgovvirginia"
  resource_group_name = azurerm_resource_group.hub.name
  virtual_network_id  = module.hub_vnet.resource_id

  tags = {
    project = "fedramp-high"
  }
}
```

### Adding Custom Zones

```hcl
module "private_dns_zones" {
  source = "../../shared/terraform/private-dns-zones"

  # ... required variables ...

  additional_zones = {
    sql = {
      zone_name = "privatelink.database.windows.net"
      service   = "Azure SQL"
    }
  }
}
```

## Inputs

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `environment` | `string` | yes | Deployment environment |
| `location` | `string` | yes | Azure region (tagging only; DNS zones are global) |
| `resource_group_name` | `string` | yes | Resource group name |
| `virtual_network_id` | `string` | yes | Hub VNet resource ID to link zones to |
| `tags` | `map(string)` | no | Additional tags |
| `additional_zones` | `map(object)` | no | Extra privatelink zones to create |

## Outputs

| Name | Description |
|------|-------------|
| `zone_ids` | Map of zone short name → resource ID |
| `resource_id` | null (multiple resources) |
| `resource_name` | null (multiple resources) |
| `private_endpoint_id` | null |
| `diagnostic_setting_id` | null |
