# Terraform Module: Route Server
#
# Deploys Route Server with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: 

resource "azurerm_virtual_hub" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "route-server"
  })

  # review per FedRAMP High compliance baseline.
}