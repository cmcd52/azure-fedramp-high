variable "location" {
  type        = string
  description = "Azure region for resource deployment. Must be a US region for FedRAMP High data residency."
  # NIST 800-53: N/A (operational), FedRAMP: data residency
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "hub_name" {
  type        = string
  description = "Name of the Azure AI Foundry Hub (Machine Learning workspace, kind: Hub)."
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,30}[a-zA-Z0-9]$", var.hub_name))
    error_message = "Hub name must be 2-32 characters, start with a letter, end with a letter or digit, and contain only alphanumerics and hyphens."
  }
}

variable "project_name" {
  type        = string
  description = "Name of the Azure AI Foundry Project (child workspace of Hub)."
  default     = ""
  validation {
    condition     = var.project_name == "" || can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,30}[a-zA-Z0-9]$", var.project_name))
    error_message = "Project name must be 2-32 characters, start with a letter, end with a letter or digit, and contain only alphanumerics and hyphens."
  }
}

variable "deploy_project" {
  type        = bool
  description = "Whether to deploy an AI Foundry Project under the Hub."
  default     = true
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the shared Log Analytics workspace for diagnostic settings."
  # NIST 800-53: AU-3, AU-6, AU-12; OMB M-21-31 EL2
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
  description = "Private DNS Zone ID for Private Endpoint DNS registration (privatelink.api.azureml.ms)."
  default     = null
  # NIST 800-53: SC-7
}

variable "key_vault_id" {
  type        = string
  description = "Resource ID of the associated Key Vault for secrets and CMK."
  # NIST 800-53: SC-13, SC-28
}

variable "storage_account_id" {
  type        = string
  description = "Resource ID of the associated Storage Account for workspace data."
  # NIST 800-53: SC-28
}

variable "application_insights_id" {
  type        = string
  description = "Resource ID of the associated Application Insights for telemetry."
}

variable "container_registry_id" {
  type        = string
  description = "Resource ID of the associated Container Registry for model images."
  default     = null
}

variable "key_vault_key_id" {
  type        = string
  description = "Key Vault key ID for customer-managed encryption. If null, platform-managed keys used."
  default     = null
  # NIST 800-53: SC-13, SC-28
}

variable "cmk_identity_id" {
  type        = string
  description = "User-assigned managed identity ID for CMK access. Required when key_vault_key_id is set."
  default     = null
}
