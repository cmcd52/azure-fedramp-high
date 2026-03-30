output "resource_id" {
  description = "The Azure Resource ID of the Azure AD B2C directory."
  value       = azurerm_aadb2c_directory.this.id
}

output "resource_name" {
  description = "The domain name of the Azure AD B2C directory."
  value       = azurerm_aadb2c_directory.this.domain_name
}

output "private_endpoint_id" {
  description = "The Resource ID of the Private Endpoint. Not supported for Azure AD B2C — always null."
  value       = null
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "tenant_id" {
  description = "The Tenant ID of the Azure AD B2C directory."
  value       = azurerm_aadb2c_directory.this.tenant_id
}
