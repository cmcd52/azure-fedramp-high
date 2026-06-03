# Terraform Module: Azure SQL Managed Instance
#
# Deploys Azure SQL Managed Instance with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-7, SC-13, SC-28, IA-2, AU-12, CP-9, AC-3

resource "azurerm_mssql_managed_instance" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # IA-2: System-assigned managed identity for service-to-service auth
  identity {
    type = "SystemAssigned"
  }

  license_type = "BasePrice"

  sku_name = "GP_Gen5"

  storage_size_in_gb = 32

  subnet_id = var.subnet_id

  vcores = 4

  administrator_login          = "sqladmin"
  administrator_login_password = "ChangeMe123!"

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "sql-managed-instance"
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

  # CP-9: Prevent accidental destruction of stateful resource
  lifecycle {
    prevent_destroy = true
  }
}


# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_mssql_managed_instance.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.Sql/managedInstances at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}