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
  description = "Resource ID of the shared Log Analytics workspace for diagnostic settings and data collection rules."
  # NIST 800-53: AU-2, AU-3, AU-12; OMB M-21-31 EL3
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Must include: environment, compliance-framework, owner."
  default     = {}
}

# Required contract variables

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the VM network interface. Must be in a subnet with NSG and no route to internet."
  # NIST 800-53: SC-7 (Boundary Protection)
}

variable "private_dns_zone_id" {
  type        = string
  description = "Not directly used by the VM module — DNS zone integration is at the NIC/VNet level."
  default     = null
}

variable "key_vault_key_id" {
  type        = string
  description = "Not used — host-based encryption is used instead of Azure Disk Encryption with Key Vault keys."
  default     = null
}

# Service-specific variables

variable "vm_name" {
  type        = string
  description = "Name of the Windows VM for DNS."
  validation {
    condition     = length(var.vm_name) <= 15
    error_message = "Windows VM name must be 15 characters or less."
  }
}

variable "vm_size" {
  type        = string
  description = "VM size. Standard_D2s_v5 recommended for DNS workloads."
  default     = "Standard_D2s_v5"
}

variable "admin_username" {
  type        = string
  description = "Local administrator username. Must not be 'admin' or 'administrator'."
  sensitive   = true
  validation {
    condition     = !contains(["admin", "administrator", "root"], lower(var.admin_username))
    error_message = "Admin username must not be 'admin', 'administrator', or 'root'."
  }
  # NIST 800-53: IA-2, IA-5
}

variable "admin_password" {
  type        = string
  description = "Local administrator password. Must meet complexity requirements. Store in Key Vault and reference via data source."
  sensitive   = true
  # NIST 800-53: IA-5
}
