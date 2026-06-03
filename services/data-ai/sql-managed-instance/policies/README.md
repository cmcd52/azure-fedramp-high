# Azure SQL Managed Instance — Policy Definitions



## Definitions

- **`audit-sql-managed-instance-diagnostic-settings-v1`** — [FedRAMP High] Azure SQL Managed Instance: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-sql-managed-instance-minimum-tls-v1`** — [FedRAMP High] Azure SQL Managed Instance: Minimum TLS 1.2
  - NIST 800-53: SC-8, SC-13
- **`audit-sql-managed-instance-managed-identity-v1`** — [FedRAMP High] Azure SQL Managed Instance: Managed Identity Required
  - NIST 800-53: IA-2, AC-3
- **`audit-sql-managed-instance-cmk-v1`** — [FedRAMP High] Azure SQL Managed Instance: Customer-Managed Key Encryption
  - NIST 800-53: SC-12, SC-13, SC-28

## Initiative — `fedramp-high-sql-managed-instance-v1`

Policy initiative for Azure SQL Managed Instance FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-8, SC-13, IA-2, AC-3, SC-12, SC-28

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.Sql/managedInstances`
