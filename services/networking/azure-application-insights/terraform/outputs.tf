output "resource_id" {
  description = "The Azure Resource ID of the Application Insights component."
  value       = azurerm_application_insights.this.id
}

output "resource_name" {
  description = "The name of the Application Insights component."
  value       = azurerm_application_insights.this.name
}

output "private_endpoint_id" {
  description = "Not applicable — Application Insights uses Azure Monitor Private Link Scope (AMPLS) for private connectivity."
  value       = null
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the Application Insights diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "instrumentation_key" {
  description = "The instrumentation key for the Application Insights component. Use connection string instead where possible."
  value       = azurerm_application_insights.this.instrumentation_key
  sensitive   = true
}

output "connection_string" {
  description = "The connection string for the Application Insights component. Preferred over instrumentation key."
  value       = azurerm_application_insights.this.connection_string
  sensitive   = true
}

output "app_id" {
  description = "The App ID of the Application Insights component."
  value       = azurerm_application_insights.this.app_id
}
