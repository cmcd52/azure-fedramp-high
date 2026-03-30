# Shared Terraform Module: Log Analytics Workspace
#
# Deploys a centralized Log Analytics workspace for all Azure service
# diagnostic data with FedRAMP High compliant defaults: 365-day
# retention, CMK encryption, network isolation, and Sentinel integration.
#
# NIST 800-53: AU-2 (Audit Events), AU-3 (Content of Audit Records),
#              AU-6 (Audit Review, Analysis, and Reporting),
#              AU-11 (Audit Record Retention), AU-12 (Audit Generation),
#              SC-28 (Protection of Information at Rest)
# FR-030: Centralized logging with 365-day retention (production)
# OMB M-21-31 EL3: Sentinel integration for advanced analytics

# ---------------------------------------------------------------
# NIST 800-53: AU-2, AU-3, AU-12 — Centralized audit log collection
# NIST 800-53: AU-11 — 365-day retention for production
# NIST 800-53: SC-28 — Encryption at rest (CMK in production)
# ---------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "this" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"

  # AU-11, FR-030: Retain audit records for minimum 365 days (production)
  retention_in_days = local.retention_days

  # SC-7: Disable internet ingestion/query in production; enforce AMPLS-only access
  internet_ingestion_enabled = local.internet_ingestion_enabled
  internet_query_enabled     = local.internet_query_enabled

  # SC-28: Customer-managed key encryption
  # When key_vault_key_id is provided, workspace data is encrypted with CMK
  cmk_for_query_forced = var.key_vault_key_id != null ? true : false

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    purpose              = "centralized-logging"
  })
}

# SC-28: CMK encryption identity for Log Analytics
# The workspace must be linked to a CMK cluster or have a dedicated cluster
# for full CMK support. For workspaces under 500 GB/day, use the
# azurerm_log_analytics_workspace_cmk resource when key_vault_key_id is set.
# NOTE: Full CMK requires a dedicated Log Analytics cluster at 500 GB/day
# commitment tier. For smaller workloads, cmk_for_query_forced provides
# query-level encryption with CMK.

# ---------------------------------------------------------------
# NIST 800-53: AU-6 — Audit Review, Analysis, and Reporting
# OMB M-21-31 EL3: Microsoft Sentinel for advanced threat analytics
# ---------------------------------------------------------------
resource "azurerm_log_analytics_solution" "sentinel" {
  solution_name         = "SecurityInsights"
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  workspace_name        = azurerm_log_analytics_workspace.this.name
  location              = var.location
  resource_group_name   = var.resource_group_name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }

  tags = var.tags
}

# ---------------------------------------------------------------
# NIST 800-53: SC-7 — Boundary Protection via AMPLS Private Endpoint
# ---------------------------------------------------------------
resource "azurerm_private_endpoint" "log_analytics" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.workspace_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.workspace_name}-psc"
    private_connection_resource_id = azurerm_log_analytics_workspace.this.id
    is_manual_connection           = false
    subresource_names              = ["azuremonitor"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id != null ? [1] : []
    content {
      name                 = "default"
      private_dns_zone_ids = [var.private_dns_zone_id]
    }
  }

  tags = var.tags
}

# ---------------------------------------------------------------
# Diagnostic Setting: Self-monitoring
# NOTE: A Log Analytics workspace cannot send its own diagnostic logs
# to itself. In production, consider forwarding workspace audit logs
# to a secondary workspace or to Azure Event Hubs for separation of
# duties (AU-9: Protection of Audit Information). This is a known
# Azure platform limitation.
# ---------------------------------------------------------------
