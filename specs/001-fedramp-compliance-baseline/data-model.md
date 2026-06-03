# Data Model: FedRAMP High Compliance Baseline

**Branch**: `001-fedramp-compliance-baseline` | **Date**: 2026-03-27 | **Last Updated**: 2026-04-28
**Constitution Version**: v8.0.0 — All GA Azure Commercial Services
**Input**: Feature spec entities, research findings, and architecture reference.

---

## Core Entities

### 1. Azure Policy Definition

A single policy rule targeting a specific configuration aspect of an Azure service for FedRAMP High compliance.

| Field | Type | Description | Validation |
|-------|------|-------------|------------|
| `name` | string | Machine name: `{effect}-{service}-{control}-v{version}` | Lowercase, hyphen-delimited, max 128 chars |
| `displayName` | string | `[FedRAMP High] {Service}: {Control Description}` | Max 256 chars |
| `description` | string | Control rationale with NIST control reference | Required, non-empty |
| `mode` | string | `All` or `Indexed` | Must be valid mode |
| `policyType` | string | `Custom` or `BuiltIn` (reference) | Required |
| `category` | string | `FedRAMP High` | Fixed value for custom policies |
| `version` | string | Semver `1.0.0` | Must be valid semver |
| `effect` | parameter | Configurable: `Audit`, `Deny`, `Disabled` | Default varies by environment |
| `policyRule` | object | `if` / `then` condition and effect | Valid Azure Policy rule schema |
| `metadata.nistControls` | string[] | NIST 800-53 Rev 5 control IDs (e.g., `["SC-8", "SC-13"]`) | At least one required |
| `metadata.frameworks` | string[] | Applicable frameworks (e.g., `["FedRAMP High", "DFARS/CUI", "CMMC 2.0 L2"]`) | At least one required |
| `metadata.fipsApplicable` | boolean | Whether FIPS 140-2 is relevant to this control | Required for encryption controls |
| `metadata.severity` | string | `High`, `Medium`, `Low` | Required |
| `metadata.service` | string | Target Azure service name | Must be a GA Azure Commercial service that is either covered by deliverables or recorded in `docs/azure-service-exclusions.md` |
| `metadata.environment` | string | `all`, `production`, `lower` | Required |

**State transitions**: Draft → Audit (lower) → Audit (production) → Deny (production). Exempt state available with expiration.

### 2. Policy Initiative (Policy Set)

A collection of policy definitions grouped for assignment.

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | `fedramp-high-{service-group}-v{version}` |
| `displayName` | string | `[FedRAMP High] {Service Group} Controls` |
| `policyDefinitions` | reference[] | Array of policy definition references |
| `parameters` | object | Inherited parameters (effect, environment) |
| `metadata.controlFamily` | string | NIST 800-53 family (e.g., `SC`, `AC`, `AU`) or `multi-family` |
| `metadata.assignmentScope` | string[] | Target management groups / subscriptions |

**Relationships**: 1 initiative → many definitions. Initiatives grouped by service group (identity, networking, compute-storage, data-ai).

### 3. Terraform Module

A self-contained, parameterized HCL configuration for deploying a compliant Azure service.

| Field | Type | Description |
|-------|------|-------------|
| `module_name` | string | Service directory name (e.g., `azure-storage-account`) |
| `required_variables` | map | See Terraform Module Interface Contract |
| `optional_variables` | map | Service-specific overrides |
| `outputs` | map | Resource ID, name, private endpoint ID, diagnostic setting ID |
| `provider_version` | string | `~> 3.x` (pinned in `versions.tf`) |
| `environment` | enum | `production` / `lower` — selects configuration profile |

**Relationships**: Service module → consumes shared infrastructure outputs. Service module → validated by corresponding policy initiative.

### 4. Security Control Baseline

A per-service Markdown document defining the required security configuration.

| Section | Content | Requirement |
|---------|---------|-------------|
| Service Overview | Service name, purpose, architecture reference | Required |
| Identity & Access | RBAC roles, Managed Identity, MFA requirements | Required |
| Network Security | Private Endpoint, NSG/firewall, allowed traffic flows | Required |
| Encryption | At rest (algorithm, key type, FIPS cert), in transit (TLS version, FIPS cert) | Required |
| Logging & Monitoring | Diagnostic categories, retention, alert rules, OMB M-21-31 tier | Required |
| NIST 800-53 Control Mapping | Control ID → configuration setting → evidence | Required |
| DISA STIG Mapping | STIG finding ID → configuration (or "No STIG available") | Required |
| Additional Framework Mappings | DFARS/CUI, CMMC, EO 14028, OMB M-22-09 | Where applicable |
| Environment Deltas | Production vs. lower deviations with justification | Required |
| Source References | URLs to Microsoft docs, NIST pubs, DISA STIGs | Required, per Principle V |

**Relationships**: 1 baseline per service. References policy definitions and Terraform module for that service.

### 5. Logging Configuration

Per-service diagnostic settings specification.

| Field | Type | Description |
|-------|------|-------------|
| `service` | string | Azure service name |
| `diagnosticCategories` | string[] | Enabled log categories (service-specific) |
| `metricsCategories` | string[] | Enabled metrics categories |
| `destination` | string | Log Analytics workspace (shared infrastructure output) |
| `retentionOnlineDays` | integer | 365 (12 months) for production |
| `retentionArchiveDays` | integer | 548 (18 months total) for production |
| `ombM2131Tier` | string | `EL1`, `EL2`, or `EL3` — the logging maturity tier achieved |
| `alertRules` | object[] | Alert name, condition, severity, action group |
| `nistAuControls` | string[] | NIST 800-53 AU family control IDs satisfied |

### 6. Compliance Mapping Entry

A row in the consolidated compliance mapping index.

| Field | Type | Description |
|-------|------|-------------|
| `service` | string | Azure service name |
| `configurationSetting` | string | Specific setting (e.g., "Encryption at rest with CMK") |
| `artifactType` | enum | `policy`, `terraform`, `control-baseline`, `logging` |
| `artifactPath` | string | Relative path to the artifact file |
| `nist80053Controls` | string[] | NIST 800-53 Rev 5 control IDs |
| `frameworks` | string[] | All applicable frameworks (FedRAMP, FIPS, STIG, DFARS, CMMC, etc.) |
| `stigFindingId` | string | DISA STIG finding ID (if applicable, else "N/A") |
| `fips140CertRef` | string | FIPS 140-2 certificate reference (if encryption, else "N/A") |
| `sourceUrl` | string | Authoritative documentation URL |
| `environment` | string | `all`, `production`, `lower` |

### 7. Policy Exemption

A documented, time-bound exception to a policy assignment.

| Field | Type | Description |
|-------|------|-------------|
| `policyAssignmentId` | string | Target policy assignment |
| `exemptionCategory` | enum | `Waiver` or `Mitigated` |
| `scope` | string | Resource or resource group scope |
| `justification` | string | Why the exemption is needed |
| `compensatingControl` | string | Alternative control in place |
| `expirationDate` | date | Mandatory expiration |
| `approver` | string | Anonymized approver role |

### 8. Environment Configuration Delta

A documented deviation between production and lower environment.

| Field | Type | Description |
|-------|------|-------------|
| `service` | string | Azure service name |
| `settingName` | string | Configuration setting |
| `productionValue` | string | Production setting value |
| `lowerValue` | string | Lower environment setting value |
| `justification` | string | Rationale for deviation |
| `riskAssessment` | string | Impact of relaxation |
| `minimumBaseline` | boolean | Whether this meets the minimum lower baseline |


---

## Entity Relationships

```
Policy Definition (many) ──────►  Policy Initiative (one per service group)
        │                                    │
        ▼                                    ▼
Terraform Module (one per service)     Management Group Assignment
        │
        ├──► Shared Infrastructure Module (consumes outputs)
        │
        ▼
Security Control Baseline (one per service)
        │
        ├──► Logging Configuration (one per service)
        │
        ├──► NIST 800-53 Control Mapping
        │
        ├──► DISA STIG Mapping
        │
        └──► Environment Configuration Delta (per setting)
        
All entities ──────► Compliance Mapping Index (consolidated)
```

---

## Service Catalog (Iterative Wave Model)

Under Constitution v8.0.0 Principle I, scope is **all GA Azure Commercial services**. There is no fixed closed-set list. Services are brought into the project iteratively in waves; services that cannot meet FedRAMP High are recorded in `docs/azure-service-exclusions.md`.

### Wave 1 — Initial Services (23)

Every Wave 1 service has a complete artifact set (policy + Terraform + controls + logging) plus compliance mapping entries.

| # | Service | Group | Policy | Terraform | Controls | Logging | Notes |
|---|---------|-------|--------|-----------|----------|---------|-------|
| 1 | Azure AD B2C | Identity | ✓ | ✓ | ✓ | ✓ | Customer identity |
| 2 | Managed Identity | Identity | — | — | ✓ | — | Configuration pattern, not standalone resource |
| 3 | Azure App Service | Compute | ✓ | ✓ | ✓ | ✓ | Includes App Service Plans |
| 4 | Azure Functions | Compute | ✓ | ✓ | ✓ | ✓ | |
| 5 | Azure Storage Account | Storage | ✓ | ✓ | ✓ | ✓ | State backend uses this |
| 6 | Key Vault | Security | ✓ | ✓ | ✓ | ✓ | Shared infra + per-service |
| 7 | Bastion | Networking | ✓ | ✓ | ✓ | ✓ | Only admin VM access method |
| 8 | DNS Private Resolver | Networking | ✓ | ✓ | ✓ | ✓ | |
| 9 | Private DNS Zone | Networking | ✓ | ✓ | ✓ | ✓ | Shared infra module |
| 10 | Private Endpoint | Networking | ✓ | ✓ | ✓ | ✓ | Per-service + shared pattern |
| 11 | ExpressRoute | Networking | ✓ | ✓ | ✓ | ✓ | On-prem ↔ Azure connectivity |
| 12 | Azure Front Door | Networking | ✓ | ✓ | ✓ | ✓ | WAF + global load balancing |
| 13 | Azure Monitor | Monitoring | ✓ | ✓ | ✓ | ✓ | Includes Log Analytics |
| 14 | Azure Application Insights | Monitoring | ✓ | ✓ | ✓ | ✓ | |
| 15 | VMs for DNS | Networking | ✓ | ✓ | ✓ | ✓ | Windows Server STIG baseline |
| 16 | Azure OpenAI | Data/AI | ✓ | ✓ | ✓ | ✓ | |
| 17 | Azure AI Search | Data/AI | ✓ | ✓ | ✓ | ✓ | |
| 18 | Azure AI Foundry | Data/AI | ✓ | ✓ | ✓ | ✓ | |
| 19 | Azure Document Intelligence | Data/AI | ✓ | ✓ | ✓ | ✓ | |
| 20 | Azure Maps | Data/AI | ✓ | ✓ | ✓ | ✓ | |
| 21 | Azure Purview | Data/AI | ✓ | ✓ | ✓ | ✓ | Data governance |
| 22 | AI Speech Service | Data/AI | ✓ | ✓ | ✓ | ✓ | |
| 23 | Event Hubs | Data/AI | ✓ | ✓ | ✓ | ✓ | |

### Wave 2 — Sweep Candidates (TBD)

Wave 2 enumerates remaining GA Azure Commercial services not yet in scope and not yet excluded. The candidate list is produced as `docs/wave-2-candidates.md` (task T018) and each candidate is classified as `policy-eligible` (full artifact set) or `exclude` (recorded in `docs/azure-service-exclusions.md` with required fields).

### Standing Exclusions (recorded in `docs/azure-service-exclusions.md`)

- Microsoft 365 (all workloads) — SaaS, no Azure ARM types
- Entra ID (standalone) — SaaS identity platform; per-service Azure consumption documented inline
- Microsoft Intune — SaaS endpoint management, no Azure ARM types

### Continuous Maintenance

When Microsoft GA's a new Azure Commercial service, or upgrades a previously excluded service to support FedRAMP High capabilities, the project MUST add the service to scope and (if previously excluded) remove the exclusion. New services are subject to the same per-service Project Owner approval gate before being considered complete.
