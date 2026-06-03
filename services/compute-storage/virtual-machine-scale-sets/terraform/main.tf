# Terraform Module: Virtual Machine Scale Sets
#
# Deploys Virtual Machine Scale Sets with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-13, SC-28, IA-2, AU-12

resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # IA-2: System-assigned managed identity for service-to-service auth
  identity {
    type = "SystemAssigned"
  }

  sku = "Standard_D2s_v3"

  admin_username = "azureadmin"

  instances = 1

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  network_interface {
    name    = "primary"
    primary = true
    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "virtual-machine-scale-sets"
  })

  # SC-28, SC-13: Customer-managed key encryption (when provided)
  dynamic "customer_managed_key" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      key_vault_key_id = var.key_vault_key_id
    }
  }
}


# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_linux_virtual_machine_scale_set.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.Compute/virtualMachineScaleSets at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}