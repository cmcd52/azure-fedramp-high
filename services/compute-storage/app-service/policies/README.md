# Policy Coverage: App Service

**Service**: App Service
**Category**: Compute & Storage
**Last Updated**: 2026-03-27

---

## Overview

Azure App Service hosts web applications with FedRAMP High compliant defaults. These policies enforce HTTPS-only access, TLS 1.2 minimum, managed identity for service-to-service authentication, and diagnostic settings for centralized logging. Custom Deny policies supplement built-in Audit policies for critical controls.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-appservice-https-only-v1` | Deny/Audit | SC-8 | High |
| `deny-appservice-minimum-tls-v1` | Deny/Audit | SC-8, SC-13 | High |
| `deny-appservice-managed-identity-v1` | Deny/Audit | IA-2 | High |
| `audit-appservice-diagnostic-settings-v1` | AuditIfNotExists | AU-12 | Medium |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-app-service-v1` | All 4 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Strong built-in coverage for App Service including HTTPS, TLS, managed identity, VNet integration, and Private Endpoint. Custom policies provide Deny enforcement where built-in only Audit.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- DISA STIG: IIS STIG patterns applicable per R-002 (web server hardening)

---

## File Structure

```text
services/compute-storage/app-service/policies/
├── definitions/
│   ├── deny-appservice-https-only-v1.json
│   ├── deny-appservice-minimum-tls-v1.json
│   ├── deny-appservice-managed-identity-v1.json
│   └── audit-appservice-diagnostic-settings-v1.json
├── initiatives/
│   └── fedramp-high-app-service-v1.json
├── built-in-references.md
└── README.md                ← this file
```
