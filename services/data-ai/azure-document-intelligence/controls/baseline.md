# Security Control Baseline: Azure Document Intelligence

**Service**: Azure Document Intelligence (Microsoft.CognitiveServices/accounts, kind: FormRecognizer)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Document Intelligence (formerly Form Recognizer) provides AI-powered document processing capabilities — including OCR, layout analysis, prebuilt models, and custom models — for extracting structured data from federal documents. The service enforces defense-in-depth security: Private Endpoint-only network access, managed identity authentication (no API keys in production), customer-managed key encryption for data at rest, and comprehensive audit logging for all API interactions. Special attention is given to PII handling as documents may contain Social Security Numbers, financial data, and other sensitive federal information.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the Document Intelligence account, Private Endpoint, and diagnostic settings. Custom models and training data are managed separately.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Cognitive Services Contributor | Resource (via PIM) | Manage Document Intelligence account configuration and custom models. JIT activation required. | AC-2, AC-3, AC-6 |
| Cognitive Services User | Resource | Invoke document analysis APIs for application managed identities. Standing assignment. | AC-3 |
| Reader | Resource group | Read-only access for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned
- Usage: Application services authenticate to Document Intelligence via managed identity and RBAC roles — no API keys
- Production: Local (API key) authentication disabled (`local_auth_enabled = false`)
- NIST: IA-2, IA-5

### Authentication Model: Managed Identity Only (Production)

- API keys: **Disabled** in production (`local_auth_enabled = false`)
- All API calls authenticated via Entra ID bearer tokens
- Enables conditional access policies, MFA for interactive users, and audit logging of caller identity
- NIST: IA-2, IA-5

---

## Network Security Controls

### Private Endpoint

- Status: Required
- Private DNS Zone: `privatelink.cognitiveservices.azure.com`
- All document analysis API traffic flows exclusively through Private Endpoint
- NIST: SC-7

### Network Rules

- Default action: **Deny** — no public network access
- Public network access: Disabled (`public_network_access_enabled = false`)
- No IP rules or VNet rules — Private Endpoint only
- NIST: SC-7

---

## Data Handling (PII in Documents)

### Document Processing Privacy

- Documents submitted for analysis may contain PII (SSN, financial data, addresses, signatures)
- Document content is processed in-region and not stored beyond the API request lifecycle (unless using custom model training)
- Custom model training data: Stored in customer-managed Azure Storage Account with PE and encryption
- No document content is used for model improvement without explicit opt-in
- NIST: SC-28, SI-12

### PII Detection

- Prebuilt models can identify and extract PII fields (SSN, date of birth, etc.)
- Application-level controls should redact or mask PII before storage
- Access to extracted PII is governed by RBAC and managed identity authentication
- NIST: SI-12, AC-3

---

## Encryption Controls

### Encryption at Rest

- Default: Platform-managed keys (AES-256)
- Optional: Customer-managed key via Key Vault (when `key_vault_key_id` provided)
- Scope: Custom model training data, cached results
- FIPS 140-2: Azure Cognitive Services uses FIPS 140-2 validated cryptographic modules
- NIST: SC-13, SC-28

### Encryption in Transit

- Protocol: TLS 1.2+ for all API calls
- FIPS 140-2: Azure TLS uses FIPS 140-2 validated cryptographic modules
- NIST: SC-8, SC-13

---

## Logging & Monitoring Controls

- Diagnostic categories: Audit, RequestResponse, Trace
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: EL2 for operation logs
- Alert rules: Unauthorized access attempt, high error rate
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Private Endpoint; public access disabled; default-deny network rules | Terraform: public_network_access_enabled = false, network_acls, PE; Policy: deny-docintel-public-access-v1 |
| SC-8 | Transmission Confidentiality | TLS 1.2 for all API calls | Platform guarantee |
| SC-13 | Cryptographic Protection | FIPS 140-2 validated modules; optional CMK | Terraform: customer_managed_key |
| IA-2 | Identification and Authentication | Managed identity; API keys disabled in production | Terraform: identity, local_auth_enabled; Policy: audit-docintel-managed-identity-v1 |
| AU-12 | Audit Generation | Audit, RequestResponse, Trace diagnostic logs | Terraform: diagnostic settings |

---

## DISA STIG Mapping

No published DISA STIG for Azure Document Intelligence / Cognitive Services. Compensating controls: NIST 800-53 controls + CIS Azure Benchmark (per R-002).

*"No published DISA STIG for this service. Compensating controls: NIST 800-53 + CIS Benchmark."*

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | Managed identity; API keys disabled; Entra ID auth | AC-2, AC-3, IA-2 |
| 3.5.1 Identify system users | Entra ID authentication; managed identity caller tracking | IA-2 |
| 3.13.8 Implement cryptographic mechanisms for CUI in transit | TLS 1.2 for all API calls | SC-8, SC-13 |
| 3.13.11 Employ FIPS-validated cryptography | FIPS 140-2 validated TLS and encryption modules | SC-13 |
| 3.14.6 Monitor organizational systems | Audit logging; request/response logging | SI-4, AU-12 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.8 | TLS 1.2 for all API interactions |
| SC.L2-3.13.11 | FIPS 140-2 validated cryptographic modules |
| AC.L2-3.1.1 | Managed identity auth; no API keys in production |
| AU.L2-3.3.1 | Audit, RequestResponse, Trace logging |

### OMB M-21-31 (Logging Maturity)

- Target tier: EL2
- Achieved tier: EL2 — Audit, RequestResponse, Trace collected

---
