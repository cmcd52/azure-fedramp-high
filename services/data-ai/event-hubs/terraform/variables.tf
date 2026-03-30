variable "location" {
  type        = string
  description = "Azure region for resource deployment. Must be a US region for FedRAMP High data residency."
  # NIST 800-53: N/A (operational), FedRAMP: data residency
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "namespace_name" {
  type        = string
  description = "Name of the Azure Event Hubs namespace."
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{4,48}[a-zA-Z0-9]$", var.namespace_name))
    error_message = "Namespace name must be 6-50 characters, start with a letter, end with a letter or digit, and contain only alphanumerics and hyphens."
  }
}

variable "sku" {
  type        = string
  description = "SKU for the Event Hubs namespace. Premium or Dedicated required for PE, CMK, and zone redundancy."
  default     = "Premium"
  validation {
    condition     = contains(["Premium", "Dedicated"], var.sku)
    error_message = "SKU must be 'Premium' or 'Dedicated' for FedRAMP High compliance (PE + CMK + zone redundancy)."
  }
}

variable "capacity" {
  type        = number
  description = "Processing units for the Event Hubs namespace (Premium tier)."
  default     = 1
}

variable "auto_inflate_enabled" {
  type        = bool
  description = "Enable auto-inflate for automatic scaling of throughput units."
  default     = true
}

variable "maximum_throughput_units" {
  type        = number
  description = "Maximum throughput units when auto-inflate is enabled."
  default     = 4
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
  description = "Private DNS Zone ID for Private Endpoint DNS registration (privatelink.servicebus.windows.net)."
  default     = null
  # NIST 800-53: SC-7
}

variable "key_vault_key_ids" {
  type        = list(string)
  description = "Key Vault key IDs for customer-managed encryption. If null, platform-managed keys used."
  default     = null
  # NIST 800-53: SC-13, SC-28
}
