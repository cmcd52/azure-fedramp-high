output "resource_id" {
  description = "The Azure Resource ID of the Event Hubs namespace."
  value       = azurerm_eventhub_namespace.this.id
}

output "resource_name" {
  description = "The name of the Event Hubs namespace."
  value       = azurerm_eventhub_namespace.this.name
}

output "default_primary_connection_string" {
  description = "The primary connection string for the Event Hubs namespace (available when local auth enabled)."
  value       = azurerm_eventhub_namespace.this.default_primary_connection_string
  sensitive   = true
}

output "private_endpoint_id" {
  description = "The Resource ID of the Private Endpoint (null if not deployed)."
  value       = try(azurerm_private_endpoint.this[0].id, null)
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "principal_id" {
  description = "The principal ID of the system-assigned managed identity."
  value       = azurerm_eventhub_namespace.this.identity[0].principal_id
}
