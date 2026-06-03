# Azure Communication Services — Policy Definitions



## Definitions

- **`audit-communication-services-diagnostic-settings-v1`** — [FedRAMP High] Azure Communication Services: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`audit-communication-services-managed-identity-v1`** — [FedRAMP High] Azure Communication Services: Managed Identity Required
  - NIST 800-53: IA-2, AC-3

## Initiative — `fedramp-high-communication-services-v1`

Policy initiative for Azure Communication Services FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, IA-2, AC-3

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.Communication/communicationServices`
