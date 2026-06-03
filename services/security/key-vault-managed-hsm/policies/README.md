# Azure Key Vault Managed HSM — Policy Definitions



## Definitions

- **`audit-key-vault-managed-hsm-diagnostic-settings-v1`** — [FedRAMP High] Azure Key Vault Managed HSM: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-key-vault-managed-hsm-public-network-access-v1`** — [FedRAMP High] Azure Key Vault Managed HSM: Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3

## Initiative — `fedramp-high-key-vault-managed-hsm-v1`

Policy initiative for Azure Key Vault Managed HSM FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.KeyVault/managedHSMs`
