variable "location" {
  type        = string
  description = "Azure region for Bastion host. Must be a US region for FedRAMP High."
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

# Required contract variable

variable "subnet_id" {
  type        = string
  description = "Resource ID of the AzureBastionSubnet. This MUST be a subnet named 'AzureBastionSubnet' — Azure Bastion requires this exact name."
  # NIST 800-53: SC-7 — Bastion deployed in dedicated subnet
}

# Optional contract variables

variable "private_dns_zone_id" {
  type        = string
  description = "Not used by Bastion. Bastion uses its own DNS resolution."
  default     = null
}

variable "key_vault_key_id" {
  type        = string
  description = "Not used by Bastion. Bastion does not support customer-managed encryption keys."
  default     = null
}

# Service-specific variables

variable "bastion_name" {
  type        = string
  description = "Name of the Azure Bastion host."
}
