# Built-in Policy References: App Service

**Service**: App Service
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### App Service Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| App Service apps should only be accessible over HTTPS | `a4af4a39-4135-47fb-b175-47fbdf85311d` | Deny/Audit | SC-8 | HTTPS enforcement |
| App Service apps should use the latest TLS version | `f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b` | Audit | SC-8, SC-13 | TLS version |
| App Service apps should use managed identity | `2b9ad585-36bc-4615-b300-fd4435808332` | Audit | IA-2 | Managed identity |
| App Service apps should have resource logs enabled | `91a78b24-f231-4a8a-8da9-02c35b2b6510` | AuditIfNotExists | AU-12 | Diagnostic logging |
| App Service apps should use a virtual network service endpoint | `c4ebc54a-46e1-481a-bee5-d7291e04159a` | Audit | SC-7 | VNet integration |
| App Service should use private link | `687aa49d-0e55-4c1e-9650-5546b227223b` | AuditIfNotExists | SC-7 | Private Endpoint |
| App Service Environment should disable TLS 1.0 and 1.1 | `d6545c6b-dd9d-4f2b-8800-54c9e4286e0d` | Audit | SC-8, SC-13 | ASE TLS |
| Function apps should only be accessible over HTTPS | `6d555dd1-86f2-4f1c-8ed7-5abae7c6cbab` | Deny/Audit | SC-8 | HTTPS for Functions |
| Remote debugging should be turned off for App Service apps | `cb510bfd-1cba-4d9f-a230-cb0976f4bb71` | AuditIfNotExists | CM-6 | Remote debugging |
| CORS should not allow every resource to access your App Service apps | `5744710e-cc2f-4ee8-8809-3b11e89f4bc9` | Audit | SC-7 | CORS restrictions |
| App Service apps should not have CORS configured to allow every resource to access your apps | `e1e6c336-cb2f-4700-a1c1-6a4a9a5b5e45` | Audit | SC-7 | CORS |

### App Service Authentication & Identity

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| App Service apps should have authentication enabled | `95bccee9-a7f8-4bec-9ee9-62c3473701fc` | AuditIfNotExists | IA-2 | Authentication |
| App Service apps should use latest HTTP version | `8c122334-9d20-4eb8-89ea-ac9a705b74ae` | Audit | CM-6 | HTTP version |

> **Note**: The FedRAMP High built-in initiative (`d5264498-16f4-418a-b659-fa7ef418175f`) includes many App Service-related policies. Custom policies provide stricter Deny enforcement where built-in policies only Audit.

---

## Custom Policy Requirement (per R-001)

Custom policy definitions supplement built-in policies for App Service-specific enforcement:

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-appservice-https-only-v1` | Deny/Audit | SC-8 | HTTPS-only enforcement (Deny vs built-in Audit) |
| `deny-appservice-minimum-tls-v1` | Deny/Audit | SC-8, SC-13 | TLS 1.2 minimum (Deny enforcement) |
| `deny-appservice-managed-identity-v1` | Deny/Audit | IA-2 | Managed identity required (Deny enforcement) |
| `audit-appservice-diagnostic-settings-v1` | AuditIfNotExists | AU-12 | Diagnostic settings to Log Analytics |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure App Service documentation | https://learn.microsoft.com/en-us/azure/app-service/overview |
| 2 | App Service networking features | https://learn.microsoft.com/en-us/azure/app-service/networking-features |
| 3 | App Service Private Endpoint | https://learn.microsoft.com/en-us/azure/app-service/networking/private-endpoint |
| 4 | Azure Policy built-in definitions for App Service | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#app-service |
| 5 | IIS DISA STIG | https://public.cyber.mil/stigs/downloads/ |
| 6 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
