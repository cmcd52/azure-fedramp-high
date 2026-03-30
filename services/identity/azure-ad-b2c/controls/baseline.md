# Security Control Baseline: Azure AD B2C

**Service**: Azure AD B2C
**Category**: Identity
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure AD B2C is the customer identity and access management (CIAM) platform for external-facing applications. It provides self-service sign-up, sign-in, password reset, and profile management for consumer and citizen users. B2C operates as a separate tenant from the workforce Entra ID tenant, with its own directory, policies, and user flows.

Authentication flows are defined using **user flows** (pre-built, configurable) or **custom policies** (Identity Experience Framework XML) for advanced scenarios. B2C supports federation with external identity providers (social, enterprise SAML/OIDC), API connectors for custom validation, and extensible claims pipelines.

**Configuration method**: Azure portal, Microsoft Graph API, and Identity Experience Framework (IEF) XML custom policies. Terraform deploys the B2C directory resource and diagnostic settings; custom policies and user flows are managed outside Terraform.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| B2C IEF Policy Administrator | B2C tenant | Manages custom policies (IEF XML). Restricted to identity engineering team. | AC-2, AC-3, AC-6 |
| B2C IEF Keyset Administrator | B2C tenant | Manages signing and encryption keys for custom policies. Restricted to security team. | AC-2, AC-3, SC-12 |
| B2C User Flow Administrator | B2C tenant | Creates and manages user flows. Restricted to identity engineering team. | AC-2, AC-3, AC-6 |
| Global Administrator | B2C tenant | Break-glass only (2 accounts, hardware FIDO2 keys). All other admin access via PIM. | AC-2, AC-3, AC-6(1) |
| Application Administrator | B2C tenant (via PIM) | Registers and manages B2C app registrations. JIT activation required. | AC-2, AC-3, AC-6 |
| Security Reader | B2C tenant | Read-only security monitoring for SOC analysts. Standing assignment permitted. | AU-6 |

### Custom Policy and User Flow Hardening

- **Token Lifetime Configuration**:
  - Access token: 1 hour maximum (production)
  - Refresh token: 24 hours maximum (production)
  - ID token: 1 hour maximum (production)
  - Session token (SSO): 24 hours rolling, 72 hours absolute maximum
  - NIST: SC-23, IA-5

- **Claims Configuration**:
  - Minimize claims in tokens to least-privilege data exposure
  - Do not include sensitive PII (SSN, financial data) in token claims
  - Use `sub` claim as opaque user identifier, not email
  - NIST: AC-4, AC-6

- **Identity Provider Federation Security**:
  - External IdPs federated via OIDC or SAML 2.0 only
  - Federation metadata validated and pinned
  - Claims mapping restricts accepted claims to minimum necessary
  - NIST: IA-8, IA-8(1), IA-8(2)

### Managed Identity

- Type: Not applicable (B2C is an identity provider, not a consumer of Managed Identities)
- Service-to-service: Applications authenticate to B2C using app registrations with client credentials (certificate-based preferred)
- NIST: IA-2, IA-5

### MFA / CAPTCHA Enforcement

#### NIST SP 800-63-4 Assurance Level Mapping (per FR-024)

| Assurance Level | Target | Achieved | Method | Use Case |
|-----------------|--------|----------|--------|----------|
| **IAL1** | IAL1 | IAL1 | Self-asserted attributes during sign-up. No identity proofing. | Self-service consumer sign-up |
| **AAL1** | AAL1 | AAL1 | Single factor: password only | Basic sign-in (non-elevated flows) |
| **AAL2** | AAL2 | AAL2 | Password + MFA (TOTP via authenticator app, phone verification) | Elevated-risk flows: payment, profile change, sensitive data access |
| **FAL1** | FAL1 | FAL1 | Bearer tokens (OAuth 2.0 access tokens, OpenID Connect ID tokens) | All API authorization |

#### MFA Configuration

- MFA **required** for elevated-risk flows (payment, PII modification, account recovery)
- MFA **available** for all sign-in flows (user opt-in or conditional)
- MFA methods: TOTP (authenticator app), phone verification (SMS/voice)
- SMS not used as sole MFA factor for AAL2 (per NIST SP 800-63-4 deprecation guidance — phone used as secondary channel only)
- NIST: IA-2(1)

#### CAPTCHA / Bot Protection

- CAPTCHA enabled on sign-up user flows to prevent automated account creation
- API connectors validate CAPTCHA tokens server-side
- NIST: SI-10 (Information Input Validation)

#### Account Lockout Policy

- Lockout threshold: **5 consecutive failed attempts**
- Lockout duration: **30 minutes**
- Progressive delay: Increasing wait times after repeated lockouts
- Account lockout events logged to audit logs and forwarded to Log Analytics
- NIST: AC-7 (Unsuccessful Logon Attempts)

#### Rate Limiting

- B2C platform-level rate limiting on authentication endpoints
- Azure Front Door WAF rate limiting rules on custom domain endpoints
- NIST: SC-5 (Denial of Service Protection)

---

## Network Security Controls

### Private Endpoint

- Status: **Not Supported**
- Justification: Azure AD B2C does not support Private Endpoints. B2C authentication endpoints are public by design (consumer-facing). This is documented as an **Edge Case** with compensating controls.
- NIST: SC-7 (Boundary Protection)

### Edge Case: Private Endpoint Not Available — Compensating Controls

| Compensating Control | Implementation | NIST Control |
|---------------------|----------------|--------------|
| IP Restrictions | B2C tenant settings restrict admin portal access to corporate IP ranges | SC-7 |
| Azure Front Door + WAF | Front Door deployed in front of B2C custom domain with WAF policy: bot protection, rate limiting, geo-filtering | SC-7, SC-5 |
| Custom Domain with TLS | B2C custom domain uses organization-owned domain with managed TLS certificate | SC-8, IA-8 |
| DDoS Protection | Azure DDoS Protection Standard on the virtual network hosting Front Door | SC-5 |
| Monitoring | Failed authentication spike alerts, unusual sign-up pattern detection | AU-6, SI-4 |

### Firewall / NSG Rules

Not applicable — B2C is a SaaS service. Network controls enforced via Front Door WAF and B2C tenant settings.

### Public Endpoint

- Status: **Justified Exception** — B2C authentication endpoints must be publicly accessible for consumer sign-in/sign-up.
- Compensating controls: Front Door WAF, rate limiting, bot protection, geo-filtering, TLS 1.2 enforcement.

---

## Encryption Controls

### Encryption at Rest

- Algorithm: AES-256
- Key Type: Platform-Managed Key (Microsoft-managed)
- Justification: B2C does not support Customer-Managed Keys (CMK). Data at rest is encrypted with Microsoft-managed AES-256 keys.
- FIPS 140-2 Certificate: Platform module (Azure Storage Service Encryption — Certificate #4532 or current)
- NIST: SC-13, SC-28

### Encryption in Transit

- Protocol: TLS 1.2+
- FIPS 140-2 Certificate: Microsoft TLS implementation (Certificate #4536 or current)
- Cipher suites: FIPS-approved only (enforced by Azure platform)
- All B2C authentication endpoints enforce TLS 1.2 minimum
- Custom domain endpoints use Azure-managed or uploaded TLS certificates
- NIST: SC-8, SC-13
- NIST SP 800-52 Rev 2: Compliant — TLS 1.2 with FIPS-approved cipher suites

---

## Logging & Monitoring Controls

- Diagnostic categories: AuditLogs, SignInLogs
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production), 30 days (lower)
- OMB M-21-31 tier: **EL2** (limited categories compared to Entra ID — no NonInteractiveUserSignInLogs, ServicePrincipalSignInLogs, RiskyUsers, etc.)
- Alert rules: Failed authentication spike, account lockout triggered, unusual sign-up pattern, MFA failure spike
- NIST: AU-2, AU-3, AU-6, AU-12
- NIST SP 800-137: Continuous monitoring via Log Analytics alerting and Sentinel integration
- See [logging/config.md](../logging/config.md) for full diagnostic configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| IA-2 | Identification and Authentication (Organizational Users) | B2C custom policies enforce authentication for all user flows | `terraform/main.tf`, `policies/definitions/audit-b2c-mfa-enabled-v1.json` |
| IA-2(1) | MFA for Privileged Accounts | MFA required for elevated-risk B2C flows | `policies/definitions/audit-b2c-mfa-enabled-v1.json` |
| IA-5 | Authenticator Management | Token lifetime: 1h access, 24h refresh. Password complexity enforced in user flows. | `policies/definitions/audit-b2c-token-lifetime-v1.json` |
| IA-8 | Identification and Authentication (Non-Organizational Users) | B2C custom domain, federated IdP validation, claims mapping | `policies/definitions/audit-b2c-custom-domain-v1.json` |
| AC-7 | Unsuccessful Logon Attempts | Account lockout: 5 failures → 30-min lockout | Custom policy / user flow configuration |
| SC-7 | Boundary Protection | **Exception**: Private Endpoint not supported. Compensating: Front Door WAF, IP restrictions | `controls/baseline.md` (this document) |
| SC-8 | Transmission Confidentiality | TLS 1.2+ enforced on all B2C endpoints | Platform default |
| SC-13 | Cryptographic Protection | FIPS 140-2 validated modules for TLS and encryption at rest | Platform certificates |
| SC-23 | Session Authenticity | Token lifetime controls, session cookie configuration | `policies/definitions/audit-b2c-token-lifetime-v1.json` |
| SC-28 | Protection of Information at Rest | AES-256 platform-managed encryption | Platform default |
| AU-2 | Audit Events | AuditLogs and SignInLogs forwarded to Log Analytics | `terraform/main.tf` diagnostic settings |
| AU-3 | Content of Audit Records | B2C logs include timestamp, user, action, result, IP, device info | `logging/config.md` |
| AU-6 | Audit Review, Analysis, and Reporting | Alert rules for failed auth spikes, lockouts, anomalies | `logging/config.md` |
| AU-12 | Audit Generation | Diagnostic settings enabled for all available B2C log categories | `terraform/main.tf` |

---

## DISA STIG Mapping

*No published DISA STIG for Azure AD B2C (per R-002). Compensating controls: NIST 800-53 Rev 5 High baseline + CIS Benchmark recommendations where applicable.*

| Finding ID | Title | Status | Implementation | Source |
|------------|-------|--------|----------------|--------|
| N/A | No STIG available | Compensating controls applied | NIST 800-53 High baseline controls implemented per this baseline. CIS Azure Foundations Benchmark identity recommendations applied where applicable. | N/A |

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| CUI Control | Implementation | CMMC Practice |
|-------------|----------------|---------------|
| 3.5.1 — Identify system users, processes, and devices | B2C user authentication via custom policies | IA.L1-3.5.1 |
| 3.5.2 — Authenticate (or verify) identities | B2C sign-in flows with MFA for elevated-risk | IA.L1-3.5.2 |
| 3.5.3 — Use multifactor authentication | MFA enabled for elevated-risk user flows | IA.L2-3.5.3 |
| 3.5.7 — Enforce minimum password complexity | Password complexity rules in B2C user flow settings | IA.L2-3.5.7 |
| 3.5.8 — Prohibit password reuse | Password history enforcement in B2C custom policies | IA.L2-3.5.8 |
| 3.1.8 — Limit unsuccessful logon attempts | 5 failures → 30-min lockout | AC.L2-3.1.8 |

### CMMC 2.0 Level 2

| Practice ID | Practice Name | Implementation |
|-------------|--------------|----------------|
| IA.L1-3.5.1 | Identification | B2C user directory with unique identifiers |
| IA.L1-3.5.2 | Authentication | B2C custom policies and user flows |
| IA.L2-3.5.3 | Multifactor Authentication | MFA for elevated-risk flows |
| IA.L2-3.5.7 | Password Complexity | User flow password policy |
| AC.L2-3.1.8 | Unsuccessful Logon Attempts | Account lockout policy |
| AU.L2-3.3.1 | System Auditing | AuditLogs and SignInLogs to Log Analytics |

### EO 14028 / OMB M-22-09 (Zero Trust)

- B2C supports zero-trust authentication by requiring per-request token validation
- No implicit trust — every API call requires a valid bearer token
- MFA and risk-based step-up authentication align with zero-trust identity pillar
- NIST SP 800-207 tenet: "All data sources and computing services are considered resources" — B2C authenticates each user individually per session

### OMB M-21-31 (Logging Maturity)

- Target tier: **EL2** (Intermediate)
- Achieved tier: **EL2** — B2C provides AuditLogs and SignInLogs. Limited compared to Entra ID (no NonInteractiveUserSignInLogs, RiskyUsers, ProvisioningLogs, etc.)
- Gap: EL3 would require risk-based event categorization; B2C lacks Identity Protection risk scoring available in Entra ID
- Compensating: Front Door WAF logs and application-level logging supplement B2C log gaps

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure AD B2C documentation | https://learn.microsoft.com/en-us/azure/active-directory-b2c/ |
| 2 | B2C custom policies overview | https://learn.microsoft.com/en-us/azure/active-directory-b2c/custom-policy-overview |
| 3 | B2C token configuration | https://learn.microsoft.com/en-us/azure/active-directory-b2c/configure-tokens |
| 4 | B2C MFA configuration | https://learn.microsoft.com/en-us/azure/active-directory-b2c/multi-factor-authentication |
| 5 | B2C user flow password complexity | https://learn.microsoft.com/en-us/azure/active-directory-b2c/password-complexity |
| 6 | B2C account lockout | https://learn.microsoft.com/en-us/azure/active-directory-b2c/threat-management |
| 7 | NIST SP 800-63-4 Digital Identity Guidelines | https://pages.nist.gov/800-63-4/ |
| 8 | NIST SP 800-53 Rev 5 | https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final |
| 9 | NIST SP 800-207 Zero Trust Architecture | https://csrc.nist.gov/publications/detail/sp/800-207/final |
| 10 | OMB M-21-31 Improving Investigation and Remediation Capabilities | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
| 11 | OMB M-22-09 Moving the US Government Toward Zero Trust | https://www.whitehouse.gov/wp-content/uploads/2022/01/M-22-09.pdf |
| 12 | Azure AD B2C diagnostic logs | https://learn.microsoft.com/en-us/azure/active-directory-b2c/azure-monitor |
| 13 | Azure Front Door with B2C | https://learn.microsoft.com/en-us/azure/active-directory-b2c/partner-azure-web-application-firewall |
| 14 | CMMC 2.0 Model | https://dodcio.defense.gov/cmmc/ |
