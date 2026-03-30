variable "location" {
  type        = string
  description = "Azure region for resource deployment. Must be a US region for FedRAMP High data residency."
  # NIST 800-53: N/A (operational), FedRAMP: data residency
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "speech_account_name" {
  type        = string
  description = "Name of the Azure AI Speech Service (Cognitive Services) account."
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,62}[a-zA-Z0-9]$", var.speech_account_name))
    error_message = "Account name must be 2-64 characters, start with a letter, end with a letter or digit, and contain only alphanumerics and hyphens."
  }
}

variable "sku_name" {
  type        = string
  description = "SKU for the AI Speech Service account."
  default     = "S0"
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
  description = "Private DNS Zone ID for Private Endpoint DNS registration (privatelink.cognitiveservices.azure.com)."
  default     = null
  # NIST 800-53: SC-7
}

variable "key_vault_key_id" {
  type        = string
  description = "Key Vault key ID for customer-managed encryption. If null, platform-managed keys used."
  default     = null
  # NIST 800-53: SC-13, SC-28
}
