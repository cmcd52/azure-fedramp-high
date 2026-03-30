variable "location" {
  type        = string
  description = "Azure region for the resource group. Must be a US region for FedRAMP High."
  # NIST 800-53: N/A (operational), FedRAMP: data residency
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into."
}

variable "domain_name" {
  type        = string
  description = "The domain name of the B2C tenant (e.g., contosob2c.onmicrosoft.com)."
  # NIST 800-53: IA-8 (Identification and Authentication — Non-Organizational Users)
}

variable "display_name" {
  type        = string
  description = "The display name of the Azure AD B2C tenant."
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

variable "country_code" {
  type        = string
  description = "Country code for the B2C directory. US required for FedRAMP High data residency."
  default     = "US"
  # FedRAMP: US data residency requirement
}

variable "data_residency_location" {
  type        = string
  description = "Data residency location for the B2C directory. Must be 'United States' for FedRAMP High."
  default     = "United States"
}
