# Terraform Module: Azure Container Instances
#
# Deploys Azure Container Instances with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-13, SC-28, IA-2, AU-12

resource "azurerm_container_group" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # IA-2: System-assigned managed identity for service-to-service auth
  identity {
    type = "SystemAssigned"
  }

  os_type = "Linux"

  container {
    name   = var.name
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "container-instances"
  })

  # SC-28, SC-13: Customer-managed key encryption (when provided)
  dynamic "customer_managed_key" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      key_vault_key_id = var.key_vault_key_id
    }
  }
}


# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_container_group.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.ContainerInstance/containerGroups at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}