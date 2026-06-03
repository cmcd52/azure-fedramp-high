# Terraform Module: Azure Private Link Service
#
# Deploys Azure Private Link Service with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: 

resource "azurerm_private_link_service" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  load_balancer_frontend_ip_configuration_ids = var.load_balancer_frontend_ip_configuration_ids

  nat_ip_configuration {
    name      = "primary"
    primary   = true
    subnet_id = var.subnet_id
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "private-link-service"
  })
}