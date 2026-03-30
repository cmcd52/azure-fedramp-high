output "resource_id" {
  description = "The Azure Resource ID of the state backend storage account."
  value       = azurerm_storage_account.tfstate.id
}

output "resource_name" {
  description = "The name of the state backend storage account."
  value       = azurerm_storage_account.tfstate.name
}

output "private_endpoint_id" {
  description = "The Resource ID of the Private Endpoint (null if not deployed)."
  value       = try(azurerm_private_endpoint.tfstate[0].id, null)
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting (null if not deployed)."
  value       = try(azurerm_monitor_diagnostic_setting.tfstate[0].id, null)
}

output "container_name" {
  description = "The name of the state container."
  value       = azurerm_storage_container.tfstate.name
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint for the storage account."
  value       = azurerm_storage_account.tfstate.primary_blob_endpoint
}
