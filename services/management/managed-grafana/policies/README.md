# Azure Managed Grafana — Policy Definitions



## Definitions

- **`audit-managed-grafana-diagnostic-settings-v1`** — [FedRAMP High] Azure Managed Grafana: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-managed-grafana-public-network-access-v1`** — [FedRAMP High] Azure Managed Grafana: Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3
- **`audit-managed-grafana-managed-identity-v1`** — [FedRAMP High] Azure Managed Grafana: Managed Identity Required
  - NIST 800-53: IA-2, AC-3

## Initiative — `fedramp-high-managed-grafana-v1`

Policy initiative for Azure Managed Grafana FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3, IA-2

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.Dashboard/grafana`
