# Security Control Baseline: ExpressRoute

**Service**: ExpressRoute
**Category**: Networking
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure ExpressRoute provides dedicated private connectivity between on-premises networks and Azure datacenters. Traffic does not traverse the public internet. ExpressRoute is the foundational network boundary control for FedRAMP High environments, ensuring all hybrid connectivity flows over a dedicated, provider-managed Layer 2/3 path.

ExpressRoute circuits are provisioned through a service provider (e.g., Equinix, AT&T) or directly via ExpressRoute Direct (dedicated physical ports). Private peering connects to Azure VNets; Microsoft peering connects to Microsoft 365 and Azure PaaS endpoints (disabled in this environment per SC-7). Note: M365 interoperability considerations over ExpressRoute Microsoft peering are out of scope for this content.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the circuit and private peering. MACsec configuration on ExpressRoute Direct is a provider-level operation via Azure portal or CLI.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Network Contributor | Resource group (via PIM) | Manages ExpressRoute circuit configuration, peering, and route filters. JIT activation required. | AC-2, AC-3, AC-6 |
| Monitoring Reader | Resource group | Read-only access to circuit metrics and diagnostic data for NOC team. Standing assignment. | AU-6 |
| Reader | Resource group | Read-only access for auditors and security team. Standing assignment. | AC-3 |

### Managed Identity

- Type: Not applicable — ExpressRoute circuits do not use Managed Identity
- Service-to-service: ExpressRoute provides network connectivity; services using the circuit authenticate independently via their own identities
- NIST: N/A

---

## Encryption Controls

### MACsec Encryption (802.1AE)

- **Availability**: ExpressRoute Direct only (dedicated physical ports)
- **Scope**: Layer 2 encryption between customer edge router and Microsoft edge router
- **Cipher suites**: GcmAes128, GcmAes256 (FIPS 140-2 validated)
- **Key management**: Customer-managed keys stored in Azure Key Vault
- **Configuration**: Azure portal or CLI on the ExpressRoute port resource
- **FIPS reference**: MACsec uses AES-GCM which is FIPS 140-2 approved. Validate that the network equipment (customer edge) uses FIPS-validated cryptographic modules.
- NIST: SC-8, SC-12, SC-13

### BGP Security

- **MD5 authentication**: Configured on private peering BGP sessions via `shared_key`
- **Purpose**: Prevents BGP session hijacking and route injection attacks
- **Key rotation**: Coordinate with service provider; rotate at least annually
- NIST: SC-8, SC-12

### IPsec over ExpressRoute (Optional Layer 3)

- **Availability**: VPN Gateway over ExpressRoute private peering
- **Use case**: Additional encryption layer when MACsec is not available (standard circuits)
- **Cipher suites**: AES-256-GCM, SHA-384 (FIPS compliant)
- NIST: SC-8, SC-13

---

## Network Controls

### Private Peering Configuration

- **Peering type**: AzurePrivatePeering ONLY
- **Microsoft peering**: DISABLED — not permitted in FedRAMP High environment per SC-7
- **Public peering**: DEPRECATED and DISABLED
- **Route filters**: Applied to limit advertised routes to required prefixes only
- NIST: SC-7

### Circuit Redundancy

- **Requirement**: Two circuits from geographically diverse peering locations
- **Active-active**: Both circuits active with equal-cost multi-path (ECMP)
- **Failover**: Automatic BGP convergence on circuit failure
- NIST: CP-6, CP-7

### No DISA STIG

- Per R-002: No DISA STIG exists for Azure ExpressRoute
- Compensating controls: NIST 800-53 controls applied directly, CIS Azure benchmark networking sections, Microsoft security baseline documentation

---

## NIST 800-53 Control Mapping

| Control | Implementation | Evidence |
|---------|---------------|----------|
| SC-7 | Private peering only; no Microsoft/public peering; route filters restrict advertised prefixes | Terraform: peering_type = AzurePrivatePeering; policy: audit-expressroute-private-peering-v1 |
| SC-8 | MACsec (ExpressRoute Direct) or IPsec (VPN Gateway over ER); MD5 BGP authentication | MACsec config on ER port; shared_key on peering; controls documented above |
| SC-12 | MACsec keys in Azure Key Vault; MD5 shared key managed via Terraform sensitive variable | Key Vault key_id reference; Terraform state encryption |
| SC-13 | AES-GCM (MACsec), AES-256-GCM (IPsec) — FIPS 140-2 validated algorithms | Cipher suite configuration on ER Direct port and VPN Gateway |
| AU-2 | Diagnostic settings enabled for circuit logs | Terraform: azurerm_monitor_diagnostic_setting |
| AU-12 | All available log categories forwarded to Log Analytics | logging/config.md |
| CP-6 | Dual circuits from diverse peering locations | Architecture documentation |
| CP-7 | Automatic BGP failover between redundant circuits | Circuit configuration |

---
