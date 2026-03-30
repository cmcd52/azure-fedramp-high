output "resource_id" {
  description = "The Azure Resource ID of the Bastion host."
  value       = azurerm_bastion_host.this.id
}

output "resource_name" {
  description = "The name of the Bastion host."
  value       = azurerm_bastion_host.this.name
}

output "private_endpoint_id" {
  description = "Not applicable for Bastion. Bastion requires a public IP (approved exception). Always null."
  value       = null
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "public_ip_id" {
  description = "The Resource ID of the Bastion public IP address."
  value       = azurerm_public_ip.this.id
}

output "nsg_id" {
  description = "The Resource ID of the NSG on AzureBastionSubnet."
  value       = azurerm_network_security_group.bastion.id
}

output "dns_name" {
  description = "The DNS name of the Bastion host."
  value       = azurerm_bastion_host.this.dns_name
}
