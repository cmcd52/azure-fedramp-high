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
  description = "Resource ID of the shared Log Analytics workspace. Used for diagnostic settings and data export source."
  # NIST 800-53: AU-2, AU-3, AU-6, AU-11, AU-12
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Must include: environment, compliance-framework, owner."
  default     = {}
}

# Required contract variables

variable "subnet_id" {
  type        = string
  description = "Not directly used — Azure Monitor is a platform service without VNet injection. Included for contract compliance."
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "Not directly used — Azure Monitor uses platform-managed endpoints. Private Link for Azure Monitor is configured separately."
  default     = null
}

variable "key_vault_key_id" {
  type        = string
  description = "Not directly used — CMK encryption is configured at the Log Analytics cluster level in shared/terraform/log-analytics/."
  default     = null
}

# Service-specific variables

variable "subscription_id" {
  type        = string
  description = "The full resource ID of the subscription to scope activity log alerts (e.g., /subscriptions/xxxx)."
  # NIST 800-53: AU-2, AU-6
}

variable "action_group_name" {
  type        = string
  description = "Name of the Azure Monitor action group for alerting."
}

variable "action_group_short_name" {
  type        = string
  description = "Short name for the action group (max 12 characters)."
  validation {
    condition     = length(var.action_group_short_name) <= 12
    error_message = "Action group short name must be 12 characters or less."
  }
}

variable "email_receivers" {
  type = list(object({
    name          = string
    email_address = string
  }))
  description = "List of email receivers for the action group. At minimum, include SOC and security team."
  default     = []
}

variable "sms_receivers" {
  type = list(object({
    name         = string
    country_code = string
    phone_number = string
  }))
  description = "List of SMS receivers for critical alerts."
  default     = []
}

variable "alert_name_prefix" {
  type        = string
  description = "Prefix for activity log alert names."
  default     = "fedramp-high"
}

variable "data_export_rule_name" {
  type        = string
  description = "Name of the Log Analytics data export rule for long-term archive."
}

variable "archive_storage_account_id" {
  type        = string
  description = "Resource ID of the storage account for log archive. Must have 18-month minimum retention configured."
  # NIST 800-53: AU-11 (Audit Record Retention)
}

variable "export_table_names" {
  type        = list(string)
  description = "List of Log Analytics table names to export to storage for long-term archive."
  default = [
    "SecurityEvent",
    "AzureActivity",
    "SigninLogs",
    "AuditLogs",
    "Syslog",
    "Heartbeat"
  ]
}
