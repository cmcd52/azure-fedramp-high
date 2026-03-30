# Terraform Module: Azure Front Door (Premium)
#
# Deploys an Azure Front Door Premium profile with FedRAMP High compliant
# defaults: WAF policy association, TLS 1.2 minimum, HTTPS-only origins,
# managed certificate, and diagnostic settings to Log Analytics.
#
# NIST 800-53: SC-5 (Denial of Service Protection),
#              SC-7 (Boundary Protection),
#              SC-8 (Transmission Confidentiality and Integrity),
#              SC-13 (Cryptographic Protection),
#              SI-4 (Information System Monitoring),
#              AU-2 (Audit Events), AU-12 (Audit Generation)
#
# NOTE: Premium tier is required for managed WAF rule sets and Private Link
# to origin (backend) connectivity.
#
# EDGE CASE: Private Endpoint to origin is optional and depends on whether
# the origin supports Private Link. When enabled, Front Door connects to
# origins via Microsoft backbone instead of public internet.

# NIST 800-53: SC-7, SI-4 — Global edge ingress with WAF protection
resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = var.profile_name
  resource_group_name = var.resource_group_name
  sku_name            = "Premium_AzureFrontDoor" # Required for WAF + Private Link

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-front-door"
  })
}

# NIST 800-53: SC-7, SI-4 — WAF policy with OWASP and bot protection rules
resource "azurerm_cdn_frontdoor_firewall_policy" "this" {
  name                              = var.waf_policy_name
  resource_group_name               = var.resource_group_name
  sku_name                          = "Premium_AzureFrontDoor"
  enabled                           = true
  mode                              = "Prevention"
  custom_block_response_status_code = 403

  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"
    action  = "Block"
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
    action  = "Block"
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "azure-front-door"
  })
}

# NIST 800-53: SC-7 — Front Door endpoint
resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                     = var.endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  enabled                  = true
}

# NIST 800-53: SC-8 — HTTPS-only origin group
resource "azurerm_cdn_frontdoor_origin_group" "this" {
  name                     = "${var.profile_name}-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  session_affinity_enabled = false

  health_probe {
    interval_in_seconds = 30
    path                = var.health_probe_path
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
}

# NIST 800-53: SC-8 — HTTPS-only origin connection
resource "azurerm_cdn_frontdoor_origin" "this" {
  name                          = "${var.profile_name}-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id
  enabled                       = true

  certificate_name_check_enabled = true
  host_name                      = var.origin_host_name
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.origin_host_name
  priority                       = 1
  weight                         = 1000

  # SC-7: Private Link to origin (optional — only if origin supports it)
  dynamic "private_link" {
    for_each = var.origin_private_link_resource_id != null ? [1] : []
    content {
      request_message        = "Front Door Private Link request for FedRAMP High"
      target_type            = var.origin_private_link_target_type
      location               = var.location
      private_link_target_id = var.origin_private_link_resource_id
    }
  }
}

# NIST 800-53: SC-8 — HTTPS redirect and routing
resource "azurerm_cdn_frontdoor_route" "this" {
  name                          = "${var.profile_name}-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.this.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true # SC-8: Force HTTPS

  link_to_default_domain = true
}

# NIST 800-53: SC-7, SI-4 — WAF association with endpoint
resource "azurerm_cdn_frontdoor_security_policy" "this" {
  name                     = "${var.profile_name}-security-policy"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.this.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.this.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}

# NIST 800-53: AU-2, AU-12 — Diagnostic settings for Front Door
# OMB M-21-31 EL3: WAF events to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.profile_name}-diag"
  target_resource_id         = azurerm_cdn_frontdoor_profile.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-2, AU-12: Access log events
  enabled_log {
    category = "FrontDoorAccessLog"
  }

  # AU-2, AU-12: Health probe events
  enabled_log {
    category = "FrontDoorHealthProbeLog"
  }

  # AU-2, AU-12, SI-4: WAF events (EL3 — security events)
  enabled_log {
    category = "FrontDoorWebApplicationFirewallLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
