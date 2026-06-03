# Azure Database for PostgreSQL Flexible Server — Policy Definitions



## Definitions

- **`audit-postgresql-flexible-diagnostic-settings-v1`** — [FedRAMP High] Azure Database for PostgreSQL Flexible Server: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`audit-postgresql-flexible-cmk-v1`** — [FedRAMP High] Azure Database for PostgreSQL Flexible Server: Customer-Managed Key Encryption
  - NIST 800-53: SC-12, SC-13, SC-28

## Initiative — `fedramp-high-postgresql-flexible-v1`

Policy initiative for Azure Database for PostgreSQL Flexible Server FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-12, SC-13, SC-28

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.DBforPostgreSQL/flexibleServers`
