# Terraform Module: Azure Bastion Host
#
# Deploys an Azure Bastion host (Standard SKU) with FedRAMP High compliant
# defaults: Standard SKU for session recording, AzureBastionSubnet, public
# IP (required by architecture), diagnostic settings, and restrictive NSG.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              AC-17 (Remote Access),
#              AU-3 (Content of Audit Records),
#              AU-12 (Audit Generation)
#
# NOTE: Bastion is the ONLY permitted method for administrative VM access
# per Constitution Principle VI. No direct RDP/SSH from the internet or
# VPN is permitted.
#
# APPROVED EXCEPTION: Bastion requires a public IP address
# (AzureBastionSubnet architecture requirement). This is an approved
# exception to the "no public IP" principle. The public IP is protected by:
# - NSG on AzureBastionSubnet with restrictive inbound/outbound rules
# - Azure DDoS Protection (inherited from VNet)
# - Bastion's TLS-encrypted HTML5 session (no direct RDP/SSH exposure)

# NIST 800-53: SC-7 — Public IP for Bastion (approved exception)
resource "azurerm_public_ip" "this" {
  name                = "${var.bastion_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "bastion"
    approved-exception   = "public-ip-required-by-bastion-architecture"
  })
}

# NIST 800-53: SC-7, AC-17 — Bastion host for privileged VM access
resource "azurerm_bastion_host" "this" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  # Standard SKU features required for FedRAMP High:
  # - Session recording (AU-3, AU-12)
  # - Native client support (AC-17)
  # - Shareable links with approval
  # - IP-based connection
  copy_paste_enabled     = true
  file_copy_enabled      = false
  tunneling_enabled      = true  # Native client support
  shareable_link_enabled = false # Disabled — use Azure AD auth only
  ip_connect_enabled     = true  # Connect by IP address

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = var.subnet_id # Must be AzureBastionSubnet
    public_ip_address_id = azurerm_public_ip.this.id
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "bastion"
  })
}

# NIST 800-53: SC-7 — NSG on AzureBastionSubnet with restrictive rules
resource "azurerm_network_security_group" "bastion" {
  name                = "${var.bastion_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Inbound: Allow HTTPS from Internet (Bastion control plane)
  security_rule {
    name                       = "AllowHttpsInbound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # Inbound: Allow Gateway Manager (Bastion control plane)
  security_rule {
    name                       = "AllowGatewayManagerInbound"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  # Inbound: Allow Azure Load Balancer health probes
  security_rule {
    name                       = "AllowAzureLoadBalancerInbound"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  # Inbound: Allow Bastion host communication
  security_rule {
    name                       = "AllowBastionHostCommunication"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["8080", "5701"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  # Outbound: Allow SSH/RDP to VirtualNetwork
  security_rule {
    name                       = "AllowSshRdpOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  # Outbound: Allow Azure Cloud communication
  security_rule {
    name                       = "AllowAzureCloudOutbound"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  }

  # Outbound: Allow Bastion host communication
  security_rule {
    name                       = "AllowBastionCommunicationOutbound"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["8080", "5701"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  # Outbound: Allow HTTP for certificate validation
  security_rule {
    name                       = "AllowHttpOutbound"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "bastion"
  })
}

# Associate NSG with AzureBastionSubnet
resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.bastion.id
}

# NIST 800-53: AU-2, AU-12 — Diagnostic settings for Bastion audit logs
# OMB M-21-31 EL3: Privileged access events to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.bastion_name}-diag"
  target_resource_id         = azurerm_bastion_host.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # AU-2, AU-3, AU-12: Bastion session audit logs (EL3 — privileged access)
  enabled_log {
    category = "BastionAuditLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
