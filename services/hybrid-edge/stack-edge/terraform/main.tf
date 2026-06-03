# Terraform Module: Azure Stack Edge
#
# Deploys Azure Stack Edge with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-13, SC-28, CP-9

resource "azurerm_databox_edge_device" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name = "EdgeP_Base-Standard"

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "stack-edge"
  })

  # SC-28, SC-13: Customer-managed key encryption (when provided)
  dynamic "customer_managed_key" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      key_vault_key_id = var.key_vault_key_id
    }
  }

  # CP-9: Prevent accidental destruction of stateful resource
  lifecycle {
    prevent_destroy = true
  }
}