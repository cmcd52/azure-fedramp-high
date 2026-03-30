# Implementation Plan: FedRAMP High Compliance Baseline

**Branch**: `001-fedramp-compliance-baseline` | **Date**: 2026-03-27 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-fedramp-compliance-baseline/spec.md`

## Summary

Produce the complete set of FedRAMP High compliance artifacts for all 23 in-scope Azure services across 3 tenants and 2 environments. Deliverables per service: Azure Policy definitions (JSON), Terraform modules (HCL), security control baseline documents (Markdown), logging configurations, and a consolidated compliance mapping index. Work is phased by service group to manage dependencies: identity services → networking → compute/storage/data/AI.

## Technical Context

**Language/Version**: HCL (Terraform 1.x) + JSON (Azure Policy schema) + Markdown (documentation)
**Primary Dependencies**: `azurerm` Terraform provider (latest stable, pinned), Azure Policy JSON schema, NIST 800-53 Rev 5, DISA STIGs (latest published)
**Storage**: Terraform state in Azure Storage backend (encryption at rest with CMK, RBAC-only, state locking, private endpoint)
**Testing**: `terraform validate`, `terraform plan` (dry-run), Azure Policy compliance evaluation, manual document review against control checklists
**Target Platform**: Azure Commercial (Azure Government explicitly out of scope)
**Project Type**: compliance-artifact-repository
**Performance Goals**: N/A — documentation and IaC artifacts, not a runtime application
**Constraints**: 100% service coverage (Constitution Principle II), 100% anonymization (Principle VIII), all claims source-referenced (Principle V), FIPS 140-2 validated encryption only
**Scale/Scope**: 23 Azure services, 3 tenants (Primary Azure Commercial, Parent Org Azure Commercial, Lower Environment), 2 environments (Production, Lower), 17+ compliance frameworks mapped

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Principle | Status | Evidence |
|---|-----------|--------|----------|
| I | Scoped Azure Services (NON-NEGOTIABLE) | **PASS** | All services sourced from `.specify/memory/azure-services-reference.md`. No additional services introduced. |
| II | Complete Service Coverage (NON-NEGOTIABLE) | **PASS** | Plan covers all 23 services in reference. Service-group phasing ensures no omissions. Verified against reference v3.0.0. |
| III | Azure Commercial Only (NON-NEGOTIABLE) | **PASS** | All artifacts target Azure Commercial regions and endpoints. Azure Government excluded. |
| IV | FedRAMP High Compliance First | **PASS** | Every artifact type (policy, Terraform, control baseline, logging) addresses FedRAMP High controls as a prerequisite. FIPS 199 High categorization assumed. |
| V | Source-Referenced Documentation | **PASS** | FR-027 mandates source URLs for every configuration decision. Compliance mapping index (FR-026) consolidates all references. |
| VI | Zero-Trust Networking | **PASS** | Private Endpoints required (FR-009). Public endpoints prohibited unless justified. Network isolation enforced via policy (FR-001). |
| VII | Least-Privilege Identity | **PASS** | Managed Identity required (FR-009). Key Vault for secrets. RBAC least-privilege enforced. |
| VIII | Customer Data Anonymization (NON-NEGOTIABLE) | **PASS** | FR-032 mandates anonymization. All examples use generic identifiers. |
| — | Regulatory Framework Alignment | **PASS** | Full 6-tier regulatory hierarchy from constitution addressed: FISMA, EO 14028, OMB M-22-09/M-21-31, NIST SP 800-series, FIPS, STIGs, CMMC, CISA BODs. |

**Pre-Phase 0 Gate**: PASS — no violations. Proceeding to research.

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
# Per-service artifact directories (23 services)
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
├── compliance-mapping-index.md # Consolidated compliance mapping index (FR-026)
├── compliance-mapping-index.csv
├── azure-services-reference.md
└── constitution.md

# Research and reference documentation
docs/
├── azure-gov-parity-research/  # Azure Commercial vs Gov Virginia parity analysis
└── pricing/                    # Pricing comparison documentation
```

**Structure Decision**: Per-service directory structure organized by service group (identity, networking, compute-storage, data-ai). Each service directory contains up to 4 artifact subdirectories: `policies/`, `terraform/`, `controls/`, `logging/`. Each service group has a `policy-initiative-summary.md` for aggregated initiative references. Shared infrastructure modules are separate to avoid duplication. This mirrors the service-group phasing strategy for implementation.

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
- Final constitution compliance verification

## Complexity Tracking

> No constitution violations requiring justification. All NON-NEGOTIABLE principles satisfied.
