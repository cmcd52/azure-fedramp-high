# Terraform Module: Azure Key Vault Managed HSM
#
# Deploys Azure Key Vault Managed HSM with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-7, AU-12, CP-9, AC-3

resource "azurerm_key_vault_managed_hardware_security_module" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  admin_object_ids = var.admin_object_ids

  sku_name = "Standard_B1"

  tenant_id = var.tenant_id

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "key-vault-managed-hsm"
  })

  # SC-7: Disable public network access — enforce Private Endpoint connectivity
  public_network_access_enabled = false

  # CP-9: Prevent accidental destruction of stateful resource
  lifecycle {
    prevent_destroy = true
  }
}


# NIST 800-53 SC-7: Private Endpoint for inbound traffic isolation
resource "azurerm_private_endpoint" "this" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_key_vault_managed_hardware_security_module.this.id
    is_manual_connection           = false
    # subresource_names: verify the correct subresource for Microsoft.KeyVault/managedHSMs.
    # Common values: ["sites"], ["blob"], ["sqlServer"], ["account"], ["managedInstance"], ["vault"], ["redisCache"], ["namespace"], ["registry"], ["mongo"], ["cassandra"], ["sql"], ["table"], ["gremlin"], ["cluster"], ["api"]
    subresource_names = ["managedhsm"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id != null ? [1] : []
    content {
      name                 = "default"
      private_dns_zone_ids = [var.private_dns_zone_id]
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "key-vault-managed-hsm"
  })
}


# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_key_vault_managed_hardware_security_module.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.KeyVault/managedHSMs at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}