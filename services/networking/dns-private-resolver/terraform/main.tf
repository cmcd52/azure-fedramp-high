# Terraform Module: DNS Private Resolver
#
# Deploys an Azure DNS Private Resolver with FedRAMP High compliant defaults:
# inbound endpoint for VNet DNS query reception, outbound endpoint for
# conditional forwarding to on-premises DNS servers, forwarding ruleset
# with domain-specific rules, and diagnostic settings to Log Analytics.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-20 (Secure Name/Address Resolution — Authoritative Source),
#              SC-21 (Secure Name/Address Resolution — Recursive/Caching),
#              AU-2 (Audit Events), AU-12 (Audit Generation)
#
# NOTE: DNS Private Resolver requires dedicated subnets with delegation
# Microsoft.Network/dnsResolvers. Inbound and outbound endpoints must use
# separate subnets. Minimum subnet size is /28.
#
# EDGE CASE: The resolver is deployed in the hub VNet. Spoke VNets resolve
# DNS via VNet peering to the hub. On-premises DNS queries are forwarded
# via the outbound endpoint through ExpressRoute/VPN.

# NIST 800-53: SC-7, SC-20 — DNS resolver within hub VNet boundary
resource "azurerm_private_dns_resolver" "this" {
  name                = var.resolver_name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = var.virtual_network_id

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "dns-private-resolver"
  })
}

# NIST 800-53: SC-7, SC-20 — Inbound endpoint receives DNS queries from VNet/peered VNets
resource "azurerm_private_dns_resolver_inbound_endpoint" "this" {
  name                    = "${var.resolver_name}-inbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = var.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = var.inbound_subnet_id
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "dns-private-resolver"
    endpoint-type        = "inbound"
  })
}

# NIST 800-53: SC-20, SC-21 — Outbound endpoint forwards queries to on-prem DNS
resource "azurerm_private_dns_resolver_outbound_endpoint" "this" {
  name                    = "${var.resolver_name}-outbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = var.location
  subnet_id               = var.outbound_subnet_id

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "dns-private-resolver"
    endpoint-type        = "outbound"
  })
}

# NIST 800-53: SC-20, SC-21 — Forwarding ruleset for on-prem domain resolution
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "this" {
  name                                       = "${var.resolver_name}-ruleset"
  resource_group_name                        = var.resource_group_name
  location                                   = var.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.this.id]

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "dns-private-resolver"
  })
}

# NIST 800-53: SC-20, SC-21 — Individual forwarding rules for on-prem domains
resource "azurerm_private_dns_resolver_forwarding_rule" "this" {
  for_each = { for rule in var.forwarding_rules : rule.domain_name => rule }

  name                      = each.value.name
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  domain_name               = each.value.domain_name
  enabled                   = true

  dynamic "target_dns_servers" {
    for_each = each.value.target_dns_servers
    content {
      ip_address = target_dns_servers.value.ip_address
      port       = lookup(target_dns_servers.value, "port", 53)
    }
  }
}

# NIST 800-53: SC-7 — Link forwarding ruleset to hub VNet
resource "azurerm_private_dns_resolver_virtual_network_link" "this" {
  name                      = "${var.resolver_name}-vnet-link"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  virtual_network_id        = var.virtual_network_id
}

# NIST 800-53: AU-2, AU-12 — Diagnostic settings for DNS Private Resolver
# OMB M-21-31 EL2: DNS query logs to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.resolver_name}-diag"
  target_resource_id         = azurerm_private_dns_resolver.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-2, AU-12: DNS resolver query events
  enabled_log {
    category = "DnsResolverLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
