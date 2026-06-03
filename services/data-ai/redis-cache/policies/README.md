# Azure Cache for Redis — Policy Definitions



## Definitions

- **`audit-redis-cache-diagnostic-settings-v1`** — [FedRAMP High] Azure Cache for Redis: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-redis-cache-public-network-access-v1`** — [FedRAMP High] Azure Cache for Redis: Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3
- **`deny-redis-cache-minimum-tls-v1`** — [FedRAMP High] Azure Cache for Redis: Minimum TLS 1.2
  - NIST 800-53: SC-8, SC-13
- **`audit-redis-cache-managed-identity-v1`** — [FedRAMP High] Azure Cache for Redis: Managed Identity Required
  - NIST 800-53: IA-2, AC-3

## Initiative — `fedramp-high-redis-cache-v1`

Policy initiative for Azure Cache for Redis FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3, SC-8, SC-13, IA-2

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.Cache/redis`
