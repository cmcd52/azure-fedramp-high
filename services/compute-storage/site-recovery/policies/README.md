# Azure Site Recovery — Policy Definitions



## Definitions

- **`audit-site-recovery-diagnostic-settings-v1`** — [FedRAMP High] Azure Site Recovery: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`audit-site-recovery-managed-identity-v1`** — [FedRAMP High] Azure Site Recovery: Managed Identity Required
  - NIST 800-53: IA-2, AC-3
- **`audit-site-recovery-cmk-v1`** — [FedRAMP High] Azure Site Recovery: Customer-Managed Key Encryption
  - NIST 800-53: SC-12, SC-13, SC-28

## Initiative — `fedramp-high-site-recovery-v1`

Policy initiative for Azure Site Recovery FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, IA-2, AC-3, SC-12, SC-13, SC-28

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.RecoveryServices/vaults`
