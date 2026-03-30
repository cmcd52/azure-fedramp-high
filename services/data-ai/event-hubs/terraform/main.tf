# Terraform Module: Azure Event Hubs
#
# Deploys an Azure Event Hubs namespace with FedRAMP High compliant
# defaults: Premium tier (for PE + CMK support), no public network
# access, Private Endpoint only, TLS 1.2, system-assigned managed
# identity, CMK encryption, zone redundancy, auto-inflate, SAS keys
# disabled in production, and diagnostic settings.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-8 (Transmission Confidentiality),
#              SC-13 (Cryptographic Protection),
#              SC-28 (Protection of Information at Rest),
#              IA-2 (Identification and Authentication),
#              AC-3 (Access Enforcement),
#              AU-12 (Audit Generation)
#
# NOTE: Premium or Dedicated tier is required for Private Endpoint,
# CMK encryption, and zone redundancy support. Standard tier does not
# support these features.

# NIST 800-53: SC-7, SC-8, SC-13, SC-28, IA-2, AC-3 — Event Hubs namespace
resource "azurerm_eventhub_namespace" "this" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  # IA-2: System-assigned managed identity for RBAC-based authentication
  identity {
    type = "SystemAssigned"
  }

  # SC-7: No public network access — PE only
  public_network_access_enabled = false

  # SC-8: TLS 1.2 minimum per NIST SP 800-52 Rev 2
  minimum_tls_version = "1.2"

  # IA-2, AC-3: Disable SAS keys in production — RBAC only
  local_authentication_enabled = false

  # SC-7: Network rules — default deny
  network_rulesets {
    default_action                 = "Deny"
    public_network_access_enabled  = false
    trusted_service_access_enabled = true
  }

  # SC-28: Zone redundancy for high availability and data protection
  zone_redundant = true

  # Capacity: Premium tier processing units
  capacity = var.capacity

  # Auto-inflate for scaling (Premium tier)
  auto_inflate_enabled     = var.auto_inflate_enabled
  maximum_throughput_units = var.auto_inflate_enabled ? var.maximum_throughput_units : null

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "event-hubs"
  })
}

# SC-13, SC-28: Customer-managed key encryption
resource "azurerm_eventhub_namespace_customer_managed_key" "this" {
  count                         = var.key_vault_key_ids != null ? 1 : 0
  eventhub_namespace_id         = azurerm_eventhub_namespace.this.id
  key_vault_key_ids             = var.key_vault_key_ids
  infrastructure_encryption_enabled = true
}

# NIST 800-53: SC-7 (Boundary Protection) — Private Endpoint
resource "azurerm_private_endpoint" "this" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.namespace_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.namespace_name}-psc"
    private_connection_resource_id = azurerm_eventhub_namespace.this.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
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
    service              = "event-hubs"
  })
}

# NIST 800-53: AU-12 — Diagnostic settings
# OMB M-21-31: EL2 for operational logs, EL3 for security events
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.namespace_name}-diag"
  target_resource_id         = azurerm_eventhub_namespace.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Archive logs — Event Hubs Capture operations
  enabled_log {
    category = "ArchiveLogs"
  }

  # AU-12: Operational logs — namespace operations and errors
  enabled_log {
    category = "OperationalLogs"
  }

  # AU-12: Auto-scale logs — auto-inflate scaling events
  enabled_log {
    category = "AutoScaleLogs"
  }

  # AU-12: Kafka coordinator logs — Kafka protocol operations
  enabled_log {
    category = "KafkaCoordinatorLogs"
  }

  # AU-12: Kafka user error logs — Kafka client errors
  enabled_log {
    category = "KafkaUserErrorLogs"
  }

  # AU-12, SC-7: VNet connection events — PE and VNet access tracking
  enabled_log {
    category = "EventHubVNetConnectionEvent"
  }

  # AU-12, SC-13: CMK operation logs — key rotation, access events
  enabled_log {
    category = "CustomerManagedKeyUserLogs"
  }

  # AU-12: Runtime audit logs — data plane operations
  enabled_log {
    category = "RuntimeAuditLogs"
  }

  # AU-12: Application metrics logs — throughput and performance
  enabled_log {
    category = "ApplicationMetricsLogs"
  }

  # SI-4: Metrics for operational monitoring
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
