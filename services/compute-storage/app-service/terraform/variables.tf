variable "location" {
  type        = string
  description = "Azure region for resource deployment. Must be a US region for FedRAMP High."
  # NIST 800-53: N/A (operational), FedRAMP: data residency
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the shared Log Analytics workspace for diagnostic settings."
  # NIST 800-53: AU-3, AU-6, AU-12; OMB M-21-31 EL2/EL3
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Must include: environment, compliance-framework, owner."
  default     = {}
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for Private Endpoint deployment."
  default     = null
  # NIST 800-53: SC-7 (Boundary Protection)
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone ID for Private Endpoint DNS registration (privatelink.azurewebsites.net)."
  default     = null
  # NIST 800-53: SC-7
}

variable "key_vault_key_id" {
  type        = string
  description = "Not directly used — App Service uses platform-managed encryption at rest. Retained for contract compliance."
  default     = null
}

# Service-specific variables

variable "app_service_plan_name" {
  type        = string
  description = "Name of the App Service Plan."
}

variable "app_name" {
  type        = string
  description = "Name of the Linux Web App."
}

variable "sku_name" {
  type        = string
  description = "App Service Plan SKU. Premium tier required for Private Endpoint and VNet integration."
  default     = "P1v3"
  # SC-7: Premium tier required for PE support
}

variable "vnet_integration_subnet_id" {
  type        = string
  description = "Subnet ID for VNet integration (outbound traffic). Separate from PE subnet."
  default     = null
  # NIST 800-53: SC-7 (Boundary Protection)
}

variable "app_settings" {
  type        = map(string)
  description = "Application settings. Do not store secrets here — use Key Vault references."
  default     = {}
  sensitive   = true
  # NIST 800-53: SC-28
}
