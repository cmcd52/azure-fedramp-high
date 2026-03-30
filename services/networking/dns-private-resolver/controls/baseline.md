# Security Control Baseline: DNS Private Resolver

**Service**: DNS Private Resolver
**Category**: Networking
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure DNS Private Resolver provides inbound and outbound DNS resolution within the hub virtual network. It replaces the need for custom IaaS DNS forwarder VMs by offering a fully managed, highly available DNS resolution service. The resolver enables:

- **Inbound resolution**: On-premises clients and peered VNets can query Azure Private DNS Zones via the inbound endpoint IP
- **Outbound forwarding**: Azure workloads can resolve on-premises domains via conditional forwarding rules that route queries to on-prem DNS servers through ExpressRoute/VPN

**Configuration method**: Terraform (`terraform/main.tf`) deploys the resolver, inbound/outbound endpoints, forwarding ruleset, forwarding rules, VNet link, and diagnostic settings.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Network Contributor | Resource group (via PIM) | Manages DNS Private Resolver, endpoints, and forwarding rules. JIT activation required. | AC-2, AC-3, AC-6 |
| DNS Zone Contributor | Resource group (via PIM) | Manages forwarding rulesets and VNet links. JIT activation required. | AC-2, AC-3, AC-6 |
| Network Reader | Resource group | Read-only access to DNS resolver configuration for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to DNS resolver metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: Not applicable — DNS Private Resolver is a managed platform service that does not use Managed Identity
- Service-to-service: DNS resolution is network-level; no identity-based authentication between resolver and targets
- NIST: N/A

---

## Network Security Controls

### VNet Integration

- **Deployment**: Resolver must be deployed in the hub VNet per SC-7
- **Inbound endpoint**: Receives DNS queries from peered VNets and on-premises (via ExpressRoute/VPN)
- **Outbound endpoint**: Forwards DNS queries to on-premises DNS servers
- **Subnet requirements**: Dedicated subnets with delegation `Microsoft.Network/dnsResolvers`, minimum /28
- NIST: SC-7

### Forwarding Rules Security

| Rule Type | Source | Destination | Protocol | Port | NIST Control |
|-----------|--------|-------------|----------|------|--------------|
| Inbound DNS | Peered VNets / On-prem | Inbound endpoint IP | UDP/TCP | 53 | SC-7, SC-20 |
| Outbound forwarding | Outbound endpoint | On-prem DNS servers | UDP/TCP | 53 | SC-20, SC-21 |

### Forwarding Rule Governance

- Only approved on-premises domains may have forwarding rules
- Target DNS server IPs must be on-premises servers reachable via ExpressRoute/VPN (not public DNS)
- Wildcard domains (e.g., `.`) forwarding is prohibited in production — only specific domain suffixes
- Changes to forwarding rules require change management approval
- NIST: SC-20, SC-21

### Public Endpoint

- Status: Not applicable — DNS Private Resolver operates entirely within VNet, no public endpoint
- NIST: SC-7

---

## Encryption Controls

### Encryption at Rest

- Not applicable — DNS Private Resolver does not persist customer data. It is a query forwarding service.
- NIST: N/A

### Encryption in Transit

- Protocol: DNS over UDP/TCP (port 53) within the VNet and over ExpressRoute/VPN to on-prem
- Note: DNS traffic within the VNet is encrypted at the network layer by Azure's infrastructure encryption
- ExpressRoute: MACsec encryption on ExpressRoute Direct circuits provides link-layer encryption
- NIST: SC-8

---

## Logging & Monitoring Controls

- Diagnostic categories: DnsResolverLog
- Destination: Centralized Log Analytics workspace
- Retention: 90 days online / 7 years archived (production)
- OMB M-21-31 tier: EL2 — DNS query logs for network telemetry
- Alert rules: DNS query to known malicious domain
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Resolver deployed in hub VNet; no public endpoint; subnet-level isolation | Terraform: virtual_network_id, inbound/outbound subnet |
| SC-20 | Secure Name/Address Resolution — Authoritative Source | Inbound endpoint serves authoritative responses from Azure Private DNS Zones; forwarding rules for on-prem | Terraform: inbound endpoint, forwarding rules |
| SC-21 | Secure Name/Address Resolution — Recursive/Caching | Outbound endpoint forwards queries to trusted on-prem DNS servers; no public DNS forwarding | Terraform: outbound endpoint, forwarding ruleset |
| AU-2 | Audit Events | Diagnostic settings enabled for DNS resolver logs | Terraform: azurerm_monitor_diagnostic_setting |
| AU-12 | Audit Generation | All DNS query log categories forwarded to Log Analytics | logging/config.md |

## DISA STIG Mapping

No published DISA STIG for Azure DNS Private Resolver. Compensating controls: NIST 800-53 SC-20/SC-21 applied directly, DNS query logging for monitoring, VNet boundary enforcement.

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.13.1 Monitor communications at external boundaries | DNS resolver within hub VNet boundary; query logging | SC-7 |
| 3.13.8 Implement cryptographic mechanisms for CUI in transit | DNS within VNet encrypted at infrastructure layer; ExpressRoute MACsec | SC-8 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.1 | DNS query boundary enforcement via hub VNet deployment |
| SC.L2-3.13.8 | Infrastructure encryption for DNS traffic |

---
