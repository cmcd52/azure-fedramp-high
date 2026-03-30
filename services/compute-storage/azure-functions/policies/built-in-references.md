# Built-in Policy References: Azure Functions

**Service**: Azure Functions
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Function App Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Function apps should only be accessible over HTTPS | `6d555dd1-86f2-4f1c-8ed7-5abae7c6cbab` | Deny/Audit | SC-8 | HTTPS enforcement |
| Function apps should use the latest TLS version | `f9d614c5-c173-4d56-95a7-b4437057d26c` | Audit | SC-8, SC-13 | TLS version |
| Function apps should use managed identity | `0da106f2-4ca3-48e8-bc85-c638fe6aea8f` | Audit | IA-2 | Managed identity |
| Function apps should have resource logs enabled | `b607c5de-e7d9-4eee-9e5c-83f1bcee4fa0` | AuditIfNotExists | AU-12 | Diagnostic logging |
| Function apps should use a virtual network service endpoint | `c4ebc54a-46e1-481a-bee5-d7291e04159a` | Audit | SC-7 | VNet integration |
| Function apps should use private link | `687aa49d-0e55-4c1e-9650-5546b227223b` | AuditIfNotExists | SC-7 | Private Endpoint |
| Remote debugging should be turned off for Function apps | `0e60b895-3786-45da-8377-9c6b4b6ac5f9` | AuditIfNotExists | CM-6 | Remote debugging |
| CORS should not allow every resource to access your Function apps | `0820b7b9-23aa-4725-a1ce-ae4558f718e5` | Audit | SC-7 | CORS restrictions |
| Function apps should not have CORS configured to allow every resource | `0820b7b9-23aa-4725-a1ce-ae4558f718e5` | Audit | SC-7 | CORS |

### Function App Authentication & Runtime

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Function apps should have authentication enabled | `95bccee9-a7f8-4bec-9ee9-62c3473701fc` | AuditIfNotExists | IA-2 | Authentication |
| Function apps should use latest HTTP version | `e2c1c086-2d84-4019-bff3-c44ccd95113c` | Audit | CM-6 | HTTP version |

> **Note**: The FedRAMP High built-in initiative includes Function App policies. Custom policies provide Deny enforcement where built-in policies only Audit.

---

## Custom Policy Requirement (per R-001)

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-functions-https-only-v1` | Deny/Audit | SC-8 | HTTPS-only enforcement (Deny vs built-in Audit) |
| `deny-functions-minimum-tls-v1` | Deny/Audit | SC-8, SC-13 | TLS 1.2 minimum (Deny enforcement) |
| `deny-functions-managed-identity-v1` | Deny/Audit | IA-2 | Managed identity required (Deny enforcement) |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Functions documentation | https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview |
| 2 | Azure Functions networking options | https://learn.microsoft.com/en-us/azure/azure-functions/functions-networking-options |
| 3 | Azure Functions Private Endpoint | https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-private-site-access |
| 4 | Azure Policy built-in definitions for App Service | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#app-service |
| 5 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
