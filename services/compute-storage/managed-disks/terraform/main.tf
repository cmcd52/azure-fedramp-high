# Terraform Module: Azure Managed Disks
#
# Deploys Azure Managed Disks with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-7, SC-13, SC-28, AC-3

resource "azurerm_managed_disk" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_type = "Premium_LRS"

  create_option = "Empty"

  disk_size_gb = 128

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "managed-disks"
  })

  # SC-7: Disable public network access — enforce Private Endpoint connectivity
  public_network_access_enabled = false

  # SC-28, SC-13: Customer-managed key encryption (when provided)
  dynamic "customer_managed_key" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      key_vault_key_id = var.key_vault_key_id
    }
  }
}