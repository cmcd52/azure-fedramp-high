# Security Control Baseline: Private DNS Zone

**Service**: Private DNS Zone
**Category**: Networking
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Private DNS Zones provide internal name resolution for Private Endpoints and internal services within the hub-spoke network topology. Every Azure service with a Private Endpoint requires a corresponding Private DNS Zone (e.g., `privatelink.blob.core.windows.net` for Storage, `privatelink.vaultcore.azure.net` for Key Vault) to route DNS queries to the private IP address of the endpoint instead of the public endpoint.

Private DNS Zones are the foundation of the network isolation strategy — without properly configured zones and VNet links, Private Endpoints would not resolve correctly and traffic could fall back to public endpoints.

**Configuration method**: Common privatelink zones are deployed via `shared/terraform/private-dns-zones/`. Additional per-service zones use the module in `terraform/main.tf`. Zone management is via Terraform only — manual portal changes are prohibited.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Private DNS Zone Contributor | Resource group (via PIM) | Manages DNS zones, record sets, and VNet links. JIT activation required. | AC-2, AC-3, AC-6 |
| Network Contributor | Resource group (via PIM) | Required for VNet link creation. JIT activation required. | AC-2, AC-3, AC-6 |
| DNS Zone Reader | Resource group | Read-only access for auditors and NOC team. Standing assignment. | AC-3, AU-6 |

### Managed Identity

- Type: Not applicable — Private DNS Zones are configuration resources, not compute services
- NIST: N/A

---

## Network Security Controls

### VNet Link Security

- **Hub VNet link**: Required for all Private DNS Zones — ensures zones resolve from the hub
- **Spoke VNet links**: Added for spoke VNets that need direct resolution (alternative: spoke VNets resolve via hub DNS via peering)
- **Auto-registration**: Disabled for privatelink zones (PE records are managed by DNS zone groups). Enabled only for internal zones (e.g., `contoso.internal`) if VM auto-registration is needed
- NIST: SC-7

### Record Management Policy

- All DNS records MUST be managed via Terraform or DNS zone groups on Private Endpoints
- Manual record creation via Azure Portal is prohibited
- A records must resolve to private IP addresses only (RFC 1918) — enforced by `deny-privatednszones-public-records-v1` policy
- CNAME records must point to internal FQDNs only
- Wildcard records are prohibited
- NIST: SC-20

### Zone Access RBAC

- Private DNS Zone Contributor role is assigned at resource group scope via PIM
- No standing write access to DNS zones
- All zone modifications are tracked via Azure Activity Log
- NIST: AC-3, AC-6

### Public Endpoint

- Status: Not applicable — Private DNS Zones are internal resources with no public endpoint
- NIST: SC-7

---

## Encryption Controls

### Encryption at Rest

- Not applicable — DNS zone data is managed by the Azure platform. No customer data storage.
- NIST: N/A

### Encryption in Transit

- DNS queries within VNet are handled by Azure platform DNS infrastructure
- DNS queries from on-premises traverse ExpressRoute with MACsec encryption
- NIST: SC-8

---

## Logging & Monitoring Controls

- Diagnostic categories: Limited — Private DNS Zones have minimal native diagnostic log support
- Query logging: Achieved via DNS Private Resolver integration (see `services/networking/dns-private-resolver/logging/config.md`)
- Zone change tracking: Azure Activity Log captures all zone/record modifications
- Destination: Centralized Log Analytics workspace (Activity Log)
- OMB M-21-31 tier: EL1 — zone configuration changes via Activity Log
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | VNet links ensure DNS resolves within trusted boundary; no public records policy | Terraform: VNet link, policy: deny-privatednszones-public-records-v1 |
| SC-20 | Secure Name/Address Resolution — Authoritative Source | Private DNS Zones serve as authoritative source for privatelink domains; records managed by PE DNS zone groups | Terraform: zone + PE integration |
| SC-21 | Secure Name/Address Resolution — Recursive/Caching | Resolution chain: VNet DNS → Private DNS Zone → private IP; no public fallback | VNet DNS configuration + zone link |
| AU-2 | Audit Events | Activity Log captures zone and record modifications | Azure Activity Log |
| AU-12 | Audit Generation | All zone changes forwarded to Log Analytics via Activity Log diagnostic settings | logging/config.md |

## DISA STIG Mapping

No published DISA STIG for Azure Private DNS Zones. Compensating controls: NIST 800-53 SC-20/SC-21 applied directly, zone modification tracking via Activity Log, RBAC enforcement via PIM.

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.13.1 Monitor communications at external boundaries | DNS resolution within VNet boundary; no public record leakage | SC-7 |
| 3.13.2 Employ architectural designs to protect CUI | Private DNS Zones ensure PE traffic resolves to private IPs | SC-7, SC-20 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.1 | VNet-linked DNS zones for boundary enforcement |
| SC.L2-3.13.2 | Private DNS resolution architecture |

---
