output "resource_id" {
  description = "The Azure Resource ID of the Azure Maps account."
  value       = azurerm_maps_account.this.id
}

output "resource_name" {
  description = "The name of the Azure Maps account."
  value       = azurerm_maps_account.this.name
}

output "x_ms_client_id" {
  description = "The unique client ID for the Azure Maps account (used for managed identity auth)."
  value       = azurerm_maps_account.this.x_ms_client_id
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "principal_id" {
  description = "The principal ID of the system-assigned managed identity."
  value       = azurerm_maps_account.this.identity[0].principal_id
}
