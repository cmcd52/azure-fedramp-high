# Security Control Baseline: Azure Managed Identity

**Service**: Azure Managed Identity
**Category**: Identity
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Managed Identity provides service-to-service authentication without stored credentials. Managed Identity is a **configuration pattern, not a standalone resource** — it is an identity capability provisioned on a consuming Azure service (e.g., App Service, Azure Functions, Virtual Machines) and authenticated by Microsoft Entra ID.

Managed Identity eliminates the need for application-embedded secrets, certificates, or connection strings in code or configuration. The identity lifecycle is fully managed by the Azure platform: credential rotation, token acquisition, and authentication are handled automatically.

**Configuration method**: Terraform (`azurerm` provider — `identity` block on consuming resource) + Azure RBAC role assignments. Managed Identity itself has no standalone portal or dedicated configuration — it is configured on the parent resource.

> **Artifact scope note**: This service has `controls/` only — no `logging/`, `terraform/`, or `policies/` directories. Managed Identity is not a standalone deployed resource; it is a configuration pattern applied to consuming resources via Terraform `identity` blocks. Logging is captured via Entra ID `ManagedIdentitySignInLogs` (configured at the tenant level, not per-resource). Azure Policy enforcement is not applicable since there is no ARM resource type to target.

---

## Identity & Access Controls

### System-Assigned vs. User-Assigned Guidance

| Type | When to Use | Lifecycle | NIST Control |
|------|-------------|-----------|--------------|
| System-assigned | **Preferred for most services** — one identity per resource, simpler lifecycle. Automatically created with the resource and deleted when the resource is destroyed. | Tied to parent resource | IA-4 |
| User-assigned | Use when the **same identity needs access to multiple resources** or for **pre-provisioning** scenarios (identity created before the consuming resource). Also required when a resource needs multiple distinct identities. | Independent — must be explicitly managed | IA-4 |

### RBAC Least-Privilege Assignments

| Scenario | Recommended Role | Anti-Pattern (Over-Privileged) | NIST Control |
|----------|-----------------|-------------------------------|--------------|
| Read blobs from Storage | Storage Blob Data Reader | ~~Storage Account Contributor~~ | AC-6 |
| Write blobs to Storage | Storage Blob Data Contributor | ~~Storage Account Contributor~~ | AC-6 |
| Read secrets from Key Vault | Key Vault Secrets User | ~~Key Vault Administrator~~ | AC-6 |
| Read keys from Key Vault | Key Vault Crypto User | ~~Key Vault Administrator~~ | AC-6 |
| Send logs to Log Analytics | Monitoring Metrics Publisher | ~~Log Analytics Contributor~~ | AC-6 |
| Access Azure SQL Database | `db_datareader` (SQL role) | ~~SQL Server Contributor~~ | AC-6 |
| Read from Cosmos DB | Cosmos DB Account Reader Role | ~~Cosmos DB Contributor~~ | AC-6 |
| Pull images from ACR | AcrPull | ~~ACR Contributor~~ | AC-6 |

**Principle**: Assign the **minimum required data-plane role**, never the control-plane contributor role. A service that reads blobs does not need the ability to manage the storage account itself.

### Service-to-Service Authentication Patterns

| Pattern | Identity Type | Target Service | Auth Flow | NIST Control |
|---------|--------------|----------------|-----------|--------------|
| App Service → Key Vault | System-assigned | Key Vault | Token via IMDS → Key Vault RBAC | IA-2, IA-5, AC-3 |
| Azure Functions → Storage Account | System-assigned | Storage Account | Token via IMDS → Storage data-plane RBAC | IA-2, IA-5, AC-3 |
| App Service → Log Analytics | System-assigned | Log Analytics workspace | Token via IMDS → Monitoring Metrics Publisher | IA-2, AU-3 |
| VM → Key Vault | System-assigned | Key Vault | Token via IMDS → Key Vault RBAC | IA-2, IA-5, AC-3 |
| Multiple services → shared Storage | User-assigned | Storage Account | Shared identity token → Storage RBAC | IA-2, IA-5, AC-3 |

**IMDS (Instance Metadata Service)**: All Managed Identity token acquisition occurs via the Azure Instance Metadata Service endpoint (`169.254.169.254`), which is accessible only from within the Azure resource. No network egress required.

### Managed Identity

- Type: Managed Identity **is** the identity (not a consumer of one)
- Credential management: Fully platform-managed — no user-accessible secrets, certificates, or passwords
- Token lifetime: Managed by Azure AD — tokens cached and refreshed automatically
- NIST: IA-2, IA-4, IA-5

### MFA / Conditional Access

- Status: **Not Applicable** — Managed Identity is a non-interactive service principal. It does not participate in interactive authentication flows and is not subject to Conditional Access policies.
- Conditional Access for workload identities: Available for user-assigned managed identities via Conditional Access for workload identities (Preview) — location-based restrictions only.
- NIST: IA-2 (met via platform authentication — no human factor)

---

## Network Security Controls

### Private Endpoint

- Status: **Not Applicable**
- Justification: Managed Identity operates on the identity plane, not the data plane. Token acquisition occurs via the Azure IMDS endpoint (`169.254.169.254`) which is a link-local address internal to the Azure fabric. There is no customer-facing network endpoint to secure with a Private Endpoint.

### Firewall / NSG Rules

- Status: **Not Applicable** — No customer-managed network surface. IMDS communication is fabric-internal.

### Public Endpoint

- Status: **Not Applicable** — Managed Identity does not expose any public endpoints. Token acquisition is internal to the Azure platform.

---

## Encryption Controls

### Encryption at Rest

- Status: **Not Applicable**
- Justification: Managed Identity does not store customer data. The identity object and its credentials are managed entirely by the Azure platform within the Entra ID directory. Platform-level encryption at rest applies.

### Encryption in Transit

- Protocol: TLS 1.2+ for all communications between Managed Identity and Azure AD token endpoints
- FIPS 140-2: Azure platform FIPS 140-2 validated cryptographic modules
- Justification: Token acquisition via IMDS uses Azure fabric-internal channels; Entra ID token endpoint communication uses TLS 1.2+.
- NIST: SC-8, SC-13

---

## Logging & Monitoring Controls

- **Note**: Managed Identity does not produce standalone diagnostic logs. Logging is captured via two channels:
  1. **Consuming service diagnostic settings**: Each service using a Managed Identity logs its own authentication and authorization events in its resource-level diagnostic settings.
  2. **Entra ID Managed Identity sign-in logs**: `ManagedIdentitySignInLogs` category in Entra ID diagnostic settings captures all Managed Identity authentication events (token acquisition success/failure, target resource, IP, etc.).
- Destination: Centralized Log Analytics workspace (via Entra ID diagnostic settings)
- Retention: 365 days online / 548 days total (production), 30 days (lower)
- OMB M-21-31 tier: **EL2** (Managed Identity sign-in events)
- Alert rules: Covered by Entra ID logging config — service principal risk detection, anomalous sign-in patterns
- NIST: AU-2, AU-3, AU-6, AU-12
- NIST SP 800-137: Continuous monitoring via Entra ID + consuming service diagnostics

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| IA-2 | Identification and Authentication | Managed Identity provides verified identity for service-to-service calls. Token issued by Entra ID after platform-level authentication. | ManagedIdentitySignInLogs |
| IA-4 | Identifier Management | System-assigned: identity created/destroyed with resource. User-assigned: explicit lifecycle management. Both produce unique object IDs in Entra ID. | Entra ID directory objects |
| IA-5 | Authenticator Management | Credentials fully platform-managed — no user-accessible secrets. Automatic rotation. No credential exposure risk. | Azure platform (no user-managed credentials) |
| AC-3 | Access Enforcement | RBAC role assignments on target resources enforce which operations the Managed Identity can perform. | Azure RBAC role assignments |
| AC-6 | Least Privilege | Minimum required data-plane roles assigned per service-to-service pattern. No control-plane roles unless explicitly justified. | Terraform role assignment configurations |

---

## DISA STIG Mapping

No published DISA STIG for Azure Managed Identity. Compensating controls: NIST 800-53 (IA-2, IA-4, IA-5, AC-3, AC-6) + CIS Microsoft Azure Foundations Benchmark (identity and access management recommendations).

| Finding ID | Title | Status | Implementation | Source |
|------------|-------|--------|----------------|--------|
| N/A | No STIG available | N/A | Compensating: NIST 800-53 IA family + CIS Azure Benchmark Section 1 (Identity and Access Management) | [CIS Azure Benchmark](https://www.cisecurity.org/benchmark/azure) |

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| CUI Control | Implementation | CMMC Practice |
|-------------|----------------|---------------|
| 3.5.1 — Identify system users | Managed Identity provides unique platform-verified identity for each service | IA.L1-3.5.1 |
| 3.5.2 — Authenticate users | Platform-managed authentication via Entra ID token issuance | IA.L1-3.5.2 |
| 3.1.1 — Limit system access to authorized users | RBAC role assignments restrict Managed Identity to minimum required permissions | AC.L1-3.1.1 |
| 3.1.5 — Employ least privilege | Data-plane roles only — no control-plane contributor assignments | AC.L2-3.1.5 |

### CMMC 2.0 Level 2

| Domain | Practice | Implementation |
|--------|----------|----------------|
| Identification & Authentication (IA) | IA.L1-3.5.1 | Unique Managed Identity per service (system-assigned) or per logical grouping (user-assigned) |
| Identification & Authentication (IA) | IA.L1-3.5.2 | Platform-managed authentication — no stored credentials |
| Access Control (AC) | AC.L2-3.1.5 | Least-privilege RBAC — minimum data-plane roles |

### EO 14028 / OMB M-22-09 (Zero Trust)

- **No stored credentials**: Managed Identity eliminates secrets, certificates, and connection strings from application configuration — core Zero Trust principle
- **Continuous verification**: Each token acquisition is a verified authentication event with Entra ID
- **Least-privilege access**: RBAC assignments enforce minimum permissions per service
- NIST SP 800-207 alignment:
  - Tenet 2 (All communication is secured regardless of location): Managed Identity tokens are cryptographically signed by Entra ID
  - Tenet 4 (Access is determined by dynamic policy): RBAC + Conditional Access for workload identities
  - Tenet 6 (Authentication and authorization are dynamic and strictly enforced): Every token request is authenticated by the platform

### OMB M-21-31 (Logging Maturity)

- Target tier: **EL2** (Important)
- Achieved tier: **EL2** — Managed Identity sign-in events captured in Entra ID `ManagedIdentitySignInLogs` diagnostic category
- Forwarded to: Centralized Log Analytics workspace per `shared/logging-strategy.md`

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Managed Identities Overview | https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview |
| 2 | Managed Identity Best Practices | https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations |
| 3 | System-Assigned vs. User-Assigned | https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview#managed-identity-types |
| 4 | Azure RBAC Built-in Roles | https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles |
| 5 | NIST SP 800-53 Rev 5 | https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final |
| 6 | NIST SP 800-207 Zero Trust Architecture | https://csrc.nist.gov/publications/detail/sp/800-207/final |
| 7 | CIS Microsoft Azure Foundations Benchmark | https://www.cisecurity.org/benchmark/azure |
| 8 | OMB M-21-31 Logging Maturity | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
| 9 | OMB M-22-09 Zero Trust Strategy | https://www.whitehouse.gov/wp-content/uploads/2022/01/M-22-09.pdf |
| 10 | EO 14028 Improving the Nation's Cybersecurity | https://www.whitehouse.gov/briefing-room/presidential-actions/2021/05/12/executive-order-on-improving-the-nations-cybersecurity/ |
| 11 | DFARS 252.204-7012 | https://www.acq.osd.mil/dpap/dars/dfars/html/current/252204.htm |
| 12 | CMMC 2.0 Model | https://dodcio.defense.gov/CMMC/ |
| 13 | Entra ID ManagedIdentitySignInLogs | https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-sign-ins#managed-identity-sign-ins |
| 14 | Conditional Access for Workload Identities | https://learn.microsoft.com/en-us/entra/identity/conditional-access/workload-identity |
| 15 | FIPS 140-2 Validated Modules (Azure) | https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-fips-140-2 |
