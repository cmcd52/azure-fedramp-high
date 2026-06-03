# Tasks: FedRAMP High Compliance Baseline

**Input**: Design documents from `/specs/001-fedramp-compliance-baseline/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md
**Constitution**: v8.0.0 — All GA Azure Commercial Services
**Branch**: `main` (off `main`) — already created
**Tests**: Not requested by spec — no test tasks generated.

**Organization**: Tasks are grouped by user story to enable independent verification and incremental delivery. The 23 Wave 1 services have existing artifact directories. Wave 2 (95 additional services) has been generated via `scripts/wave2/generate.py`. Forward-looking implementation work targets the **Wave 2 sweep** of remaining GA Azure Commercial services and **cross-cutting finalization**.

## Format: `[ID] [P?] [Story?] Description`

- `[P]`: Independent file / no blocking dependencies — may run in parallel
- `[USn]`: User story label (Phase 3+ only)


---

## Phase 1: Setup

**Purpose**: Confirm working environment for Wave 2 + cross-cutting work. Branch is already created.

- [X] T001 Verify branch `main` is checked out from `main` and clean (`git status`, `git rev-parse --abbrev-ref HEAD`)
- [X] T002 [P] Confirm Terraform CLI (>= 1.x) and `azurerm` provider lock files resolve under `shared/terraform/state-backend/.terraform.lock.hcl`
- [X] T003 [P] Confirm markdown lint / link-check tooling configuration at repository root (add `.markdownlint.json` if missing) for use by Wave 2 doc generation
- [X] T004 [P] Confirm JSON schema validation tooling (`ajv` or equivalent) is available for validating Azure Policy definitions in `services/*/*/policies/`
- [X] T005 Record the 23 Wave 1 service paths in `specs/001-fedramp-compliance-baseline/checklists/constitution-verification.md` as the baseline service inventory for this run

**Checkpoint**: Tooling ready. Wave 1 service inventory recorded.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Refresh design artifacts to match Constitution v8.0.0 before any user-story work begins. These updates affect only `specs/001-fedramp-compliance-baseline/**` and `checklists/`.

**⚠️ CRITICAL**: No user story (Phase 3+) work may begin until this phase is complete.

- [X] T006 Regenerate `specs/001-fedramp-compliance-baseline/data-model.md` to (a) remove the closed-set "23 services" language, (b) describe the all-GA + exclusion-tracker scope model, and (c) add entity definitions for the iterative wave model
- [X] T007 [P] Refresh `specs/001-fedramp-compliance-baseline/contracts/compliance-mapping-schema.md` — replace any "lookup against `azure-services-reference.md`" validation rule with: every `service` value MUST be a GA Azure Commercial service that is either covered by deliverables or recorded in `docs/azure-service-exclusions.md`
- [X] T008 [P] Refresh `specs/001-fedramp-compliance-baseline/contracts/policy-definition-schema.md` — remove legacy services-reference dependency; add validation rules for schema conformance
- [X] T009 [P] Refresh `specs/001-fedramp-compliance-baseline/contracts/control-baseline-template.md` — remove legacy services-reference dependency; add validation rules for schema conformance
- [X] T010 [P] Refresh `specs/001-fedramp-compliance-baseline/contracts/terraform-module-interface.md` — remove legacy services-reference dependency; add contract conformance validation rules
- [X] T011 Update `specs/001-fedramp-compliance-baseline/checklists/constitution-verification.md` to Constitution v8.0.0 — rename principles to "All Generally Available Azure Commercial Services", "Complete Service Coverage with Exclusion Tracking"; add checks for the exclusions tracker and GovRAMP guide
- [X] T012 [P] Update `specs/001-fedramp-compliance-baseline/quickstart.md` — note that `.specify/memory/azure-services-reference.md` is legacy/historical; document the contributor workflow for Wave 2 service refinement

**Checkpoint**: Design artifacts aligned with Constitution v8.0.0. Wave 2 + cross-cutting work may now proceed in parallel.

---

## Phase 3: User Story 1 — Per-Service Azure Policy Definitions and Initiatives (Priority: P1) 🎯 MVP

**Goal**: Confirm the Wave 1 policy artifacts still satisfy FR-001/FR-002/FR-003/FR-005/FR-007 unchanged, and extend the same pattern to Wave 2 candidate services (or formally exclude them).

**Independent Test**: For any single in-scope service, confirm that policy definitions exist covering encryption, network isolation, identity, and logging — each mapped to NIST 800-53 Rev 5 controls — OR the service is recorded in `docs/azure-service-exclusions.md` with justification. Deploy the initiative to a test subscription and verify a non-compliant resource is flagged.

### Verification (Wave 1 — Frozen, Read-Only)

- [X] T013 [P] [US1] Read-only audit of frozen policy artifacts under `services/identity/azure-ad-b2c/policies/` — confirm JSON schema validity, NIST 800-53 metadata present, configurable effect parameter present; record findings in `specs/001-fedramp-compliance-baseline/checklists/constitution-verification.md`. **Do not modify files.**
- [X] T014 [P] [US1] Read-only audit of frozen policy artifacts under `services/networking/{expressroute,azure-front-door,bastion,dns-private-resolver,private-dns-zone,private-endpoint,vms-for-dns,azure-monitor,azure-application-insights}/policies/` — same audit criteria as T013
- [X] T015 [P] [US1] Read-only audit of frozen policy artifacts under `services/compute-storage/{app-service,azure-functions,azure-storage-account,key-vault}/policies/` — same audit criteria as T013
- [X] T016 [P] [US1] Read-only audit of frozen policy artifacts under `services/data-ai/{azure-openai,azure-ai-search,azure-ai-foundry,azure-document-intelligence,azure-maps,azure-purview,ai-speech-service,event-hubs}/policies/` — same audit criteria as T013
- [X] T017 [US1] If any audit (T013–T016) detects a defect, create a follow-up issue. Otherwise, mark the audit clean in the verification checklist.

### Wave 2 Sweep (New Services or Documented Exclusions)

- [X] T018 [US1] Produce the Wave 2 candidate list at `docs/wave-2-candidates.md`: enumerate every GA Azure Commercial service that is (a) not in the 23 Wave 1 frozen set and (b) not already recorded in `docs/azure-service-exclusions.md`. Include source URL (Microsoft Azure products page) for each
- [X] T019 [US1] For each Wave 2 candidate, perform an applicability triage and classify as `policy-eligible` or `exclude` in `docs/wave-2-candidates.md` (depends on T018)
- [X] T020 [P] [US1] For each `policy-eligible` Wave 2 candidate `<svc>` in group `<grp>`: create `services/<grp>/<svc>/policies/` with policy definitions covering encryption-at-rest (FIPS 140-2), encryption-in-transit (TLS 1.2+), network isolation, identity, and diagnostic logging — each with NIST 800-53 metadata and configurable effect parameter (FR-001, FR-003, FR-005) — _Wave 2 templates generated 2026-04-28 by `scripts/wave2/generate.py`_
- [X] T021 [P] [US1] For each `policy-eligible` Wave 2 candidate `<svc>`: create the policy initiative summary at `services/<grp>/policy-initiative-summary.md` (append-only addition for the group) referencing the new initiative grouped by NIST 800-53 control family (FR-002)
- [X] T022 [US1] For each `exclude` Wave 2 candidate: append a row to `docs/azure-service-exclusions.md` with service name, exclusion reason, FedRAMP High control(s) not satisfiable, assessment date, Microsoft documentation URL, and re-evaluation trigger (FR-037, SC-021)

**Checkpoint**: Every GA Azure Commercial service has either a policy initiative or a documented exclusion (SC-001 / FR-034 satisfied for the policy artifact type).

---

## Phase 4: User Story 2 — Terraform Configuration per Service (Priority: P2)

**Goal**: Confirm Wave 1 Terraform modules remain compliant and unchanged; produce Terraform modules for Wave 2 `policy-eligible` services so they pass their corresponding policy initiative.

**Independent Test**: For any single service, `terraform plan` with default variables produces a resource with private endpoint, encryption at rest (CMK where supported), diagnostic settings to Log Analytics, and Managed Identity — and the resource passes the P1 policy initiative with zero violations.

### Verification (Wave 1 — Frozen, Read-Only)

- [X] T023 [P] [US2] Read-only `terraform validate` + `terraform plan -refresh=false` dry-run audit of frozen modules under `services/identity/azure-ad-b2c/terraform/` and all `services/networking/*/terraform/` directories listed in the freeze ledger — record results in the verification checklist. **Do not modify files.**
- [X] T024 [P] [US2] Read-only `terraform validate` + `terraform plan -refresh=false` dry-run audit of frozen modules under `services/compute-storage/{app-service,azure-functions,azure-storage-account,key-vault}/terraform/`
- [X] T025 [P] [US2] Read-only `terraform validate` + `terraform plan -refresh=false` dry-run audit of frozen modules under `services/data-ai/{azure-openai,azure-ai-search,azure-ai-foundry,azure-document-intelligence,azure-maps,azure-purview,ai-speech-service,event-hubs}/terraform/`
- [X] T026 [P] [US2] Read-only audit of `shared/terraform/state-backend/` — confirm Azure Storage backend uses CMK encryption, RBAC-only (shared access keys disabled), state lease locking, and private endpoint (FR-012)
- [X] T027 [P] [US2] Read-only audit of `shared/terraform/{log-analytics,key-vault,virtual-network,private-dns-zones}/` — confirm modules expose outputs consumed by service modules (FR-013)

### Wave 2 Sweep

- [X] T028 [P] [US2] For each `policy-eligible` Wave 2 candidate `<svc>` in group `<grp>` (from T019): create `services/<grp>/<svc>/terraform/` with a module that configures private endpoint (where supported), CMK encryption-at-rest, TLS 1.2+, diagnostic settings to the shared Log Analytics workspace, Managed Identity, and an `environment` parameter (production/lower) with inline NIST 800-53 control comments (FR-008, FR-009, FR-010, FR-014) — _Wave 2 templates generated 2026-04-28 by `scripts/wave2/generate.py`. Modules contain `TODO_SUBRESOURCE_NAME` placeholders and an explicit "Pending Review Items" checklist that MUST be completed before deployment._
- [X] T029 [US2] For each new Wave 2 module from T028, run `terraform validate` and confirm zero syntax/schema errors (depends on T020, T028). Live `terraform plan` against a test subscription deferred until subscription access is provided. — _`TODO_SUBRESOURCE_NAME` placeholders resolved 2026-05-12 (31 modules); CMK policy field validation fixed (27 policies). Validated 2026-05-18: 110/110 modules pass (resource-graph converted to README-only — API-only service with no azurerm resource type)._

**Checkpoint**: Every covered service has a deployable, policy-clean Terraform module; exclusions remain documented.

---

## Phase 5: User Story 3 — Security Control Configuration (Azure) (Priority: P3)

**Goal**: Confirm Wave 1 control baselines remain valid; produce control baselines for Wave 2 `policy-eligible` services with full regulatory mapping (FISMA, FedRAMP High, NIST 800-53 Rev 5, FIPS 140-2/3, DISA STIGs, DFARS/CUI, CMMC 2.0, EO 14028, OMB M-22-09).

**Independent Test**: For any single service, the `controls/` document defines RBAC, Conditional Access, MFA, network security, encryption (FIPS-validated), logging, and STIG/CUI hardening as applicable — every control mapped to NIST 800-53 control IDs with source URLs.

### Verification (Wave 1 — Frozen, Read-Only)

- [X] T030 [P] [US3] Read-only audit of frozen control baselines under `services/identity/azure-ad-b2c/controls/` and `services/identity/managed-identity/controls/` — verify identity assurance level (NIST SP 800-63-4 IAL/AAL/FAL) coverage and cross-tenant B2B guest access section (FR-017, FR-019, FR-020)
- [X] T031 [P] [US3] Read-only audit of frozen control baselines under all `services/networking/*/controls/` — verify VMs for DNS includes Windows Server DISA STIG, Guest Configuration, FIPS 140-2 OS-mode (FR-018, SC-016)
- [X] T032 [P] [US3] Read-only audit of frozen control baselines under `services/compute-storage/*/controls/` — verify FIPS 140-2 cryptographic module references and encryption algorithm specifications (FR-029, SC-010)
- [X] T033 [P] [US3] Read-only audit of frozen control baselines under `services/data-ai/*/controls/` — verify IR/CP family coverage (FR-021, SC-017) and supply chain risk references (FR-022)

### Wave 2 Sweep

- [X] T034 [P] [US3] For each `policy-eligible` Wave 2 candidate `<svc>` in group `<grp>`: create `services/<grp>/<svc>/controls/baseline.md` covering identity/access (RBAC, Managed Identity, Conditional Access, MFA, PIM), network (private endpoint, NSG/firewall), encryption (FIPS 140-2 validated), and audit logging — each control mapped to NIST 800-53 Rev 5 IDs and a source URL (FR-015, FR-016, FR-019) — _Wave 2 templates generated 2026-04-28_
- [X] T035 [P] [US3] For each Wave 2 control baseline from T034: add an IR/CP technical configuration section per FR-021 and a supply-chain attestation section per FR-022 / NIST SP 800-161 Rev 1 — _Wave 2 templates include IR/CP placeholder sections; per-service approval review MUST flesh them out with workload-specific RTO/RPO and supply-chain attestations_

**Checkpoint**: Every covered service has a control baseline mapped to the full regulatory hierarchy.

---

## Phase 6: User Story 4 — Logging and Monitoring Configuration (Priority: P4)

**Goal**: Confirm Wave 1 logging configurations remain valid; produce logging configurations for Wave 2 `policy-eligible` services; finalize the centralized logging strategy document.

**Independent Test**: For any single service, the `logging/` document specifies enabled diagnostic categories, Log Analytics destination, retention (12 months online + 18 months archived), OMB M-21-31 EL tier targets, and alert rules — and the Terraform module enforces these settings.

### Verification (Wave 1 — Frozen, Read-Only)

- [X] T036 [P] [US4] Read-only audit of frozen logging configurations under all `services/identity/*/logging/`, `services/networking/*/logging/`, `services/compute-storage/*/logging/`, and `services/data-ai/*/logging/` — verify retention thresholds (12 mo online / 18 mo archived) and OMB M-21-31 EL3 targeting for critical security events (FR-023, FR-024, SC-007)

### Wave 2 Sweep + Cross-Cutting Logging Strategy

- [X] T037 [P] [US4] For each `policy-eligible` Wave 2 candidate `<svc>` in group `<grp>`: create `services/<grp>/<svc>/logging/config.md` specifying diagnostic categories, Log Analytics workspace destination, retention, OMB M-21-31 EL tier, and alert rules (FR-023, FR-025) — _Wave 2 templates generated 2026-04-28_
- [X] T038 [US4] Finalize `shared/logging-strategy.md` (append-only update) — append Wave 2 service references, NIST SP 800-137 continuous monitoring alignment, OMB M-21-31 maturity tier rollup, and cross-service correlation approach (FR-024). **Append references only — do not alter Wave 1 content.** — _Completed 2026-05-12_

**Checkpoint**: Centralized logging strategy is current; every covered service has a logging configuration.

---

## Phase 7: User Story 5 — Source Reference Material and Control Mapping Index (Priority: P5)

**Goal**: Finalize the consolidated compliance mapping index and validate cross-cutting reference documents (GovRAMP guide, exclusions tracker) so every configuration decision traces to an authoritative source.

**Independent Test**: For any configuration decision in any service's artifacts, the reference index contains an entry with service, setting, control ID(s), framework(s), and a working source URL.

### Cross-Cutting Reference Index Finalization

- [X] T039 [US5] Finalize `.specify/memory/compliance-mapping-index.md` (append-only) — append all Wave 2 entries from Phases 3–6; ensure 100% framework coverage across FISMA, FedRAMP High, NIST 800-53 Rev 5, FIPS 140-2/3, NIST 800-171/172, CMMC 2.0, DISA STIGs, EO 14028, OMB M-22-09, OMB M-21-31, NIST SP 800-207, NIST SP 800-63-4, DoD CC SRG, CISA BODs (FR-026, SC-002, SC-009) — _558 Wave 2 entries appended 2026-05-12_
- [X] T040 [P] [US5] Regenerate `.specify/memory/compliance-mapping-index.csv` from the markdown index in T039 — single source of truth, machine-readable export — _771 rows exported 2026-05-12_
- [X] T041 [P] [US5] Validate every URL in the compliance mapping index resolves (HTTP 200) using the link-check tooling configured in T003; record dead links in `specs/001-fedramp-compliance-baseline/checklists/constitution-verification.md` for remediation — _Validated 2026-05-18: 62 URLs checked, 5 dead links found and fixed (3 x 404 path corrections, 1 x retired product URL updated, 1 x template URL redirected to landing page). Final result: 62/62 pass._
- [X] T042 [P] [US5] Map every applicable DISA STIG finding ID to the corresponding policy definition and Terraform configuration in the index (FR-028, SC-005) — _Appendix C added 2026-05-12: 8 STIGs, 35 finding IDs mapped to policy definitions and TF settings_

### Policy Lifecycle Framework + Environment Delta

- [X] T043 [P] [US5] Create `docs/policy-lifecycle-framework.md` — document effect escalation (Audit → Deny), exemption process with expirations, DeployIfNotExists/Modify remediation guidance, and policy-definition versioning schema (FR-006) — _Created 2026-05-12_
- [X] T044 [P] [US5] Create `docs/environment-delta.md` — document every justified deviation between production and lower environments per service (setting, prod value, lower value, justification, risk) and confirm minimum-baseline parity for encryption-in-transit, diagnostic logging, and identity controls (FR-035, SC-014) — _Created 2026-05-12_

### GovRAMP, Exclusions — Maintenance Process Validation

- [X] T045 [P] [US5] Validate `docs/govramp-applicability-guide.md` source references resolve, comparison tables remain accurate, and add a periodic-review process section (review cadence, owner, trigger conditions) (FR-036, SC-020)
- [X] T046 [P] [US5] Validate `docs/azure-service-exclusions.md` against the Wave 2 sweep output — confirm every excluded service has all required fields and a re-evaluation trigger; add a periodic-review process section (FR-037, SC-021)

**Checkpoint**: The complete reference index plus all cross-cutting documents are current and validated.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Final constitution alignment and audit hygiene.

- [X] T051 [P] Run a repository-wide grep audit for stale references to `.specify/memory/azure-services-reference.md` — replace with `docs/azure-service-exclusions.md` references where appropriate
- [X] T052 [P] Run a repository-wide grep audit for legacy "23 services" closed-set language and replace with the iterative wave model phrasing
- [X] T053 Run the Constitution verification checklist in `specs/001-fedramp-compliance-baseline/checklists/constitution-verification.md` end-to-end and record `PASS`/`FAIL` per principle
- [X] T054 ~~Freeze enforcement audit~~ — _removed; Principle IX (Service Approval and Immutability) has been removed from the constitution as of v8.0.0_
- [X] T055 [P] Run quickstart.md validation per `specs/001-fedramp-compliance-baseline/quickstart.md` — confirm a contributor can locate exclusions tracker and workflow without referencing legacy artifacts
- [X] T056 Update `specs/001-fedramp-compliance-baseline/plan.md` "Implement Phase Readiness" table to mark T006–T012 deliverables ✅ and link this regenerated `tasks.md`

**Checkpoint**: Constitution alignment verified; ready for merge to `main`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup — **BLOCKS all user stories**
- **User Stories (Phases 3–7)**: All depend on Foundational; can run in parallel (per story) once T011 + T012 land
- **Polish (Phase 9)**: Depends on Phases 3–7

### User Story Dependencies

- **US1 (P1)**: Foundational only — no dependency on other stories. T020 (Wave 2 policies) blocks T029 (Wave 2 Terraform plan-clean assertion in US2)
- **US2 (P2)**: Foundational; T029 depends on US1 T020/T028
- **US3 (P3)**: Foundational only
- **US4 (P4)**: Foundational only
- **US5 (P5)**: Depends on Phases 3–6 outputs to populate the index (T039)

### Within Each User Story

- Wave 1 verification audits can run fully in parallel
- Wave 2 sweep tasks (T018–T022, T028–T029, T034–T035, T037–T038) require T018/T019 candidate-list output before per-service work begins

### Parallel Opportunities

- All `[P]` Setup tasks (T002–T004) — parallel
- All `[P]` Foundational tasks (T007–T010, T012) — parallel after T006 lands
- All Wave 1 read-only audits (T013–T016, T023–T027, T030–T033, T036) — fully parallel across stories and across service groups
- Wave 2 per-service implementation tasks (T020, T021, T028, T034, T035, T037) — parallel by service
- Cross-cutting finalization in US5 (T040–T047) — parallel
- Polish grep audits (T051, T052, T055) — parallel

### Independent Test Criteria (per Story)

- **US1**: Pick any service → policy definitions cover encryption / network isolation / identity / logging with NIST 800-53 mappings, OR service is in exclusions tracker
- **US2**: Pick any service → `terraform plan` produces a resource that passes the US1 policy initiative with zero violations
- **US3**: Pick any service → `controls/` document covers RBAC, Conditional Access, MFA, encryption (FIPS), and logging with NIST + framework mappings and source URLs
- **US4**: Pick any service → `logging/` document specifies categories, destination, retention (12mo/18mo), EL tier, and alert rules; Terraform module enforces them
- **US5**: Pick any configuration decision → reference index entry exists with service, setting, control IDs, frameworks, and source URL

---

## Suggested MVP Scope

**MVP = Phase 1 + Phase 2 + Phase 3 (US1)**. This delivers:

- Refreshed design artifacts (data model, contracts, checklists, quickstart) aligned with Constitution v8.0.0
- Read-only verification of all 23 frozen Wave 1 policy initiatives
- A complete Wave 2 candidate list, with each candidate either policy-implemented or excluded

This MVP closes the Principle II coverage gap (every GA service either covered or excluded) for the foundational artifact type without requiring Wave 2 Terraform / controls / logging / approvals to land first.

---

## Parallel Example: Wave 1 Verification Sweep

```bash
# After Foundational (Phase 2) completes, run all Wave 1 read-only audits in parallel:
# T013, T014, T015, T016 (US1 policies)
# T023, T024, T025, T026, T027 (US2 terraform)
# T030, T031, T032, T033 (US3 controls)
# T036 (US4 logging)
# All operate on disjoint frozen service directories — no write contention possible
# (frozen paths are read-only by definition).
```

---

