output "resource_id" {
  description = "The Azure Resource ID of the Private Endpoint."
  value       = azurerm_private_endpoint.this.id
}

output "resource_name" {
  description = "The name of the Private Endpoint."
  value       = azurerm_private_endpoint.this.name
}

output "private_endpoint_id" {
  description = "The Azure Resource ID of the Private Endpoint (same as resource_id for this module)."
  value       = azurerm_private_endpoint.this.id
}

output "diagnostic_setting_id" {
  description = "Not applicable — PE connection state diagnostics are logged via the parent resource. No separate diagnostic setting on the PE itself."
  value       = null
}

output "private_ip_address" {
  description = "The private IP address assigned to the Private Endpoint network interface."
  value       = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}

output "network_interface_id" {
  description = "The Resource ID of the Private Endpoint's network interface."
  value       = azurerm_private_endpoint.this.network_interface[0].id
}

output "private_dns_zone_group_id" {
  description = "The Resource ID of the DNS zone group."
  value       = azurerm_private_endpoint.this.private_dns_zone_group[0].id
}
