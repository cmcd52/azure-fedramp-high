# Terraform Module: Microsoft Sentinel
#
# Deploys Microsoft Sentinel with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: AU-12

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "this" {

  workspace_id = var.log_analytics_workspace_id
}


# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "sentinel-diag"
  target_resource_id         = azurerm_sentinel_log_analytics_workspace_onboarding.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.OperationsManagement/solutions at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}