variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)."
  type        = string
}

variable "location" {
  description = "Azure region (used for tagging; DNS zones are global)."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to deploy DNS zones into."
  type        = string
}

variable "virtual_network_id" {
  description = "Resource ID of the hub virtual network to link DNS zones to (SC-21)."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "additional_zones" {
  description = "Optional map of additional privatelink DNS zones to create. Key = short name, value = { zone_name, service }."
  type = map(object({
    zone_name = string
    service   = string
  }))
  default = {}
}
