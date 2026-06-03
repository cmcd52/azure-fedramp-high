# Azure Cache for Redis Enterprise — Policy Definitions



## Definitions

- **`audit-redis-enterprise-diagnostic-settings-v1`** — [FedRAMP High] Azure Cache for Redis Enterprise: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-redis-enterprise-minimum-tls-v1`** — [FedRAMP High] Azure Cache for Redis Enterprise: Minimum TLS 1.2
  - NIST 800-53: SC-8, SC-13

## Initiative — `fedramp-high-redis-enterprise-v1`

Policy initiative for Azure Cache for Redis Enterprise FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-8, SC-13

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.Cache/redisEnterprise`
