# Terraform Module: Logic Apps Standard
#
# Deploys Logic Apps Standard with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-7, IA-2, AU-12, AC-3

resource "azurerm_logic_app_standard" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # IA-2: System-assigned managed identity for service-to-service auth
  identity {
    type = "SystemAssigned"
  }

  app_service_plan_id = var.app_service_plan_id

  storage_account_name = var.func_storage_account_name

  storage_account_access_key = var.func_storage_account_access_key

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "logic-apps-standard"
  })

  # SC-7: Disable public network access — enforce Private Endpoint connectivity
  public_network_access_enabled = false
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
    private_connection_resource_id = azurerm_logic_app_standard.this.id
    is_manual_connection           = false
    # subresource_names: verify the correct subresource for Microsoft.Web/sites.
    # Common values: ["sites"], ["blob"], ["sqlServer"], ["account"], ["managedInstance"], ["vault"], ["redisCache"], ["namespace"], ["registry"], ["mongo"], ["cassandra"], ["sql"], ["table"], ["gremlin"], ["cluster"], ["api"]
    subresource_names = ["sites"]
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
    service              = "logic-apps-standard"
  })
}


# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_logic_app_standard.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.Web/sites at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}