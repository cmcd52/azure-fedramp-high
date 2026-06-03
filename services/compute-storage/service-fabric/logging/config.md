# Azure Service Fabric — Diagnostic Logging Configuration



**Service**: Azure Service Fabric
**ARM Resource Type**: `Microsoft.ServiceFabric/clusters`
**Logging Strategy**: See [shared logging strategy](../../../../shared/logging-strategy.md)

---

## Log Sinks

All logs from this service flow to the central Log Analytics workspace per the [shared logging strategy](../../../../shared/logging-strategy.md).

| Sink | Configuration | Retention |
|------|---------------|-----------|
| Log Analytics workspace | `Microsoft.Insights/diagnosticSettings` with `workspaceId` set to the central workspace | 365 days online |
| Storage account (archive) | Optional secondary sink via `storageAccountId` for low-cost long-term retention | 540 days archive (OMB M-21-31 EL3) |
| Microsoft Sentinel | Sentinel onboarded to the central workspace; detection rules consume the same data | (Lives in Log Analytics retention) |

## Diagnostic Settings

This service emits diagnostic logs and metrics to Azure Monitor. Enable ALL available log categories via Terraform's `azurerm_monitor_diagnostic_setting` resource.

### Required Log Categories (verify against current service capabilities at approval review)

| Category | NIST Control | Purpose |
|----------|--------------|---------|
| AuditLogs | AU-2, AU-12 | Control-plane and management actions |
| ResourceLogs | AU-2, AU-12 | Data-plane operations |
| Metrics | CA-7 | Continuous monitoring (capacity, latency, error rates) |

## Retention (OMB M-21-31)

- **Online (Log Analytics)**: 12 months minimum (EL2). Configured at the workspace level.
- **Archive (Storage)**: 18 months minimum (EL3 — full event-level logging). Configured per diagnostic setting via `storageAccountId`.
- Retention policies are enforced by the [shared Log Analytics module](../../../../shared/terraform/log-analytics/).

## Alerting

- High-severity service health and security signals route to the SOC via Microsoft Sentinel analytics rules and Action Groups (NIST IR-4, IR-5).
- Cost-anomaly alerts route to FinOps via Azure Cost Management (NIST CA-7).

## References

- Shared logging strategy: <../../../../shared/logging-strategy.md>
- Azure Monitor diagnostic settings: <https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings>
- OMB Memorandum M-21-31: <https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf>
- Azure Service Fabric log categories: <https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/microsoft-servicefabric-clusters-logs>

---

**Version**: 0.1.0 (template) | **Generated**: 2026-04-28
