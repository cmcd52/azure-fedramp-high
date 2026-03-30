# Terraform Module: Azure AI Foundry
#
# Deploys an Azure AI Foundry Hub and Project with FedRAMP High
# compliant defaults: managed VNet isolation, no public access,
# Private Endpoint, system-assigned managed identity, CMK encryption
# for workspace data, associated resources (Key Vault, Storage,
# Application Insights, Container Registry), and diagnostic settings.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-8 (Transmission Confidentiality),
#              SC-13 (Cryptographic Protection),
#              SC-28 (Protection of Information at Rest),
#              IA-2 (Identification and Authentication),
#              AU-12 (Audit Generation)
#
# NOTE: Azure AI Foundry uses the Microsoft.MachineLearningServices
# resource type. In azurerm ~> 3.x, Hub/Project are deployed as "Default"
# kind workspaces with managed VNet isolation. The Hub is the primary
# workspace; Projects are managed via Azure AI Foundry Portal or API.


# NIST 800-53: SC-7, SC-13, SC-28, IA-2 — Azure AI Foundry Hub Workspace
resource "azurerm_machine_learning_workspace" "hub" {
  name                = var.hub_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Default"

  # IA-2: System-assigned managed identity for Entra ID authentication
  identity {
    type = "SystemAssigned"
  }

  # SC-7: No public network access — managed VNet or PE only
  public_network_access_enabled = false

  # SC-7: Managed VNet isolation for compute and data access
  managed_network {
    isolation_mode = "AllowOnlyApprovedOutbound"
  }

  # Associated resources (required)
  application_insights_id = var.application_insights_id
  key_vault_id            = var.key_vault_id
  storage_account_id      = var.storage_account_id
  container_registry_id   = var.container_registry_id

  # SC-13, SC-28: Customer-managed key encryption for workspace data
  dynamic "encryption" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      key_id                    = var.key_vault_key_id
      key_vault_id              = var.key_vault_id
      user_assigned_identity_id = var.cmk_identity_id
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-ai-foundry"
  })
}

# NIST 800-53: SC-7 (Boundary Protection) — Private Endpoint for Hub
resource "azurerm_private_endpoint" "hub" {
  count               = var.subnet_id != null ? 1 : 0
  name                = "${var.hub_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.hub_name}-psc"
    private_connection_resource_id = azurerm_machine_learning_workspace.hub.id
    is_manual_connection           = false
    subresource_names              = ["amlworkspace"]
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
    service              = "azure-ai-foundry"
  })
}

# NIST 800-53: AU-12 — Diagnostic settings for Hub
# OMB M-21-31: EL2 for compute and model operation logs
resource "azurerm_monitor_diagnostic_setting" "hub" {
  name                       = "${var.hub_name}-diag"
  target_resource_id         = azurerm_machine_learning_workspace.hub.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-12: Compute cluster events
  enabled_log {
    category = "AmlComputeClusterEvent"
  }

  enabled_log {
    category = "AmlComputeClusterNodeEvent"
  }

  # AU-12: Compute job events
  enabled_log {
    category = "AmlComputeJobEvent"
  }

  # SI-4: Compute utilization monitoring
  enabled_log {
    category = "AmlComputeCpuGpuUtilization"
  }

  # AU-12: Run status changes
  enabled_log {
    category = "AmlRunStatusChangedEvent"
  }

  # AU-12: Model lifecycle events
  enabled_log {
    category = "ModelsChangeEvent"
  }

  enabled_log {
    category = "ModelsReadEvent"
  }

  enabled_log {
    category = "ModelsActionEvent"
  }

  # AU-12: Deployment events
  enabled_log {
    category = "DeploymentReadEvent"
  }

  enabled_log {
    category = "DeploymentEventACI"
  }

  enabled_log {
    category = "DeploymentEventAKS"
  }

  enabled_log {
    category = "InferencingOperationAKS"
  }

  # AU-12: Environment events
  enabled_log {
    category = "EnvironmentChangeEvent"
  }

  enabled_log {
    category = "EnvironmentReadEvent"
  }

  # AU-12: Data labeling events
  enabled_log {
    category = "DataLabelChangeEvent"
  }

  enabled_log {
    category = "DataLabelReadEvent"
  }

  # AU-12: Dataset events
  enabled_log {
    category = "DataSetChangeEvent"
  }

  enabled_log {
    category = "DataSetReadEvent"
  }

  # AU-12: Pipeline events
  enabled_log {
    category = "PipelineChangeEvent"
  }

  enabled_log {
    category = "PipelineReadEvent"
  }

  # AU-12: Run events
  enabled_log {
    category = "RunEvent"
  }

  enabled_log {
    category = "RunMetricEvent"
  }

  # SI-4: Metrics for operational monitoring
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
