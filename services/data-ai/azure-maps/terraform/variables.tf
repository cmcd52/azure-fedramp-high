variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "location" {
  type        = string
  description = "Azure region for resource deployment."
}

variable "maps_account_name" {
  type        = string
  description = "Name of the Azure Maps account."
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,62}[a-zA-Z0-9]$", var.maps_account_name))
    error_message = "Account name must be 2-64 characters, start with a letter, end with a letter or digit, and contain only alphanumerics and hyphens."
  }
}

variable "sku_name" {
  type        = string
  description = "SKU for Azure Maps. S1 required for production workloads."
  default     = "S1"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the shared Log Analytics workspace for diagnostic settings."
  # NIST 800-53: AU-3, AU-6, AU-12; OMB M-21-31 EL1
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Must include: environment, compliance-framework, owner."
  default     = {}
}

variable "cors_allowed_origins" {
  type        = list(string)
  description = "List of allowed CORS origins for Azure Maps. Must be restricted to authorized application domains."
  default     = []
  # NIST 800-53: AC-4 (Information Flow Enforcement)
}
