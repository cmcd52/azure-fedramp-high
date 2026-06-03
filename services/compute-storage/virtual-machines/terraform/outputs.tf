output "id" {
  value       = azurerm_linux_virtual_machine.this.id
  description = "Resource ID."
}

output "name" {
  value       = azurerm_linux_virtual_machine.this.name
  description = "Resource name."
}
