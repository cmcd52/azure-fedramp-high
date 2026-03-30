# Security Control Baseline: App Service

**Service**: Azure App Service (Linux Web App)
**Category**: Compute & Storage
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure App Service hosts web applications on a managed PaaS platform. The deployment uses a Premium-tier Linux App Service Plan for Private Endpoint support and VNet integration, ensuring all inbound and outbound traffic traverses private network paths. App Service enforces HTTPS-only access, TLS 1.2 minimum, and system-assigned managed identity for zero-credential service-to-service authentication.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the App Service Plan, Linux Web App, Private Endpoint, and diagnostic settings. Platform-level hardening (TLS, HTTPS, remote debugging disabled) is enforced via resource properties and Azure Policy.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Website Contributor | Resource group (via PIM) | Manages App Service lifecycle (deploy, configure, restart). JIT activation required. | AC-2, AC-3, AC-6 |
| Reader | Resource group | Read-only access to App Service configuration for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to App Service metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned
- Usage: Web App authenticates to Azure services (Key Vault, Storage, SQL) via managed identity — no connection strings with credentials stored in app settings
- Key Vault references: App settings use `@Microsoft.KeyVault(SecretUri=...)` syntax for secret injection
- NIST: IA-2, IA-5

### MFA / Conditional Access

- App Service authentication (EasyAuth) or external IdP with MFA enforcement
- AAL level achieved: AAL2 (Entra ID with MFA via Conditional Access)
- NIST: IA-2(1), IA-2(2)

---

## Network Security Controls

### Private Endpoint

- Status: Required
- Private DNS Zone: `privatelink.azurewebsites.net`
- Inbound traffic flows exclusively through Private Endpoint
- NIST: SC-7

### VNet Integration

- Outbound traffic routed through VNet integration subnet
- All egress traffic subject to NSG rules and route tables
- NIST: SC-7

### Firewall / NSG Rules

| Rule | Direction | Source | Destination | Port | Action | NIST Control |
|------|-----------|--------|-------------|------|--------|--------------|
| Allow-HTTPS-PE-Inbound | Inbound | VNet/Spoke | PE subnet | 443 | Allow | SC-7 |
| Allow-VNet-Int-Outbound | Outbound | VNet-integration subnet | Azure services | 443 | Allow | SC-7 |
| Deny-Internet-Outbound | Outbound | VNet-integration subnet | Internet | * | Deny | SC-7 |

### Public Endpoint

- Status: Disabled — all access via Private Endpoint
- Access restrictions: IP-based access restrictions deny all public traffic
- NIST: SC-7

---

## Encryption Controls

### Encryption at Rest

- Algorithm: AES-256
- Key Type: Platform-Managed Key (Azure manages keys for App Service storage)
- App Service does not support CMK for its internal storage — compensated by TDE/SSE on back-end data stores (SQL, Storage Account)
- FIPS 140-2: Azure platform storage uses FIPS 140-2 validated modules
- NIST: SC-13, SC-28

### Encryption in Transit

- Protocol: TLS 1.2+ (minimum enforced via `minTlsVersion`)
- HTTPS-only: Enforced via `httpsOnly = true` — HTTP requests redirected to HTTPS
- FTPS: Disabled — deployment via CI/CD pipeline over HTTPS
- FIPS 140-2: TLS 1.2 uses FIPS 140-2 validated cryptographic modules on Azure platform
- Cipher suites: FIPS-approved only (managed by Azure platform)
- NIST: SC-8, SC-13
- NIST SP 800-52 Rev 2: TLS 1.2 compliant

---

## IIS STIG Patterns (per R-002)

Azure App Service runs on IIS internally. While direct IIS configuration is limited on PaaS, the following STIG-aligned hardening is applied:

| IIS STIG Pattern | App Service Implementation | Status |
|-----------------|---------------------------|--------|
| HTTPS required | `httpsOnly = true` | Implemented |
| TLS 1.2 minimum | `minTlsVersion = 1.2` | Implemented |
| Remote debugging disabled | `remote_debugging_enabled = false` | Implemented |
| FTPS disabled | `ftps_state = Disabled` | Implemented |
| Directory browsing disabled | Platform default (disabled) | Implemented |
| Custom error pages | Application-level configuration | Application responsibility |
| Request filtering | Application-level (WAF recommended for public-facing) | Application responsibility |

---

## Logging & Monitoring Controls

- Diagnostic categories: AppServiceHTTPLogs, AppServiceConsoleLogs, AppServiceAppLogs, AppServiceAuditLogs, AppServiceIPSecAuditLogs, AppServicePlatformLogs, AppServiceAntivirusScanAuditLogs
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: EL2 (Intermediate), EL3 for audit logs
- Alert rules: HTTP 5xx spike, failed authentication, deployment event
- NIST: AU-2, AU-3, AU-6, AU-12
- NIST SP 800-137: Continuous monitoring via Log Analytics alerts
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Private Endpoint + VNet integration; no public access | Terraform: PE, VNet integration, NSG rules |
| SC-8 | Transmission Confidentiality | HTTPS-only, TLS 1.2 minimum | Terraform: httpsOnly, minTlsVersion; Policy: deny-appservice-https-only-v1 |
| SC-13 | Cryptographic Protection | TLS 1.2 with FIPS 140-2 validated modules | Terraform: minTlsVersion; Policy: deny-appservice-minimum-tls-v1 |
| SC-28 | Protection of Information at Rest | Platform-managed encryption (AES-256) | Azure platform default |
| IA-2 | Identification and Authentication | System-assigned managed identity; EasyAuth/external IdP with MFA | Terraform: identity block; Policy: deny-appservice-managed-identity-v1 |
| AU-12 | Audit Generation | All 7 diagnostic categories forwarded to Log Analytics | Terraform: diagnostic setting; Policy: audit-appservice-diagnostic-settings-v1 |

---

## DISA STIG Mapping

No published DISA STIG for Azure App Service (PaaS). Compensating controls: IIS STIG patterns applied via platform configuration (see IIS STIG Patterns section above), NIST 800-53 controls, and CIS Azure Benchmark.

| IIS STIG Alignment | Title | Status | Implementation | Source |
|---------------------|-------|--------|----------------|--------|
| Web server hardening | HTTPS, TLS, FTPS disabled, remote debug off | Implemented | Terraform resource properties | IIS STIG V2R3+ patterns |

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | Managed identity + RBAC; EasyAuth with MFA | AC-2, AC-3, AC-6 |
| 3.13.8 Implement cryptographic mechanisms for CUI in transit | HTTPS-only, TLS 1.2 | SC-8, SC-13 |
| 3.13.11 Employ FIPS-validated cryptography | TLS 1.2 FIPS 140-2 validated modules | SC-13 |
| 3.14.1 Identify and remediate system flaws | App Service platform patching (managed by Azure) | SI-2 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.8 | HTTPS-only, TLS 1.2 minimum |
| SC.L2-3.13.11 | FIPS 140-2 validated TLS modules |
| IA.L2-3.5.3 | Managed identity (no shared credentials) |
| AU.L2-3.3.1 | 7 diagnostic log categories to Log Analytics |

### EO 14028 / OMB M-22-09 (Zero Trust)

- All access via Private Endpoint — no implicit trust based on network location
- Managed identity eliminates static credentials
- NIST SP 800-207 tenet: Least privilege, per-request access decisions

### OMB M-21-31 (Logging Maturity)

- Target tier: EL2 (Intermediate) for HTTP logs, EL3 (Advanced) for audit logs
- Achieved tier: EL2/EL3 — all diagnostic categories collected and forwarded

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure App Service documentation | https://learn.microsoft.com/en-us/azure/app-service/overview |
| 2 | App Service Private Endpoint | https://learn.microsoft.com/en-us/azure/app-service/networking/private-endpoint |
| 3 | App Service VNet Integration | https://learn.microsoft.com/en-us/azure/app-service/overview-vnet-integration |
| 4 | App Service TLS settings | https://learn.microsoft.com/en-us/azure/app-service/configure-ssl-bindings |
| 5 | IIS DISA STIG | https://public.cyber.mil/stigs/downloads/ |
| 6 | CIS Azure Benchmark | https://www.cisecurity.org/benchmark/azure |
