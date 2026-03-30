# Built-in Policy References: Azure Purview

**Service**: Azure Purview
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Microsoft Purview Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Azure Purview accounts should use private link | `3faf8ee0-e5a3-4519-bc89-4e5f8a674f58` | AuditIfNotExists | SC-7 | Private Endpoint |
| Resource logs in Azure Purview should be enabled | `b4330a05-a843-4bc8-bf9a-cacce50c67f4` | AuditIfNotExists | AU-12 | Diagnostic logs |
| Azure Purview should disable public network access | `aba5f526-e7a9-4c3e-9562-507f35eab5a4` | Audit | SC-7 | Public access |

### Azure Purview–Specific Considerations

| Consideration | Status | Notes |
|--------------|--------|-------|
| Managed Identity for scanning | No built-in policy | Custom policy required (`audit-purview-managed-identity-v1`) |
| Public access denial (Deny effect) | Partial built-in | Built-in only Audits; custom Deny needed (`deny-purview-public-access-v1`) |
| Managed VNet for scanning | No built-in policy | Enforced via Terraform configuration |
| Multiple Private Endpoints | No built-in policy | Purview requires account, portal, and ingestion PEs — enforced via Terraform |

> **Note**: Limited built-in coverage exists per R-001. Built-in policies only Audit; custom policies provide Deny enforcement for public access. Managed Identity for credential-free scanning and diagnostic settings enforcement require custom policies.

---

## Custom Policy Requirement (per R-001)

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-purview-public-access-v1` | Deny/Audit | SC-7 | No public network access (Deny enforcement) |
| `audit-purview-managed-identity-v1` | Audit | IA-2 | Managed Identity required for credential-free scanning |
| `audit-purview-diagnostic-settings-v1` | AuditIfNotExists | AU-12 | Diagnostic settings enabled |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Purview documentation | https://learn.microsoft.com/en-us/azure/purview/overview |
| 2 | Azure Purview network security | https://learn.microsoft.com/en-us/azure/purview/catalog-private-link |
| 3 | Azure Purview managed identity | https://learn.microsoft.com/en-us/azure/purview/register-scan-azure-blob-storage-source#authentication-for-a-scan |
| 4 | Azure Purview Private Endpoints | https://learn.microsoft.com/en-us/azure/purview/catalog-private-link-end-to-end |
| 5 | Azure Policy built-in definitions for Purview | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#purview |
| 6 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
