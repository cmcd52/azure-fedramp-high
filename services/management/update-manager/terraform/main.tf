# Terraform Module: Azure Update Manager
#
# Deploys Azure Update Manager with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: 

resource "azurerm_maintenance_configuration" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  scope = "InGuestPatch"

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "update-manager"
  })
}