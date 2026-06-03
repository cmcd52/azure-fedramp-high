# Terraform Module: Network Watcher
#
# Deploys Network Watcher with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: 

resource "azurerm_network_watcher" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "network-watcher"
  })

  # review per FedRAMP High compliance baseline.
}