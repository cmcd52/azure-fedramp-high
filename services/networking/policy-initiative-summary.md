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
