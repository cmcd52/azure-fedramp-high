# Built-in Policy References: DNS Private Resolver

**Service**: DNS Private Resolver
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Azure DNS Private Resolver Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| (Minimal built-in coverage) | — | — | — | — |

> **Note (per R-001)**: Azure DNS Private Resolver has minimal built-in Azure Policy coverage. Custom policies are required to enforce hub VNet integration and forwarding rule configuration for FedRAMP High compliance. Microsoft has not published dedicated built-in policies for the DNS Private Resolver resource type as of this writing.

### Related Built-in Policies (DNS / Network)

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Virtual networks should use specified virtual network gateway | `f1776c76-f58c-4245-a9d0-bf0522e84f48` | Audit | SC-7 | VNet routing enforcement (related but not DNS-specific) |

---

## Custom Policy Requirement (per R-001)

Custom policy definitions are required for comprehensive FedRAMP High coverage due to minimal built-in support:

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `audit-dnsresolver-vnet-link-v1` | Audit | SC-7, SC-20 | Resolver must be deployed in hub VNet |
| `audit-dnsresolver-forwarding-rules-v1` | Audit | SC-20, SC-21 | Forwarding rules must exist for on-prem DNS resolution |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure DNS Private Resolver documentation | https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview |
| 2 | Azure DNS Private Resolver endpoints | https://learn.microsoft.com/en-us/azure/dns/private-resolver-endpoints-dns-resolution |
| 3 | Azure Policy built-in definitions for Network | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#network |
| 4 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
