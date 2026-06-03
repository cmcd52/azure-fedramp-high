output "id" {
  value       = azurerm_managed_disk.this.id
  description = "Resource ID."
}

output "name" {
  value       = azurerm_managed_disk.this.name
  description = "Resource name."
}
