# Compute & Storage Services — Policy Initiative Summary

> **Version**: 1.0.0 | **Date**: 2026-03-27 | **FR**: FR-007

## Custom Initiatives

| Service | Initiative | Scope | Policy Count |
|---------|-----------|-------|-------------|
| App Service | appservice-fedramp-high | App subscription(s) | 4 |
| Azure Functions | functions-fedramp-high | App subscription(s) | 3 |
| Azure Storage Account | storage-fedramp-high | Root management group | 5 |
| Key Vault | keyvault-fedramp-high | Root management group | 4 |

### Azure Storage Account (Most Restrictive — 5 Deny Policies)

| # | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
|---|--------|---------------|----------------|-------------|
| 1 | deny-storage-public-access | Deny | Deny | SC-7 |
| 2 | deny-storage-shared-key | Deny | Audit | AC-3, IA-2 |
| 3 | deny-storage-http | Deny | Deny | SC-8 |
| 4 | deny-storage-old-tls | Deny | Deny | SC-8, SC-13 |
| 5 | audit-storage-cmk | Audit | Audit | SC-13, SC-28 |

### Key Vault

| # | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
|---|--------|---------------|----------------|-------------|
| 1 | deny-keyvault-soft-delete | Deny | Deny | CP-9 |
| 2 | deny-keyvault-purge-protection | Deny | Deny | CP-9 |
| 3 | deny-keyvault-rbac-auth | Deny | Audit | AC-3, AC-6 |
| 4 | audit-keyvault-key-expiration | Audit | Audit | SC-12 |

## Built-In Policy References

| Service | Built-In Policy | NIST Control |
|---------|----------------|-------------|
| App Service | App Service should use a virtual network service endpoint | SC-7 |
| App Service | App Service should require FTPS only | SC-8 |
| App Service | App Service should use latest TLS version | SC-8, SC-13 |
| Functions | Function apps should use managed identity | IA-2 |
| Storage | Storage accounts should restrict network access | SC-7 |
| Storage | Secure transfer should be enabled | SC-8 |
| Storage | Storage accounts should use CMK | SC-13, SC-28 |
| Key Vault | Key vaults should have purge protection enabled | CP-9 |
| Key Vault | Key vaults should use private link | SC-7 |
| Key Vault | Key Vault keys should have expiration date | SC-12 |

## Assignment Strategy

- **Root Management Group**: Storage Account, Key Vault initiatives (universal services)
- **App Subscriptions**: App Service, Azure Functions initiatives
- **Exemption Process**: Per organizational policy lifecycle governance

---

*Compute & Storage Services — Azure Policy compliance artifacts.*
