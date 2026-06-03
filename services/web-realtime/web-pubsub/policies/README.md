# Azure Web PubSub — Policy Definitions



## Definitions

- **`audit-web-pubsub-diagnostic-settings-v1`** — [FedRAMP High] Azure Web PubSub: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-web-pubsub-public-network-access-v1`** — [FedRAMP High] Azure Web PubSub: Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3
- **`deny-web-pubsub-minimum-tls-v1`** — [FedRAMP High] Azure Web PubSub: Minimum TLS 1.2
  - NIST 800-53: SC-8, SC-13
- **`audit-web-pubsub-managed-identity-v1`** — [FedRAMP High] Azure Web PubSub: Managed Identity Required
  - NIST 800-53: IA-2, AC-3

## Initiative — `fedramp-high-web-pubsub-v1`

Policy initiative for Azure Web PubSub FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3, SC-8, SC-13, IA-2

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.SignalRService/webPubSub`
