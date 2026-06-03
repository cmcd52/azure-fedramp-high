# Terraform Module: Azure Lighthouse
#
# Deploys Azure Lighthouse with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: 

resource "azurerm_lighthouse_definition" "this" {
  name = var.name

  managing_tenant_id = var.managing_tenant_id

  scope = var.scope

  authorization {
    principal_id       = "00000000-0000-0000-0000-000000000000"
    role_definition_id = "acdd72a7-3385-48ef-bd42-f606fba81ae7"
  }
}