# Azure Machine Learning — Policy Definitions



## Definitions

- **`audit-machine-learning-diagnostic-settings-v1`** — [FedRAMP High] Azure Machine Learning: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-machine-learning-public-network-access-v1`** — [FedRAMP High] Azure Machine Learning: Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3
- **`audit-machine-learning-managed-identity-v1`** — [FedRAMP High] Azure Machine Learning: Managed Identity Required
  - NIST 800-53: IA-2, AC-3
- **`audit-machine-learning-cmk-v1`** — [FedRAMP High] Azure Machine Learning: Customer-Managed Key Encryption
  - NIST 800-53: SC-12, SC-13, SC-28

## Initiative — `fedramp-high-machine-learning-v1`

Policy initiative for Azure Machine Learning FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3, IA-2, SC-12, SC-13, SC-28

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.MachineLearningServices/workspaces`
