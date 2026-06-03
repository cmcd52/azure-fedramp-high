# Terraform Module: Azure Policy
#
# Deploys Azure Policy with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: 

resource "azurerm_policy_definition" "this" {
  name = var.name

  policy_type = "Custom"

  mode = "All"

  display_name = var.name
}