# Terraform Module: Azure Maps
#
# Deploys an Azure Maps account with FedRAMP High compliant defaults:
# S1 SKU, system-assigned managed identity, shared key auth disabled
# in production, CORS restrictions, and diagnostic settings.
#
# NIST 800-53: IA-2 (Identification and Authentication),
#              SC-8 (Transmission Confidentiality),
#              AU-12 (Audit Generation)
#
# EXCEPTION: Azure Maps does NOT support Private Endpoint. This is
# documented as a FedRAMP SC-7 exception with compensating controls:
# 1. Managed identity authentication (disable shared key in production)
# 2. CORS origin restrictions (authorized domains only)
# 3. Azure Front Door WAF in front of map tile requests
# 4. IP address restrictions at the application/infrastructure level
# 5. No sensitive data in map queries (tile requests only)
#
# NOTE: Azure Maps uses the Microsoft.Maps/accounts resource type.


# NIST 800-53: IA-2, SC-8 — Azure Maps account
resource "azurerm_maps_account" "this" {
  name                = var.maps_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku_name

  # IA-2: System-assigned managed identity for Entra ID authentication
  identity {
    type = "SystemAssigned"
  }

  # IA-2: Disable shared key authentication in production
  # Managed identity + Entra ID RBAC is the only auth method in production
  local_authentication_enabled = false

  # AC-4: CORS restrictions — authorized origins only
  dynamic "cors" {
    for_each = length(var.cors_allowed_origins) > 0 ? [1] : []
    content {
      allowed_origins = var.cors_allowed_origins
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-maps"
    pe-exception         = "true"
  })
}

# NIST 800-53: AU-12 — Diagnostic settings
# OMB M-21-31: EL1 for audit logs (limited categories)
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.maps_account_name}-diag"
  target_resource_id         = azurerm_maps_account.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Audit log — API access events
  enabled_log {
    category = "Audit"
  }

  # SI-4: Metrics for operational monitoring
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
