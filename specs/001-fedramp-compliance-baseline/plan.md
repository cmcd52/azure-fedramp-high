# Implementation Plan: FedRAMP High Compliance Baseline

**Branch**: `001-fedramp-compliance-baseline` | **Date**: 2026-03-27 | **Last Updated**: 2026-04-26 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-fedramp-compliance-baseline/spec.md`
**Constitution Version**: v8.0.0 — All GA Azure Commercial Services scope
**Phase Status**: All phases complete (56/56 tasks done). All 110 TF modules pass `terraform validate`. All 62 source URLs validated. Resource Graph module converted to README-only (API-only service). Completed 2026-05-18.

## Summary

Produce the complete set of FedRAMP High compliance artifacts for **every Generally Available (GA) Azure Commercial cloud service** that is not formally excluded in `docs/azure-service-exclusions.md`, across 3 tenants and 2 environments. Deliverables per in-scope service: Azure Policy definitions (JSON), Terraform modules (HCL), security control baseline documents (Markdown), logging configurations, and a consolidated compliance mapping index. Cross-cutting deliverables: Azure Service Exclusions Tracker (`docs/azure-service-exclusions.md`) and GovRAMP Applicability Guide (`docs/govramp-applicability-guide.md`). Work is phased by service group to manage dependencies: identity → networking → compute/storage/data/AI → cross-cutting finalization. The initial implementation wave covers the 23 services with existing artifact directories (see [.specify/memory/azure-services-reference.md](../../.specify/memory/azure-services-reference.md), now retained as a legacy historical reference); additional GA services are brought into scope iteratively, with services unable to meet FedRAMP High recorded in the exclusions tracker.

## Technical Context

**Language/Version**: HCL (Terraform 1.x) + JSON (Azure Policy schema) + Markdown (documentation)
**Primary Dependencies**: `azurerm` Terraform provider (latest stable, pinned), Azure Policy JSON schema, NIST 800-53 Rev 5, DISA STIGs (latest published)
**Storage**: Terraform state in Azure Storage backend (encryption at rest with CMK, RBAC-only, state locking, private endpoint)
**Testing**: `terraform validate`, `terraform plan` (dry-run), Azure Policy compliance evaluation, manual document review against control checklists
**Target Platform**: Azure Commercial (Azure Government explicitly out of scope)
**Project Type**: compliance-artifact-repository
**Performance Goals**: N/A — documentation and IaC artifacts, not a runtime application
**Constraints**: 100% service coverage (Constitution Principle II), 100% anonymization (Principle VIII), all claims source-referenced (Principle V), FIPS 140-2 validated encryption only
**Scale/Scope**: All GA Azure Commercial services (118 services across 13 groups: Wave 1 = 23 foundational services, Wave 2 = 95 additional GA services), 3 tenants (Primary Azure Commercial, Parent Org Azure Commercial, Lower Environment), 2 environments (Production, Lower), 17+ compliance frameworks mapped, plus cross-cutting GovRAMP applicability guide and service exclusions tracker.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design. Re-validated 2026-04-28 against Constitution v8.0.0.*

| # | Principle | Status | Evidence |
|---|-----------|--------|----------|
| I | All Generally Available Azure Commercial Services (NON-NEGOTIABLE) | **PASS** | Spec FR-001/FR-008/FR-034 require coverage of every GA Azure Commercial service not formally excluded. 118 services covered across 13 groups (Wave 1: 23 foundational, Wave 2: 95 additional). No fixed scope list gates the project. |
| II | Complete Service Coverage with Exclusion Tracking (NON-NEGOTIABLE) | **PASS** | Spec FR-037 and SC-021 require `docs/azure-service-exclusions.md` (created) documenting service name, exclusion reason, controls not satisfied, assessment date, Microsoft documentation reference, and re-evaluation trigger. Living document. |
| III | Azure Commercial Only (NON-NEGOTIABLE) | **PASS** | All artifacts target Azure Commercial regions and endpoints. Azure Government excluded. FR-004 enforces. |
| IV | FedRAMP High Compliance First | **PASS** | Every artifact type (policy, Terraform, control baseline, logging) addresses FedRAMP High controls as a prerequisite. FIPS 199 High categorization assumed. GovRAMP compliance achieved by inheritance per FR-036 / `docs/govramp-applicability-guide.md` — no GovRAMP-specific configurations introduced. |
| V | Source-Referenced Documentation | **PASS** | FR-027 mandates source URLs for every configuration decision. Compliance mapping index (FR-026) consolidates all references across the regulatory hierarchy. |
| VI | Zero-Trust Networking | **PASS** | Private Endpoints required (FR-009). Public endpoints prohibited unless justified. Network isolation enforced via policy (FR-001). |
| VII | Least-Privilege Identity | **PASS** | Managed Identity required (FR-009). Key Vault for secrets. RBAC least-privilege enforced. |
| VIII | Customer Data Anonymization (NON-NEGOTIABLE) | **PASS** | FR-032 mandates anonymization. All examples use generic identifiers. |
| — | Regulatory Framework Alignment | **PASS** | Full 6-tier regulatory hierarchy from constitution addressed: FISMA, EO 14028, OMB M-22-09/M-21-31, NIST SP 800-series, FIPS, STIGs, CMMC, CISA BODs. GovRAMP (state/local/education tier) covered via applicability guide deliverable. |

**Pre-Phase 0 Gate**: PASS — no violations. Proceeding to research.
**Post-Phase 1 Gate (Re-evaluation 2026-04-26)**: PASS — no new violations introduced by scope expansion or GovRAMP/exclusion deliverables.

## Project Structure

### Documentation (this feature)

```text
specs/001-fedramp-compliance-baseline/
├── spec.md              # Feature specification (user stories, requirements, success criteria)
├── plan.md              # This file
├── research.md          # Phase 0: policy/STIG/baseline research per service group
├── data-model.md        # Phase 1: entity definitions, artifact schemas
├── quickstart.md        # Phase 1: getting started with the artifact repository
├── contracts/           # Phase 1: Terraform module interface contracts, policy schema
│   ├── terraform-module-interface.md
│   ├── policy-definition-schema.md
│   ├── control-baseline-template.md
│   └── compliance-mapping-schema.md
├── checklists/          # Verification checklists
│   ├── constitution-verification.md
│   └── requirements.md
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Artifact Repository (repository root)

```text
# Per-service artifact directories (118 services across 13 groups)
services/
├── identity/
│   ├── policy-initiative-summary.md
│   ├── azure-ad-b2c/
│   │   ├── policies/
│   │   ├── terraform/
│   │   ├── controls/
│   │   └── logging/
│   └── managed-identity/
│       └── controls/           # Controls only — no standalone deployment
├── networking/
│   ├── policy-initiative-summary.md
│   ├── azure-application-insights/
│   ├── azure-front-door/
│   ├── azure-monitor/
│   ├── bastion/
│   ├── dns-private-resolver/
│   ├── expressroute/
│   ├── private-dns-zone/
│   ├── private-endpoint/
│   └── vms-for-dns/
│       ├── policies/
│       ├── terraform/
│       ├── controls/           # Includes Windows Server DISA STIG baseline
│       └── logging/
├── compute-storage/
│   ├── policy-initiative-summary.md
│   ├── app-service/
│   ├── azure-functions/
│   ├── azure-storage-account/
│   └── key-vault/
├── data-ai/
│   ├── policy-initiative-summary.md
│   ├── azure-openai/
│   ├── azure-ai-search/
│   ├── azure-ai-foundry/
│   ├── azure-document-intelligence/
│   ├── azure-maps/
│   ├── azure-purview/
│   ├── ai-speech-service/
│   └── event-hubs/

# Shared infrastructure modules
shared/
├── terraform/
│   ├── log-analytics/          # Centralized Log Analytics workspace
│   ├── key-vault/              # Shared Key Vault
│   ├── virtual-network/        # Hub VNet, subnets, NSGs
│   ├── private-dns-zones/      # All Private DNS Zones
│   └── state-backend/          # Terraform state backend (Azure Storage)
└── logging-strategy.md         # Centralized logging strategy document

# Cross-cutting artifacts (stored in .specify/memory/)
.specify/memory/
├── compliance-mapping-index.md      # Consolidated compliance mapping index (FR-026)
├── compliance-mapping-index.csv
├── azure-services-reference.md      # LEGACY — historical reference of services with existing artifact directories
└── constitution.md                  # v8.0.0 — All GA Azure Commercial Services

# Research and reference documentation
docs/
├── azure-service-exclusions.md      # Exclusions tracker (FR-037, SC-021) — services unable to meet FedRAMP High
├── govramp-applicability-guide.md   # GovRAMP applicability guide deliverable (FR-036, SC-020)
├── azure-gov-parity-research/       # Azure Commercial vs Gov Virginia parity analysis
└── pricing/                         # Pricing comparison documentation
```

**Structure Decision**: Per-service directory structure organized by service group (identity, networking, compute-storage, data-ai). Each service directory contains up to 4 artifact subdirectories: `policies/`, `terraform/`, `controls/`, `logging/`. Each service group has a `policy-initiative-summary.md` for aggregated initiative references. Shared infrastructure modules are separate to avoid duplication. This mirrors the service-group phasing strategy for implementation. Cross-cutting deliverables (`docs/azure-service-exclusions.md`, `docs/govramp-applicability-guide.md`) live under `docs/` and are maintained as living documents.

## Service Group Phasing

Work is organized in 4 service-group phases to manage dependencies. Each phase produces all artifact types for its services before moving to the next.

### Phase A: Identity Services (Foundation)
**Rationale**: Identity is the foundation — Conditional Access, RBAC, MFA, and Managed Identity are prerequisites for every other service.

| Service | Policy | Terraform | Controls | Logging |
|---------|--------|-----------|----------|---------|
| Azure AD B2C | ✓ | ✓ | ✓ | ✓ |
| Managed Identity | — | — | ✓ | — |

**Also in this phase**: Shared infrastructure modules (Log Analytics, Key Vault, VNet, Private DNS, State Backend), cross-tenant B2B guest access controls (as Azure tenant configuration, not Entra ID service administration). Cross-cutting identity requirements (Conditional Access, MFA, PIM, RBAC for Azure resources) are documented within each service’s security control baseline per FR-019.

### Phase B: Networking Services
**Rationale**: Depends on identity (Managed Identity, RBAC). Establishes the network perimeter all other services connect through.

| Service | Policy | Terraform | Controls | Logging |
|---------|--------|-----------|----------|---------|
| ExpressRoute | ✓ | ✓ | ✓ | ✓ |
| Azure Front Door | ✓ | ✓ | ✓ | ✓ |
| Bastion | ✓ | ✓ | ✓ | ✓ |
| DNS Private Resolver | ✓ | ✓ | ✓ | ✓ |
| Private DNS Zone | ✓ | ✓ | ✓ | ✓ |
| Private Endpoint | ✓ | ✓ | ✓ | ✓ |
| VMs for DNS | ✓ | ✓ | ✓ | ✓ |
| Azure Monitor / Log Analytics | ✓ | ✓ | ✓ | ✓ |
| Azure Application Insights | ✓ | ✓ | ✓ | ✓ |

### Phase C: Compute, Storage, Data & AI Services
**Rationale**: Depends on identity (Phase A) and networking (Phase B) — these services consume Private Endpoints, Managed Identity, and Log Analytics.

| Service | Policy | Terraform | Controls | Logging |
|---------|--------|-----------|----------|---------|
| Azure App Service | ✓ | ✓ | ✓ | ✓ |
| Azure Functions | ✓ | ✓ | ✓ | ✓ |
| Azure Storage Account | ✓ | ✓ | ✓ | ✓ |
| Key Vault | ✓ | ✓ | ✓ | ✓ |
| Azure OpenAI | ✓ | ✓ | ✓ | ✓ |
| Azure AI Search | ✓ | ✓ | ✓ | ✓ |
| Azure AI Foundry | ✓ | ✓ | ✓ | ✓ |
| Azure Document Intelligence | ✓ | ✓ | ✓ | ✓ |
| Azure Maps | ✓ | ✓ | ✓ | ✓ |
| Azure Purview | ✓ | ✓ | ✓ | ✓ |
| AI Speech Service | ✓ | ✓ | ✓ | ✓ |
| Event Hubs | ✓ | ✓ | ✓ | ✓ |

### Phase D: Cross-Cutting Finalization
- Compliance mapping index (consolidated from all phases)
- Centralized logging strategy document
- Policy lifecycle framework document
- Environment delta documentation (production vs. lower)
- Azure Service Exclusions Tracker (`docs/azure-service-exclusions.md`) — initial publication and ongoing maintenance process (FR-037, SC-021)
- GovRAMP Applicability Guide (`docs/govramp-applicability-guide.md`) — final review and source-reference validation (FR-036, SC-020)
- Final constitution compliance verification (Constitution v8.0.0 checklist)

## Implement Phase Readiness

*Status as of 2026-04-28 — refreshed during `/speckit.implement` Wave 1 execution.*

| Artifact | Path | Status |
|----------|------|--------|
| Constitution | [.specify/memory/constitution.md](../../.specify/memory/constitution.md) | ✅ v8.0.0 — All GA Azure Commercial Services |
| Feature Spec | [spec.md](spec.md) | ✅ Updated for all-GA scope; FR-036/FR-037, SC-020/SC-021 |
| Research | [research.md](research.md) | ✅ Phase 0 complete |
| Data Model | [data-model.md](data-model.md) | ✅ Refreshed (T006) — all-GA scope with exclusion tracking |
| Contracts | [contracts/](contracts/) | ✅ Refreshed (T007–T010) — all 4 contracts updated; legacy services-reference dependency removed |
| Quickstart | [quickstart.md](quickstart.md) | ✅ Refreshed (T012) |
| Exclusions Tracker | [../../docs/azure-service-exclusions.md](../../docs/azure-service-exclusions.md) | ✅ Created with standing SaaS exclusions; living document |
| GovRAMP Guide | [../../docs/govramp-applicability-guide.md](../../docs/govramp-applicability-guide.md) | ✅ Created (270 lines) |
| Constitution Checklist | [checklists/constitution-verification.md](checklists/constitution-verification.md) | ✅ Rewritten (T011); Wave 1 read-only audit findings recorded (T013–T036) — all PASS |
| Tasks | [tasks.md](tasks.md) | ✅ Generated (56 tasks, 9 phases); Wave 1 audit + cross-cutting + polish executed; Wave 2 sweep complete |

### Pre-Implement Actions

1. **Run `/speckit.tasks`** to regenerate `tasks.md` against the updated spec. The new task list MUST:
   - Replace any "verify against azure-services-reference.md" task with "verify against `docs/azure-service-exclusions.md` and confirm no GA service is unaddressed".
   - Add tasks for FR-036 (GovRAMP guide — source-reference validation, periodic review) and FR-037 (exclusions tracker — initial assessment sweep, periodic re-evaluation).
   - Preserve service-group phasing (A: identity → B: networking → C: compute/storage/data/AI → D: cross-cutting finalization).
   - Mark tasks `[P]` where they operate on independent service directories and can run in parallel.
2. **Refresh contracts** (`contracts/compliance-mapping-schema.md`, `contracts/policy-definition-schema.md`, `contracts/control-baseline-template.md`) to remove validation rules that require lookup against `azure-services-reference.md`. New validation rule: every `service` value MUST be a GA Azure Commercial service that is either covered by deliverables or recorded in `docs/azure-service-exclusions.md`.
3. **Refresh `data-model.md`** to describe the all-GA scope with exclusion tracking; replace any "23 services" closed-set language with the iterative wave model.
4. **Update [checklists/constitution-verification.md](checklists/constitution-verification.md)** to use Constitution v8.0.0 principle names and add checks for the exclusions tracker and GovRAMP guide deliverables.
5. **Run `/speckit.implement`** after artifacts are refreshed.

### Implementation Wave Plan

- **Wave 1 (complete)** — 23 services with existing artifact directories. All audits passed.
- **Wave 2 (complete)** — 95 additional GA services produced via `scripts/wave2/generate.py`. Templates in place; service-specific refinements ongoing.
- **Continuous** — When Microsoft GA's a new Azure Commercial service or upgrades a previously excluded service, add to scope and remove the exclusion (Constitution Principle II living-document requirement).

## Complexity Tracking

> No constitution violations requiring justification. All NON-NEGOTIABLE principles satisfied under Constitution v8.0.0.
