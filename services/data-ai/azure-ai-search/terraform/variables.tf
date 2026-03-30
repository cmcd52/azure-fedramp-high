variable "location" {
  type        = string
  description = "Azure region for resource deployment. Must be a US region for FedRAMP High data residency."
  # NIST 800-53: N/A (operational), FedRAMP: data residency
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "search_service_name" {
  type        = string
  description = "Name of the Azure AI Search service."
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,58}[a-z0-9]$", var.search_service_name))
    error_message = "Search service name must be 2-60 characters, lowercase letters, numbers, and hyphens only, starting with a letter."
  }
}

variable "sku" {
  type        = string
  description = "SKU for Azure AI Search. Standard or higher required for Private Endpoint support."
  default     = "standard"
  validation {
    condition     = contains(["standard", "standard2", "standard3", "storage_optimized_l1", "storage_optimized_l2"], var.sku)
    error_message = "SKU must be standard or higher for Private Endpoint support."
  }
}

variable "replica_count" {
  type        = number
  description = "Number of replicas. Minimum 2 for high availability SLA."
  default     = 1
}

variable "partition_count" {
  type        = number
  description = "Number of partitions for index storage scaling."
  default     = 1
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
  description = "Private DNS Zone ID for Private Endpoint DNS registration (privatelink.search.windows.net)."
  default     = null
  # NIST 800-53: SC-7
}

variable "key_vault_key_id" {
  type        = string
  description = "Key Vault key ID for customer-managed index encryption. If null, platform-managed keys used."
  default     = null
  # NIST 800-53: SC-13, SC-28
}
