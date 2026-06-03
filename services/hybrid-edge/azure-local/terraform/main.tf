# Terraform Module: Azure Local (Azure Stack HCI)
#
# Deploys Azure Local (Azure Stack HCI) with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-13, SC-28, AU-12, CP-9

resource "azurerm_stack_hci_cluster" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-local"
  })

  # review per FedRAMP High compliance baseline.

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
  target_resource_id         = azurerm_stack_hci_cluster.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.AzureStackHCI/clusters at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}