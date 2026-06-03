variable "name" {
  type        = string
  description = "Resource name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
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

variable "container_app_environment_id" {
  type        = string
  description = "The ID of the Container App Environment."
}
