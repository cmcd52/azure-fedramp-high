# Built-in Policy References: Azure Storage Account

**Service**: Azure Storage Account
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Storage Account Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Storage accounts should prevent public network access | `b2982f36-99f2-4db5-8eff-283140c09693` | Deny/Audit | SC-7 | Public access |
| Storage accounts should use customer-managed key for encryption | `6fac406b-40ca-413b-bf8e-0bf964659c25` | Audit | SC-28, SC-13 | CMK encryption |
| Secure transfer to storage accounts should be enabled | `404c3081-a854-4457-ae30-26a93ef643f9` | Deny/Audit | SC-8 | HTTPS only |
| Storage accounts should have the specified minimum TLS version | `fe83a0eb-a853-422d-abc7-2a8f5246c71d` | Deny/Audit | SC-8 | TLS version |
| Storage accounts should use private link | `6edd7eda-6dd8-40f7-810d-67160c639cd9` | AuditIfNotExists | SC-7 | Private Endpoint |
| Storage account keys should not be expired | `044985bb-afe1-42cd-8a36-9d5d42424537` | Audit | IA-5 | Key management |
| Storage accounts should restrict network access | `34c877ad-507e-4c82-993e-3452a6e0ad3c` | Audit | SC-7 | Network rules |
| Storage accounts should have infrastructure encryption | `4733ea7b-a883-42fe-8cac-97454c2a9e4a` | Audit | SC-28 | Double encryption |
| Storage accounts should prevent shared key access | `8c6a50c6-9ffd-4ae7-986f-5fa6111f9a54` | Audit | AC-3 | Shared key |

### Storage Account Diagnostics & Monitoring

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Storage accounts should have resource logs enabled for Blob service | `b4fe1a3b-0715-4c6c-a5ea-ffc33cf823cb` | AuditIfNotExists | AU-12 | Blob logging |
| Azure Defender for Storage should be enabled | `308fbb08-4ab8-4e67-9b29-592e93fb94fa` | Audit | SI-4 | Threat detection |

> **Note**: Strong built-in coverage exists per R-001. Custom policies provide Deny enforcement where built-in only Audit, and additional FIPS cipher suite enforcement requirements.

---

## Custom Policy Requirement (per R-001)

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-storageaccount-public-access-v1` | Deny/Audit | SC-7 | No public blob access (Deny enforcement) |
| `deny-storageaccount-cmk-encryption-v1` | Deny/Audit | SC-28, SC-13 | CMK required in production |
| `deny-storageaccount-minimum-tls-v1` | Deny/Audit | SC-8 | TLS 1.2 minimum (Deny enforcement) |
| `deny-storageaccount-https-only-v1` | Deny/Audit | SC-8 | HTTPS-only transfer (Deny enforcement) |
| `deny-storageaccount-shared-key-disabled-v1` | Deny/Audit | AC-3 | Shared key disabled, RBAC only |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Storage documentation | https://learn.microsoft.com/en-us/azure/storage/common/storage-introduction |
| 2 | Azure Storage encryption | https://learn.microsoft.com/en-us/azure/storage/common/storage-service-encryption |
| 3 | Azure Storage customer-managed keys | https://learn.microsoft.com/en-us/azure/storage/common/customer-managed-keys-overview |
| 4 | Azure Storage Private Endpoint | https://learn.microsoft.com/en-us/azure/storage/common/storage-private-endpoints |
| 5 | Azure Policy built-in definitions for Storage | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#storage |
| 6 | FIPS 140-2 validated modules for Azure | https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-fips-140-2 |
| 7 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
