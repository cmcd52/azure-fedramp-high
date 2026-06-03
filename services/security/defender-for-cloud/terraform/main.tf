# Terraform Module: Microsoft Defender for Cloud
#
# Deploys Microsoft Defender for Cloud with FedRAMP High compliant configuration.
# NIST 800-53 Rev 5: 

resource "azurerm_security_center_subscription_pricing" "this" {

  tier = "Standard"

  resource_type = "VirtualMachines"
}