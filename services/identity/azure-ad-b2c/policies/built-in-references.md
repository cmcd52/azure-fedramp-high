# Built-in Policy References: Azure AD B2C

**Service**: Azure AD B2C
**Last Updated**: 2026-03-27

---

## Important Note (per R-001)

Azure AD B2C has **minimal built-in Azure Policy coverage**. The `Microsoft.AzureActiveDirectory/b2cDirectories` resource type is supported by Azure Policy, but there are no purpose-built built-in policies for B2C user flow configuration, custom policy enforcement, MFA settings, or token lifetime management.

B2C compliance is primarily achieved through:
- **Custom policies (Identity Experience Framework XML)** for authentication flow hardening
- **User flow settings** in the Azure portal for MFA, password complexity, and session management
- **Azure AD B2C tenant configuration** via the Azure portal or Microsoft Graph API

Custom Azure Policy definitions in this directory provide a **compliance audit reporting layer** to tag and track B2C configuration status at the Azure resource level.

---

## Built-in Policy References

### General Azure AD Policies (Applicable to B2C Directory Resource)

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Allowed locations | `e56962a6-4747-49cd-b67b-bf8b01975c4c` | Deny | N/A (data residency) | B2C directory region restriction |

> **Note**: The FedRAMP High built-in initiative (`d5264498-16f4-418a-b659-fa7ef418175f`) does not include policies specifically targeting `Microsoft.AzureActiveDirectory/b2cDirectories`. Custom policies are required to achieve FedRAMP High audit coverage for B2C.

---

## Custom Policy Requirement (per R-001)

Because built-in policy coverage is minimal, the following custom policy definitions have been created:

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `audit-b2c-token-lifetime-v1` | Audit | IA-5, SC-23 | Token lifetime compliance tagging |
| `audit-b2c-custom-domain-v1` | Audit | IA-8 | Custom domain phishing protection |
| `audit-b2c-mfa-enabled-v1` | Audit | IA-2(1) | MFA enablement compliance tagging |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Policy built-in definitions | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies |
| 2 | Azure AD B2C resource provider operations | https://learn.microsoft.com/en-us/azure/role-based-access-control/resource-provider-operations#microsoftazureactivedirectory |
| 3 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
| 4 | Azure AD B2C overview | https://learn.microsoft.com/en-us/azure/active-directory-b2c/overview |
