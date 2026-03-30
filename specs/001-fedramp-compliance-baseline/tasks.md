# Tasks: FedRAMP High Compliance Baseline

**Input**: Design documents from `/specs/001-fedramp-compliance-baseline/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Not requested. Validation is via `terraform validate`, `terraform plan`, and document review against contracts.

**Organization**: Tasks are grouped by service-group phase (from plan.md) rather than by user story, because each service produces artifacts across multiple user stories simultaneously (policies=US1, terraform=US2, controls=US3, logging=US4, mapping=US5). Within each phase, services are parallelizable.

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different services/files, no cross-dependencies)
- **[US1–US5]**: Maps to spec.md user stories (P1: Policy, P2: Terraform, P3: Controls, P4: Logging, P5: Mapping)
- Exact file paths included in all descriptions
- Contracts referenced where applicable

---

## Phase 1: Setup (Project Initialization)

**Purpose**: Create directory structure, initialize Terraform, establish shared infrastructure modules.

- [X] T001 Create full directory structure per plan.md: `services/identity/`, `services/networking/`, `services/compute-storage/`, `services/data-ai/` with all per-service subdirectories (`policies/`, `terraform/`, `controls/`, `logging/`), `shared/terraform/` subdirectories, and `.specify/memory/compliance-mapping-index.md`
- [X] T002 Create root-level Terraform configuration: `terraform.tf` with required_providers block pinning `azurerm` provider version, and `.terraform.lock.hcl` placeholder per contract `specs/001-fedramp-compliance-baseline/contracts/terraform-module-interface.md`
- [X] T003 [P] [US2] Create shared Terraform module for state backend at `shared/terraform/state-backend/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` — Azure Storage Account with CMK encryption, RBAC-only access, state locking, private endpoint per FR-012
- [X] T004 [P] [US2] Create shared Terraform module for Log Analytics workspace at `shared/terraform/log-analytics/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` — centralized workspace with 365-day retention (production), 30-day (lower) per FR-013 and contract environment conditioning pattern
- [X] T005 [P] [US2] Create shared Terraform module for Key Vault at `shared/terraform/key-vault/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` — RBAC access, private endpoint, soft-delete, purge protection per FR-009
- [X] T006 [P] [US2] Create shared Terraform module for Virtual Network at `shared/terraform/virtual-network/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` — hub VNet with subnets for Private Endpoints, Bastion, DNS, NSGs per FR-009 and Constitution Principle VI
- [X] T007 [P] [US2] Create shared Terraform module for Private DNS Zones at `shared/terraform/private-dns-zones/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` — all required privatelink.* zones for in-scope services per FR-009

**Checkpoint**: Directory structure and shared infrastructure modules ready. All subsequent service modules consume these outputs.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Create policy naming convention documentation, environment delta template, centralized logging strategy, and policy lifecycle framework. All service-phase tasks depend on these.

**CRITICAL**: No service-phase work can begin until this phase is complete.

- [X] T008 [US1] Create policy naming convention and lifecycle document at `shared/policy-lifecycle.md` covering: naming convention (`{effect}-{service}-{control}-v{N}`), effect escalation path (Audit→Deny), exemption process with expiration, versioning schema per FR-006 and contract `specs/001-fedramp-compliance-baseline/contracts/policy-definition-schema.md`
- [X] T009 [US4] Create centralized logging strategy document at `shared/logging-strategy.md` covering: Log Analytics workspace topology (one per environment), retention (12 months online, 18 months archived), OMB M-21-31 tier targets (EL3 critical, EL1 all others), NIST SP 800-137 continuous monitoring, cross-service correlation per FR-024
- [X] T010 [US3] Create environment delta template at `shared/environment-delta-template.md` per data-model entity "Environment Configuration Delta": setting name, production value, lower value, justification, risk assessment, minimum baseline met per FR-035
- [X] T011 [US3] Create supply chain risk management document at `shared/supply-chain-risk.md` covering: Terraform provider verification (HashiCorp GPG), version pinning, lock file integrity, update process per FR-022 and research R-012

**Checkpoint**: Foundation documents ready. All service-phase artifact authoring can now reference these.

---

## Phase A: Identity Services (Foundation)

**Goal**: Produce all artifacts for identity services. Identity is the foundation — Conditional Access, RBAC, MFA, Managed Identity are prerequisites for all other services.

**Independent Test**: For Azure AD B2C, verify policy definitions cover IA/AC control families, control baseline covers user flow hardening with NIST SP 800-63-4 assurance levels, logging config specifies sign-in and audit log categories. For Managed Identity, verify controls-only baseline covers system-assigned vs. user-assigned guidance and RBAC least-privilege.

### Azure AD B2C

- [X] T012 [P] [US1] Create Azure Policy definitions for Azure AD B2C at `services/identity/azure-ad-b2c/policies/definitions/` and initiative at `services/identity/azure-ad-b2c/policies/initiatives/fedramp-high-b2c-v1.json` per policy-definition-schema contract — token lifetime, custom policy hardening. Custom policies needed per R-001
- [X] T013 [P] [US2] Create Terraform module for Azure AD B2C at `services/identity/azure-ad-b2c/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract. Include environment conditioning per R-013
- [X] T014 [P] [US3] Create security control baseline for Azure AD B2C at `services/identity/azure-ad-b2c/controls/baseline.md` per control-baseline-template contract — custom policy and user flow hardening, token lifetime/claims, identity provider federation, MFA/CAPTCHA, account lockout, NIST SP 800-63-4 IAL/AAL/FAL per FR-017. No STIG available per R-002
- [X] T015 [P] [US4] Create logging configuration for Azure AD B2C at `services/identity/azure-ad-b2c/logging/config.md` — audit logs, sign-in logs; OMB M-21-31 tier; retention per FR-023

### Managed Identity

- [X] T016 [P] [US3] Create security control baseline for Managed Identity at `services/identity/managed-identity/controls/baseline.md` per control-baseline-template contract — system-assigned vs. user-assigned guidance, RBAC least-privilege, service-to-service auth patterns, no STIG per R-002. Controls-only (no standalone deployment) per data-model service catalog

### Cross-Tenant Controls

- [X] T017 [US3] Create cross-tenant B2B guest access control baseline at `shared/cross-tenant-b2b-controls.md` — Conditional Access policies for guest users accessing Azure resources, external collaboration settings, guest access review, cross-tenant access settings trust configuration per FR-020. This documents Azure tenant configuration, not Entra ID service administration

**Checkpoint**: Identity artifacts complete. All services now have access to identity patterns (RBAC, Managed Identity, Conditional Access). Cross-tenant B2B guest access documented as Azure tenant configuration.

---

## Phase B: Networking Services

**Goal**: Produce all artifacts for networking and monitoring services. Establishes the network perimeter all other services connect through.

**Independent Test**: For Bastion, verify policy definitions enforce Deny for public IP on Bastion (production), Terraform module deploys with Private DNS + diagnostic settings, control baseline maps to SC-7 and SC-13.

### ExpressRoute

- [X] T018 [P] [US1] Create Azure Policy definitions for ExpressRoute at `services/networking/expressroute/policies/definitions/` and initiative at `services/networking/expressroute/policies/initiatives/fedramp-high-expressroute-v1.json` per policy-definition-schema contract. Built-in references at `services/networking/expressroute/policies/built-in-references.md`
- [X] T019 [P] [US2] Create Terraform module for ExpressRoute at `services/networking/expressroute/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T020 [P] [US3] Create security control baseline for ExpressRoute at `services/networking/expressroute/controls/baseline.md` per control-baseline-template contract — encryption, BGP security, private peering, no STIG per R-002
- [X] T021 [P] [US4] Create logging configuration for ExpressRoute at `services/networking/expressroute/logging/config.md` — circuit diagnostics, BGP route table logs; OMB M-21-31 tier; retention per FR-023

### Azure Front Door

- [X] T022 [P] [US1] Create Azure Policy definitions for Azure Front Door at `services/networking/azure-front-door/policies/definitions/` and initiative per policy-definition-schema contract — WAF enablement, TLS version, built-in references per R-001
- [X] T023 [P] [US2] Create Terraform module for Azure Front Door at `services/networking/azure-front-door/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T024 [P] [US3] Create security control baseline for Azure Front Door at `services/networking/azure-front-door/controls/baseline.md` per control-baseline-template contract — WAF, TLS, origin security, no STIG per R-002
- [X] T025 [P] [US4] Create logging configuration for Azure Front Door at `services/networking/azure-front-door/logging/config.md` — access logs, WAF logs, health probe logs; OMB M-21-31 EL3 for WAF events; retention per FR-023

### Bastion

- [X] T026 [P] [US1] Create Azure Policy definitions for Bastion at `services/networking/bastion/policies/definitions/` and initiative per policy-definition-schema contract — enforce SKU, diagnostic settings
- [X] T027 [P] [US2] Create Terraform module for Bastion at `services/networking/bastion/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract — only permitted admin VM access method per Constitution Principle VI
- [X] T028 [P] [US3] Create security control baseline for Bastion at `services/networking/bastion/controls/baseline.md` per control-baseline-template contract — session recording, NSG rules, no STIG per R-002
- [X] T029 [P] [US4] Create logging configuration for Bastion at `services/networking/bastion/logging/config.md` — session logs, audit logs; retention per FR-023

### DNS Private Resolver

- [X] T030 [P] [US1] Create Azure Policy definitions for DNS Private Resolver at `services/networking/dns-private-resolver/policies/definitions/` and initiative per policy-definition-schema contract — custom policies needed per R-001
- [X] T031 [P] [US2] Create Terraform module for DNS Private Resolver at `services/networking/dns-private-resolver/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T032 [P] [US3] Create security control baseline for DNS Private Resolver at `services/networking/dns-private-resolver/controls/baseline.md` per control-baseline-template contract — VNet integration, forwarding rules security; no STIG per R-002
- [X] T033 [P] [US4] Create logging configuration for DNS Private Resolver at `services/networking/dns-private-resolver/logging/config.md` — DNS query logs; retention per FR-023

### Private DNS Zone

- [X] T034 [P] [US1] Create Azure Policy definitions for Private DNS Zone at `services/networking/private-dns-zone/policies/definitions/` and initiative per policy-definition-schema contract
- [X] T035 [P] [US2] Create Terraform module for Private DNS Zone at `services/networking/private-dns-zone/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract — shared pattern consumed by all PE-enabled services
- [X] T036 [P] [US3] Create security control baseline for Private DNS Zone at `services/networking/private-dns-zone/controls/baseline.md` per control-baseline-template contract — VNet link security, record management; no STIG per R-002
- [X] T037 [P] [US4] Create logging configuration for Private DNS Zone at `services/networking/private-dns-zone/logging/config.md` — query logs; retention per FR-023

### Private Endpoint

- [X] T038 [P] [US1] Create Azure Policy definitions for Private Endpoint at `services/networking/private-endpoint/policies/definitions/` and initiative per policy-definition-schema contract — PE enforcement per service type, built-in references per R-001
- [X] T039 [P] [US2] Create Terraform module for Private Endpoint at `services/networking/private-endpoint/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract — reusable pattern module consumed by service modules
- [X] T040 [P] [US3] Create security control baseline for Private Endpoint at `services/networking/private-endpoint/controls/baseline.md` per control-baseline-template contract — DNS integration, NSG, approval workflow; no STIG per R-002
- [X] T041 [P] [US4] Create logging configuration for Private Endpoint at `services/networking/private-endpoint/logging/config.md` — connection logs; retention per FR-023

### VMs for DNS

- [X] T042 [P] [US1] Create Azure Policy definitions for VMs for DNS at `services/networking/vms-for-dns/policies/definitions/` and initiative per policy-definition-schema contract — Guest Configuration policies for OS-level STIG, disk encryption, diagnostic settings
- [X] T043 [P] [US2] Create Terraform module for VMs for DNS at `services/networking/vms-for-dns/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract — Windows Server VM with FIPS mode, disk encryption, diagnostic settings, Guest Configuration extension
- [X] T044 [P] [US3] Create security control baseline for VMs for DNS at `services/networking/vms-for-dns/controls/baseline.md` per control-baseline-template contract — Windows Server 2022 DISA STIG (V1R5+) mapping, CIS benchmark alignment, Azure Guest Configuration for continuous assessment, FIPS 140-2 OS mode per FR-025 and R-002
- [X] T045 [P] [US4] Create logging configuration for VMs for DNS at `services/networking/vms-for-dns/logging/config.md` — Windows Event Logs, Sysmon, Azure Monitor Agent categories; OMB M-21-31 EL3 for auth events; retention per FR-023

### Azure Monitor / Log Analytics

- [X] T046 [P] [US1] Create Azure Policy definitions for Azure Monitor at `services/networking/azure-monitor/policies/definitions/` and initiative per policy-definition-schema contract — workspace retention, diagnostic settings enforcement
- [X] T047 [P] [US2] Create Terraform module for Azure Monitor at `services/networking/azure-monitor/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract — workspace configuration, data export, alert rules
- [X] T048 [P] [US3] Create security control baseline for Azure Monitor at `services/networking/azure-monitor/controls/baseline.md` per control-baseline-template contract — RBAC, data access, encryption, NIST 800-53 AU family mapping; no STIG per R-002
- [X] T049 [P] [US4] Create logging configuration for Azure Monitor at `services/networking/azure-monitor/logging/config.md` — activity logs, workspace audit; self-monitoring configuration; retention per FR-023

### Azure Application Insights

- [X] T050 [P] [US1] Create Azure Policy definitions for Application Insights at `services/networking/azure-application-insights/policies/definitions/` and initiative per policy-definition-schema contract
- [X] T051 [P] [US2] Create Terraform module for Application Insights at `services/networking/azure-application-insights/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T052 [P] [US3] Create security control baseline for Application Insights at `services/networking/azure-application-insights/controls/baseline.md` per control-baseline-template contract — data retention, sampling, PII exclusion; no STIG per R-002
- [X] T053 [P] [US4] Create logging configuration for Application Insights at `services/networking/azure-application-insights/logging/config.md` — telemetry categories, export config; retention per FR-023

**Checkpoint**: Networking and monitoring artifacts complete. Network perimeter and monitoring infrastructure established for all subsequent services.

---

## Phase C: Compute, Storage, Data & AI Services

**Goal**: Produce all artifacts for compute, storage, and data/AI services. These services consume Private Endpoints, Managed Identity, and Log Analytics from Phases A and B.

**Independent Test**: For Azure Storage Account, verify policy initiative covers encryption (CMK), public access denial, TLS 1.2+, Private Endpoint, diagnostic settings. Terraform module deploys with zero policy violations. Control baseline has NIST 800-53 SC and AU family mappings with FIPS 140-2 certificate references.

### Azure App Service

- [X] T054 [P] [US1] Create Azure Policy definitions for App Service at `services/compute-storage/app-service/policies/definitions/` and initiative per policy-definition-schema contract — HTTPS-only, TLS 1.2, PE, managed identity, diagnostic settings; strong built-in coverage per R-001
- [X] T055 [P] [US2] Create Terraform module for App Service at `services/compute-storage/app-service/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract — includes App Service Plan, PE, diagnostic settings
- [X] T056 [P] [US3] Create security control baseline for App Service at `services/compute-storage/app-service/controls/baseline.md` per control-baseline-template contract — IIS STIG patterns applicable per R-002
- [X] T057 [P] [US4] Create logging configuration for App Service at `services/compute-storage/app-service/logging/config.md` — HTTP logs, app logs, platform logs; retention per FR-023

### Azure Functions

- [X] T058 [P] [US1] Create Azure Policy definitions for Azure Functions at `services/compute-storage/azure-functions/policies/definitions/` and initiative per policy-definition-schema contract
- [X] T059 [P] [US2] Create Terraform module for Azure Functions at `services/compute-storage/azure-functions/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T060 [P] [US3] Create security control baseline for Azure Functions at `services/compute-storage/azure-functions/controls/baseline.md` per control-baseline-template contract
- [X] T061 [P] [US4] Create logging configuration for Azure Functions at `services/compute-storage/azure-functions/logging/config.md` — function execution logs, host logs; retention per FR-023

### Azure Storage Account

- [X] T062 [P] [US1] Create Azure Policy definitions for Storage Account at `services/compute-storage/azure-storage-account/policies/definitions/` and initiative per policy-definition-schema contract — public access denial, CMK, TLS 1.2, PE, HTTPS-only, shared key disabled; strong built-in coverage per R-001. Custom needed for FIPS cipher suite enforcement
- [X] T063 [P] [US2] Create Terraform module for Storage Account at `services/compute-storage/azure-storage-account/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract — CMK (prod) / PMK (lower), PE, RBAC-only, blob versioning
- [X] T064 [P] [US3] Create security control baseline for Storage Account at `services/compute-storage/azure-storage-account/controls/baseline.md` per control-baseline-template contract — encryption with FIPS 140-2 cert per R-004, no dedicated STIG (CIS benchmark per R-002)
- [X] T065 [P] [US4] Create logging configuration for Storage Account at `services/compute-storage/azure-storage-account/logging/config.md` — blob/queue/table/file diagnostic logs, storage analytics; retention per FR-023

### Key Vault

- [X] T066 [P] [US1] Create Azure Policy definitions for Key Vault at `services/compute-storage/key-vault/policies/definitions/` and initiative per policy-definition-schema contract — soft-delete, purge protection, PE, RBAC, key expiration
- [X] T067 [P] [US2] Create Terraform module for Key Vault at `services/compute-storage/key-vault/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract — RBAC, PE, FIPS 140-2 Level 2/3 HSM per R-004
- [X] T068 [P] [US3] Create security control baseline for Key Vault at `services/compute-storage/key-vault/controls/baseline.md` per control-baseline-template contract — FIPS 140-2 Level 2 (software) / Level 3 (HSM), no STIG (CIS benchmark per R-002), key rotation, access policies
- [X] T069 [P] [US4] Create logging configuration for Key Vault at `services/compute-storage/key-vault/logging/config.md` — audit events, key/secret/cert operations; OMB M-21-31 EL3 for all Key Vault events; retention per FR-023

### Azure OpenAI

- [X] T070 [P] [US1] Create Azure Policy definitions for Azure OpenAI at `services/data-ai/azure-openai/policies/definitions/` and initiative per policy-definition-schema contract — PE, network isolation, content filtering; custom needed per R-001
- [X] T071 [P] [US2] Create Terraform module for Azure OpenAI at `services/data-ai/azure-openai/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T072 [P] [US3] Create security control baseline for Azure OpenAI at `services/data-ai/azure-openai/controls/baseline.md` per control-baseline-template contract — no STIG per R-002, content filtering, managed identity, data residency
- [X] T073 [P] [US4] Create logging configuration for Azure OpenAI at `services/data-ai/azure-openai/logging/config.md` — request/response logs, token usage; retention per FR-023

### Azure AI Search

- [X] T074 [P] [US1] Create Azure Policy definitions for AI Search at `services/data-ai/azure-ai-search/policies/definitions/` and initiative per policy-definition-schema contract
- [X] T075 [P] [US2] Create Terraform module for AI Search at `services/data-ai/azure-ai-search/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T076 [P] [US3] Create security control baseline for AI Search at `services/data-ai/azure-ai-search/controls/baseline.md` per control-baseline-template contract — no STIG per R-002
- [X] T077 [P] [US4] Create logging configuration for AI Search at `services/data-ai/azure-ai-search/logging/config.md` — query logs, indexer logs; retention per FR-023

### Azure AI Foundry

- [X] T078 [P] [US1] Create Azure Policy definitions for AI Foundry at `services/data-ai/azure-ai-foundry/policies/definitions/` and initiative per policy-definition-schema contract — limited built-in coverage per R-001
- [X] T079 [P] [US2] Create Terraform module for AI Foundry at `services/data-ai/azure-ai-foundry/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T080 [P] [US3] Create security control baseline for AI Foundry at `services/data-ai/azure-ai-foundry/controls/baseline.md` per control-baseline-template contract — no STIG per R-002
- [X] T081 [P] [US4] Create logging configuration for AI Foundry at `services/data-ai/azure-ai-foundry/logging/config.md` — experiment logs, compute logs; retention per FR-023

### Azure Document Intelligence

- [X] T082 [P] [US1] Create Azure Policy definitions for Document Intelligence at `services/data-ai/azure-document-intelligence/policies/definitions/` and initiative per policy-definition-schema contract
- [X] T083 [P] [US2] Create Terraform module for Document Intelligence at `services/data-ai/azure-document-intelligence/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T084 [P] [US3] Create security control baseline for Document Intelligence at `services/data-ai/azure-document-intelligence/controls/baseline.md` per control-baseline-template contract — no STIG per R-002
- [X] T085 [P] [US4] Create logging configuration for Document Intelligence at `services/data-ai/azure-document-intelligence/logging/config.md` — API request logs; retention per FR-023

### Azure Maps

- [X] T086 [P] [US1] Create Azure Policy definitions for Azure Maps at `services/data-ai/azure-maps/policies/definitions/` and initiative per policy-definition-schema contract
- [X] T087 [P] [US2] Create Terraform module for Azure Maps at `services/data-ai/azure-maps/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T088 [P] [US3] Create security control baseline for Azure Maps at `services/data-ai/azure-maps/controls/baseline.md` per control-baseline-template contract — no STIG per R-002
- [X] T089 [P] [US4] Create logging configuration for Azure Maps at `services/data-ai/azure-maps/logging/config.md` — API usage logs; retention per FR-023

### Azure Purview

- [X] T090 [P] [US1] Create Azure Policy definitions for Azure Purview at `services/data-ai/azure-purview/policies/definitions/` and initiative per policy-definition-schema contract — limited built-in per R-001
- [X] T091 [P] [US2] Create Terraform module for Azure Purview at `services/data-ai/azure-purview/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T092 [P] [US3] Create security control baseline for Azure Purview at `services/data-ai/azure-purview/controls/baseline.md` per control-baseline-template contract — data governance boundary controls per Constitution; no STIG per R-002
- [X] T093 [P] [US4] Create logging configuration for Azure Purview at `services/data-ai/azure-purview/logging/config.md` — scan logs, classification logs; retention per FR-023

### AI Speech Service

- [X] T094 [P] [US1] Create Azure Policy definitions for AI Speech Service at `services/data-ai/ai-speech-service/policies/definitions/` and initiative per policy-definition-schema contract
- [X] T095 [P] [US2] Create Terraform module for AI Speech Service at `services/data-ai/ai-speech-service/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T096 [P] [US3] Create security control baseline for AI Speech Service at `services/data-ai/ai-speech-service/controls/baseline.md` per control-baseline-template contract — no STIG per R-002
- [X] T097 [P] [US4] Create logging configuration for AI Speech Service at `services/data-ai/ai-speech-service/logging/config.md` — API logs; retention per FR-023

### Event Hubs

- [X] T098 [P] [US1] Create Azure Policy definitions for Event Hubs at `services/data-ai/event-hubs/policies/definitions/` and initiative per policy-definition-schema contract
- [X] T099 [P] [US2] Create Terraform module for Event Hubs at `services/data-ai/event-hubs/terraform/main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` per terraform-module-interface contract
- [X] T100 [P] [US3] Create security control baseline for Event Hubs at `services/data-ai/event-hubs/controls/baseline.md` per control-baseline-template contract — no STIG per R-002
- [X] T101 [P] [US4] Create logging configuration for Event Hubs at `services/data-ai/event-hubs/logging/config.md` — operational logs, archive logs, auto-scale logs; retention per FR-023

**Checkpoint**: All Azure service artifacts complete. 21 services with full artifact sets (policies + Terraform + controls + logging), 1 with controls-only (Managed Identity), 1 cross-cutting controls document (cross-tenant B2B). Policy initiatives, Terraform modules, control baselines, and logging configurations all authored per contracts.

---

## Phase D: Cross-Cutting Finalization

**Purpose**: Consolidate compliance mapping index, finalize environment delta documentation, create policy lifecycle framework, run final constitution compliance verification.

- [X] T102 [US5] Create consolidated compliance mapping index at `.specify/memory/compliance-mapping-index.md` per contract `specs/001-fedramp-compliance-baseline/contracts/compliance-mapping-schema.md` — aggregate all configuration decisions from all services across all artifact types, with NIST 800-53 control IDs, framework mappings, STIG finding IDs, FIPS 140-2 cert references, and source URLs per FR-026
- [X] T103 [P] [US5] Create machine-readable companion at `.specify/memory/compliance-mapping-index.csv` with same schema as compliance-mapping-schema contract for programmatic consumption per SC-009
- [X] T104 [US3] Create consolidated environment delta document at `shared/environment-deltas.md` — compile all per-service environment deltas from control baselines into a single reference, verify minimum lower baseline (encryption in transit, logging, identity) per FR-035
- [X] T105 [US1] Create per-service-group policy initiative summary documents: `services/identity/policy-initiative-summary.md`, `services/networking/policy-initiative-summary.md`, `services/compute-storage/policy-initiative-summary.md`, `services/data-ai/policy-initiative-summary.md` — aggregate initiative references and management group assignment scopes per FR-007
- [X] T106 [US3] Create IR/CP technical configuration requirements document at `shared/ir-cp-requirements.md` — per-service backup/recovery settings, automated incident detection config, recovery point/time objectives per FR-021 and NIST SP 800-61 Rev 3
- [X] T107 Run final constitution compliance verification: audit all artifacts against Constitution v5.1.0 principles I–VIII, regulatory framework coverage per Governance section. Document result at `specs/001-fedramp-compliance-baseline/checklists/constitution-verification.md`
- [X] T108 Run `specs/001-fedramp-compliance-baseline/quickstart.md` validation: verify `terraform validate` passes for all modules, verify directory structure matches plan.md, verify all contract templates are correctly applied

---

## Dependencies

```
Phase 1 (Setup)
    └──► Phase 2 (Foundational)
              └──► Phase A (Identity) ──────────┐
                        └──► Phase B (Networking)│
                                  └──► Phase C (Compute/Storage/Data/AI)
                                                  │
              All service phases ─────────────────┘──► Phase D (Cross-cutting)
```

**Within each service phase**: All services are parallelizable (marked [P]). Within a single service, the 4 artifact tasks (policies, terraform, controls, logging) are also parallelizable since they target different files.

## Parallel Execution Examples

**Phase A maximum parallelism**: T012–T017 can all run simultaneously (6 tasks, 2 services + 1 cross-cutting doc).

**Phase B maximum parallelism**: T018–T053 can all run simultaneously (36 tasks, 9 services × 4 artifacts each).

**Phase C maximum parallelism**: T054–T101 can all run simultaneously (48 tasks, 12 services × 4 artifacts each).

## Implementation Strategy

1. **MVP**: Phase 1 + Phase 2 + Phase A (Identity) — delivers shared infrastructure, policy lifecycle, and the foundational identity artifacts. An auditor can review identity controls end-to-end.
2. **Increment 2**: Phase B (Networking) — adds network perimeter artifacts. Combined with identity, represents the complete security boundary.
3. **Increment 3**: Phase C (Compute/Storage/Data/AI) — the bulk of service-specific artifacts.
4. **Final**: Phase D (Cross-cutting) — consolidation, compliance index, constitution verification.

## Summary

| Metric | Count |
|--------|-------|
| Total tasks | 108 |
| Phase 1 (Setup) | 7 |
| Phase 2 (Foundational) | 4 |
| Phase A (Identity) | 6 |
| Phase B (Networking) | 36 |
| Phase C (Compute/Storage/Data/AI) | 48 |
| Phase D (Cross-cutting) | 7 |
| Parallelizable tasks | 96 (89%) |
| Services covered | 23 (100% of services reference) |
| US1 (Policy) tasks | 21 + 1 summary = 22 |
| US2 (Terraform) tasks | 23 (18 service + 5 shared) |
| US3 (Controls) tasks | 24 |
| US4 (Logging) tasks | 22 |
| US5 (Mapping) tasks | 2 |
| Cross-cutting tasks | 11 |
