output "resource_id" {
  description = "The Azure Resource ID of the AI Search service."
  value       = azurerm_search_service.this.id
}

output "resource_name" {
  description = "The name of the AI Search service."
  value       = azurerm_search_service.this.name
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
  value       = azurerm_search_service.this.identity[0].principal_id
}

output "query_endpoint" {
  description = "The search service endpoint URL (https://{name}.search.windows.net)."
  value       = "https://${azurerm_search_service.this.name}.search.windows.net"
}
