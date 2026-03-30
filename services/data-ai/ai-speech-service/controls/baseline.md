# Security Control Baseline: AI Speech Service

**Service**: AI Speech Service (Microsoft.CognitiveServices/accounts, kind: SpeechServices)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure AI Speech Service provides speech-to-text, text-to-speech, speech translation, and speaker recognition capabilities for federal workloads. The service enforces defense-in-depth security: Private Endpoint-only network access, managed identity authentication (no API keys in production), customer-managed key encryption for custom model data, and comprehensive audit logging. Audio data may contain PII — network isolation and encryption are critical for speech processing workloads.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the Speech Service account, Private Endpoint, and diagnostic settings. Custom speech models and endpoints are managed separately.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Cognitive Services Speech Contributor | Resource (via PIM) | Deploy and manage custom speech models and endpoints. JIT activation required. | AC-2, AC-3, AC-6 |
| Cognitive Services Speech User | Resource | Invoke speech-to-text, text-to-speech, and translation for application managed identities. Standing assignment. | AC-3 |
| Cognitive Services Contributor | Resource group (via PIM) | Manage Cognitive Services account configuration. JIT activation required. | AC-2, AC-3, AC-6 |
| Reader | Resource group | Read-only access for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned
- Usage: Application services authenticate to Speech Service via managed identity and RBAC roles — no API keys
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
- All speech API traffic flows exclusively through Private Endpoint
- NIST: SC-7

### Network Rules

- Default action: **Deny** — no public network access
- Public network access: Disabled (`public_network_access_enabled = false`)
- No IP rules or VNet rules — Private Endpoint only
- NIST: SC-7

---

## Audio Data Handling (PII Considerations)

### Speech Content as PII

- Audio data: Speech content may contain personally identifiable information (PII), including names, addresses, SSN references, and health information
- Real-time transcription: Audio streams are processed in memory and not persisted unless custom logging is enabled
- Batch transcription: Audio files stored in customer-managed storage (encrypted at rest)
- Custom model training data: Audio/text data uploaded for custom model training is encrypted at rest
- NIST: SC-28 (protection of information at rest)

### Custom Models: Data at Rest Encryption

- Training data: Encrypted with platform-managed keys (default) or customer-managed keys (CMK)
- Custom model artifacts: Encrypted at rest
- Custom endpoint data: Audio processed by custom endpoints is not stored beyond the request lifecycle
- NIST: SC-13, SC-28

---

## Encryption Controls

### Encryption at Rest

- Default: Platform-managed keys (AES-256)
- Optional: Customer-managed key via Key Vault (when `key_vault_key_id` provided)
- Custom model training data: CMK supported for at-rest encryption
- FIPS 140-2: Azure Cognitive Services uses FIPS 140-2 validated cryptographic modules
- NIST: SC-13, SC-28

### Encryption in Transit

- Protocol: TLS 1.2+ for all API calls and audio streams
- WebSocket connections: TLS 1.2 for real-time speech-to-text streaming
- FIPS 140-2: Azure TLS uses FIPS 140-2 validated cryptographic modules
- NIST: SC-8, SC-13

---

## Logging & Monitoring Controls

- Diagnostic categories: Audit, RequestResponse, Trace
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: EL2 for request/response, EL3 for audit events
- Alert rules: Unauthorized access, high error rate, unusual request patterns
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Private Endpoint; public access disabled; network rules default deny | Terraform: public_network_access_enabled = false, PE; Policy: deny-speech-public-access-v1 |
| SC-8 | Transmission Confidentiality | TLS 1.2 for all API calls and audio streams | Platform guarantee |
| SC-13 | Cryptographic Protection | FIPS 140-2 validated modules; optional CMK for custom models | Terraform: customer_managed_key |
| IA-2 | Identification and Authentication | Managed identity; API keys disabled in production | Terraform: identity, local_auth_enabled; Policy: audit-speech-managed-identity-v1 |
| AU-12 | Audit Generation | Audit, RequestResponse, Trace diagnostic logs | Terraform: diagnostic settings |

---

## DISA STIG Mapping

No published DISA STIG for Azure AI Speech Service / Cognitive Services. Compensating controls: NIST 800-53 controls + CIS Azure Benchmark (per R-002).

*"No published DISA STIG for this service. Compensating controls: NIST 800-53 + CIS Benchmark."*

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | Managed identity; API keys disabled; Entra ID auth | AC-2, AC-3, IA-2 |
| 3.5.1 Identify system users | Entra ID authentication; managed identity caller tracking | IA-2 |
| 3.13.8 Implement cryptographic mechanisms for CUI in transit | TLS 1.2 for all API calls and audio streams | SC-8, SC-13 |
| 3.13.11 Employ FIPS-validated cryptography | FIPS 140-2 validated TLS and encryption modules | SC-13 |
| 3.14.6 Monitor organizational systems | Audit logging; request/response logging | SI-4, AU-12 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.8 | TLS 1.2 for all speech API and audio stream interactions |
| SC.L2-3.13.11 | FIPS 140-2 validated cryptographic modules |
| AC.L2-3.1.1 | Managed identity auth; no API keys in production |
| SI.L2-3.14.6 | Audit + request/response logging |
| AU.L2-3.3.1 | Audit, RequestResponse, Trace logging |

### OMB M-21-31 (Logging Maturity)

- Target tier: EL2 for request/response, EL3 for audit events
- Achieved tier: EL2/EL3 — Audit, RequestResponse, Trace collected

---
