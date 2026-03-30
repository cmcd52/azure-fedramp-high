variable "environment" {
  type        = string
  description = "Deployment environment."
}

variable "location" {
  type        = string
  description = "Azure region for resource deployment. Must be a US region for FedRAMP High."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account for Terraform state."
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage account name must be 3-24 lowercase alphanumeric characters."
  }
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the shared Log Analytics workspace for diagnostic settings."
  default     = null
  # NIST 800-53: AU-3, AU-6, AU-12
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
  description = "Private DNS Zone ID for Private Endpoint DNS registration."
  default     = null
  # NIST 800-53: SC-7
}

variable "key_vault_key_id" {
  type        = string
  description = "Key Vault key ID for customer-managed encryption. Null uses platform-managed keys."
  default     = null
  # NIST 800-53: SC-12, SC-13, SC-28; FIPS 140-2
}

variable "encryption_identity_id" {
  type        = string
  description = "User-assigned managed identity ID for CMK access to Key Vault."
  default     = null
  # NIST 800-53: IA-2, AC-3
}
