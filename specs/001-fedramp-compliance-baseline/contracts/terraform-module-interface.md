# Contract: Terraform Module Interface

**Applies to**: All per-service Terraform modules under `services/{group}/{service}/terraform/`

---

## Required Variables (All Modules)

Every Terraform module MUST accept these variables. Shared infrastructure modules may omit variables that reference other shared modules (e.g., `log_analytics_workspace_id` is not required for the Log Analytics module itself).

```hcl
variable "environment" {
  type        = string
  description = "Deployment environment. Controls policy effects, encryption key type, and retention settings."
  validation {
    condition     = contains(["production", "lower"], var.environment)
    error_message = "Environment must be 'production' or 'lower'."
  }
}

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
  # NIST 800-53: AU-3, AU-6, AU-12
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Must include: environment, compliance-framework, owner."
  default     = {}
}
```

## Common Optional Variables

```hcl
variable "subnet_id" {
  type        = string
  description = "Subnet ID for Private Endpoint deployment."
  default     = null
  # NIST 800-53: SC-7 (Boundary Protection)
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone ID for Private Endpoint DNS registration."
  default     = null
  # NIST 800-53: SC-7
}

variable "key_vault_key_id" {
  type        = string
  description = "Key Vault key ID for customer-managed encryption. If null, platform-managed keys used (lower environment only)."
  default     = null
  # NIST 800-53: SC-12, SC-13, SC-28; FIPS 140-2
}
```

## Required Outputs (All Modules)

```hcl
output "resource_id" {
  description = "The Azure Resource ID of the deployed service."
}

output "resource_name" {
  description = "The name of the deployed resource."
}

output "private_endpoint_id" {
  description = "The Resource ID of the Private Endpoint (null if not applicable)."
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the diagnostic setting."
}
```

## File Structure (Per Module)

```text
services/{group}/{service}/terraform/
├── main.tf          # Resource definitions with inline NIST control comments
├── variables.tf     # All input variables with control mapping in description
├── outputs.tf       # All outputs
├── versions.tf      # Provider version pin and required_providers
├── locals.tf        # Environment-conditional values (production vs. lower)
└── README.md        # Module usage, required inputs, control coverage summary
```

## Environment Conditioning Pattern

```hcl
locals {
  is_production = var.environment == "production"
  
  # SC-28: Encryption at rest — CMK in production, platform key in lower
  encryption_key_type = local.is_production ? "CustomerManaged" : "PlatformManaged"
  
  # AU-11: Retention — 365 days production, 30 days lower
  retention_days = local.is_production ? 365 : 30
}
```

## Inline Control Mapping Convention

```hcl
# NIST 800-53: SC-8 (Transmission Confidentiality), SC-13 (Cryptographic Protection)
# FIPS 140-2: TLS 1.2 uses FIPS-validated cryptographic modules
# FedRAMP High: Encryption in transit required for all services
resource "azurerm_storage_account" "this" {
  min_tls_version = "TLS1_2"
  # ...
}
```

## Validation Requirements

1. `terraform fmt -check` — must pass
2. `terraform validate` — must pass
3. `terraform plan` — must succeed with no errors against lower environment
4. Policy compliance — deployed resource must pass corresponding policy initiative with zero violations
