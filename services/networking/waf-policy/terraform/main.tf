# Terraform Module: Web Application Firewall Policy
#
# Deploys Web Application Firewall Policy with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: 

resource "azurerm_web_application_firewall_policy" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "waf-policy"
  })
}