# Logging Configuration: Azure AD B2C

**Service**: Azure AD B2C
**Category**: Identity
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate) — limited diagnostic categories compared to Entra ID

---

## Diagnostic Categories

Azure AD B2C supports a limited set of diagnostic log categories compared to Entra ID. All available categories MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| AuditLogs | Directory changes: user registration, profile updates, policy modifications, app registration changes, key management | EL2 | AU-2, AU-3, AU-12 |
| SignInLogs | User sign-in events including authentication success/failure, MFA status, user flow name, IP address, device info, location | EL2 | AU-2, AU-3, AU-12 |

### Categories NOT Available in B2C (vs. Entra ID)

The following Entra ID diagnostic categories are **not available** in Azure AD B2C:

| Category | Entra ID | B2C | Impact |
|----------|----------|-----|--------|
| NonInteractiveUserSignInLogs | Yes | No | Token refresh events not logged separately |
| ServicePrincipalSignInLogs | Yes | No | App authentication logged via AuditLogs only |
| ManagedIdentitySignInLogs | Yes | No | Not applicable — B2C does not use Managed Identities |
| ProvisioningLogs | Yes | No | B2C user provisioning is self-service, not SCIM-based |
| RiskyUsers | Yes | No | B2C lacks Identity Protection risk scoring |
| UserRiskEvents | Yes | No | No risk-based event detection in B2C |
| RiskyServicePrincipals | Yes | No | Not applicable |
| MicrosoftGraphActivityLogs | Yes | No | Graph API calls to B2C not separately logged |

**Compensating controls**: Application-level logging, Azure Front Door WAF logs, and API gateway logs supplement B2C diagnostic gaps.

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The B2C directory resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Azure AD B2C directory (azurerm_aadb2c_directory)
Name: "{display_name}-diag"
Destination: Log Analytics workspace (shared)
Categories: AuditLogs, SignInLogs — Enabled
```

---

## Retention

| Environment | Online Retention | Archived Retention | Total Retention | NIST Control |
|-------------|-----------------|-------------------|-----------------|--------------|
| Production | 365 days (12 months) | 548 days (18 months) | 18 months | AU-11 |

**Rationale**: Production retention meets FedRAMP High AU-11 (12 months online minimum, 18 months total). Per `shared/logging-strategy.md`.

---

## OMB M-21-31 Event Logging Maturity

### Target: EL2 (Intermediate)

| Event Category | Target Tier | Implementation | Rationale |
|----------------|-------------|----------------|-----------|
| User sign-in events (success/failure) | EL2 | SignInLogs → Log Analytics | Authentication monitoring for consumer identity |
| MFA events (success/failure) | EL2 | SignInLogs (MFA detail fields) → Log Analytics | MFA enforcement verification |
| Directory changes (audit events) | EL2 | AuditLogs → Log Analytics | Configuration change tracking |
| User registration events | EL2 | AuditLogs (user creation) → Log Analytics | Account lifecycle monitoring |
| Password reset events | EL2 | AuditLogs (password change) → Log Analytics | Credential management monitoring |

**Gap from EL3**: B2C lacks Identity Protection risk scoring, so risk-based event categorization is not natively available. Compensating: Application-level risk scoring and Front Door WAF threat intelligence provide supplemental detection.

---

## Alert Rules

### Critical Alerts (Immediate Notification)

| Alert Rule | Condition | Severity | Threshold | Window | Action | NIST Control |
|-----------|-----------|----------|-----------|--------|--------|--------------|
| Failed Authentication Spike | Count of failed sign-ins from a single IP or user | Critical | > 20 failures | 5 minutes | Notify SOC, investigate potential credential stuffing | AU-6, AC-7 |
| Account Lockout Triggered | B2C account lockout event detected | High | Any lockout event | Real-time | Notify SOC, review for brute-force attack | AU-6, AC-7 |
| Unusual Sign-Up Pattern | Spike in new user registrations | High | > 50 registrations | 15 minutes | Notify SOC, investigate potential bot attack | AU-6, SI-4 |
| MFA Failure Spike | Elevated MFA failure rate | High | > 10 MFA failures from single user | 10 minutes | Notify SOC, potential account compromise | AU-6, IA-2(1) |

### Warning Alerts (Review Required)

| Alert Rule | Condition | Severity | Threshold | Window | Action | NIST Control |
|-----------|-----------|----------|-----------|--------|--------|--------------|
| Custom Policy Error | IEF custom policy execution error | Medium | > 5 errors | 15 minutes | Notify identity engineering team | AU-6, CM-3 |
| Token Issuance Anomaly | Unusual token issuance volume | Medium | > 2x baseline | 1 hour | Review for application misconfiguration | AU-6, SC-23 |
| Admin Configuration Change | B2C tenant configuration modified | Medium | Any change | Real-time | Notify identity engineering team for review | AU-6, CM-3 |
| External IdP Authentication Failure | Federated identity provider returning errors | Medium | > 5 errors | 10 minutes | Notify identity engineering team | AU-6, IA-8 |

---

## KQL Query Examples

### Failed Sign-In Analysis

```kusto
SigninLogs
| where TimeGenerated > ago(24h)
| where ResultType != "0"  // Non-success
| summarize FailedCount = count() by UserPrincipalName, IPAddress, Location
| where FailedCount > 5
| order by FailedCount desc
```

### Account Lockout Events

```kusto
AuditLogs
| where TimeGenerated > ago(24h)
| where OperationName == "Account locked out"
| project TimeGenerated, TargetResources, InitiatedBy, AdditionalDetails
```

### New User Registration Monitoring

```kusto
AuditLogs
| where TimeGenerated > ago(1h)
| where OperationName == "Create user" or OperationName == "Add user"
| summarize RegistrationCount = count() by bin(TimeGenerated, 5m)
| where RegistrationCount > 10
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure AD B2C monitoring with Azure Monitor | https://learn.microsoft.com/en-us/azure/active-directory-b2c/azure-monitor |
| 2 | B2C audit logs reference | https://learn.microsoft.com/en-us/azure/active-directory-b2c/auditing-and-reporting |
| 3 | NIST SP 800-53 Rev 5 — AU family | https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final |
| 4 | OMB M-21-31 Logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
| 5 | Log Analytics workspace overview | https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview |
| 6 | Shared logging strategy | `shared/logging-strategy.md` |
