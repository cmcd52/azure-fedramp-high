variable "location" {
  type        = string
  description = "Azure region. Private DNS Zones are global resources but this is used for tagging and regional consistency."
  # NIST 800-53: N/A (operational), FedRAMP: data residency
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the shared Log Analytics workspace. Private DNS Zones have limited native diagnostics — query logging is via DNS Private Resolver."
  default     = null
  # NIST 800-53: AU-2, AU-3, AU-12
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Must include: environment, compliance-framework, owner."
  default     = {}
}

# Optional contract variables

variable "subnet_id" {
  type        = string
  description = "Not directly used — Private DNS Zones are VNet-linked, not subnet-scoped."
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "Not applicable — this module creates the Private DNS Zone."
  default     = null
}

variable "key_vault_key_id" {
  type        = string
  description = "Not applicable — Private DNS Zones do not support customer-managed encryption keys."
  default     = null
}

# Service-specific variables

variable "zone_name" {
  type        = string
  description = "Name of the Private DNS Zone (e.g., 'privatelink.blob.core.windows.net', 'contoso.internal')."
  # NIST 800-53: SC-20 — Authoritative DNS zone for internal resolution
}

variable "virtual_network_id" {
  type        = string
  description = "Resource ID of the hub virtual network to link to the Private DNS Zone."
  # NIST 800-53: SC-7 — VNet link ensures zone resolves within trusted boundary
}

variable "auto_registration_enabled" {
  type        = bool
  description = "Enable auto-registration of VM DNS records in the zone. Only applicable for non-privatelink zones."
  default     = false
}

variable "additional_vnet_links" {
  type = list(object({
    name               = string
    virtual_network_id = string
  }))
  description = "Additional VNet links (e.g., spoke VNets) to associate with the Private DNS Zone."
  default     = []
  # NIST 800-53: SC-7 — Extend DNS resolution to spoke VNets
}
