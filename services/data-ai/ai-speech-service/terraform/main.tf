# Terraform Module: AI Speech Service
#
# Deploys an Azure AI Speech Service (Cognitive Services) account with
# FedRAMP High compliant defaults: no public network access, Private
# Endpoint only, system-assigned managed identity, CMK encryption,
# network rules default deny, and diagnostic settings.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-8 (Transmission Confidentiality),
#              SC-13 (Cryptographic Protection),
#              IA-2 (Identification and Authentication),
#              AU-12 (Audit Generation)
#
# NOTE: AI Speech Service uses the Microsoft.CognitiveServices/accounts
# resource type with kind = "SpeechServices". Audio data may contain PII
# — network isolation and encryption are critical.

# NIST 800-53: SC-7, IA-2, SC-13 — AI Speech Service account
resource "azurerm_cognitive_account" "this" {
  name                  = var.speech_account_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "SpeechServices"
  sku_name              = var.sku_name
  custom_subdomain_name = var.speech_account_name

  # IA-2: System-assigned managed identity for Entra ID authentication
  identity {
    type = "SystemAssigned"
  }

  # SC-7: No public network access — PE only
  public_network_access_enabled = false

  # SC-7: Network rules — default deny
  network_acls {
    default_action = "Deny"
  }

  # IA-2: Disable local (API key) authentication in production
  local_auth_enabled = false

  # SC-13: Customer-managed key encryption (when key vault key ID provided)
  dynamic "customer_managed_key" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      key_vault_key_id = var.key_vault_key_id
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "ai-speech-service"
  })
}

# NIST 800-53: SC-7 (Boundary Protection) — Private Endpoint
resource "azurerm_private_endpoint" "this" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.speech_account_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.speech_account_name}-psc"
    private_connection_resource_id = azurerm_cognitive_account.this.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id != null ? [1] : []
    content {
      name                 = "default"
      private_dns_zone_ids = [var.private_dns_zone_id]
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "ai-speech-service"
  })
}

# NIST 800-53: AU-12 — Diagnostic settings
# OMB M-21-31: EL2 for request/response, EL3 for audit events
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.speech_account_name}-diag"
  target_resource_id         = azurerm_cognitive_account.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Audit log — authentication, authorization, and administrative events
  enabled_log {
    category = "Audit"
  }

  # AU-12: Request/Response log — API call details
  enabled_log {
    category = "RequestResponse"
  }

  # AU-12: Trace log — detailed diagnostic information
  enabled_log {
    category = "Trace"
  }

  # SI-4: Metrics for operational monitoring
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
