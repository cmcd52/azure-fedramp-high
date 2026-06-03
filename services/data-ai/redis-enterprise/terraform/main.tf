# Terraform Module: Azure Cache for Redis Enterprise
#
# Deploys Azure Cache for Redis Enterprise with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-7, SC-13, SC-28, AU-12, CP-9

resource "azurerm_redis_enterprise_cluster" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name = "Enterprise_E10-2"

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "redis-enterprise"
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




# NIST 800-53 SC-7: Private Endpoint for inbound traffic isolation
resource "azurerm_private_endpoint" "this" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_redis_enterprise_cluster.this.id
    is_manual_connection           = false
    subresource_names              = ["redisEnterprise"]
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
    service              = "redis-enterprise"
  })
}

# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_redis_enterprise_cluster.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.Cache/redisEnterprise at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}