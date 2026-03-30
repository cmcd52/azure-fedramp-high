# Terraform Module: Azure App Service
#
# Deploys a Linux App Service Plan (Premium tier for PE support) and
# Linux Web App with FedRAMP High compliant defaults: HTTPS-only,
# TLS 1.2, system-assigned managed identity, VNet integration,
# Private Endpoint, and diagnostic settings to Log Analytics.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-8 (Transmission Confidentiality),
#              SC-13 (Cryptographic Protection),
#              SC-28 (Protection of Information at Rest),
#              IA-2 (Identification and Authentication),
#              AU-12 (Audit Generation)
#
# IIS STIG: Web server hardening patterns applied via App Service
# platform configuration (HTTPS-only, TLS 1.2, disabled remote debug).

# NIST 800-53: SC-7 — App Service Plan (Premium for PE + VNet integration)
resource "azurerm_service_plan" "this" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "app-service"
  })
}

# NIST 800-53: SC-8, SC-13, IA-2 — Linux Web App with FedRAMP High defaults
resource "azurerm_linux_web_app" "this" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id

  # SC-8: HTTPS-only — all HTTP traffic redirected to HTTPS
  https_only = true

  # SC-7: VNet integration for outbound traffic isolation
  virtual_network_subnet_id = var.vnet_integration_subnet_id

  site_config {
    # SC-8, SC-13: TLS 1.2 minimum — FIPS-validated cryptographic modules
    minimum_tls_version = "1.2"

    # SC-13: FTPS disabled — only HTTPS deployment supported
    ftps_state = "Disabled"

    # CM-6: Remote debugging disabled (IIS STIG pattern)
    remote_debugging_enabled = false

    # CM-6: Always-on for Premium tier — ensures app is warm
    always_on = true

    # SC-7: Only allow HTTPS traffic
    http2_enabled = true
  }

  # IA-2: System-assigned managed identity for service-to-service auth
  identity {
    type = "SystemAssigned"
  }

  # SC-28: App settings — no secrets in app config (use Key Vault references)
  app_settings = var.app_settings

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "app-service"
  })
}

# NIST 800-53: SC-7 — Private Endpoint for inbound traffic isolation
resource "azurerm_private_endpoint" "this" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.app_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.app_name}-psc"
    private_connection_resource_id = azurerm_linux_web_app.this.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
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
    service              = "app-service"
  })
}

# NIST 800-53: AU-12 — Diagnostic settings for comprehensive logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.app_name}-diag"
  target_resource_id         = azurerm_linux_web_app.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: HTTP request/response logs
  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  # AU-12: Application console output
  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  # AU-12: Application-level logs
  enabled_log {
    category = "AppServiceAppLogs"
  }

  # AU-12: Audit logs for configuration changes
  enabled_log {
    category = "AppServiceAuditLogs"
  }

  # AU-12: IP security audit logs
  enabled_log {
    category = "AppServiceIPSecAuditLogs"
  }

  # AU-12: Platform-level logs
  enabled_log {
    category = "AppServicePlatformLogs"
  }

  # SI-3: Antivirus scan audit logs
  enabled_log {
    category = "AppServiceAntivirusScanAuditLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
