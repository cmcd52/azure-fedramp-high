variable "location" {
  type        = string
  description = "Azure region for resource deployment. Must be a US region for FedRAMP High data residency."
  # NIST 800-53: N/A (operational), FedRAMP: data residency
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "purview_account_name" {
  type        = string
  description = "Name of the Azure Purview account."
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,62}[a-zA-Z0-9]$", var.purview_account_name))
    error_message = "Account name must be 2-64 characters, start with a letter, end with a letter or digit, and contain only alphanumerics and hyphens."
  }
}

variable "managed_resource_group_name" {
  type        = string
  description = "Name of the managed resource group for Purview managed storage and Event Hubs."
  default     = null
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
  description = "Subnet ID for account and portal Private Endpoint deployment."
  default     = null
  # NIST 800-53: SC-7 (Boundary Protection)
}

variable "ingestion_subnet_id" {
  type        = string
  description = "Subnet ID for ingestion Private Endpoint deployment. Can be the same as subnet_id or a separate subnet."
  default     = null
  # NIST 800-53: SC-7 (Boundary Protection)
}

variable "private_dns_zone_ids" {
  type        = map(string)
  description = <<-EOT
    Map of Private DNS Zone IDs for each Purview PE sub-resource.
    Required keys: "account" (privatelink.purview.azure.com),
                   "portal" (privatelink.purviewstudio.azure.com),
                   "ingestion" (privatelink.blob.core.windows.net).
  EOT
  default = {
    account   = null
    portal    = null
    ingestion = null
  }
  # NIST 800-53: SC-7
}
