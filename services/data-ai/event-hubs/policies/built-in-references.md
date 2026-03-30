# Built-in Policy References: Event Hubs

**Service**: Event Hubs
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Azure Event Hubs Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Event Hub namespaces should disable public network access | `5765f388-fcfb-40f7-b56e-8e7e3609df0c` | Audit | SC-7 | Public access |
| Event Hub namespaces should use private link | `b8564268-eb4a-4337-89be-a19db070c59d` | AuditIfNotExists | SC-7 | Private Endpoint |
| Event Hub namespaces should have double encryption enabled | `836cd60e-87f3-4e6a-a27c-29d687f01a4c` | Audit | SC-28, SC-13 | Encryption at rest |
| Resource logs in Event Hub should be enabled | `83a214f7-d01a-484b-91a9-ed54470c9a6a` | AuditIfNotExists | AU-12 | Diagnostic logs |
| Event Hub namespaces should use a customer-managed key for encryption | `a1ad735a-e96f-45d2-a7b2-9a4932cab7ec` | Audit | SC-28, SC-13 | CMK encryption |
| Authorization rules on the Event Hub instance should be defined | `f4826e5f-6a27-407c-ae3e-9582eb39891d` | AuditIfNotExists | AC-3 | Authorization |

### Event Hubs–Specific Considerations

| Consideration | Status | Notes |
|--------------|--------|-------|
| Public access denial (Deny effect) | Partial built-in | Built-in only Audits; custom Deny needed (`deny-eventhubs-public-access-v1`) |
| TLS 1.2 minimum enforcement | No built-in Deny | Custom Deny needed (`deny-eventhubs-minimum-tls-v1`) |
| Managed Identity / RBAC auth | No built-in policy | Custom policy required (`audit-eventhubs-managed-identity-v1`) |
| SAS key disablement | No built-in policy | Enforced via Terraform configuration (disableLocalAuth) |
| Zone redundancy | No built-in policy | Enforced via Terraform (Premium/Dedicated tier) |

> **Note**: Some built-in coverage exists per R-001. Built-in policies only Audit; custom policies provide Deny enforcement for public access and TLS. Managed Identity / RBAC authentication and SAS key disablement require custom policies.

---

## Custom Policy Requirement (per R-001)

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-eventhubs-public-access-v1` | Deny/Audit | SC-7 | No public network access (Deny enforcement) |
| `deny-eventhubs-minimum-tls-v1` | Deny/Audit | SC-8 | TLS 1.2 minimum (Deny enforcement) |
| `audit-eventhubs-managed-identity-v1` | Audit | IA-2, AC-3 | Managed Identity / RBAC auth required |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Event Hubs documentation | https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about |
| 2 | Azure Event Hubs network security | https://learn.microsoft.com/en-us/azure/event-hubs/network-security |
| 3 | Azure Event Hubs Private Endpoints | https://learn.microsoft.com/en-us/azure/event-hubs/private-link-service |
| 4 | Azure Event Hubs authentication with managed identity | https://learn.microsoft.com/en-us/azure/event-hubs/authenticate-managed-identity |
| 5 | Azure Event Hubs encryption at rest with CMK | https://learn.microsoft.com/en-us/azure/event-hubs/configure-customer-managed-key |
| 6 | Azure Policy built-in definitions for Event Hubs | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#event-hub |
| 7 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
