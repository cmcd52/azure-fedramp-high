# API Management — Policy Definitions



## Definitions

- **`audit-api-management-diagnostic-settings-v1`** — [FedRAMP High] API Management: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-api-management-public-network-access-v1`** — [FedRAMP High] API Management: Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3
- **`deny-api-management-minimum-tls-v1`** — [FedRAMP High] API Management: Minimum TLS 1.2
  - NIST 800-53: SC-8, SC-13
- **`audit-api-management-managed-identity-v1`** — [FedRAMP High] API Management: Managed Identity Required
  - NIST 800-53: IA-2, AC-3
- **`audit-api-management-cmk-v1`** — [FedRAMP High] API Management: Customer-Managed Key Encryption
  - NIST 800-53: SC-12, SC-13, SC-28

## Initiative — `fedramp-high-api-management-v1`

Policy initiative for API Management FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3, SC-8, SC-13, IA-2, SC-12, SC-28

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.ApiManagement/service`
