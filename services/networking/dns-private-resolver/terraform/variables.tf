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
  description = "Resource ID of the shared Log Analytics workspace for diagnostic settings."
  # NIST 800-53: AU-2, AU-3, AU-12; OMB M-21-31 EL2
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Must include: environment, compliance-framework, owner."
  default     = {}
}

# Optional contract variables

variable "subnet_id" {
  type        = string
  description = "Not directly used — DNS Private Resolver uses dedicated inbound/outbound subnets. See inbound_subnet_id and outbound_subnet_id."
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "Not directly used — DNS Private Resolver integrates with Private DNS Zones via forwarding rulesets, not zone IDs."
  default     = null
}

variable "key_vault_key_id" {
  type        = string
  description = "Not applicable — DNS Private Resolver does not support customer-managed encryption keys."
  default     = null
}

# Service-specific variables

variable "resolver_name" {
  type        = string
  description = "Name of the DNS Private Resolver instance."
}

variable "virtual_network_id" {
  type        = string
  description = "Resource ID of the hub virtual network for the DNS Private Resolver. Resolver must be deployed in the hub VNet."
  # NIST 800-53: SC-7 — Boundary protection; resolver within trusted network
}

variable "inbound_subnet_id" {
  type        = string
  description = "Subnet ID for the inbound endpoint. Must have delegation Microsoft.Network/dnsResolvers. Minimum /28."
  # NIST 800-53: SC-7, SC-20 — Inbound DNS reception within hub VNet
}

variable "outbound_subnet_id" {
  type        = string
  description = "Subnet ID for the outbound endpoint. Must have delegation Microsoft.Network/dnsResolvers. Minimum /28. Must be separate from inbound subnet."
  # NIST 800-53: SC-20, SC-21 — Outbound forwarding to on-prem DNS
}

variable "forwarding_rules" {
  type = list(object({
    name        = string
    domain_name = string
    target_dns_servers = list(object({
      ip_address = string
      port       = optional(number, 53)
    }))
  }))
  description = "List of forwarding rules for on-premises domain resolution. Each rule specifies a domain and target DNS server IPs."
  default     = []
  # NIST 800-53: SC-20, SC-21 — Conditional forwarding for on-prem domains
}
