variable "location" {
  type        = string
  description = "Azure region for Private Link origin connections. Front Door is a global service but Private Link requires a region."
  # NIST 800-53: N/A (operational), FedRAMP: data residency
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the shared Log Analytics workspace for diagnostic settings."
  # NIST 800-53: AU-2, AU-3, AU-12; OMB M-21-31 EL3
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Must include: environment, compliance-framework, owner."
  default     = {}
}

# Optional contract variables

variable "subnet_id" {
  type        = string
  description = "Not directly used by Front Door. Front Door is a global edge service. Private Link to origins is configured separately."
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS zone ID for Private Link to origin DNS resolution. Optional."
  default     = null
}

variable "key_vault_key_id" {
  type        = string
  description = "Key Vault key ID for customer-managed certificate on custom domains. Optional."
  default     = null
}

# Service-specific variables

variable "profile_name" {
  type        = string
  description = "Name of the Azure Front Door profile."
}

variable "waf_policy_name" {
  type        = string
  description = "Name of the WAF policy associated with Front Door."
}

variable "endpoint_name" {
  type        = string
  description = "Name of the Front Door endpoint."
}

variable "origin_host_name" {
  type        = string
  description = "FQDN of the origin (backend) server. Must support HTTPS."
  # NIST 800-53: SC-8 — HTTPS-only origin connection
}

variable "health_probe_path" {
  type        = string
  description = "Path for origin health probe."
  default     = "/"
}

variable "origin_private_link_resource_id" {
  type        = string
  description = "Resource ID of the origin for Private Link connection. Null disables Private Link to origin."
  default     = null
  # NIST 800-53: SC-7 — Private connectivity to origin
}

variable "origin_private_link_target_type" {
  type        = string
  description = "Target type for Private Link to origin (e.g., 'sites' for App Service, 'blob' for Storage)."
  default     = null
}
