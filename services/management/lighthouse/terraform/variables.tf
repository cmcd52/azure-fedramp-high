variable "name" {
  type        = string
  description = "Resource name."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Central Log Analytics workspace resource ID for diagnostic forwarding."
}

variable "managing_tenant_id" {
  type        = string
  description = "The managing tenant ID."
}

variable "scope" {
  type        = string
  description = "The scope (subscription ID)."
}
