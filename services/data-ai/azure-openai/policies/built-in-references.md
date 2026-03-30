# Built-in Policy References: Azure OpenAI

**Service**: Azure OpenAI
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Cognitive Services / Azure OpenAI Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Cognitive Services accounts should disable public network access | `0725b4dd-7e76-479c-a735-68e7ee23d5be` | Audit | SC-7 | Public access |
| Cognitive Services accounts should use private link | `cddd188c-4b82-4c48-a19d-ddf74ee66a01` | AuditIfNotExists | SC-7 | Private Endpoint |
| Cognitive Services accounts should use managed identity | `fe3fd216-4f83-4fc1-8984-2b10d5f20044` | Audit | IA-2 | Managed Identity |
| Cognitive Services accounts should restrict network access | `037eea7a-bd0a-46c5-9a66-03afa78705d3` | Audit | SC-7 | Network rules |
| Cognitive Services accounts should use customer managed key | `67121cc7-ff39-4ab8-b7e3-95b84dab487d` | Audit | SC-28, SC-13 | CMK encryption |
| Cognitive Services accounts should have local auth methods disabled | `71ef260a-8f18-47b7-abcb-62d0673d94dc` | Audit | IA-2 | API key disablement |
| Resource logs in Azure AI services should be enabled | `b4330a05-a843-4bc8-bf9a-cacce50c67f4` | AuditIfNotExists | AU-12 | Diagnostic logs |

### Azure OpenAI–Specific Considerations

| Consideration | Status | Notes |
|--------------|--------|-------|
| Content filtering policies | No built-in policy | Custom policy required (`audit-openai-content-filtering-v1`) |
| Network isolation (OpenAI-specific) | Partial built-in | Generic Cognitive Services policy; custom Deny needed for OpenAI kind filter |
| Data residency enforcement | No built-in policy | Enforced via deployment region selection (US regions only) |

> **Note**: Some built-in coverage exists per R-001 via generic Cognitive Services policies. Custom policies provide OpenAI-specific filtering (kind = OpenAI) and Deny enforcement where built-in only Audit. Content filtering policy is unique to Azure OpenAI.

---

## Custom Policy Requirement (per R-001)

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-openai-public-access-v1` | Deny/Audit | SC-7 | No public network access (OpenAI-specific Deny) |
| `audit-openai-managed-identity-v1` | Audit | IA-2 | Managed Identity required |
| `audit-openai-content-filtering-v1` | Audit | SI-4 | Content filtering enabled (responsible AI) |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure OpenAI documentation | https://learn.microsoft.com/en-us/azure/ai-services/openai/overview |
| 2 | Azure OpenAI network security | https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks |
| 3 | Azure OpenAI content filtering | https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/content-filter |
| 4 | Azure OpenAI managed identity | https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/managed-identity |
| 5 | Azure Policy built-in definitions for Cognitive Services | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#cognitive-services |
| 6 | Azure OpenAI data privacy | https://learn.microsoft.com/en-us/legal/cognitive-services/openai/data-privacy |
| 7 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
