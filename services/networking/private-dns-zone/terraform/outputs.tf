output "resource_id" {
  description = "The Azure Resource ID of the Private DNS Zone."
  value       = azurerm_private_dns_zone.this.id
}

output "resource_name" {
  description = "The name of the Private DNS Zone."
  value       = azurerm_private_dns_zone.this.name
}

output "private_endpoint_id" {
  description = "Not applicable — Private DNS Zones do not use Private Endpoints."
  value       = null
}

output "diagnostic_setting_id" {
  description = "Not applicable — Private DNS Zones have limited native diagnostic settings. Query logging is via DNS Private Resolver integration."
  value       = null
}

output "zone_id" {
  description = "The Azure Resource ID of the Private DNS Zone. Use this when configuring DNS zone groups on Private Endpoints."
  value       = azurerm_private_dns_zone.this.id
}

output "hub_vnet_link_id" {
  description = "The Resource ID of the hub VNet link."
  value       = azurerm_private_dns_zone_virtual_network_link.hub.id
}
