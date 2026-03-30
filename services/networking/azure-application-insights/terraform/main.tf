# Terraform Module: Azure Application Insights
#
# Deploys an Azure Application Insights component (workspace-based) with
# FedRAMP High compliant defaults: linked to shared Log Analytics workspace,
# local authentication disabled (Entra ID only), sampling rate configured,
# and daily data cap for cost management.
#
# NIST 800-53: AU-3 (Content of Audit Records),
#              AU-6 (Audit Review, Analysis, and Reporting),
#              AU-12 (Audit Generation),
#              IA-2 (Identification and Authentication)
#
# NOTE: Application Insights MUST be workspace-based (not classic).
# Workspace-based mode forwards all telemetry to the shared Log Analytics
# workspace, enabling centralized query, unified retention, and RBAC.
# Classic Application Insights is deprecated and uses isolated storage.
#
# EDGE CASE: Custom telemetry emitted by application code MUST NOT include
# PII or sensitive data. Application teams are responsible for filtering
# sensitive fields before telemetry submission. Use TelemetryInitializers
# or TelemetryProcessors to strip PII.

# NIST 800-53: AU-3, AU-6, AU-12, IA-2 — Application Insights (workspace-based)
resource "azurerm_application_insights" "this" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = var.log_analytics_workspace_id
  application_type    = "web"

  # IA-2: Disable local authentication, require Entra ID
  local_authentication_disabled = true

  # AU-12: Sampling percentage for telemetry volume management
  sampling_percentage = var.sampling_percentage

  # Cost management: daily data cap
  daily_data_cap_in_gb = var.daily_data_cap_in_gb

  # AU-12: Retention aligns with workspace retention (workspace-based mode)
  retention_in_days = var.retention_in_days

  # Disable IP masking only if required for security investigations
  disable_ip_masking = false

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "application-insights"
    application-type     = "web"
  })
}

# NIST 800-53: AU-2, AU-12 — Diagnostic settings for Application Insights itself
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.application_insights_name}-diag"
  target_resource_id         = azurerm_application_insights.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AppAvailabilityResults"
  }

  enabled_log {
    category = "AppBrowserTimings"
  }

  enabled_log {
    category = "AppDependencies"
  }

  enabled_log {
    category = "AppEvents"
  }

  enabled_log {
    category = "AppExceptions"
  }

  enabled_log {
    category = "AppMetrics"
  }

  enabled_log {
    category = "AppPageViews"
  }

  enabled_log {
    category = "AppPerformanceCounters"
  }

  enabled_log {
    category = "AppRequests"
  }

  enabled_log {
    category = "AppSystemEvents"
  }

  enabled_log {
    category = "AppTraces"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
