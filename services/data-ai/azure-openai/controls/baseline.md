# Security Control Baseline: Azure OpenAI

**Service**: Azure OpenAI (Microsoft.CognitiveServices/accounts, kind: OpenAI)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure OpenAI provides large language model (LLM) capabilities — including GPT-4, GPT-4o, and embedding models — for federal workloads. The service enforces defense-in-depth security: Private Endpoint-only network access, managed identity authentication (no API keys in production), content filtering for responsible AI, customer-managed key encryption when supported, and comprehensive audit logging for all API interactions.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the Azure OpenAI account, Private Endpoint, and diagnostic settings. Model deployments are managed separately with content filtering policies applied at the deployment level.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Cognitive Services OpenAI Contributor | Resource (via PIM) | Deploy and manage OpenAI models and deployments. JIT activation required. | AC-2, AC-3, AC-6 |
| Cognitive Services OpenAI User | Resource | Invoke model completions and embeddings for application managed identities. Standing assignment. | AC-3 |
| Cognitive Services Contributor | Resource group (via PIM) | Manage Cognitive Services account configuration. JIT activation required. | AC-2, AC-3, AC-6 |
| Reader | Resource group | Read-only access for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned
- Usage: Application services authenticate to Azure OpenAI via managed identity and RBAC roles — no API keys
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
- Private DNS Zone: `privatelink.openai.azure.com`
- All API traffic flows exclusively through Private Endpoint
- NIST: SC-7

### Network Rules

- Default action: **Deny** — no public network access
- Public network access: Disabled (`public_network_access_enabled = false`)
- Outbound network access: Restricted (`outbound_network_access_restricted = true`)
- No IP rules or VNet rules — Private Endpoint only
- NIST: SC-7

---

## Content Filtering (Responsible AI)

### Default Content Filter

- Status: **Enabled** on all model deployments
- Categories filtered: Hate, Sexual, Violence, Self-harm
- Severity thresholds: Medium or above blocked (customizable per deployment)
- Prompt injection detection: Enabled
- NIST: SI-4

### Custom Content Filters

- Blocklists: Organization-specific term blocking for sensitive topics
- Jailbreak detection: Enabled to prevent prompt manipulation
- Data exfiltration prevention: Content filtering monitors for PII/CUI in outputs
- Policy enforcement: `audit-openai-content-filtering-v1`

---

## Data Residency

- Region: US regions only for FedRAMP High compliance
- Data processing: All prompts and completions processed within the selected Azure region
- Data storage: Azure OpenAI does not store prompt/completion data beyond 30-day abuse monitoring (opt-out available for approved customers)
- Model training: Customer data is NOT used for model training
- NIST: N/A (FedRAMP data residency requirement)

---

## Encryption Controls

### Encryption at Rest

- Default: Platform-managed keys (AES-256)
- Optional: Customer-managed key via Key Vault (when `key_vault_key_id` provided)
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
- OMB M-21-31 tier: EL2 for request/response, EL3 for audit events
- Alert rules: Unauthorized access attempt, content filter trigger, token rate limit exceeded
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Private Endpoint; public access disabled; outbound restricted | Terraform: public_network_access_enabled = false, PE; Policy: deny-openai-public-access-v1 |
| SC-8 | Transmission Confidentiality | TLS 1.2 for all API calls | Platform guarantee |
| SC-13 | Cryptographic Protection | FIPS 140-2 validated modules; optional CMK | Terraform: customer_managed_key |
| IA-2 | Identification and Authentication | Managed identity; API keys disabled in production | Terraform: identity, local_auth_enabled; Policy: audit-openai-managed-identity-v1 |
| AU-12 | Audit Generation | Audit, RequestResponse, Trace diagnostic logs | Terraform: diagnostic settings |
| SI-4 | Information System Monitoring | Content filtering on all deployments | Policy: audit-openai-content-filtering-v1 |

---

## DISA STIG Mapping

No published DISA STIG for Azure OpenAI / Cognitive Services. Compensating controls: NIST 800-53 controls + CIS Azure Benchmark (per R-002).

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
| 3.14.6 Monitor organizational systems | Content filtering; audit logging; request/response logging | SI-4, AU-12 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.8 | TLS 1.2 for all API interactions |
| SC.L2-3.13.11 | FIPS 140-2 validated cryptographic modules |
| AC.L2-3.1.1 | Managed identity auth; no API keys in production |
| SI.L2-3.14.6 | Content filtering + audit logging |
| AU.L2-3.3.1 | Audit, RequestResponse, Trace logging |

### OMB M-21-31 (Logging Maturity)

- Target tier: EL2 for request/response, EL3 for audit events
- Achieved tier: EL2/EL3 — Audit, RequestResponse, Trace collected

---
