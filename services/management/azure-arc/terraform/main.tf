# Terraform Module: Azure Arc
#
# Deploys Azure Arc with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: IA-2, AU-12

resource "azurerm_arc_machine" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # IA-2: System-assigned managed identity for service-to-service auth
  identity {
    type = "SystemAssigned"
  }

  kind = "SCVMM"

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-arc"
  })
}


# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_arc_machine.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.HybridCompute/machines at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}