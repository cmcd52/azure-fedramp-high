# Security Control Baseline: Azure AI Search

**Service**: Azure AI Search (Microsoft.Search/searchServices)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure AI Search provides full-text search, semantic ranking, vector search, and AI enrichment capabilities over federal data indexes. The service enforces defense-in-depth security: Private Endpoint-only access, managed identity for data source connections, customer-managed key encryption for index data, TLS 1.2 minimum, RBAC preferred over API keys, and comprehensive operation logging.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the AI Search service, Private Endpoint, and diagnostic settings. Index schemas, skillsets, and data source connections are managed separately.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Search Service Contributor | Resource (via PIM) | Manages search service configuration, indexes, and data sources. JIT activation required. | AC-2, AC-3, AC-6 |
| Search Index Data Contributor | Resource (via PIM) | Upload, modify, and delete index data. JIT activation required. | AC-2, AC-3, AC-6 |
| Search Index Data Reader | Resource | Read-only query access for application managed identities. Standing assignment. | AC-3 |
| Reader | Resource group | Read-only access for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned
- Usage: AI Search authenticates to data sources (Azure Blob, SQL, Cosmos DB) via managed identity — no connection strings with embedded credentials
- Indexer connections: Managed identity for secure data source access
- NIST: IA-2, IA-5

### Access Model: RBAC Preferred

- API keys: **Disabled** in production (`local_authentication_enabled = false`)
- RBAC-based authentication preferred for both control plane and data plane operations
- NIST: AC-3, AC-6, IA-2

---

## Network Security Controls

### Private Endpoint

- Status: Required
- Private DNS Zone: `privatelink.search.windows.net`
- All query and indexing traffic flows exclusively through Private Endpoint
- NIST: SC-7

### Network Rules

- Public network access: **Disabled** (`public_network_access_enabled = false`)
- No IP rules or VNet rules — Private Endpoint only
- NIST: SC-7

---

## Encryption Controls

### Encryption at Rest — Index Data

- Default: Platform-managed keys (AES-256) for index storage
- Optional: Customer-managed key (CMK) for index encryption via Key Vault
  - CMK encrypts: index content, synonym maps, indexers, data source definitions, skillset definitions
  - Key Vault: FIPS 140-2 Level 2 validated HSM
  - Key rotation: Managed via Key Vault rotation policy
- NIST: SC-13, SC-28

### Encryption in Transit

- Protocol: TLS 1.2 minimum (enforced via `minimum_tls_version`)
- All client-to-service and service-to-data-source communications encrypted
- FIPS 140-2: Azure Search TLS uses FIPS 140-2 validated cryptographic modules
- NIST: SC-8, SC-13
- NIST SP 800-52 Rev 2: TLS 1.2 compliant

---

## Logging & Monitoring Controls

- Diagnostic categories: OperationLogs, AllMetrics
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: EL2 for operation logs
- Alert rules: Index corruption, query failure rate, throttling events
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Private Endpoint; public access disabled | Terraform: public_network_access_enabled = false, PE; Policy: deny-aisearch-public-access-v1 |
| SC-8 | Transmission Confidentiality | TLS 1.2 minimum | Terraform: minimum_tls_version; Policy: deny-aisearch-minimum-tls-v1 |
| SC-13 | Cryptographic Protection | FIPS 140-2 validated modules; CMK for index encryption | Terraform: encryption block; Key Vault integration |
| SC-28 | Protection of Information at Rest | AES-256 encryption; optional CMK for index content | Terraform: encryption block |
| IA-2 | Identification and Authentication | Managed identity; API keys disabled in production | Terraform: identity, local_authentication_enabled; Policy: audit-aisearch-managed-identity-v1 |

---

## DISA STIG Mapping

No published DISA STIG for Azure AI Search / Cognitive Search. Compensating controls: NIST 800-53 controls + CIS Azure Benchmark (per R-002).

*"No published DISA STIG for this service. Compensating controls: NIST 800-53 + CIS Benchmark."*

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | RBAC; managed identity; API keys disabled | AC-2, AC-3, IA-2 |
| 3.1.2 Limit system access to authorized functions | Search data roles (Index Data Reader/Contributor) | AC-3, AC-6 |
| 3.13.8 Implement cryptographic mechanisms for CUI in transit | TLS 1.2 minimum | SC-8, SC-13 |
| 3.13.11 Employ FIPS-validated cryptography | FIPS 140-2 validated TLS and encryption | SC-13 |
| 3.13.16 Protect CUI at rest | CMK encryption for index data | SC-28 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.8 | TLS 1.2 minimum for all search API calls |
| SC.L2-3.13.11 | FIPS 140-2 validated cryptographic modules |
| SC.L2-3.13.16 | CMK encryption for index content at rest |
| AC.L2-3.1.1 | RBAC access; managed identity authentication |
| AU.L2-3.3.1 | OperationLogs diagnostic logging |

### OMB M-21-31 (Logging Maturity)

- Target tier: EL2 for operation logs
- Achieved tier: EL2 — OperationLogs collected

---
