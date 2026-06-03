# Azure Stack Edge — Policy Definitions



## Definitions

- **`audit-stack-edge-diagnostic-settings-v1`** — [FedRAMP High] Azure Stack Edge: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2

## Initiative — `fedramp-high-stack-edge-v1`

Policy initiative for Azure Stack Edge FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.DataBoxEdge/dataBoxEdgeDevices`
