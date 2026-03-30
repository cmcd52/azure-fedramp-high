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
  # NIST 800-53: AU-3, AU-6, AU-12; OMB M-21-31 EL2
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
  description = "Not directly used — Functions use platform-managed encryption at rest. Retained for contract compliance."
  default     = null
}

# Service-specific variables

variable "function_plan_name" {
  type        = string
  description = "Name of the App Service Plan for the Function App."
}

variable "function_app_name" {
  type        = string
  description = "Name of the Linux Function App."
}

variable "sku_name" {
  type        = string
  description = "App Service Plan SKU. Premium tier required for Private Endpoint support."
  default     = "EP1"
  # SC-7: Premium/Elastic Premium required for PE support
}

variable "storage_account_name" {
  type        = string
  description = "Name of the Storage Account linked to the Function App for runtime (triggers, bindings, code). Must be secured with PE and HTTPS-only."
  # NIST 800-53: SC-28
}

variable "storage_account_access_key" {
  type        = string
  description = "Access key for the linked Storage Account. Consider using managed identity-based access in future."
  sensitive   = true
  # NIST 800-53: SC-28, IA-5
}

variable "dotnet_version" {
  type        = string
  description = ".NET version for the Function App runtime."
  default     = "8.0"
}

variable "app_settings" {
  type        = map(string)
  description = "Application settings. Do not store secrets here — use Key Vault references."
  default     = {}
  sensitive   = true
  # NIST 800-53: SC-28
}
