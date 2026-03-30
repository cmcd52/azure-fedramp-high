# Hub Virtual Network — FedRAMP High

Shared Terraform module that deploys a hub virtual network with dedicated subnets for Private Endpoints, Azure Bastion, and DNS infrastructure.

## NIST 800-53 Controls

| Control | Implementation |
|---------|---------------|
| **SC-7** (Boundary Protection) | Hub VNet boundary; dedicated subnets with NSGs enforce network segmentation |
| **AC-4** (Information Flow Enforcement) | NSG rules restrict traffic to only required flows per subnet |
| **AU-2** (Audit Events) | NSG diagnostic settings stream security events to Log Analytics |
| **AU-12** (Audit Generation) | NSG flow log categories enabled for all network security groups |

## Architecture

```
Hub VNet (configurable /16)
├── snet-private-endpoints (/24) — All Private Endpoint NICs
├── AzureBastionSubnet     (/26) — Azure Bastion (required name)
└── snet-dns               (/28) — DNS VMs & DNS Private Resolver
```

Each subnet has a dedicated NSG with restrictive inbound/outbound rules and diagnostic settings forwarding to Log Analytics.

## Usage

```hcl
module "hub_vnet" {
  source = "../../shared/terraform/virtual-network"

  environment                = "prod"
  location                   = "usgovvirginia"
  resource_group_name        = azurerm_resource_group.hub.name
  vnet_name                  = "vnet-hub-prod"
  address_space              = ["10.0.0.0/16"]
  log_analytics_workspace_id = module.log_analytics.resource_id

  tags = {
    project = "fedramp-high"
  }
}
```

## Inputs

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `environment` | `string` | yes | Deployment environment (dev, staging, prod) |
| `location` | `string` | yes | Azure region |
| `resource_group_name` | `string` | yes | Resource group name |
| `vnet_name` | `string` | yes | Hub VNet name |
| `address_space` | `list(string)` | yes | VNet address space |
| `log_analytics_workspace_id` | `string` | yes | Log Analytics workspace resource ID |
| `tags` | `map(string)` | no | Additional tags |

## Outputs

| Name | Description |
|------|-------------|
| `resource_id` | Hub VNet resource ID |
| `resource_name` | Hub VNet name |
| `private_endpoint_subnet_id` | Private Endpoints subnet ID |
| `bastion_subnet_id` | AzureBastionSubnet ID |
| `dns_subnet_id` | DNS subnet ID |
| `private_endpoint_id` | null (no PE for VNet itself) |
| `diagnostic_setting_id` | Map of NSG diagnostic setting IDs |
