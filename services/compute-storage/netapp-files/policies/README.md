# Azure NetApp Files — Policy Definitions



## Definitions

- **`audit-netapp-files-diagnostic-settings-v1`** — [FedRAMP High] Azure NetApp Files: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`audit-netapp-files-cmk-v1`** — [FedRAMP High] Azure NetApp Files: Customer-Managed Key Encryption
  - NIST 800-53: SC-12, SC-13, SC-28

## Initiative — `fedramp-high-netapp-files-v1`

Policy initiative for Azure NetApp Files FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-12, SC-13, SC-28

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.NetApp/netAppAccounts`
