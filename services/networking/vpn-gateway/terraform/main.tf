# Terraform Module: VPN Gateway
#
# Deploys VPN Gateway with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: AU-12, CP-9

resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  type = "Vpn"

  sku = "VpnGw2"

  ip_configuration {
    name                 = "vnetGatewayConfig"
    public_ip_address_id = var.public_ip_address_id
    subnet_id            = var.gateway_subnet_id
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "vpn-gateway"
  })

  # CP-9: Prevent accidental destruction of stateful resource
  lifecycle {
    prevent_destroy = true
  }
}


# NIST 800-53 AU-12: Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_virtual_network_gateway.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Enable all available log categories. Verify exact category names
  # for Microsoft.Network/virtualNetworkGateways at:
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/
  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}