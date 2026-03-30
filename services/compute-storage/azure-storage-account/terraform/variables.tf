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
  description = "Private DNS Zone ID for Private Endpoint DNS registration (privatelink.blob.core.windows.net)."
  default     = null
  # NIST 800-53: SC-7
}

variable "key_vault_key_id" {
  type        = string
  description = "Key Vault key ID for customer-managed encryption. If null, platform-managed keys are used."
  default     = null
  # NIST 800-53: SC-12, SC-13, SC-28; FIPS 140-2
}

# Service-specific variables

variable "storage_account_name" {
  type        = string
  description = "Name of the Storage Account. Must be 3-24 characters, lowercase letters and numbers only."
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage Account name must be 3-24 characters, lowercase letters and numbers only."
  }
}

variable "account_tier" {
  type        = string
  description = "Storage Account tier."
  default     = "Standard"
}

variable "account_replication" {
  type        = string
  description = "Storage Account replication type. GRS recommended for production."
  default     = "GRS"
}

variable "cmk_identity_id" {
  type        = string
  description = "User-assigned managed identity resource ID for CMK access to Key Vault. Required when key_vault_key_id is set."
  default     = null
  # NIST 800-53: SC-12, IA-2
}
