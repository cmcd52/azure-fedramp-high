# Terraform Module: Azure Dedicated Host
#
# Deploys Azure Dedicated Host with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: AU-12, CP-9

resource "azurerm_dedicated_host_group" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  platform_fault_domain_count = 2

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "dedicated-host"
  })

  # CP-9: Prevent accidental destruction of stateful resource
  lifecycle {
    prevent_destroy = true
  }
}


# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_dedicated_host_group.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.Compute/hostGroups at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}