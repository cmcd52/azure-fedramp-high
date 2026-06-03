# Networking Services — Policy Initiative Summary

> **Version**: 1.0.0 | **Date**: 2026-03-27 | **FR**: FR-007

## Custom Initiatives

### Network Security Initiative

Each networking service defines its own initiative. These are grouped under a management-group-level assignment.

| Service | Initiative | Scope | Policy Count |
|---------|-----------|-------|-------------|
| ExpressRoute | expressroute-fedramp-high | Connectivity subscription | 2 |
| Azure Front Door | frontdoor-fedramp-high | App subscription(s) | 3 |
| Bastion | bastion-fedramp-high | Hub subscription | 2 |
| DNS Private Resolver | dns-resolver-fedramp-high | Hub subscription | 2 |
| Private DNS Zone | private-dns-fedramp-high | Hub subscription | 2 |
| Private Endpoint | private-endpoint-fedramp-high | Root management group | 3 |
| VMs for DNS | vms-dns-fedramp-high | Hub subscription | 4 |
| Azure Monitor | azure-monitor-fedramp-high | Root management group | 3 |
| Application Insights | appinsights-fedramp-high | App subscription(s) | 2 |

### Common Policy Patterns

All networking service initiatives follow these patterns:

| Pattern | Effect (Prod) | Effect (Lower) | NIST Control | Applied To |
|---------|---------------|----------------|-------------|-----------|
| Deny public network access | Deny | Audit | SC-7 | All except Bastion (exception) |
| Require diagnostic settings | DeployIfNotExists | AuditIfNotExists | AU-2, AU-12 | All services |
| Require Private Endpoint | Deny | Audit | SC-7 | All PE-capable services |
| Require TLS 1.2 | Deny | Deny | SC-8, SC-13 | All services with TLS config |
| Require managed identity | Audit | Audit | IA-2 | VMs for DNS, App Insights |

## Built-In Policy References

| Service | Built-In Policy | NIST Control |
|---------|----------------|-------------|
| ExpressRoute | ExpressRoute should have diagnostic logs | AU-2 |
| Front Door | Azure Front Door should have WAF enabled | SC-7 |
| Bastion | Azure Bastion should use diagnostic logs | AU-2 |
| Private Endpoint | Private endpoints should be enabled | SC-7 |
| Azure Monitor | Log Analytics workspace should have diagnostic logs | AU-2 |
| All Networking | Network interfaces should not have public IPs | SC-7 |

## Assignment Strategy

- **Root Management Group**: Private Endpoint, Azure Monitor initiatives
- **Hub/Connectivity Subscription**: ExpressRoute, Bastion, DNS Resolver, Private DNS, VMs for DNS
- **App Subscriptions**: Front Door, Application Insights
- **Exemption Process**: Per organizational policy lifecycle governance

---

*Networking Services — Azure Policy compliance artifacts.*


## Wave 2 (Pending Approval)

_Generated 2026-04-28 by `scripts/wave2/generate.py`. Each row is **** per FedRAMP High compliance baseline._

| Initiative | Service | NIST Families | Path |
|---|---|---|---|
| `fedramp-high-application-gateway-v1` | Application Gateway | SC, AU, SI | [policies/](./application-gateway/policies/) |
| `fedramp-high-azure-cdn-v1` | Azure CDN (Microsoft) | SC, AU | [policies/](./azure-cdn/policies/) |
| `fedramp-high-azure-firewall-v1` | Azure Firewall | SC, AU, SI | [policies/](./azure-firewall/policies/) |
| `fedramp-high-ddos-protection-v1` | Azure DDoS Protection | SC, SI | [policies/](./ddos-protection/policies/) |
| `fedramp-high-load-balancer-v1` | Azure Load Balancer | SC, AU | [policies/](./load-balancer/policies/) |
| `fedramp-high-nat-gateway-v1` | NAT Gateway | SC | [policies/](./nat-gateway/policies/) |
| `fedramp-high-network-security-group-v1` | Network Security Group | SC, AC, AU | [policies/](./network-security-group/policies/) |
| `fedramp-high-network-watcher-v1` | Network Watcher | AU, SC | [policies/](./network-watcher/policies/) |
| `fedramp-high-private-link-service-v1` | Azure Private Link Service | SC, AC | [policies/](./private-link-service/policies/) |
| `fedramp-high-public-ip-v1` | Azure Public IP Address | SC | [policies/](./public-ip/policies/) |
| `fedramp-high-route-server-v1` | Route Server | SC, AU | [policies/](./route-server/policies/) |
| `fedramp-high-traffic-manager-v1` | Traffic Manager | SC, AU | [policies/](./traffic-manager/policies/) |
| `fedramp-high-virtual-network-v1` | Virtual Network | SC, AC, AU | [policies/](./virtual-network/policies/) |
| `fedramp-high-virtual-wan-v1` | Virtual WAN | SC, AU | [policies/](./virtual-wan/policies/) |
| `fedramp-high-vpn-gateway-v1` | VPN Gateway | SC, IA, AU | [policies/](./vpn-gateway/policies/) |
| `fedramp-high-waf-policy-v1` | Web Application Firewall Policy | SC, SI | [policies/](./waf-policy/policies/) |
