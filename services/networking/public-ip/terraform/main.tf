# Terraform Module: Azure Public IP Address
#
# Deploys Azure Public IP Address with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: 

resource "azurerm_public_ip" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method = "Static"

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "public-ip"
  })
}