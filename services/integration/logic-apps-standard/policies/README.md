# Logic Apps Standard — Policy Definitions



## Definitions

- **`audit-logic-apps-standard-diagnostic-settings-v1`** — [FedRAMP High] Logic Apps Standard: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-logic-apps-standard-minimum-tls-v1`** — [FedRAMP High] Logic Apps Standard: Minimum TLS 1.2
  - NIST 800-53: SC-8, SC-13
- **`deny-logic-apps-standard-https-only-v1`** — [FedRAMP High] Logic Apps Standard: HTTPS Only Required
  - NIST 800-53: SC-8
- **`audit-logic-apps-standard-managed-identity-v1`** — [FedRAMP High] Logic Apps Standard: Managed Identity Required
  - NIST 800-53: IA-2, AC-3

## Initiative — `fedramp-high-logic-apps-standard-v1`

Policy initiative for Logic Apps Standard FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-8, SC-13, IA-2, AC-3

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.Web/sites`
