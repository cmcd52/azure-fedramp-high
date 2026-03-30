# Terraform Module: Key Vault (Per-Service)
#
# Deploys an Azure Key Vault for service-specific secrets, keys, and
# certificates with FedRAMP High compliant defaults: Premium SKU for
# FIPS 140-2 Level 2 software keys / Level 3 HSM-backed keys,
# RBAC-only access, soft-delete, purge protection, Private Endpoint,
# and diagnostic settings.
#
# NOTE: The SHARED Key Vault is deployed by shared/terraform/key-vault/.
# This module is the PER-SERVICE pattern for service-specific vaults
# (e.g., application secrets, service-specific CMK keys).
#
# NIST 800-53: SC-12 (Cryptographic Key Establishment & Management),
#              SC-13 (Cryptographic Protection),
#              SC-28 (Protection of Information at Rest),
#              AC-3 (Access Enforcement), AC-6 (Least Privilege),
#              CP-9 (System Backup)
# R-004: FIPS 140-2 Level 2 software / Level 3 HSM-backed keys

# NIST 800-53: SC-12, SC-13, SC-28 — Per-service key management
# FIPS 140-2: Premium SKU enables Level 2 software keys and Level 3 HSM-backed keys (R-004)
resource "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id

  # R-004: Premium SKU required for FIPS 140-2 Level 2 software keys
  # and Level 3 HSM-backed keys
  sku_name = "premium"

  # AC-3, AC-6: RBAC authorization — no access policies, least privilege
  enable_rbac_authorization = true

  # CP-9: Soft-delete prevents accidental permanent deletion of vault objects
  soft_delete_retention_days = 90

  # CP-9: Purge protection prevents permanent deletion during retention period
  purge_protection_enabled = true

  # SC-7: Disable public network access in production
  public_network_access_enabled = false

  # SC-7: Network ACLs — default deny
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "key-vault"
  })
}

# NIST 800-53: SC-7 (Boundary Protection) — Private Endpoint
resource "azurerm_private_endpoint" "this" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.key_vault_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.key_vault_name}-psc"
    private_connection_resource_id = azurerm_key_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
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
    service              = "key-vault"
  })
}

# NIST 800-53: AU-2, AU-12 — Diagnostic settings
# OMB M-21-31 EL3: All Key Vault audit events to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.key_vault_name}-diag"
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-2, AU-12: All Key Vault audit events (access, modification, deletion)
  enabled_log {
    category = "AuditEvent"
  }

  # AU-2: Azure Policy evaluation details for compliance reporting
  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  # AU-2: All metrics for operational monitoring
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
