# Azure AI Services (Umbrella) — Policy Definitions



## Definitions

- **`audit-ai-services-umbrella-diagnostic-settings-v1`** — [FedRAMP High] Azure AI Services (Umbrella): Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-ai-services-umbrella-public-network-access-v1`** — [FedRAMP High] Azure AI Services (Umbrella): Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3
- **`audit-ai-services-umbrella-managed-identity-v1`** — [FedRAMP High] Azure AI Services (Umbrella): Managed Identity Required
  - NIST 800-53: IA-2, AC-3
- **`audit-ai-services-umbrella-cmk-v1`** — [FedRAMP High] Azure AI Services (Umbrella): Customer-Managed Key Encryption
  - NIST 800-53: SC-12, SC-13, SC-28

## Initiative — `fedramp-high-ai-services-umbrella-v1`

Policy initiative for Azure AI Services (Umbrella) FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3, IA-2, SC-12, SC-13, SC-28

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.CognitiveServices/accounts`
