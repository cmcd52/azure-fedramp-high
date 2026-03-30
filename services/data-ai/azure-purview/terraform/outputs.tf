output "resource_id" {
  description = "The Azure Resource ID of the Azure Purview account."
  value       = azurerm_purview_account.this.id
}

output "resource_name" {
  description = "The name of the Azure Purview account."
  value       = azurerm_purview_account.this.name
}

output "atlas_kafka_endpoint_primary_connection_string" {
  description = "The primary connection string for the Atlas Kafka endpoint."
  value       = azurerm_purview_account.this.atlas_kafka_endpoint_primary_connection_string
  sensitive   = true
}

output "scan_endpoint" {
  description = "The scan endpoint URL for the Purview account."
  value       = azurerm_purview_account.this.scan_endpoint
}

output "catalog_endpoint" {
  description = "The catalog endpoint URL for the Purview account."
  value       = azurerm_purview_account.this.catalog_endpoint
}

output "private_endpoint_account_id" {
  description = "The Resource ID of the account Private Endpoint (null if not deployed)."
  value       = try(azurerm_private_endpoint.account[0].id, null)
}

output "private_endpoint_portal_id" {
  description = "The Resource ID of the portal Private Endpoint (null if not deployed)."
  value       = try(azurerm_private_endpoint.portal[0].id, null)
}

output "private_endpoint_ingestion_id" {
  description = "The Resource ID of the ingestion Private Endpoint (null if not deployed)."
  value       = try(azurerm_private_endpoint.ingestion[0].id, null)
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "principal_id" {
  description = "The principal ID of the system-assigned managed identity."
  value       = azurerm_purview_account.this.identity[0].principal_id
}
