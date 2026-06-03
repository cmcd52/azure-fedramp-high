# Azure Managed Disks — Policy Definitions



## Definitions

- **`audit-managed-disks-diagnostic-settings-v1`** — [FedRAMP High] Azure Managed Disks: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-managed-disks-public-network-access-v1`** — [FedRAMP High] Azure Managed Disks: Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3
- **`audit-managed-disks-cmk-v1`** — [FedRAMP High] Azure Managed Disks: Customer-Managed Key Encryption
  - NIST 800-53: SC-12, SC-13, SC-28

## Initiative — `fedramp-high-managed-disks-v1`

Policy initiative for Azure Managed Disks FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3, SC-12, SC-13, SC-28

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.Compute/disks`
