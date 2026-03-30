output "resource_id" {
  description = "The Azure Resource ID of the Linux Function App."
  value       = azurerm_linux_function_app.this.id
}

output "resource_name" {
  description = "The name of the Linux Function App."
  value       = azurerm_linux_function_app.this.name
}

output "private_endpoint_id" {
  description = "The Resource ID of the Private Endpoint (null if subnet_id not provided)."
  value       = length(azurerm_private_endpoint.this) > 0 ? azurerm_private_endpoint.this[0].id : null
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "function_plan_id" {
  description = "The Azure Resource ID of the App Service Plan."
  value       = azurerm_service_plan.this.id
}

output "default_hostname" {
  description = "The default hostname of the Function App."
  value       = azurerm_linux_function_app.this.default_hostname
}

output "system_assigned_identity_principal_id" {
  description = "The principal ID of the Function App's system-assigned managed identity."
  value       = azurerm_linux_function_app.this.identity[0].principal_id
}
