# Azure HPC — Policy Definitions



## Definitions

- **`audit-hpc-diagnostic-settings-v1`** — [FedRAMP High] Azure HPC: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`audit-hpc-managed-identity-v1`** — [FedRAMP High] Azure HPC: Managed Identity Required
  - NIST 800-53: IA-2, AC-3

## Initiative — `fedramp-high-hpc-v1`

Policy initiative for Azure HPC FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, IA-2, AC-3

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.Batch/batchAccounts`
