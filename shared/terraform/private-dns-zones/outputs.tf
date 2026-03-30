output "zone_ids" {
  description = "Map of DNS zone short name → resource ID."
  value = {
    for key, zone in azurerm_private_dns_zone.zones : key => zone.id
  }
}

output "resource_id" {
  description = "null — module deploys multiple resources."
  value       = null
}

output "resource_name" {
  description = "null — module deploys multiple resources."
  value       = null
}

output "private_endpoint_id" {
  description = "null — no private endpoint for DNS zones."
  value       = null
}

output "diagnostic_setting_id" {
  description = "null — DNS zones do not have diagnostic settings."
  value       = null
}
