# Terraform Module: Azure DDoS Protection
#
# Deploys Azure DDoS Protection with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: CP-9

resource "azurerm_network_ddos_protection_plan" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "ddos-protection"
  })

  # review per FedRAMP High compliance baseline.

  # CP-9: Prevent accidental destruction of stateful resource
  lifecycle {
    prevent_destroy = true
  }
}