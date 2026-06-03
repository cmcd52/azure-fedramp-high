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

variable "tenant_id" {
  type        = string
  description = "The Azure AD tenant ID."
}

variable "ledger_admin_principal_id" {
  type        = string
  description = "The principal ID for ledger administrator."
}
