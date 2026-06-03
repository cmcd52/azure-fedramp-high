# Azure Digital Twins — Policy Definitions



## Definitions

- **`audit-digital-twins-diagnostic-settings-v1`** — [FedRAMP High] Azure Digital Twins: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-digital-twins-public-network-access-v1`** — [FedRAMP High] Azure Digital Twins: Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3
- **`audit-digital-twins-managed-identity-v1`** — [FedRAMP High] Azure Digital Twins: Managed Identity Required
  - NIST 800-53: IA-2, AC-3

## Initiative — `fedramp-high-digital-twins-v1`

Policy initiative for Azure Digital Twins FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3, IA-2

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.DigitalTwins/digitalTwinsInstances`
