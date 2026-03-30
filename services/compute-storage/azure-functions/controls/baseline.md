# Security Control Baseline: Azure Functions

**Service**: Azure Functions (Linux Function App)
**Category**: Compute & Storage
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Functions provides serverless, event-driven compute for running small units of code (functions) without managing infrastructure. The deployment uses a Premium App Service Plan for Private Endpoint support, ensuring all inbound traffic traverses private network paths. Functions enforce HTTPS-only access, TLS 1.2 minimum, and system-assigned managed identity for service-to-service authentication.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the App Service Plan, Linux Function App, Private Endpoint, and diagnostic settings. A linked Storage Account is required for function runtime (triggers, bindings, code storage) and must also be secured.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Website Contributor | Resource group (via PIM) | Manages Function App lifecycle (deploy, configure, restart). JIT activation required. | AC-2, AC-3, AC-6 |
| Reader | Resource group | Read-only access to Function App configuration for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to Function App metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned
- Usage: Function App authenticates to Azure services (Key Vault, Storage, Event Hubs, Service Bus) via managed identity — no connection strings with credentials
- Key Vault references: App settings use `@Microsoft.KeyVault(SecretUri=...)` syntax for secret injection
- NIST: IA-2, IA-5

### MFA / Conditional Access

- Function-level authorization keys for HTTP triggers (function keys, host keys)
- For user-facing functions: Entra ID authentication with MFA via Conditional Access
- AAL level achieved: AAL2 (Entra ID with MFA)
- NIST: IA-2(1), IA-2(2)

---

## Network Security Controls

### Private Endpoint

- Status: Required
- Private DNS Zone: `privatelink.azurewebsites.net`
- Inbound traffic flows exclusively through Private Endpoint
- NIST: SC-7

### VNet Integration

- Outbound traffic routed through VNet via `WEBSITE_VNET_ROUTE_ALL = 1`
- All egress traffic subject to NSG rules and route tables
- NIST: SC-7

### Firewall / NSG Rules

| Rule | Direction | Source | Destination | Port | Action | NIST Control |
|------|-----------|--------|-------------|------|--------|--------------|
| Allow-HTTPS-PE-Inbound | Inbound | VNet/Spoke | PE subnet | 443 | Allow | SC-7 |
| Allow-Storage-Outbound | Outbound | Function subnet | Storage PE | 443 | Allow | SC-7 |
| Deny-Internet-Outbound | Outbound | Function subnet | Internet | * | Deny | SC-7 |

### Public Endpoint

- Status: Disabled — all access via Private Endpoint
- NIST: SC-7

---

## Functions-Specific Security Considerations

### Runtime Isolation

- Each Function App runs in an isolated sandbox (on Premium plan, dedicated compute)
- No shared memory or file system between function apps
- NIST: SC-39 (Process Isolation)

### Cold Start Security

- Premium plan with always-on eliminates cold start delays
- No security-sensitive initialization in cold start path to avoid timing attacks
- NIST: SC-7 (attack surface reduction)

### Function Keys

- HTTP trigger authorization keys stored in the linked Storage Account
- Keys should be rotated regularly and not shared in code repositories
- Prefer Entra ID authentication over function keys for production workloads
- NIST: IA-5 (Authenticator Management)

### Linked Storage Account

- Required for function runtime (triggers, bindings, function code, logs)
- Must be secured: HTTPS-only, TLS 1.2, Private Endpoint, no public access
- See: `services/compute-storage/azure-storage-account/` for Storage Account controls
- NIST: SC-28

---

## Encryption Controls

### Encryption at Rest

- Algorithm: AES-256
- Key Type: Platform-Managed Key (Azure manages keys for Function App storage)
- Function code and configuration stored in linked Storage Account — encryption handled by Storage Account controls
- FIPS 140-2: Azure platform storage uses FIPS 140-2 validated modules
- NIST: SC-13, SC-28

### Encryption in Transit

- Protocol: TLS 1.2+ (minimum enforced via `minTlsVersion`)
- HTTPS-only: Enforced via `httpsOnly = true`
- FTPS: Disabled
- FIPS 140-2: TLS 1.2 uses FIPS 140-2 validated cryptographic modules on Azure platform
- Cipher suites: FIPS-approved only (managed by Azure platform)
- NIST: SC-8, SC-13

---

## Logging & Monitoring Controls

- Diagnostic categories: FunctionAppLogs
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: EL2 (Intermediate)
- Alert rules: Function execution failure rate, runtime exception
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Private Endpoint; VNet route all; no public access | Terraform: PE, WEBSITE_VNET_ROUTE_ALL |
| SC-8 | Transmission Confidentiality | HTTPS-only, TLS 1.2 minimum | Terraform: httpsOnly, minTlsVersion; Policy: deny-functions-https-only-v1 |
| SC-13 | Cryptographic Protection | TLS 1.2 FIPS-validated modules | Policy: deny-functions-minimum-tls-v1 |
| IA-2 | Identification and Authentication | System-assigned managed identity | Terraform: identity block; Policy: deny-functions-managed-identity-v1 |
| AU-12 | Audit Generation | FunctionAppLogs forwarded to Log Analytics | Terraform: diagnostic setting |
| SC-39 | Process Isolation | Function App sandbox isolation on Premium plan | Azure platform |

---

## DISA STIG Mapping

No published DISA STIG for Azure Functions (serverless PaaS). Compensating controls: NIST 800-53 controls and CIS Azure Benchmark.

*"No published DISA STIG for this service. Compensating controls: NIST 800-53 + CIS Benchmark."*

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | Managed identity + RBAC; Entra ID authentication | AC-2, AC-3, AC-6 |
| 3.13.8 Implement cryptographic mechanisms for CUI in transit | HTTPS-only, TLS 1.2 | SC-8, SC-13 |
| 3.13.11 Employ FIPS-validated cryptography | TLS 1.2 FIPS 140-2 validated modules | SC-13 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.8 | HTTPS-only, TLS 1.2 minimum |
| SC.L2-3.13.11 | FIPS 140-2 validated TLS modules |
| IA.L2-3.5.3 | Managed identity (no shared credentials) |
| AU.L2-3.3.1 | FunctionAppLogs to Log Analytics |

### EO 14028 / OMB M-22-09 (Zero Trust)

- All access via Private Endpoint — no implicit trust based on network location
- Managed identity eliminates static credentials
- NIST SP 800-207 tenet: Least privilege, per-request access decisions

### OMB M-21-31 (Logging Maturity)

- Target tier: EL2 (Intermediate)
- Achieved tier: EL2 — FunctionAppLogs collected and forwarded

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Functions documentation | https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview |
| 2 | Azure Functions networking | https://learn.microsoft.com/en-us/azure/azure-functions/functions-networking-options |
| 3 | Azure Functions Private Endpoint | https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-private-site-access |
| 4 | Azure Functions security | https://learn.microsoft.com/en-us/azure/azure-functions/security-concepts |
| 5 | CIS Azure Benchmark | https://www.cisecurity.org/benchmark/azure |
