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
  description = "Not directly used — PE connection state is logged via the parent resource's diagnostic settings. Included for contract compliance."
  default     = null
  # NIST 800-53: AU-2, AU-3, AU-12
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Must include: environment, compliance-framework, owner."
  default     = {}
}

# Required contract variables

variable "subnet_id" {
  type        = string
  description = "Subnet ID for Private Endpoint deployment. Subnet must have NSG and privateEndpointNetworkPolicies enabled."
  # NIST 800-53: SC-7 (Boundary Protection)
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone ID for DNS zone group registration. PE private IP will be registered in this zone."
  # NIST 800-53: SC-7, SC-20
}

variable "key_vault_key_id" {
  type        = string
  description = "Not applicable — Private Endpoints do not support customer-managed encryption keys."
  default     = null
}

# Service-specific variables

variable "endpoint_name" {
  type        = string
  description = "Name of the Private Endpoint."
}

variable "resource_id" {
  type        = string
  description = "The Azure Resource ID of the service to connect via Private Endpoint."
  # NIST 800-53: SC-7 — Target resource for private connectivity
}

variable "subresource_name" {
  type        = string
  description = "The sub-resource name for the Private Endpoint connection (e.g., 'blob', 'vault', 'sites', 'sqlServer')."
  # NIST 800-53: SC-7
}

variable "is_manual_connection" {
  type        = bool
  description = "Whether the PE connection requires manual approval. Set to true for third-party services."
  default     = false
}

variable "request_message" {
  type        = string
  description = "Request message for manual connection approval. Only used when is_manual_connection = true."
  default     = "FedRAMP High Private Endpoint connection request"
}
