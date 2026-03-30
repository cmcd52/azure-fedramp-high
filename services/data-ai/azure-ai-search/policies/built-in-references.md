# Built-in Policy References: Azure AI Search

**Service**: Azure AI Search
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Azure AI Search Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Azure Cognitive Search service should use a SKU that supports private link | `a049bf77-880b-470f-ba6d-9f21c530cf83` | Audit | SC-7 | SKU for PE support |
| Azure Cognitive Search services should disable public network access | `ee980b6d-0571-477a-b999-2e4529b45f49` | Audit | SC-7 | Public access |
| Azure Cognitive Search services should use private link | `0fda3595-084a-4c31-8a74-2e6cb0d54ba8` | AuditIfNotExists | SC-7 | Private Endpoint |
| Resource logs in Search services should be enabled | `b4330a05-a843-4bc8-bf9a-cacce50c67f4` | AuditIfNotExists | AU-12 | Diagnostic logs |
| Azure Cognitive Search service should use customer-managed keys | `76a56461-9dc0-40f0-82f5-2453283afa2f` | Audit | SC-28, SC-13 | CMK encryption |

### Azure AI Search–Specific Considerations

| Consideration | Status | Notes |
|--------------|--------|-------|
| TLS minimum version policy | No built-in policy | Custom policy required (`deny-aisearch-minimum-tls-v1`) |
| Managed identity policy | No search-specific built-in | Custom policy required (`audit-aisearch-managed-identity-v1`) |
| Public access Deny enforcement | Built-in is Audit only | Custom Deny policy required (`deny-aisearch-public-access-v1`) |

> **Note**: Built-in coverage exists for Audit-level policies per R-001. Custom policies provide Deny enforcement for public access and TLS minimum, plus managed identity requirement not covered by built-in policies.

---

## Custom Policy Requirement (per R-001)

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-aisearch-public-access-v1` | Deny/Audit | SC-7 | No public access (Deny enforcement) |
| `audit-aisearch-managed-identity-v1` | Audit | IA-2 | Managed Identity required |
| `deny-aisearch-minimum-tls-v1` | Deny/Audit | SC-8 | TLS 1.2 minimum (Deny enforcement) |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure AI Search documentation | https://learn.microsoft.com/en-us/azure/search/search-what-is-azure-search |
| 2 | Azure AI Search security | https://learn.microsoft.com/en-us/azure/search/search-security-overview |
| 3 | Azure AI Search Private Endpoint | https://learn.microsoft.com/en-us/azure/search/service-create-private-endpoint |
| 4 | Azure AI Search CMK encryption | https://learn.microsoft.com/en-us/azure/search/search-security-manage-encryption-keys |
| 5 | Azure Policy built-in definitions for Search | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#search |
| 6 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
