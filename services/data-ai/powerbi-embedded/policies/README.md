# Power BI Embedded — Policy Definitions



## Definitions

- **`audit-powerbi-embedded-diagnostic-settings-v1`** — [FedRAMP High] Power BI Embedded: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2

## Initiative — `fedramp-high-powerbi-embedded-v1`

Policy initiative for Power BI Embedded FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.PowerBIDedicated/capacities`
