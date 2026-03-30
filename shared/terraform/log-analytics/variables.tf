variable "location" {
  type        = string
  description = "Azure region for resource deployment. Must be a US region for FedRAMP High."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "workspace_name" {
  type        = string
  description = "Name of the Log Analytics workspace."
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{2,62}$", var.workspace_name))
    error_message = "Workspace name must be 3-63 characters: alphanumeric and hyphens, starting with alphanumeric."
  }
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Must include: environment, compliance-framework, owner."
  default     = {}
}

variable "key_vault_key_id" {
  type        = string
  description = "Key Vault key ID for customer-managed encryption. Null uses platform-managed keys."
  default     = null
  # NIST 800-53: SC-12, SC-13, SC-28; FIPS 140-2
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for AMPLS Private Endpoint deployment."
  default     = null
  # NIST 800-53: SC-7 (Boundary Protection)
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone ID for AMPLS Private Endpoint DNS registration."
  default     = null
  # NIST 800-53: SC-7
}
