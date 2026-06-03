# Terraform Module: Azure Confidential Ledger
#
# Deploys Azure Confidential Ledger with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: SC-7, AU-12, CP-9

resource "azurerm_confidential_ledger" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  ledger_type = "Public"

  azuread_based_service_principal {
    principal_id     = var.ledger_admin_principal_id
    tenant_id        = var.tenant_id
    ledger_role_name = "Administrator"
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "confidential-ledger"
  })

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
    private_connection_resource_id = azurerm_confidential_ledger.this.id
    is_manual_connection           = false
    subresource_names              = ["ledger"]
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
    service              = "confidential-ledger"
  })
}

# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_confidential_ledger.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.ConfidentialLedger/ledgers at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}