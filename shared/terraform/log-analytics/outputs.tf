output "resource_id" {
  description = "The Azure Resource ID of the Log Analytics workspace. Consumed by all other modules as log_analytics_workspace_id."
  value       = azurerm_log_analytics_workspace.this.id
}

output "resource_name" {
  description = "The name of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.name
}

output "private_endpoint_id" {
  description = "The Resource ID of the AMPLS Private Endpoint (null if not deployed)."
  value       = try(azurerm_private_endpoint.log_analytics[0].id, null)
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting (null — workspace cannot self-monitor)."
  value       = null
}

output "workspace_id" {
  description = "The GUID workspace_id of the Log Analytics workspace (used for agent configuration)."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "primary_shared_key" {
  description = "The primary shared key of the Log Analytics workspace (for agent configuration only)."
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}
