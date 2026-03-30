output "resource_id" {
  description = "The Azure Resource ID of the DNS Private Resolver."
  value       = azurerm_private_dns_resolver.this.id
}

output "resource_name" {
  description = "The name of the DNS Private Resolver."
  value       = azurerm_private_dns_resolver.this.name
}

output "private_endpoint_id" {
  description = "Not applicable — DNS Private Resolver does not use Private Endpoints. It is deployed directly in the VNet."
  value       = null
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "inbound_endpoint_id" {
  description = "The Resource ID of the inbound endpoint."
  value       = azurerm_private_dns_resolver_inbound_endpoint.this.id
}

output "inbound_endpoint_ip" {
  description = "The private IP address of the inbound endpoint. Use this as the DNS server IP for VNet DNS settings."
  value       = azurerm_private_dns_resolver_inbound_endpoint.this.ip_configurations[0].private_ip_address
}

output "outbound_endpoint_id" {
  description = "The Resource ID of the outbound endpoint."
  value       = azurerm_private_dns_resolver_outbound_endpoint.this.id
}

output "forwarding_ruleset_id" {
  description = "The Resource ID of the DNS forwarding ruleset."
  value       = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
}
