output "resource_id" {
  description = "Resource ID of the hub virtual network."
  value       = azurerm_virtual_network.hub.id
}

output "resource_name" {
  description = "Name of the hub virtual network."
  value       = azurerm_virtual_network.hub.name
}

output "private_endpoint_subnet_id" {
  description = "Resource ID of the Private Endpoints subnet (snet-private-endpoints)."
  value       = azurerm_subnet.private_endpoints.id
}

output "bastion_subnet_id" {
  description = "Resource ID of the Bastion subnet (AzureBastionSubnet)."
  value       = azurerm_subnet.bastion.id
}

output "dns_subnet_id" {
  description = "Resource ID of the DNS subnet (snet-dns)."
  value       = azurerm_subnet.dns.id
}

output "private_endpoint_id" {
  description = "Private endpoint ID — null for the VNet module itself."
  value       = null
}

output "diagnostic_setting_id" {
  description = "Diagnostic setting IDs for all NSGs."
  value = {
    private_endpoints = azurerm_monitor_diagnostic_setting.nsg_private_endpoints.id
    bastion           = azurerm_monitor_diagnostic_setting.nsg_bastion.id
    dns               = azurerm_monitor_diagnostic_setting.nsg_dns.id
  }
}
