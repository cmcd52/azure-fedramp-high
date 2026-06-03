output "id" {
  value       = azurerm_mssql_database.this.id
  description = "Resource ID."
}

output "name" {
  value       = azurerm_mssql_database.this.name
  description = "Resource name."
}
