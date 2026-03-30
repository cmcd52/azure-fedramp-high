output "resource_id" {
  description = "The Azure Resource ID of the Monitor action group."
  value       = azurerm_monitor_action_group.this.id
}

output "resource_name" {
  description = "The name of the Monitor action group."
  value       = azurerm_monitor_action_group.this.name
}

output "private_endpoint_id" {
  description = "Not applicable — Azure Monitor is a platform service. Private Link is configured separately."
  value       = null
}

output "diagnostic_setting_id" {
  description = "The Resource ID of the action group diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.action_group.id
}

output "action_group_id" {
  description = "The Azure Resource ID of the action group. Used by other modules to configure alert actions."
  value       = azurerm_monitor_action_group.this.id
}

output "resource_deletion_alert_id" {
  description = "The Resource ID of the resource deletion activity log alert."
  value       = azurerm_monitor_activity_log_alert.resource_deletion.id
}

output "role_assignment_alert_id" {
  description = "The Resource ID of the role assignment change activity log alert."
  value       = azurerm_monitor_activity_log_alert.role_assignment.id
}

output "policy_violation_alert_id" {
  description = "The Resource ID of the policy violation activity log alert."
  value       = azurerm_monitor_activity_log_alert.policy_violation.id
}

output "data_export_rule_id" {
  description = "The Resource ID of the Log Analytics data export rule for long-term archive."
  value       = azurerm_log_analytics_data_export_rule.archive.id
}
