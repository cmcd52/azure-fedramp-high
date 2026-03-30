# Logging Configuration: ExpressRoute

**Service**: ExpressRoute
**Category**: Networking
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate) for circuit operational events

---

## Diagnostic Categories

All available ExpressRoute diagnostic log categories MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| PeeringRouteLog | BGP route table changes and route advertisements on peering sessions | EL2 | AU-2, AU-3, AU-12 |

### Metrics (AllMetrics)

The following metrics are collected via the AllMetrics category on the diagnostic setting:

| Metric | Description | Alert Threshold | NIST Control |
|--------|------------|-----------------|--------------|
| BitsInPerSecond | Inbound bits per second on the circuit | Utilization > 80% | SI-4 |
| BitsOutPerSecond | Outbound bits per second on the circuit | Utilization > 80% | SI-4 |
| ArpAvailability | ARP availability percentage (circuit health) | < 100% | CP-7, SI-4 |
| BgpAvailability | BGP availability percentage (peering health) | < 100% | CP-7, SI-4 |

### ExpressRoute Gateway Logs (if VNet Gateway is deployed)

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| GatewayDiagnosticLog | Gateway operational events | EL2 | AU-2, AU-12 |
| TunnelDiagnosticLog | IPsec tunnel events (if VPN over ER) | EL2 | AU-2, AU-12, SC-8 |
| RouteDiagnosticLog | Route change events on the gateway | EL2 | AU-2, AU-12 |
| IKEDiagnosticLog | IKE negotiation events (if VPN over ER) | EL2 | AU-2, AU-12, SC-8 |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The circuit resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.Network/expressRouteCircuits
Name: "{circuit_name}-diag"
Destination: Log Analytics workspace (shared)
Log Categories: PeeringRouteLog — Enabled
Metrics: AllMetrics — Enabled
```

---

## Retention

| Tier | Retention Period | Justification |
|------|-----------------|---------------|
| Hot (Log Analytics) | 90 days | Active query and alerting |
| Archive (Storage Account) | 7 years | FedRAMP AU-11 audit record retention |

---

## Alert Rules

The following alerts MUST be configured in the shared monitoring infrastructure:

| Alert Name | Condition | Severity | Action Group | NIST Control |
|-----------|-----------|----------|-------------|--------------|
| ExpressRoute Circuit Down | BgpAvailability < 100% for 5 minutes | Sev 0 (Critical) | NOC + Incident Response | CP-7, IR-6 |
| BGP State Change | PeeringRouteLog contains BGP state transition events | Sev 1 (Error) | NOC | SC-7, SI-4 |
| Circuit Utilization High | BitsInPerSecond or BitsOutPerSecond > 80% capacity for 15 minutes | Sev 2 (Warning) | NOC | CP-2 |
| ARP Availability Degraded | ArpAvailability < 100% for 5 minutes | Sev 1 (Error) | NOC | CP-7, SI-4 |

---

## Log Query Examples

### Circuit Health Check
```kusto
AzureMetrics
| where ResourceProvider == "MICROSOFT.NETWORK"
| where Resource contains "expressroute"
| where MetricName in ("BgpAvailability", "ArpAvailability")
| where Average < 100
| summarize MinAvailability = min(Average) by Resource, MetricName, bin(TimeGenerated, 5m)
```

### BGP Route Changes
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.NETWORK"
| where Category == "PeeringRouteLog"
| project TimeGenerated, Resource, OperationName, properties_s
| order by TimeGenerated desc
```
