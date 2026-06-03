# Azure Health Data Services — Policy Definitions



## Definitions

- **`audit-health-data-services-diagnostic-settings-v1`** — [FedRAMP High] Azure Health Data Services: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-health-data-services-public-network-access-v1`** — [FedRAMP High] Azure Health Data Services: Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3
- **`audit-health-data-services-managed-identity-v1`** — [FedRAMP High] Azure Health Data Services: Managed Identity Required
  - NIST 800-53: IA-2, AC-3
- **`audit-health-data-services-cmk-v1`** — [FedRAMP High] Azure Health Data Services: Customer-Managed Key Encryption
  - NIST 800-53: SC-12, SC-13, SC-28

## Initiative — `fedramp-high-health-data-services-v1`

Policy initiative for Azure Health Data Services FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3, IA-2, SC-12, SC-13, SC-28

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.HealthcareApis/workspaces`
