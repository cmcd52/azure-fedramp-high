variable "location" {
  type        = string
  description = "Azure region for the ExpressRoute circuit. Must be a US region for FedRAMP High."
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

# Optional contract variables (not used by ExpressRoute but included for module interface consistency)

variable "subnet_id" {
  type        = string
  description = "Not used by ExpressRoute. ExpressRoute IS the private connectivity and does not deploy into a subnet."
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "Not used by ExpressRoute. DNS resolution is handled by on-premises DNS or Azure DNS Private Resolver over ExpressRoute."
  default     = null
}

variable "key_vault_key_id" {
  type        = string
  description = "Not used by ExpressRoute. MACsec keys for ExpressRoute Direct are managed via Azure Key Vault separately."
  default     = null
}

# Service-specific variables

variable "circuit_name" {
  type        = string
  description = "Name of the ExpressRoute circuit."
}

variable "service_provider_name" {
  type        = string
  description = "ExpressRoute service provider name (e.g., 'Equinix', 'AT&T')."
}

variable "peering_location" {
  type        = string
  description = "ExpressRoute peering location (e.g., 'Washington DC', 'Dallas')."
}

variable "bandwidth_in_mbps" {
  type        = number
  description = "Bandwidth of the ExpressRoute circuit in Mbps."
  default     = 1000
}

variable "sku_family" {
  type        = string
  description = "ExpressRoute SKU family: MeteredData or UnlimitedData."
  default     = "MeteredData"
  validation {
    condition     = contains(["MeteredData", "UnlimitedData"], var.sku_family)
    error_message = "SKU family must be 'MeteredData' or 'UnlimitedData'."
  }
}

variable "peer_asn" {
  type        = number
  description = "Peer BGP ASN for private peering."
}

variable "primary_peer_address_prefix" {
  type        = string
  description = "Primary peer address prefix for private peering (/30 CIDR)."
}

variable "secondary_peer_address_prefix" {
  type        = string
  description = "Secondary peer address prefix for private peering (/30 CIDR)."
}

variable "vlan_id" {
  type        = number
  description = "VLAN ID for private peering (2-4094)."
}

variable "shared_key" {
  type        = string
  description = "MD5 shared key for BGP session authentication. SC-8, SC-12 compliance."
  sensitive   = true
  default     = null
}
