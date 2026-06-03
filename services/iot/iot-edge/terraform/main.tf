# Terraform Module: Azure IoT Edge
#
# Deploys Azure IoT Edge with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: AU-12

resource "azurerm_iothub" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "S1"
    capacity = 1
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "iot-edge"
  })
}


# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_iothub.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.Devices/IotHubs at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}