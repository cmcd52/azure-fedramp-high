# Terraform Module: Azure AD B2C Directory

**Service**: Azure AD B2C
**Category**: Identity
**Last Updated**: 2026-03-27

---

## Overview

Deploys an Azure AD B2C directory (customer identity platform) with FedRAMP High compliant defaults. This module provisions the B2C directory resource and configures diagnostic settings to the shared Log Analytics workspace.

### Important Limitations

- **Private Endpoint**: NOT supported for Azure AD B2C. Compensating controls (IP restrictions, Azure Front Door with WAF) are documented in `controls/baseline.md`.
- **Custom Policies / User Flows**: B2C authentication logic (custom policies, user flows, MFA configuration, token lifetime) is managed via the Azure portal, Microsoft Graph API, or Identity Experience Framework XML — NOT Terraform. This module deploys the directory resource and diagnostics only.

---

## Required Inputs

| Variable | Type | Description | NIST Control |
|----------|------|-------------|--------------|
| `environment` | `string` | `production` or `lower` | — |
| `location` | `string` | Azure region (US for FedRAMP) | — |
| `resource_group_name` | `string` | Target resource group | — |
| `domain_name` | `string` | B2C tenant domain (e.g., `contosob2c.onmicrosoft.com`) | IA-8 |
| `display_name` | `string` | B2C tenant display name | — |
| `log_analytics_workspace_id` | `string` | Shared Log Analytics workspace ID | AU-2, AU-12 |

## Optional Inputs

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | `map(string)` | `{}` | Resource tags |
| `country_code` | `string` | `"US"` | Data residency country code |
| `data_residency_location` | `string` | `"United States"` | Data residency location |

## Outputs

| Output | Description |
|--------|-------------|
| `resource_id` | Azure Resource ID of the B2C directory |
| `resource_name` | Domain name of the B2C directory |
| `private_endpoint_id` | Always `null` — Private Endpoint not supported for B2C |
| `diagnostic_setting_id` | Resource ID of the diagnostic setting |
| `tenant_id` | Tenant ID of the B2C directory |

---

## NIST 800-53 Control Coverage

| Control | Implementation |
|---------|---------------|
| IA-2 | Customer identity authentication via B2C |
| IA-5 | Token lifetime and credential management (via custom policies) |
| IA-8 | Non-organizational user identification |
| SC-23 | Session authenticity via token management |
| AU-2, AU-12 | Diagnostic settings to Log Analytics |
| SC-7 | **Exception**: Private Endpoint not supported — see `controls/baseline.md` |

---

## Usage

```hcl
module "b2c" {
  source = "./services/identity/azure-ad-b2c/terraform"

  environment                = "production"
  location                   = "eastus"
  resource_group_name        = "rg-identity-prod"
  domain_name                = "contosob2c.onmicrosoft.com"
  display_name               = "Contoso B2C"
  log_analytics_workspace_id = module.log_analytics.resource_id

  tags = {
    environment          = "production"
    compliance-framework = "FedRAMP-High"
    owner                = "identity-team"
  }
}
```
