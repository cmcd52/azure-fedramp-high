# Security Control Baseline: Azure Maps

**Service**: Azure Maps (Microsoft.Maps/accounts)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**Environment**: Production

> **EDGE CASE**: Azure Maps does NOT support Private Endpoint. This service requires compensating controls and a documented FedRAMP exception for SC-7 (Boundary Protection).

## Service Overview

Azure Maps provides geospatial APIs — including map rendering, geocoding, routing, search, and spatial analysis — for federal applications. Unlike most Azure services, Azure Maps does **not** support Private Endpoint, making it an exception to the standard network isolation pattern. The service relies on compensating controls: managed identity authentication (no shared keys in production), CORS origin restrictions, Azure Front Door WAF protection, IP address restrictions at the infrastructure level, and ensuring no sensitive data flows through map queries (tile requests only).

**Configuration method**: Terraform (`terraform/main.tf`) deploys the Maps account, configures managed identity auth, CORS restrictions, and diagnostic settings. No Private Endpoint is deployed (not supported).

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Azure Maps Contributor | Resource (via PIM) | Manage Maps account configuration. JIT activation required. | AC-2, AC-3, AC-6 |
| Azure Maps Data Reader | Resource | Read-only access to map data APIs for application managed identities. Standing assignment. | AC-3 |
| Reader | Resource group | Read-only access for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned
- Usage: Application services authenticate to Azure Maps via managed identity and RBAC roles — no shared keys
- Production: Shared key authentication disabled (`local_authentication_enabled = false`)
- `x-ms-client-id` header used for managed identity auth
- NIST: IA-2, IA-5

### Authentication Model: Managed Identity Only (Production)

- Shared keys: **Disabled** in production (`local_authentication_enabled = false`)
- All API calls authenticated via Entra ID bearer tokens with `x-ms-client-id`
- Enables conditional access policies and audit logging of caller identity
- NIST: IA-2, IA-5

---

## Network Security Controls

### Private Endpoint — EXCEPTION

- Status: **NOT SUPPORTED** — Azure Maps does not support Private Endpoint
- Impact: SC-7 (Boundary Protection) exception documented in FedRAMP POA&M
- Risk acceptance: Approved with compensating controls

### Compensating Controls (SC-7 Exception)

| # | Compensating Control | Description | NIST Control |
|---|---------------------|-------------|--------------|
| 1 | Managed identity authentication | Shared key auth disabled in production; all requests require Entra ID bearer token | IA-2 |
| 2 | CORS origin restrictions | Only authorized application domains can make cross-origin requests to Maps APIs | AC-4 |
| 3 | Azure Front Door WAF | Web Application Firewall in front of application endpoints consuming Maps APIs | SC-7 |
| 4 | IP address restrictions | Application infrastructure restricts outbound connectivity; Maps API calls routed through controlled egress | SC-7 |
| 5 | No sensitive data in queries | Map tile requests contain only coordinates/addresses — no PII, CUI, or classified data in API payloads | SC-28 |

### CORS Restrictions

- Allowed origins: Restricted to authorized application domains only (no wildcard `*`)
- Configuration: Terraform `cors_allowed_origins` variable
- NIST: AC-4

---

## Data Handling

### Map Query Data Classification

- Map tile requests: Coordinates, zoom levels — **not sensitive**
- Geocoding requests: Addresses — **potentially PII** (minimize usage, do not log)
- Routing requests: Start/end locations — **potentially sensitive** (operational patterns)
- Geofencing: Boundary coordinates — **not sensitive**

### Data Flow Controls

- Application must NOT include PII or CUI in Map API query parameters
- If geocoding addresses that may contain PII, use server-side calls (not client-side JavaScript)
- Access logs do not retain full query parameters beyond diagnostic retention period
- NIST: SI-12, AC-4

---

## Encryption Controls

### Encryption in Transit

- Protocol: TLS 1.2+ for all API calls
- FIPS 140-2: Azure Maps uses FIPS 140-2 validated cryptographic modules
- NIST: SC-8, SC-13

### Encryption at Rest

- Azure Maps is a stateless API — no persistent customer data storage
- Map tiles and reference data stored by Microsoft are encrypted at rest with platform-managed keys
- NIST: SC-28 (N/A for customer data)

---

## Logging & Monitoring Controls

- Diagnostic categories: Audit
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: EL1 (limited categories available)
- Alert rules: Unusual query volume, unauthorized auth attempt
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | **EXCEPTION**: No PE support. Compensating controls: managed identity, CORS, Front Door WAF, IP restrictions | POA&M documented; Terraform: local_authentication_enabled = false |
| SC-8 | Transmission Confidentiality | TLS 1.2 for all API calls | Platform guarantee |
| IA-2 | Identification and Authentication | Managed identity; shared keys disabled in production | Terraform: identity, local_authentication_enabled; Policy: audit-maps-managed-identity-v1 |
| AC-4 | Information Flow Enforcement | CORS restrictions; no sensitive data in queries | Terraform: cors block; Policy: audit-maps-cors-restrictions-v1 |
| AU-12 | Audit Generation | Audit diagnostic logs enabled | Terraform: diagnostic settings |

---

## DISA STIG Mapping

No published DISA STIG for Azure Maps. Compensating controls: NIST 800-53 controls + CIS Azure Benchmark (per R-002).

*"No published DISA STIG for this service. Compensating controls: NIST 800-53 + CIS Benchmark."*

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | Managed identity; shared keys disabled; Entra ID auth | AC-2, AC-3, IA-2 |
| 3.5.1 Identify system users | Entra ID authentication; managed identity caller tracking | IA-2 |
| 3.13.8 Implement cryptographic mechanisms for CUI in transit | TLS 1.2 for all API calls | SC-8, SC-13 |
| 3.13.11 Employ FIPS-validated cryptography | FIPS 140-2 validated TLS modules | SC-13 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.8 | TLS 1.2 for all API interactions |
| SC.L2-3.13.11 | FIPS 140-2 validated cryptographic modules |
| AC.L2-3.1.1 | Managed identity auth; no shared keys in production |
| AU.L2-3.3.1 | Audit logging |

### OMB M-21-31 (Logging Maturity)

- Target tier: EL1 (limited categories available)
- Achieved tier: EL1 — Audit logs collected

---
