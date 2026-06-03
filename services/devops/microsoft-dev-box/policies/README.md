# Microsoft Dev Box — Policy Definitions



## Definitions

- **`audit-microsoft-dev-box-diagnostic-settings-v1`** — [FedRAMP High] Microsoft Dev Box: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`audit-microsoft-dev-box-managed-identity-v1`** — [FedRAMP High] Microsoft Dev Box: Managed Identity Required
  - NIST 800-53: IA-2, AC-3

## Initiative — `fedramp-high-microsoft-dev-box-v1`

Policy initiative for Microsoft Dev Box FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, IA-2, AC-3

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.DevCenter/devcenters`
