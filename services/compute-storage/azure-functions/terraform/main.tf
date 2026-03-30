# Terraform Module: Azure Functions
#
# Deploys a Linux Function App on a Premium App Service Plan with
# FedRAMP High compliant defaults: HTTPS-only, TLS 1.2,
# system-assigned managed identity, Private Endpoint,
# linked Storage Account, and diagnostic settings to Log Analytics.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-8 (Transmission Confidentiality),
#              IA-2 (Identification and Authentication),
#              AU-12 (Audit Generation)
#
# NOTE: Premium plan required for Private Endpoint support.
# The linked Storage Account is required for function runtime
# (triggers, bindings, function code). It must also be secured
# with Private Endpoint and HTTPS-only.

# NIST 800-53: SC-7 — App Service Plan (Premium for PE support)
resource "azurerm_service_plan" "this" {
  name                = var.function_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-functions"
  })
}

# NIST 800-53: SC-8, IA-2 — Linux Function App with FedRAMP High defaults
resource "azurerm_linux_function_app" "this" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id

  # SC-28: Linked Storage Account for function runtime
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  # SC-8: HTTPS-only — all HTTP traffic redirected to HTTPS
  https_only = true

  site_config {
    # SC-8, SC-13: TLS 1.2 minimum — FIPS-validated cryptographic modules
    minimum_tls_version = "1.2"

    # SC-13: FTPS disabled — only HTTPS deployment supported
    ftps_state = "Disabled"

    # CM-6: Remote debugging disabled
    remote_debugging_enabled = false

    # CM-6: Always-on for Premium tier — ensures function host is warm
    always_on = true

    application_stack {
      dotnet_version              = var.dotnet_version
      use_dotnet_isolated_runtime = true
    }
  }

  # IA-2: System-assigned managed identity for service-to-service auth
  identity {
    type = "SystemAssigned"
  }

  app_settings = merge(var.app_settings, {
    # SC-7: Route all outbound traffic through VNet
    "WEBSITE_VNET_ROUTE_ALL" = "1"
  })

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-functions"
  })
}

# NIST 800-53: SC-7 — Private Endpoint for inbound traffic isolation
resource "azurerm_private_endpoint" "this" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.function_app_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.function_app_name}-psc"
    private_connection_resource_id = azurerm_linux_function_app.this.id
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
    service              = "azure-functions"
  })
}

# NIST 800-53: AU-12 — Diagnostic settings for function app logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.function_app_name}-diag"
  target_resource_id         = azurerm_linux_function_app.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Function execution and error logs
  enabled_log {
    category = "FunctionAppLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
