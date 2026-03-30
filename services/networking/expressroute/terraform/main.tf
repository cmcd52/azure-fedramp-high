# Terraform Module: ExpressRoute Circuit
#
# Deploys an Azure ExpressRoute circuit with FedRAMP High compliant defaults:
# Premium SKU, private peering configuration, diagnostic settings to Log
# Analytics, and MD5 authentication on BGP peering.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-8 (Transmission Confidentiality and Integrity),
#              SC-12 (Cryptographic Key Establishment and Management),
#              SC-13 (Cryptographic Protection),
#              AU-2 (Audit Events), AU-12 (Audit Generation)
#
# NOTE: ExpressRoute IS the private connectivity — no Private Endpoint is
# deployed. ExpressRoute provides a dedicated Layer 2/3 connection between
# on-premises and Azure that does not traverse the public internet.
#
# EDGE CASE: MACsec encryption requires ExpressRoute Direct and is configured
# on the ExpressRoute port resource, not the circuit. This module deploys the
# circuit resource. MACsec configuration on ExpressRoute Direct ports is a
# provider-level operation documented in controls/baseline.md.

# NIST 800-53: SC-7, SC-8 — Dedicated private connectivity circuit
resource "azurerm_express_route_circuit" "this" {
  name                  = var.circuit_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  service_provider_name = var.service_provider_name
  peering_location      = var.peering_location
  bandwidth_in_mbps     = var.bandwidth_in_mbps

  sku {
    tier   = "Premium"
    family = var.sku_family
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "expressroute"
  })
}

# NIST 800-53: SC-7 — Private peering (no public internet traffic)
# SC-8 — Encrypted BGP session with MD5 authentication
resource "azurerm_express_route_circuit_peering" "private" {
  peering_type                  = "AzurePrivatePeering"
  express_route_circuit_name    = azurerm_express_route_circuit.this.name
  resource_group_name           = var.resource_group_name
  peer_asn                      = var.peer_asn
  primary_peer_address_prefix   = var.primary_peer_address_prefix
  secondary_peer_address_prefix = var.secondary_peer_address_prefix
  vlan_id                       = var.vlan_id
  shared_key                    = var.shared_key # SC-8, SC-12: MD5 authentication for BGP session

  ipv4_enabled = true
}

# NIST 800-53: AU-2, AU-12 — Diagnostic settings for circuit monitoring
# OMB M-21-31 EL2: ExpressRoute circuit events to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.circuit_name}-diag"
  target_resource_id         = azurerm_express_route_circuit.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-2, AU-12: ARP table events for circuit health monitoring
  enabled_log {
    category = "PeeringRouteLog"
  }

  # AU-2, AU-12: Metrics for circuit utilization and health
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
