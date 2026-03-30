# Built-in Policy References: Private Endpoint

**Service**: Private Endpoint
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Service-Specific "Should Use Private Link" Built-in Policies (per R-001)

Many built-in policies exist per service for Private Link enforcement. Below is a representative sample:

| Built-in Policy | Policy ID | Effect | NIST Controls | Service |
|----------------|-----------|--------|---------------|---------|
| Storage accounts should use private link | `6edd7eda-6dd8-40f7-810d-67160c639cd9` | Audit/Deny | SC-7 | Storage Account |
| Key vaults should use private link | `a6abeaec-4d90-4a02-805f-6b26c4d3fbe9` | Audit/Deny | SC-7 | Key Vault |
| Azure Cognitive Search service should use a private link | `0fda3395-abe5-4969-8eb7-3f9e3924b55f` | Audit | SC-7 | AI Search |
| Cognitive Services accounts should use private link | `cddd188c-4b82-4c48-a19d-ddf74ee66a01` | Audit | SC-7 | Cognitive Services / OpenAI |
| App Service apps should use private endpoints | `687aa49d-0982-40f8-bf6b-66d1da97a04b` | Audit | SC-7 | App Service |
| Function apps should use private endpoints | `11c82d0c-db9f-4d7b-97c5-f3f9aa957da2` | Audit | SC-7 | Azure Functions |
| Azure Event Hubs namespaces should use private link | `b8564268-eb4a-4337-89be-a19db070c59d` | Audit | SC-7 | Event Hubs |

### Generic Private Endpoint Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Private endpoints should be deployed to the specified subnet | `d5810846-c2ae-4a78-8fa5-96c63c03a7b5` | Audit/Deny | SC-7 | Subnet enforcement |

> **Note (per R-001)**: Built-in "should use private link" policies exist for most Azure services. Custom policies supplement coverage for DNS zone group enforcement and NSG requirements which are not covered by built-in policies.

---

## Custom Policy Requirement (per R-001)

Custom policy definitions supplement built-in policies:

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-privateendpoint-required-v1` | Deny/Audit | SC-7 | Generic template — services must disable public network access |
| `audit-privateendpoint-dns-configured-v1` | Audit | SC-7, SC-20 | PE must have DNS zone group for private DNS registration |
| `audit-privateendpoint-nsg-v1` | Audit | SC-7 | PE subnet must have NSG association |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Private Endpoint documentation | https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview |
| 2 | Private Endpoint DNS integration | https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns |
| 3 | NSG support for Private Endpoints | https://learn.microsoft.com/en-us/azure/private-link/disable-private-endpoint-network-policy |
| 4 | Azure Policy built-in definitions for Private Link | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#network |
| 5 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
