output "resource_id" {
  description = "The Azure Resource ID of the Storage Account."
  value       = azurerm_storage_account.this.id
}

output "resource_name" {
  description = "The name of the Storage Account."
  value       = azurerm_storage_account.this.name
}

output "private_endpoint_id" {
  description = "The Resource ID of the blob Private Endpoint (null if subnet_id not provided)."
  value       = length(azurerm_private_endpoint.blob) > 0 ? azurerm_private_endpoint.blob[0].id : null
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the Storage Account diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.storage.id
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint URL."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_access_key" {
  description = "The primary access key (sensitive). Only available when shared key access is enabled."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}
