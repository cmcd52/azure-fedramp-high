output "resource_id" {
  description = "The Azure Resource ID of the Windows VM."
  value       = azurerm_windows_virtual_machine.this.id
}

output "resource_name" {
  description = "The name of the Windows VM."
  value       = azurerm_windows_virtual_machine.this.name
}

output "private_endpoint_id" {
  description = "Not applicable — VMs do not use Private Endpoints. VM is accessed via private NIC + Bastion."
  value       = null
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the NIC diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.nic.id
}

output "private_ip_address" {
  description = "The private IP address of the VM network interface."
  value       = azurerm_network_interface.this.private_ip_address
}

output "network_interface_id" {
  description = "The Resource ID of the VM network interface."
  value       = azurerm_network_interface.this.id
}

output "system_assigned_identity_principal_id" {
  description = "The principal ID of the VM's system-assigned managed identity."
  value       = azurerm_windows_virtual_machine.this.identity[0].principal_id
}

output "data_collection_rule_id" {
  description = "The Resource ID of the data collection rule for VM log ingestion."
  value       = azurerm_monitor_data_collection_rule.this.id
}
