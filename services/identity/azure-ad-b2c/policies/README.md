# Policy Coverage: Azure AD B2C

**Service**: Azure AD B2C
**Category**: Identity
**Last Updated**: 2026-03-27

---

## Overview

Azure AD B2C is the customer identity provider (CIAM) for external-facing applications. Unlike Entra ID (workforce identity), B2C has **minimal built-in Azure Policy coverage** (per R-001). Custom policy definitions in this directory serve as an **audit and compliance reporting layer** to track B2C configuration status at the Azure resource level.

Actual enforcement of B2C identity controls is configured through:
- Custom policies (Identity Experience Framework XML)
- User flow settings in the Azure portal
- Microsoft Graph API for B2C

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `audit-b2c-token-lifetime-v1` | Audit | IA-5, SC-23 | Medium |
| `audit-b2c-custom-domain-v1` | Audit | IA-8 | Medium |
| `audit-b2c-mfa-enabled-v1` | Audit | IA-2(1) | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-b2c-v1` | All 3 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Minimal built-in coverage — no purpose-built policies for B2C user flows, MFA, or token configuration. Custom policies required per R-001.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- DISA STIG: No STIG available for Azure AD B2C (per R-002)

---

## File Structure

```text
services/identity/azure-ad-b2c/policies/
├── definitions/
│   ├── audit-b2c-token-lifetime-v1.json
│   ├── audit-b2c-custom-domain-v1.json
│   └── audit-b2c-mfa-enabled-v1.json
├── initiatives/
│   └── fedramp-high-b2c-v1.json
├── built-in-references.md
└── README.md                ← this file
```
