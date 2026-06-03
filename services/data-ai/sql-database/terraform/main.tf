# Terraform Module: Azure SQL Database
#
# Deploys Azure SQL Database with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-13, SC-28, IA-2, AU-12, CP-9

resource "azurerm_mssql_database" "this" {
  name = var.name
  # IA-2: System-assigned managed identity for service-to-service auth
  identity {
    type         = "UserAssigned"
    identity_ids = var.identity_ids
  }

  server_id = var.server_id

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "sql-database"
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

# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_mssql_database.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.Sql/servers/databases at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}