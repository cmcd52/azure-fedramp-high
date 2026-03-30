output "resource_id" {
  description = "The Azure Resource ID of the ExpressRoute circuit."
  value       = azurerm_express_route_circuit.this.id
}

output "resource_name" {
  description = "The name of the ExpressRoute circuit."
  value       = azurerm_express_route_circuit.this.name
}

output "private_endpoint_id" {
  description = "Not applicable for ExpressRoute — ExpressRoute IS the private connectivity. Always null."
  value       = null
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "service_key" {
  description = "The service key of the ExpressRoute circuit (used for provider provisioning)."
  value       = azurerm_express_route_circuit.this.service_key
  sensitive   = true
}

output "service_provider_provisioning_state" {
  description = "The provisioning state of the ExpressRoute circuit with the service provider."
  value       = azurerm_express_route_circuit.this.service_provider_provisioning_state
}
