# Terraform Module: Azure Purview
#
# Deploys an Azure Purview (Microsoft Purview) account with FedRAMP High
# compliant defaults: no public network access, managed VNet for scanning,
# system-assigned managed identity, multiple Private Endpoints (account,
# portal, ingestion), and diagnostic settings.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-8 (Transmission Confidentiality),
#              IA-2 (Identification and Authentication),
#              AU-12 (Audit Generation)
#
# NOTE: Azure Purview requires MULTIPLE Private Endpoints:
#   - account: Purview account API access
#   - portal: Purview Studio (governance portal) access
#   - ingestion: Data ingestion endpoints (blob, queue, namespace)
# All three must be deployed for fully private connectivity.

# NIST 800-53: SC-7, IA-2 — Azure Purview account
resource "azurerm_purview_account" "this" {
  name                = var.purview_account_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # IA-2: System-assigned managed identity for credential-free data source scanning
  identity {
    type = "SystemAssigned"
  }

  # SC-7: No public network access — PE only
  public_network_enabled = false

  # SC-7: Managed VNet for scanning — isolates scan runtime in Microsoft-managed VNet
  managed_resource_group_name = var.managed_resource_group_name

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-purview"
  })
}

# NIST 800-53: SC-7 (Boundary Protection) — Private Endpoint: Account
# Provides access to the Purview account API for governance operations.
resource "azurerm_private_endpoint" "account" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.purview_account_name}-account-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.purview_account_name}-account-psc"
    private_connection_resource_id = azurerm_purview_account.this.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_ids["account"] != null ? [1] : []
    content {
      name                 = "default"
      private_dns_zone_ids = [var.private_dns_zone_ids["account"]]
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-purview"
    pe-subresource       = "account"
  })
}

# NIST 800-53: SC-7 (Boundary Protection) — Private Endpoint: Portal
# Provides access to Purview Studio (governance portal) for browser-based management.
resource "azurerm_private_endpoint" "portal" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.purview_account_name}-portal-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.purview_account_name}-portal-psc"
    private_connection_resource_id = azurerm_purview_account.this.id
    is_manual_connection           = false
    subresource_names              = ["portal"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_ids["portal"] != null ? [1] : []
    content {
      name                 = "default"
      private_dns_zone_ids = [var.private_dns_zone_ids["portal"]]
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-purview"
    pe-subresource       = "portal"
  })
}

# NIST 800-53: SC-7 (Boundary Protection) — Private Endpoint: Ingestion
# Provides access to managed storage (blob, queue) and Event Hubs namespace
# used by Purview for scan ingestion. Required for fully private scanning.
resource "azurerm_private_endpoint" "ingestion" {
  count               = var.ingestion_subnet_id != null ? 1 : 0
  name                = "${var.purview_account_name}-ingestion-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.ingestion_subnet_id

  private_service_connection {
    name                           = "${var.purview_account_name}-ingestion-psc"
    private_connection_resource_id = azurerm_purview_account.this.managed_resources[0].storage_account_id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_ids["ingestion"] != null ? [1] : []
    content {
      name                 = "default"
      private_dns_zone_ids = [var.private_dns_zone_ids["ingestion"]]
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-purview"
    pe-subresource       = "ingestion"
  })
}

# NIST 800-53: AU-12 — Diagnostic settings
# OMB M-21-31: EL2 for scan/sensitivity logs
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.purview_account_name}-diag"
  target_resource_id         = azurerm_purview_account.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Scan status log — scan execution results and failures
  enabled_log {
    category = "ScanStatusLogEvent"
  }

  # AU-12: Data sensitivity log — sensitive data classification discoveries
  enabled_log {
    category = "DataSensitivityLogEvent"
  }

  # AU-12: Security log — authentication, authorization, and administrative events
  enabled_log {
    category = "Security"
  }

  # SI-4: Metrics for operational monitoring
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
