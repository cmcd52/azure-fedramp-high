# Built-in Policy References: Azure Document Intelligence

**Service**: Azure Document Intelligence
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Cognitive Services / Azure Document Intelligence Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Cognitive Services accounts should disable public network access | `0725b4dd-7e76-479c-a735-68e7ee23d5be` | Audit | SC-7 | Public access |
| Cognitive Services accounts should use private link | `cddd188c-4b82-4c48-a19d-ddf74ee66a01` | AuditIfNotExists | SC-7 | Private Endpoint |
| Cognitive Services accounts should use managed identity | `fe3fd216-4f83-4fc1-8984-2b10d5f20044` | Audit | IA-2 | Managed Identity |
| Cognitive Services accounts should restrict network access | `037eea7a-bd0a-46c5-9a66-03afa78705d3` | Audit | SC-7 | Network rules |
| Cognitive Services accounts should use customer managed key | `67121cc7-ff39-4ab8-b7e3-95b84dab487d` | Audit | SC-28, SC-13 | CMK encryption |
| Cognitive Services accounts should have local auth methods disabled | `71ef260a-8f18-47b7-abcb-62d0673d94dc` | Audit | IA-2 | API key disablement |
| Resource logs in Azure AI services should be enabled | `b4330a05-a843-4bc8-bf9a-cacce50c67f4` | AuditIfNotExists | AU-12 | Diagnostic logs |

### Azure Document Intelligence–Specific Considerations

| Consideration | Status | Notes |
|--------------|--------|-------|
| Kind-specific filtering (FormRecognizer) | No built-in policy | Built-in policies target all Cognitive Services; custom policies filter by kind |
| PII data handling enforcement | No built-in policy | Enforced via application-level controls and network isolation |
| Custom model storage protection | No built-in policy | Protected via Storage Account PE and CMK |

> **Note**: Document Intelligence uses the Cognitive Services resource provider (kind: FormRecognizer). Built-in policies cover generic Cognitive Services per R-001. Custom policies provide FormRecognizer-specific kind filtering and Deny enforcement where built-in only Audit.

---

## Custom Policy Requirement (per R-001)

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-docintel-public-access-v1` | Deny/Audit | SC-7 | No public network access (FormRecognizer-specific Deny) |
| `audit-docintel-managed-identity-v1` | Audit | IA-2 | Managed Identity required |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Document Intelligence documentation | https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/overview |
| 2 | Azure Document Intelligence network security | https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks |
| 3 | Azure Document Intelligence data privacy | https://learn.microsoft.com/en-us/legal/cognitive-services/document-intelligence/data-privacy-security |
| 4 | Azure Policy built-in definitions for Cognitive Services | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#cognitive-services |
| 5 | Azure Document Intelligence managed identity | https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/managed-identities |
| 6 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
