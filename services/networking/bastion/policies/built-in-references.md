# Built-in Policy References: Azure Bastion

**Service**: Azure Bastion
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Azure Bastion Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Azure Bastion should have diagnostic logs enabled | `f8352124-56fa-4f94-9441-425571f38a57` | AuditIfNotExists | AU-12 | Diagnostic settings verification |

### Network Security Group Policies (Applicable to AzureBastionSubnet)

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Subnets should be associated with a Network Security Group | `e71308d3-144b-4262-b144-efdc3cc90517` | AuditIfNotExists | SC-7 | NSG on AzureBastionSubnet |

> **Note**: The FedRAMP High built-in initiative (`d5264498-16f4-418a-b659-fa7ef418175f`) includes the Bastion diagnostic logs policy. Custom policies supplement coverage for SKU enforcement which is not covered by built-in policies.

---

## Custom Policy Requirement (per R-001)

Custom policy definitions supplement built-in policies for comprehensive FedRAMP High coverage:

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-bastion-sku-standard-v1` | Deny/Audit | SC-7 | Standard SKU required for session recording and native client |
| `audit-bastion-diagnostic-settings-v1` | AuditIfNotExists | AU-12 | Diagnostic settings must be configured |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Policy built-in definitions for Network | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#network |
| 2 | Azure Bastion documentation | https://learn.microsoft.com/en-us/azure/bastion/bastion-overview |
| 3 | Azure Bastion SKU comparison | https://learn.microsoft.com/en-us/azure/bastion/configuration-settings#skus |
| 4 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
