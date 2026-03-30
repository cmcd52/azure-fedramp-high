output "resource_id" {
  description = "The Azure Resource ID of the Key Vault."
  value       = azurerm_key_vault.this.id
}

output "resource_name" {
  description = "The name of the Key Vault."
  value       = azurerm_key_vault.this.name
}

output "private_endpoint_id" {
  description = "The Resource ID of the Private Endpoint (null if not deployed)."
  value       = try(azurerm_private_endpoint.this[0].id, null)
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "vault_uri" {
  description = "The URI of the Key Vault for use by other modules."
  value       = azurerm_key_vault.this.vault_uri
}
