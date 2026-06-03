# Terraform Module: VMs for DNS (Windows Server 2022)
#
# Deploys Windows Server 2022 Datacenter VMs for DNS forwarding with
# FedRAMP High compliant defaults: host-based encryption, FIPS mode,
# Azure Monitor Agent, Guest Configuration extension, private NIC only
# (no public IP — Bastion for access), and diagnostic settings.
#
# NIST 800-53: SC-7 (Boundary Protection),
#              SC-28 (Protection of Information at Rest),
#              CM-6 (Configuration Settings),
#              AU-2 (Audit Events), AU-12 (Audit Generation),
#              SI-7 (Software, Firmware, and Information Integrity)
#
# NOTE: These VMs complement the DNS Private Resolver for scenarios
# requiring custom DNS logic, conditional forwarding to legacy systems,
# or WINS resolution. Access is exclusively via Azure Bastion.
#
# EDGE CASE: FIPS mode is enabled via a custom script extension that
# sets the Windows registry key for CNG FIPS mode. This requires a
# reboot after initial provisioning.

# NIST 800-53: SC-7, SC-28 — Windows Server 2022 VM for DNS
resource "azurerm_windows_virtual_machine" "this" {
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.this.id]

  # SC-28: Host-based encryption for OS and temp disks
  encryption_at_host_enabled = true

  # SI-7: Secure boot and vTPM for integrity verification
  secure_boot_enabled = true
  vtpm_enabled        = true

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "vms-for-dns"
    role                 = "dns-forwarder"
  })
}

# NIST 800-53: SC-7 — Private NIC only, no public IP
resource "azurerm_network_interface" "this" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    # No public_ip_address_id — Bastion for access
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "vms-for-dns"
  })
}

# NIST 800-53: CM-6 — FIPS mode enablement via custom script
# Windows CNG module in FIPS mode — requires reboot
resource "azurerm_virtual_machine_extension" "fips_mode" {
  name                 = "${var.vm_name}-fips-mode"
  virtual_machine_id   = azurerm_windows_virtual_machine.this.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = "powershell -Command \"Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Lsa\\FipsAlgorithmPolicy' -Name Enabled -Value 1 -Type DWord; Write-Output 'FIPS mode enabled — reboot required'\""
  })

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
  })
}

# NIST 800-53: AU-2, AU-12 — Azure Monitor Agent for log collection
resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  name                       = "${var.vm_name}-ama"
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.0"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
  })

  depends_on = [azurerm_virtual_machine_extension.fips_mode]
}

# NIST 800-53: CM-6 — Guest Configuration extension for STIG compliance assessment
resource "azurerm_virtual_machine_extension" "guest_configuration" {
  name                       = "${var.vm_name}-guest-config"
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = "Microsoft.GuestConfiguration"
  type                       = "ConfigurationforWindows"
  type_handler_version       = "1.0"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
  })

  depends_on = [azurerm_virtual_machine_extension.azure_monitor_agent]
}

# NIST 800-53: SI-3 — Microsoft Defender for Endpoint (antimalware)
resource "azurerm_virtual_machine_extension" "antimalware" {
  name                       = "${var.vm_name}-antimalware"
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true

  settings = jsonencode({
    AntimalwareEnabled        = true
    RealtimeProtectionEnabled = "true"
    ScheduledScanSettings = {
      isEnabled = "true"
      scanType  = "Full"
      day       = "7"
      time      = "120"
    }
  })

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
  })

  depends_on = [azurerm_virtual_machine_extension.guest_configuration]
}

# NIST 800-53: AU-2, AU-12 — Data collection rule association for VM logs
resource "azurerm_monitor_data_collection_rule" "this" {
  name                = "${var.vm_name}-dcr"
  resource_group_name = var.resource_group_name
  location            = var.location

  destinations {
    log_analytics {
      workspace_resource_id = var.log_analytics_workspace_id
      name                  = "log-analytics-destination"
    }
  }

  data_flow {
    streams      = ["Microsoft-Event", "Microsoft-InsightsMetrics"]
    destinations = ["log-analytics-destination"]
  }

  # AU-2: Windows Security Event Log
  data_sources {
    windows_event_log {
      name    = "security-events"
      streams = ["Microsoft-Event"]
      x_path_queries = [
        "Security!*",
        "System!*",
        "Application!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]
    }

    performance_counter {
      name                          = "vm-performance"
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\% Committed Bytes In Use",
        "\\LogicalDisk(_Total)\\% Free Space",
        "\\Network Interface(*)\\Bytes Total/sec"
      ]
    }
  }

  tags = merge(var.tags, {
    compliance-framework = "FedRAMP-High"
    service              = "vms-for-dns"
  })
}

# Associate DCR with VM
resource "azurerm_monitor_data_collection_rule_association" "this" {
  name                    = "${var.vm_name}-dcr-assoc"
  target_resource_id      = azurerm_windows_virtual_machine.this.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.this.id
}

# NIST 800-53: AU-2, AU-12 — Diagnostic settings for VM boot diagnostics
resource "azurerm_monitor_diagnostic_setting" "nic" {
  name                       = "${var.vm_name}-nic-diag"
  target_resource_id         = azurerm_network_interface.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
