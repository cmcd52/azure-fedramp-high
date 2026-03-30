# Built-in Policy References: Azure AI Foundry

**Service**: Azure AI Foundry
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Machine Learning Services Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Azure Machine Learning workspaces should disable public network access | `438c38d2-3772-465a-a9cc-7a6c6d2f167f` | Audit | SC-7 | Public access |
| Azure Machine Learning workspaces should use private link | `40cec1dd-a100-4a01-b5e1-e198f3076228` | Audit | SC-7 | Private Endpoint |
| Azure Machine Learning workspaces should use user-assigned managed identity | `5f0c7d88-c7de-45b8-ac49-db49e72eaa78` | Audit | IA-2 | Managed Identity |
| Azure Machine Learning workspaces should be encrypted with a customer-managed key | `ba769a63-b8cc-4b2d-abf6-ac33c7204be8` | Audit | SC-28, SC-13 | CMK encryption |
| Resource logs in Azure Machine Learning workspaces should be enabled | `afe0c3be-ba3b-4544-ba52-0c99672a8ad6` | AuditIfNotExists | AU-12 | Diagnostic logs |
| Azure Machine Learning computes should be in a virtual network | `7804b5c7-01dc-4723-969b-ae300cc07ff1` | Audit | SC-7 | Compute isolation |

### Azure AI Foundry–Specific Considerations

| Consideration | Status | Notes |
|--------------|--------|-------|
| Hub/Project kind filtering | No built-in policy | Built-in policies target all ML workspaces; custom policies filter by kind (Hub/Project) |
| Data exfiltration prevention | No built-in policy | Enforced via managed VNet egress rules in Terraform |
| Compute isolation (managed VNet) | Partial built-in | Built-in checks VNet; custom policy adds Hub/Project specificity |

> **Note**: AI Foundry uses the Microsoft.MachineLearningServices resource provider (Hub/Project kinds). Built-in policies cover generic ML workspaces per R-001 but lack Hub/Project-specific filtering. Custom policies provide kind-specific enforcement.

---

## Custom Policy Requirement (per R-001)

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-aifoundry-public-access-v1` | Deny/Audit | SC-7 | No public network access (Hub/Project-specific Deny) |
| `audit-aifoundry-managed-identity-v1` | Audit | IA-2 | Managed Identity required |
| `audit-aifoundry-diagnostic-settings-v1` | AuditIfNotExists | AU-12 | Diagnostic settings enabled |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure AI Foundry documentation | https://learn.microsoft.com/en-us/azure/ai-studio/what-is-ai-studio |
| 2 | Azure AI Foundry network isolation | https://learn.microsoft.com/en-us/azure/ai-studio/how-to/configure-managed-network |
| 3 | Azure Machine Learning security baseline | https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/machine-learning-security-baseline |
| 4 | Azure Policy built-in definitions for Machine Learning | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#machine-learning |
| 5 | Azure AI Foundry data encryption | https://learn.microsoft.com/en-us/azure/ai-studio/concepts/encryption-keys-portal |
| 6 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
