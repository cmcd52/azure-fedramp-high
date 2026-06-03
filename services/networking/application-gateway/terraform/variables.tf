variable "name" {
  type        = string
  description = "Resource name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Central Log Analytics workspace resource ID for diagnostic forwarding."
}

variable "public_ip_address_id" {
  type        = string
  description = "The ID of the Public IP for the Application Gateway."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet for the Application Gateway."
}
