output "hub_resource_id" {
  description = "The Azure Resource ID of the AI Foundry Hub."
  value       = azurerm_machine_learning_workspace.hub.id
}

output "hub_resource_name" {
  description = "The name of the AI Foundry Hub."
  value       = azurerm_machine_learning_workspace.hub.name
}

output "hub_principal_id" {
  description = "The principal ID of the Hub system-assigned managed identity."
  value       = azurerm_machine_learning_workspace.hub.identity[0].principal_id
}

output "private_endpoint_id" {
  description = "The Resource ID of the Hub Private Endpoint (null if not deployed)."
  value       = try(azurerm_private_endpoint.hub[0].id, null)
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the Hub diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.hub.id
}
