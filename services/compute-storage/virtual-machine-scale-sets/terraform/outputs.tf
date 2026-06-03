output "id" {
  value       = azurerm_linux_virtual_machine_scale_set.this.id
  description = "Resource ID."
}

output "name" {
  value       = azurerm_linux_virtual_machine_scale_set.this.name
  description = "Resource name."
}
