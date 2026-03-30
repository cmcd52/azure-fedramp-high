# Built-in Policy References: ExpressRoute

**Service**: ExpressRoute
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### ExpressRoute Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| ExpressRoute circuits should have resiliency plans | `de3f2c63-7abc-43e0-af39-e5e3e8e7e698` | Audit | CP-6, CP-7 | Verifies redundancy configuration |
| ExpressRoute gateways should not use classic deployment model | `59e88a17-43c2-47a3-9d44-6abb9b0e8d27` | Audit | CM-2 | Enforce ARM deployment model |

### Network Watcher Policies (Applicable to ExpressRoute Monitoring)

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Network Watcher should be enabled | `b6e2945c-0b7b-40f5-9233-7a5323b5cdc6` | Audit | AU-12, SI-4 | Required for ExpressRoute circuit monitoring |

> **Note**: The FedRAMP High built-in initiative (`d5264498-16f4-418a-b659-fa7ef418175f`) includes general networking policies but does not specifically target ExpressRoute encryption or peering configuration. Custom policies are required for MACsec and private peering enforcement.

---

## Custom Policy Requirement (per R-001)

Because built-in policy coverage does not address ExpressRoute-specific FedRAMP High controls, the following custom policy definitions have been created:

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `audit-expressroute-encryption-enabled-v1` | Audit | SC-8, SC-13 | MACsec encryption on ExpressRoute Direct |
| `audit-expressroute-private-peering-v1` | Audit | SC-7 | Private peering only — no Microsoft/public peering |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Policy built-in definitions for Network | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#network |
| 2 | ExpressRoute documentation | https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction |
| 3 | ExpressRoute Direct MACsec | https://learn.microsoft.com/en-us/azure/expressroute/expressroute-howto-macsec |
| 4 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
