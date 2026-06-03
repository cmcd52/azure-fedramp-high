# Terraform Module: Azure Spring Apps
#
# Deploys Azure Spring Apps with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-7, AU-12, AC-3

resource "azurerm_spring_cloud_service" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "spring-apps"
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
    private_connection_resource_id = azurerm_spring_cloud_service.this.id
    is_manual_connection           = false
    # subresource_names: verify the correct subresource for Microsoft.AppPlatform/Spring.
    # Common values: ["sites"], ["blob"], ["sqlServer"], ["account"], ["managedInstance"], ["vault"], ["redisCache"], ["namespace"], ["registry"], ["mongo"], ["cassandra"], ["sql"], ["table"], ["gremlin"], ["cluster"], ["api"]
    subresource_names = ["springApps"]
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
    service              = "spring-apps"
  })
}


# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_spring_cloud_service.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.AppPlatform/Spring at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}