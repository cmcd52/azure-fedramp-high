locals {
  # Subnet address space calculations
  # Assumes the first CIDR in address_space is used for subnet carving.
  # Default layout for a /16:
  #   /24 — Private Endpoints (256 addresses, ample for PE NICs)
  #   /26 — AzureBastionSubnet (minimum /26 required by Azure)
  #   /28 — DNS VMs / DNS Private Resolver
  base_cidr = var.address_space[0]

  private_endpoints_prefix = cidrsubnet(local.base_cidr, 8, 0)  # e.g. 10.0.0.0/24
  bastion_prefix           = cidrsubnet(local.base_cidr, 10, 4)  # e.g. 10.0.1.0/26
  dns_prefix               = cidrsubnet(local.base_cidr, 12, 16) # e.g. 10.0.1.0/28 (offset)
}
