variable "location" {
  type        = string
  description = "Azure region for resource deployment. Must be a US region for FedRAMP High."
  # NIST 800-53: N/A (operational), FedRAMP: data residency
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault."
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$", var.key_vault_name))
    error_message = "Key Vault name must be 3-24 characters, start with a letter, end with a letter or digit, and contain only alphanumerics and hyphens."
  }
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID for the Key Vault."
  # NIST 800-53: AC-3, IA-2
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the shared Log Analytics workspace for diagnostic settings."
  # NIST 800-53: AU-2, AU-12; OMB M-21-31 EL3
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
  description = "Private DNS Zone ID for Private Endpoint DNS registration (privatelink.vaultcore.azure.net)."
  default     = null
  # NIST 800-53: SC-7
}
