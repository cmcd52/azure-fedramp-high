# Static Web Apps — Policy Definitions



## Definitions

- **`audit-static-web-apps-diagnostic-settings-v1`** — [FedRAMP High] Static Web Apps: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`audit-static-web-apps-managed-identity-v1`** — [FedRAMP High] Static Web Apps: Managed Identity Required
  - NIST 800-53: IA-2, AC-3

## Initiative — `fedramp-high-static-web-apps-v1`

Policy initiative for Static Web Apps FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, IA-2, AC-3

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.Web/staticSites`
