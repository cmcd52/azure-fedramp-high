# Terraform Module: Private DNS Zone
#
# Deploys an Azure Private DNS Zone with VNet link for FedRAMP High compliant
# internal name resolution. This is the per-service pattern for additional
# Private DNS Zones beyond the shared zones in shared/terraform/private-dns-zones/.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-20 (Secure Name/Address Resolution — Authoritative Source),
#              AU-2 (Audit Events), AU-12 (Audit Generation)
#
# NOTE: The main deployment of common Private DNS Zones (e.g., privatelink.blob.core.windows.net)
# is via shared/terraform/private-dns-zones/. This module is the reusable pattern
# for deploying additional service-specific Private DNS Zones.
#
# EDGE CASE: Query logging for Private DNS Zones is achieved via DNS Private
# Resolver integration, not direct diagnostic settings on the zone itself.
# Azure Private DNS Zones have limited native diagnostic log support.

# NIST 800-53: SC-7, SC-20 — Private DNS Zone for internal name resolution
resource "azurerm_private_dns_zone" "this" {
  name                = var.zone_name
  resource_group_name = var.resource_group_name

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "private-dns-zone"
  })
}

# NIST 800-53: SC-7 — VNet link to hub VNet for name resolution
resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  name                  = "${var.zone_name}-hub-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = var.auto_registration_enabled

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "private-dns-zone"
  })
}

# NIST 800-53: SC-7 — Additional VNet links (spoke VNets)
resource "azurerm_private_dns_zone_virtual_network_link" "additional" {
  for_each = { for link in var.additional_vnet_links : link.name => link }

  name                  = each.value.name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = false

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "private-dns-zone"
  })
}

# NIST 800-53: AU-2, AU-12 — Diagnostic settings for Private DNS Zone
# NOTE: Azure Private DNS Zones have limited native diagnostic log categories.
# Query-level DNS logging is achieved via DNS Private Resolver integration
# (see services/networking/dns-private-resolver/). This diagnostic setting
# captures available metrics for compliance completeness.
resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.log_analytics_workspace_id != null ? 1 : 0

  name                       = "${var.zone_name}-diag"
  target_resource_id         = azurerm_private_dns_zone.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
