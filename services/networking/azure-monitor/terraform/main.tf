# Terraform Module: Azure Monitor
#
# Deploys Azure Monitor resources for centralized alerting and log archival.
# The core Log Analytics workspace is deployed by shared/terraform/log-analytics/.
# This module deploys additional monitor resources:
#   - Action group for alerting (email, SMS)
#   - Activity log alerts for critical events
#   - Log Analytics data export rule for archive to storage
#
# NIST 800-53: AU-2 (Audit Events),
#              AU-3 (Content of Audit Records),
#              AU-6 (Audit Review, Analysis, and Reporting),
#              AU-11 (Audit Record Retention),
#              AU-12 (Audit Generation)
#
# NOTE: The shared Log Analytics workspace (shared/terraform/log-analytics/)
# is the primary audit destination. This module configures monitoring ON TOP
# of that workspace — action groups, alert rules, and data export for
# long-term archive (18-month retention in storage).
#
# EDGE CASE: The workspace cannot send its own diagnostic logs to itself.
# Workspace-level diagnostics should be forwarded to a secondary workspace
# or the Azure Monitor Agent for self-monitoring gaps.

# NIST 800-53: AU-6 — Action group for security and operations alerting
resource "azurerm_monitor_action_group" "this" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.action_group_short_name

  dynamic "email_receiver" {
    for_each = var.email_receivers
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = true
    }
  }

  dynamic "sms_receiver" {
    for_each = var.sms_receivers
    content {
      name         = sms_receiver.value.name
      country_code = sms_receiver.value.country_code
      phone_number = sms_receiver.value.phone_number
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-monitor"
    role                 = "alerting"
  })
}

# NIST 800-53: AU-6, AU-12 — Alert on resource deletion events
resource "azurerm_monitor_activity_log_alert" "resource_deletion" {
  name                = "${var.alert_name_prefix}-resource-deletion"
  resource_group_name = var.resource_group_name
  location            = "global"
  scopes              = [var.subscription_id]
  description         = "Alerts on resource deletion events in the subscription. FedRAMP High AU-6 requires audit review of critical operations."

  criteria {
    operation_name = "Microsoft.Resources/subscriptions/resourceGroups/delete"
    category       = "Administrative"
    level          = "Critical"
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-monitor"
    nist-controls        = "AU-6, AU-12"
  })
}

# NIST 800-53: AU-6, AC-2 — Alert on role assignment changes
resource "azurerm_monitor_activity_log_alert" "role_assignment" {
  name                = "${var.alert_name_prefix}-role-assignment-change"
  resource_group_name = var.resource_group_name
  location            = "global"
  scopes              = [var.subscription_id]
  description         = "Alerts on RBAC role assignment creation or deletion. FedRAMP High AC-2 requires monitoring of account management events."

  criteria {
    operation_name = "Microsoft.Authorization/roleAssignments/write"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-monitor"
    nist-controls        = "AU-6, AC-2"
  })
}

# NIST 800-53: AU-6, CM-6 — Alert on policy violation events
resource "azurerm_monitor_activity_log_alert" "policy_violation" {
  name                = "${var.alert_name_prefix}-policy-violation"
  resource_group_name = var.resource_group_name
  location            = "global"
  scopes              = [var.subscription_id]
  description         = "Alerts on Azure Policy non-compliance events. FedRAMP High CM-6 requires monitoring of configuration baseline deviations."

  criteria {
    category = "Policy"
    level    = "Warning"
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-monitor"
    nist-controls        = "AU-6, CM-6"
  })
}

# NIST 800-53: AU-11 — Data export rule for long-term archive to storage
# 18-month retention in storage account for FedRAMP AU-11 compliance
resource "azurerm_log_analytics_data_export_rule" "archive" {
  name                    = var.data_export_rule_name
  resource_group_name     = var.resource_group_name
  workspace_resource_id   = var.log_analytics_workspace_id
  destination_resource_id = var.archive_storage_account_id
  table_names             = var.export_table_names
  enabled                 = true
}

# NIST 800-53: AU-2, AU-12 — Diagnostic settings for the action group itself
resource "azurerm_monitor_diagnostic_setting" "action_group" {
  name                       = "${var.action_group_name}-diag"
  target_resource_id         = azurerm_monitor_action_group.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ActionGroupActions"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
