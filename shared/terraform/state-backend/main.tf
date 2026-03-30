# Shared Terraform Module: Terraform State Backend
#
# Deploys an Azure Storage Account for Terraform remote state with
# FedRAMP High compliant defaults: CMK encryption, RBAC-only access,
# state locking via blob lease, and Private Endpoint.
#
# NIST 800-53: SC-12, SC-13, SC-28 (Encryption), AC-3 (Access Enforcement),
#              AU-9 (Protection of Audit Information)
# FR-012: Terraform state backend security requirements

# NIST 800-53: SC-28 (Protection of Information at Rest)
# FIPS 140-2: AES-256 via Azure Storage Service Encryption
resource "azurerm_storage_account" "tfstate" {
  name                          = var.storage_account_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "GRS"
  account_kind                  = "StorageV2"
  min_tls_version               = "TLS1_2" # SC-8, SC-13: FIPS-validated TLS
  shared_access_key_enabled     = false     # AC-3: RBAC-only, no shared keys
  public_network_access_enabled = false     # SC-7: No public access

  # SC-28: Encryption at rest with CMK
  dynamic "customer_managed_key" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      key_vault_key_id          = var.key_vault_key_id
      user_assigned_identity_id = var.encryption_identity_id
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = var.encryption_identity_id != null ? [var.encryption_identity_id] : []
  }

  blob_properties {
    versioning_enabled = true # CM-3: Configuration change management
    delete_retention_policy {
      days = 30 # CP-9: Backup/recovery
    }
    container_delete_retention_policy {
      days = 30
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    purpose              = "terraform-state-backend"
  })
}

# State container with blob lease locking
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# NIST 800-53: SC-7 (Boundary Protection) — Private Endpoint
resource "azurerm_private_endpoint" "tfstate" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.storage_account_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.storage_account_name}-psc"
    private_connection_resource_id = azurerm_storage_account.tfstate.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
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

# NIST 800-53: AU-3, AU-6, AU-12 — Diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "tfstate" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.storage_account_name}-diag"
  target_resource_id         = azurerm_storage_account.tfstate.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }
}
