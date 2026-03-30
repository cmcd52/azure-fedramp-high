###############################################################################
# Private DNS Zones — FedRAMP High
# NIST 800-53 Controls: SC-7  (Boundary Protection — private name resolution),
#                        SC-20 (Secure Name/Address Resolution — authoritative),
#                        SC-21 (Secure Name/Address Resolution — recursive)
###############################################################################

# SC-7, SC-20: Private DNS zones for all in-scope privatelink services
resource "azurerm_private_dns_zone" "zones" {
  for_each = local.all_dns_zones

  name                = each.value.zone_name
  resource_group_name = var.resource_group_name

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    environment          = var.environment
    service              = each.value.service
  })
}

# SC-21: Link each DNS zone to the hub VNet for recursive resolution
resource "azurerm_private_dns_zone_virtual_network_link" "hub_link" {
  for_each = local.all_dns_zones

  name                  = "vnetlink-${each.key}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.zones[each.key].name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    environment          = var.environment
  })
}
