# Azure Data Share — Policy Definitions



## Definitions

- **`audit-data-share-diagnostic-settings-v1`** — [FedRAMP High] Azure Data Share: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`audit-data-share-managed-identity-v1`** — [FedRAMP High] Azure Data Share: Managed Identity Required
  - NIST 800-53: IA-2, AC-3

## Initiative — `fedramp-high-data-share-v1`

Policy initiative for Azure Data Share FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, IA-2, AC-3

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.DataShare/accounts`
