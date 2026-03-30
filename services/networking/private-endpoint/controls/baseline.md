# Security Control Baseline: Private Endpoint

**Service**: Private Endpoint
**Category**: Networking
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Private Endpoint is the primary network isolation mechanism for the FedRAMP High environment. A Private Endpoint creates a network interface with a private IP address in a VNet subnet, connecting to an Azure service over the Microsoft backbone. This ensures all traffic between the VNet and the service traverses the private network — never the public internet.

Every Azure service that supports Private Endpoints MUST use them. The PE module (`terraform/main.tf`) is the shared reusable pattern consumed by all service-specific Terraform modules.

**Configuration method**: Terraform module called by each service module. The PE module accepts `resource_id`, `subresource_name`, `subnet_id`, and `private_dns_zone_id` as inputs.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Network Contributor | Resource group (via PIM) | Creates and manages Private Endpoints and network interfaces. JIT activation required. | AC-2, AC-3, AC-6 |
| Private DNS Zone Contributor | DNS resource group (via PIM) | Required for DNS zone group creation on PE. JIT activation required. | AC-2, AC-3, AC-6 |
| Reader | Resource group | Read-only access to PE configuration for auditors. Standing assignment. | AC-3, AU-6 |

### Managed Identity

- Type: Not applicable — Private Endpoints are network resources, not compute services
- NIST: N/A

---

## Network Security Controls

### DNS Integration

- **DNS zone group**: Every PE MUST have a DNS zone group configured per `audit-privateendpoint-dns-configured-v1` policy
- **Automatic registration**: DNS zone group automatically creates an A record in the Private DNS Zone pointing to the PE's private IP
- **Resolution flow**: Client → VNet DNS → Private DNS Zone → PE private IP → Service
- **Without DNS zone group**: DNS resolves to the service's public IP, bypassing PE entirely — this is a critical misconfiguration
- NIST: SC-7, SC-20

### NSG on PE Subnet

- **Requirement**: PE subnet MUST have an NSG associated per `audit-privateendpoint-nsg-v1` policy
- **Network policies**: `privateEndpointNetworkPolicies` must be set to `Enabled` on the subnet to allow NSG rules to apply to PE traffic
- **NSG rules**: Allow only required traffic from known source subnets to PE subnet
- NIST: SC-7

### Manual Approval Workflow

- **Default**: Auto-approved for first-party Azure services within the same tenant
- **Manual approval**: Required for cross-tenant or third-party service connections
- **Approval process**: Connection request reviewed by Network Security team, approved via Azure Portal or API
- NIST: AC-3

### Public Endpoint

- Status: Not applicable — PE is a network resource, not a service with a public endpoint
- Note: Services connected via PE should have their public endpoint disabled (`publicNetworkAccess = Disabled`)
- NIST: SC-7

---

## Encryption Controls

### Encryption at Rest

- Not applicable — Private Endpoints do not store data
- NIST: N/A

### Encryption in Transit

- Protocol: PE traffic traverses the Azure backbone — encrypted at the platform infrastructure layer
- Service-level encryption: TLS 1.2+ is enforced at the service level (e.g., Storage, Key Vault), not at the PE level
- NIST: SC-8

---

## Logging & Monitoring Controls

- Diagnostic categories: Limited — PE connection state is logged via the parent resource's diagnostic settings, not the PE itself
- Network interface diagnostics: NIC flow logs via NSG flow logs on the PE subnet
- Destination: Centralized Log Analytics workspace
- OMB M-21-31 tier: EL1 — PE configuration tracked via Activity Log
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | PE creates private network path; subnet NSG controls traffic; public endpoint disabled | Terraform: PE module, NSG rules, publicNetworkAccess = Disabled |
| SC-20 | Secure Name/Address Resolution — Authoritative Source | DNS zone group registers PE IP in Private DNS Zone | Terraform: private_dns_zone_group block |
| AC-3 | Access Enforcement | RBAC for PE management; manual approval for cross-tenant connections | PIM role assignments |
| AU-2 | Audit Events | PE creation/deletion tracked via Activity Log; parent resource diagnostics | Azure Activity Log |

## DISA STIG Mapping

No published DISA STIG for Azure Private Endpoints. Compensating controls: NIST 800-53 SC-7 applied directly, NSG enforcement on PE subnets, DNS zone group verification.

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.13.1 Monitor communications at external boundaries | PE ensures traffic stays on private network; no public internet path | SC-7 |
| 3.13.2 Employ architectural designs to protect CUI | PE + DNS zone group + NSG = defense-in-depth for CUI data access | SC-7, SC-20 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.1 | Private Endpoint network isolation |
| SC.L2-3.13.2 | PE + DNS + NSG layered security architecture |

---
