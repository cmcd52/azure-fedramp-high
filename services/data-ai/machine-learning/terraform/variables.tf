variable "name" {
  type        = string
  description = "Resource name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Central Log Analytics workspace resource ID for diagnostic forwarding."
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "Subnet ID for the Private Endpoint NIC."
}

variable "private_dns_zone_id" {
  type        = string
  default     = null
  description = "Private DNS zone ID for service-specific zone (e.g., privatelink.<service>.azure.com)."
}

variable "key_vault_key_id" {
  type        = string
  default     = null
  description = "Key Vault key ID for CMK encryption-at-rest. When null, service-managed keys apply."
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the Key Vault for ML workspace."
}

variable "storage_account_id" {
  type        = string
  description = "The ID of the Storage Account for ML workspace."
}

variable "application_insights_id" {
  type        = string
  description = "The ID of Application Insights for ML workspace."
}
