output "resource_id" {
  description = "The Azure Resource ID of the Azure Document Intelligence account."
  value       = azurerm_cognitive_account.this.id
}

output "resource_name" {
  description = "The name of the Azure Document Intelligence account."
  value       = azurerm_cognitive_account.this.name
}

output "endpoint" {
  description = "The endpoint URL for the Azure Document Intelligence account."
  value       = azurerm_cognitive_account.this.endpoint
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
  value       = azurerm_cognitive_account.this.identity[0].principal_id
}
