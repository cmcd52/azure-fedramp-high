variable "location" {
  type        = string
  description = "Azure region for resource deployment. Must be a US region for FedRAMP High."
  # NIST 800-53: N/A (operational), FedRAMP: data residency
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the shared Log Analytics workspace. Application Insights will be workspace-based and forward all telemetry here."
  # NIST 800-53: AU-3, AU-6, AU-12
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Must include: environment, compliance-framework, owner."
  default     = {}
}

# Required contract variables

variable "subnet_id" {
  type        = string
  description = "Not directly used — Application Insights is a platform service. Private Link via AMPLS is configured separately."
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "Not directly used — Application Insights Private Link is managed via Azure Monitor Private Link Scope."
  default     = null
}

variable "key_vault_key_id" {
  type        = string
  description = "Not directly used — Application Insights encryption is managed at the workspace level (CMK on Log Analytics cluster)."
  default     = null
}

# Service-specific variables

variable "application_insights_name" {
  type        = string
  description = "Name of the Application Insights component."
}

variable "sampling_percentage" {
  type        = number
  description = "Sampling percentage for telemetry collection. 100 = no sampling (all data collected). Lower values reduce volume and cost."
  default     = 100
  validation {
    condition     = var.sampling_percentage >= 0 && var.sampling_percentage <= 100
    error_message = "Sampling percentage must be between 0 and 100."
  }
}

variable "daily_data_cap_in_gb" {
  type        = number
  description = "Daily data volume cap in GB. Prevents unexpected cost spikes. Set to 0 for no cap (not recommended)."
  default     = 10
  validation {
    condition     = var.daily_data_cap_in_gb >= 0
    error_message = "Daily data cap must be >= 0."
  }
}

variable "retention_in_days" {
  type        = number
  description = "Data retention in days. For workspace-based App Insights, this is managed by the workspace retention. This value sets the component-level retention."
  default     = 90
  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "Retention must be between 30 and 730 days."
  }
}
