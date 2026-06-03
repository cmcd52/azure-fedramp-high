# Terraform Module: Azure Service Fabric
#
# Deploys Azure Service Fabric with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-13, SC-28, AU-12, CP-9

resource "azurerm_service_fabric_cluster" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  reliability_level = "Silver"

  upgrade_mode = "Automatic"

  vm_image = "Windows"

  management_endpoint = var.management_endpoint

  node_type {
    name                 = "default"
    instance_count       = 3
    is_primary           = true
    client_endpoint_port = 19000
    http_endpoint_port   = 19080
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "service-fabric"
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
  target_resource_id         = azurerm_service_fabric_cluster.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.ServiceFabric/clusters at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}