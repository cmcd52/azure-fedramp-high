output "id" {
  value       = azurerm_kubernetes_cluster.this.id
  description = "Resource ID."
}

output "name" {
  value       = azurerm_kubernetes_cluster.this.name
  description = "Resource name."
}
