# Terraform Module: Azure Storage Account
#
# Deploys an Azure Storage Account with FedRAMP High compliant defaults:
# CMK encryption, no public access,
# HTTPS-only, TLS 1.2, shared key disabled (RBAC-only), blob
# versioning, soft-delete, Private Endpoint, and diagnostic settings.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-8 (Transmission Confidentiality),
#              SC-13 (Cryptographic Protection),
#              SC-28 (Protection of Information at Rest),
#              AC-3 (Access Enforcement),
#              AU-12 (Audit Generation)
#
# FIPS 140-2: Azure Storage Service Encryption uses FIPS 140-2
# validated cryptographic modules (Certificate #4536 or current).

# NIST 800-53: SC-28, SC-13, SC-7, SC-8, AC-3 — Storage Account
resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication

  # SC-8: HTTPS-only — HTTP requests rejected
  https_traffic_only_enabled = true

  # SC-8: TLS 1.2 minimum
  min_tls_version = "TLS1_2"

  # SC-7: No public blob access
  allow_nested_items_to_be_public = false

  # AC-3: Shared key access disabled — RBAC-only
  shared_access_key_enabled = false

  # SC-7: Default network rule — deny all public access
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  # SC-28, SC-13: Customer-managed key encryption (production)
  dynamic "customer_managed_key" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      key_vault_key_id          = var.key_vault_key_id
      user_assigned_identity_id = var.cmk_identity_id
    }
  }

  # IA-2: Identity for CMK access
  dynamic "identity" {
    for_each = var.cmk_identity_id != null ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = [var.cmk_identity_id]
    }
  }

  dynamic "identity" {
    for_each = var.cmk_identity_id == null ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  # SC-28: Blob properties — versioning and soft-delete for data protection
  blob_properties {
    # SC-28: Blob versioning for data integrity
    versioning_enabled = true

    # SC-28: Soft-delete for blob recovery
    delete_retention_policy {
      days = 90
    }

    # SC-28: Soft-delete for container recovery
    container_delete_retention_policy {
      days = 90
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-storage-account"
  })
}

# NIST 800-53: SC-7 — Private Endpoint for blob sub-service
resource "azurerm_private_endpoint" "blob" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.storage_account_name}-blob-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.storage_account_name}-blob-psc"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
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
    service              = "azure-storage-account"
  })
}

# NIST 800-53: AU-12 — Diagnostic settings for Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                       = "${var.storage_account_name}-diag"
  target_resource_id         = azurerm_storage_account.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# NIST 800-53: AU-12 — Diagnostic settings for blob sub-service
resource "azurerm_monitor_diagnostic_setting" "blob" {
  name                       = "${var.storage_account_name}-blob-diag"
  target_resource_id         = "${azurerm_storage_account.this.id}/blobServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# NIST 800-53: AU-12 — Diagnostic settings for queue sub-service
resource "azurerm_monitor_diagnostic_setting" "queue" {
  name                       = "${var.storage_account_name}-queue-diag"
  target_resource_id         = "${azurerm_storage_account.this.id}/queueServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# NIST 800-53: AU-12 — Diagnostic settings for table sub-service
resource "azurerm_monitor_diagnostic_setting" "table" {
  name                       = "${var.storage_account_name}-table-diag"
  target_resource_id         = "${azurerm_storage_account.this.id}/tableServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# NIST 800-53: AU-12 — Diagnostic settings for file sub-service
resource "azurerm_monitor_diagnostic_setting" "file" {
  name                       = "${var.storage_account_name}-file-diag"
  target_resource_id         = "${azurerm_storage_account.this.id}/fileServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}
