# Terraform Module: Azure AI Search
#
# Deploys an Azure AI Search (Cognitive Search) service with FedRAMP High
# compliant defaults: Standard SKU (for Private Endpoint support), no
# public access, managed identity, CMK for index encryption, TLS 1.2,
# and diagnostic settings.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-8 (Transmission Confidentiality),
#              SC-13 (Cryptographic Protection),
#              SC-28 (Protection of Information at Rest),
#              IA-2 (Identification and Authentication)
#
# NOTE: Standard SKU or higher is required for Private Endpoint support.
# Basic and Free SKUs do not support private endpoints.

# NIST 800-53: SC-7, SC-8, SC-28, IA-2 — Azure AI Search service
resource "azurerm_search_service" "this" {
  name                = var.search_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  # IA-2: System-assigned managed identity for data source connections
  identity {
    type = "SystemAssigned"
  }

  # SC-7: No public network access — PE only
  public_network_access_enabled = false

  # SC-7: Disable local (API key) authentication for control plane
  local_authentication_enabled = false

  # SC-28, SC-13: CMK enforcement for index encryption
  customer_managed_key_enforcement_enabled = var.key_vault_key_id != null ? true : false

  replica_count   = var.replica_count
  partition_count = var.partition_count

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-ai-search"
  })
}

# NIST 800-53: SC-7 (Boundary Protection) — Private Endpoint
resource "azurerm_private_endpoint" "this" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.search_service_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.search_service_name}-psc"
    private_connection_resource_id = azurerm_search_service.this.id
    is_manual_connection           = false
    subresource_names              = ["searchService"]
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
    service              = "azure-ai-search"
  })
}

# NIST 800-53: AU-12 — Diagnostic settings
# OMB M-21-31: EL2 for operation logs
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.search_service_name}-diag"
  target_resource_id         = azurerm_search_service.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Operation logs — indexing, queries, and service operations
  enabled_log {
    category = "OperationLogs"
  }

  # SI-4: Metrics for operational monitoring
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
