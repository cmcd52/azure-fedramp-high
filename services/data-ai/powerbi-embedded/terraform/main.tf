# Terraform Module: Power BI Embedded
#
# Deploys Power BI Embedded with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: 

resource "azurerm_powerbi_embedded" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name = "A1"

  administrators = ["TODO@example.com"]

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "powerbi-embedded"
  })
}