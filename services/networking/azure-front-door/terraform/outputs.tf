output "resource_id" {
  description = "The Azure Resource ID of the Front Door profile."
  value       = azurerm_cdn_frontdoor_profile.this.id
}

output "resource_name" {
  description = "The name of the Front Door profile."
  value       = azurerm_cdn_frontdoor_profile.this.name
}

output "private_endpoint_id" {
  description = "Not applicable at the Front Door level. Private Link to origin is configured per-origin. See origin resource for Private Link status."
  value       = null
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "endpoint_fqdn" {
  description = "The FQDN of the Front Door endpoint."
  value       = azurerm_cdn_frontdoor_endpoint.this.host_name
}

output "waf_policy_id" {
  description = "The Resource ID of the WAF policy."
  value       = azurerm_cdn_frontdoor_firewall_policy.this.id
}

output "profile_resource_guid" {
  description = "The UUID of the Front Door profile."
  value       = azurerm_cdn_frontdoor_profile.this.resource_guid
}
