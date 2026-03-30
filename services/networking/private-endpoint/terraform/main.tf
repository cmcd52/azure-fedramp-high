# Terraform Module: Private Endpoint
#
# Deploys an Azure Private Endpoint with DNS zone group configuration.
# This is the shared PE pattern consumed by all service modules that
# require Private Endpoint connectivity.
#
# NIST 800-53: SC-7 (Boundary Protection)
#
# Usage: Service modules call this module with:
#   - resource_id: The Azure resource to connect via PE
#   - subresource_name: The sub-resource (e.g., "blob", "vault", "sites")
#   - subnet_id: The PE subnet
#   - private_dns_zone_id: The corresponding Private DNS Zone
#
# EDGE CASE: Some services require manual approval of the PE connection
# (e.g., third-party services). Set is_manual_connection = true for these.

# NIST 800-53: SC-7 — Private Endpoint for network isolation
resource "azurerm_private_endpoint" "this" {
  name                = var.endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.endpoint_name}-connection"
    private_connection_resource_id = var.resource_id
    subresource_names              = [var.subresource_name]
    is_manual_connection           = var.is_manual_connection
    request_message                = var.is_manual_connection ? var.request_message : null
  }

  # SC-7, SC-20: DNS zone group registers PE IP in Private DNS Zone
  private_dns_zone_group {
    name                 = "${var.endpoint_name}-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "private-endpoint"
    target-resource      = var.resource_id
  })
}

# NIST 800-53: AU-2, AU-12 — Diagnostic settings for Private Endpoint
# NOTE: Private Endpoint connection state and traffic logging is primarily
# captured via the parent resource's diagnostic settings. This diagnostic
# setting captures PE-level network interface metrics for defense-in-depth.
resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.log_analytics_workspace_id != null ? 1 : 0

  name                       = "${var.endpoint_name}-diag"
  target_resource_id         = azurerm_private_endpoint.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
