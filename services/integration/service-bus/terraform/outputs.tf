output "id" {
  value       = azurerm_servicebus_namespace.this.id
  description = "Resource ID."
}

output "name" {
  value       = azurerm_servicebus_namespace.this.name
  description = "Resource name."
}
