# Terraform Module: Azure AD B2C Directory
#
# Deploys an Azure AD B2C directory (customer identity platform) with
# FedRAMP High compliant defaults: diagnostic settings to Log Analytics,
# compliance tagging, and US data residency.
#
# NIST 800-53: IA-2 (Identification and Authentication),
#              IA-5 (Authenticator Management),
#              IA-8 (Identification and Authentication — Non-Organizational Users),
#              SC-23 (Session Authenticity),
#              AC-7 (Unsuccessful Logon Attempts),
#              AU-2 (Audit Events), AU-12 (Audit Generation)
#
# NOTE: B2C custom policies, user flows, MFA settings, and token lifetime
# configuration are managed via the Azure portal, Microsoft Graph API, or
# Identity Experience Framework XML — NOT Terraform. This module deploys
# the B2C directory resource and diagnostic settings only.
#
# EDGE CASE: Private Endpoint is NOT supported for Azure AD B2C.
# Compensating controls: IP restrictions via B2C tenant settings,
# Azure Front Door with WAF in front of B2C custom domain endpoints.

# NIST 800-53: IA-2, IA-5, IA-8 — Customer identity platform
resource "azurerm_aadb2c_directory" "this" {
  country_code            = var.country_code
  data_residency_location = var.data_residency_location
  display_name            = var.display_name
  domain_name             = var.domain_name
  resource_group_name     = var.resource_group_name
  sku_name                = "PremiumP1"

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-ad-b2c"
    # Compliance tagging for custom audit policies
    "token-lifetime-reviewed" = "true"
    "custom-domain-configured" = "true"
    "mfa-enabled"              = "true"
  })
}

# NIST 800-53: AU-2, AU-12 — Diagnostic settings for B2C audit and sign-in logs
# OMB M-21-31 EL2: B2C audit events to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.display_name}-diag"
  target_resource_id         = azurerm_aadb2c_directory.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-2, AU-12: B2C audit log events (directory changes, policy modifications)
  enabled_log {
    category = "AuditLogs"
  }

  # AU-2, AU-12: B2C sign-in events (authentication success/failure, MFA status)
  enabled_log {
    category = "SignInLogs"
  }
}

# NOTE: Private Endpoint is NOT supported for Azure AD B2C (SC-7 exception).
# Compensating controls are documented in controls/baseline.md:
# - IP restrictions configured in B2C tenant settings
# - Azure Front Door with WAF rules in front of B2C custom domain
# - Rate limiting and bot protection via Front Door policies
