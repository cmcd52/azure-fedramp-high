# Feature Specification: FedRAMP High Compliance Baseline

**Feature Branch**: `001-fedramp-compliance-baseline`  
**Created**: 2026-03-27  
**Status**: Draft — Clarification Round 1 Complete  
**Input**: User description: "Generate Azure Policy definitions/initiatives/blueprints, Terraform configuration, security control configuration (Azure), logging configuration, and source reference material for each configuration consideration. Use all public Microsoft documentation, NIST, STIG, and similar standards, Government regulations, FedRAMP, DFARS/CUI."

## User Scenarios & Testing *(mandatory)*

### User Story 1 — Per-Service Azure Policy Definitions and Initiatives (Priority: P1)

A compliance engineer needs a complete set of Azure Policy definitions and policy initiatives for every in-scope Azure service, organized by NIST 800-53 Rev 5 control family, so that each service can be audited and enforced against FedRAMP High requirements without manual interpretation.

**Why this priority**: Azure Policy is the foundational enforcement mechanism. Without it, no other artifact can be validated or enforced. Every subsequent deliverable (Terraform, logging, security controls) depends on having clearly defined policy rules per service.

**Independent Test**: For any single Azure service (e.g., Azure Storage Account), confirm that a complete set of policy definitions exists covering encryption, network isolation, identity, and logging — and that each definition maps to one or more NIST 800-53 Rev 5 controls. Deploy the policy initiative to a test subscription and verify it flags a non-compliant resource.

**Acceptance Scenarios**:

1. **Given** a GA Azure Commercial service, **When** a compliance engineer looks up that service, **Then** a dedicated set of policy definitions exists covering all applicable FedRAMP High controls (encryption, networking, identity, logging at minimum) — unless the service is formally excluded in `docs/azure-service-exclusions.md`.
2. **Given** a policy initiative for a service, **When** an auditor reviews it, **Then** every policy definition within the initiative includes a mapping to specific NIST 800-53 Rev 5 control IDs.
3. **Given** a non-compliant resource configuration, **When** the policy initiative is assigned to a subscription, **Then** the non-compliant resource is flagged with a clear description of the violation and the control it violates.
4. **Given** the complete set of policy initiatives, **When** cross-referenced against all GA Azure Commercial services, **Then** every service has at least one policy initiative or a documented exclusion in `docs/azure-service-exclusions.md` — no service is unaddressed.
5. **Given** a policy definition with a configurable effect parameter, **When** assigned in the production environment, **Then** critical controls (encryption, network isolation, identity) default to Deny effect. **When** assigned in the lower (test/dev) environment, **Then** the same definition defaults to Audit effect.
6. **Given** the complete set of policy initiatives, **When** the assignment scope is reviewed, **Then** policy initiatives are assignable at the management group level and target all in-scope tenants: Primary Azure Commercial (production), Parent Org Azure Commercial (cross-tenant controls), and the Lower Environment tenant.

---

### User Story 2 — Terraform Configuration per Service (Priority: P2)

An infrastructure engineer needs Terraform modules for every in-scope Azure service that produce a FedRAMP-High-compliant resource by default — with private endpoints, encryption, logging, and identity pre-configured — so that compliant infrastructure can be deployed repeatably without ad-hoc manual configuration.

**Why this priority**: Terraform configurations are the primary deployment mechanism. They encode the compliant baseline into repeatable, version-controlled infrastructure. This depends on P1 (policy definitions) to validate correctness.

**Independent Test**: For any single Azure service (e.g., Key Vault), apply the Terraform module to a test subscription. Run `terraform plan` and verify the plan produces a resource with private endpoint, encryption at rest (customer-managed key if supported), diagnostic settings routing to Log Analytics, and Managed Identity for access. Confirm the deployed resource passes the P1 policy initiative with zero violations.

**Acceptance Scenarios**:

1. **Given** an in-scope Azure service, **When** an engineer applies its Terraform module with default variables, **Then** the resulting resource meets all FedRAMP High requirements (encryption, network isolation, logging, identity) without overrides.
2. **Given** a Terraform module for a service, **When** reviewed, **Then** it includes inline comments referencing the NIST 800-53 control(s) each configuration block satisfies.
3. **Given** the complete set of Terraform modules, **When** cross-referenced against all GA Azure Commercial services, **Then** every service has a corresponding module or a documented exclusion in `docs/azure-service-exclusions.md` — no service is unaddressed.
4. **Given** a deployed Terraform resource, **When** the P1 policy initiative is assigned, **Then** the resource shows zero policy violations.
5. **Given** the Terraform state backend configuration, **When** reviewed, **Then** state is stored in an Azure Storage Account with encryption at rest, RBAC-only access (no shared access keys), state file locking, and private endpoint.
6. **Given** the shared infrastructure modules (Log Analytics workspace, Key Vault, Virtual Network, Private DNS Zones), **When** `terraform plan` is run for a service module, **Then** the plan references shared infrastructure outputs and does not duplicate foundational resources.
7. **Given** a Terraform module with an environment parameter set to "lower," **When** deployed, **Then** the resource configuration uses documented relaxed settings (e.g., Audit-only policy, platform-managed keys) with inline justification for each deviation from production defaults.

---

### User Story 3 — Security Control Configuration (Azure) (Priority: P3)

A security architect needs a documented security control baseline for every in-scope Azure service — covering RBAC assignments, network security rules, encryption settings, OS-level hardening, and Conditional Access integration — so that the full security posture is defined, auditable, and traceable to the complete regulatory framework: FISMA, FedRAMP High, NIST 800-53 Rev 5, FIPS 140-2/140-3, DISA STIGs, DFARS/NIST 800-171/172 (CUI), CMMC 2.0, EO 14028 / OMB M-22-09 (Zero Trust), and OMB M-21-31 (logging maturity).

**Why this priority**: Security controls bridge the gap between policy definitions (P1) and infrastructure code (P2). Controls like RBAC assignments, Conditional Access integration, and OS-level hardening operate at the identity and management plane, not the resource plane, and require separate documentation.

**Independent Test**: Select any Azure service (e.g., Azure AD B2C) and verify that a security control document exists that defines: RBAC roles and assignments, Conditional Access policies, MFA requirements, and any STIG/CUI-specific hardening. Verify each control maps to a NIST 800-53 control ID and includes a source reference link.

**Acceptance Scenarios**:

1. **Given** an in-scope Azure service, **When** a security architect reviews its control baseline, **Then** the document covers: identity/access (RBAC, Managed Identity), network (private endpoint, NSG/firewall rules), encryption (at rest and in transit using FIPS 140-2 validated modules, key management per NIST SP 800-57), and logging (diagnostic settings, audit logs).
2. **Given** a security control document, **When** an auditor reviews mappings, **Then** every control maps to at least one of: NIST 800-53 Rev 5 control, FIPS 140-2/140-3, DISA STIG, DFARS 252.204-7012 / NIST 800-171 (CUI), CMMC 2.0 practice, EO 14028 requirement, or FedRAMP High baseline requirement — with a source documentation link.
3. **Given** any encryption configuration across all services, **When** reviewed, **Then** it specifies FIPS 140-2 validated cryptographic modules and FIPS-approved algorithms only. Non-FIPS encryption is flagged as non-compliant.
4. **Given** the Azure AD B2C security control baseline, **When** reviewed, **Then** it covers: custom policy and user flow hardening, token lifetime and claims configuration, identity provider federation security, MFA/CAPTCHA enforcement, account lockout and rate limiting, and NIST SP 800-63-4 identity assurance level mapping.
5. **Given** cross-tenant B2B guest access between the Primary and Parent Org Azure tenants, **When** the control baseline is reviewed, **Then** it documents: Conditional Access policies applied to guest users accessing Azure resources, external collaboration settings, guest access review processes, and limitations on guest permissions — scoped to Azure tenant configuration, not Entra ID service administration.
6. **Given** the VMs for DNS security control baseline, **When** reviewed, **Then** it includes: Windows Server DISA STIG baselines, Azure Guest Configuration policies for continuous OS-level compliance assessment, CIS benchmark alignment, and FIPS 140-2 mode enablement at the OS level.

---

### User Story 4 — Logging and Monitoring Configuration (Priority: P4)

An operations engineer needs a centralized logging and monitoring strategy with per-service diagnostic settings, log categories, retention policies, and alert rules — so that all audit, security, and operational events are captured, retained, and alertable per FedRAMP High requirements.

**Why this priority**: Logging underpins auditability, incident response, and continuous monitoring — all required by FedRAMP. This builds on P1/P2 (policies and Terraform already reference logging) but consolidates the strategy and addresses cross-cutting concerns like retention and alerting.

**Independent Test**: For any single Azure service, verify that a logging configuration document specifies: which diagnostic log categories to enable, the destination (Log Analytics workspace), the retention period, and any alert rules. Confirm the Terraform module (P2) implements these settings. Confirm the policy definitions (P1) enforce diagnostic settings are enabled.

**Acceptance Scenarios**:

1. **Given** an in-scope Azure service, **When** its logging configuration is reviewed, **Then** it specifies: enabled diagnostic log categories, destination Log Analytics workspace, retention period (minimum 12 months online in Log Analytics, 18 months total in archived/cold storage per FedRAMP High AU-11), OMB M-21-31 logging maturity tier target (EL3 for critical security events, EL1 minimum for all others), and any required alert rules.
2. **Given** the centralized logging strategy document, **When** reviewed, **Then** it defines the Log Analytics workspace topology, data retention requirements (12 months online, 18 months archived), NIST 800-53 AU family control mappings, OMB M-21-31 event logging tier compliance, and NIST SP 800-137 continuous monitoring alignment.
3. **Given** the complete set of logging configurations, **When** cross-referenced against all GA Azure Commercial services, **Then** every covered service has a logging configuration — no service is unaddressed without a documented exclusion.
4. **Given** a security event (e.g., failed authentication, policy violation), **When** it occurs, **Then** the logging configuration ensures it is captured and an alert rule exists to notify operations within the defined SLA.

---

### User Story 5 — Source Reference Material and Control Mapping Index (Priority: P5)

A compliance officer needs a consolidated reference index that maps every configuration decision to its authoritative source — FISMA, FedRAMP, NIST 800-53 Rev 5, FIPS 140-2/140-3, NIST SP 800-207 (Zero Trust), NIST SP 800-63-4 (Digital Identity), DISA STIGs, DFARS/NIST 800-171/172 (CUI), CMMC 2.0, EO 14028, OMB M-22-09, OMB M-21-31, CISA BODs, DoD Cloud Computing SRG, and Microsoft documentation — so that any audit finding can be traced to the specific standard, control, and source URL that justifies the configuration.

**Why this priority**: Source references are required by the constitution (Principle V) and are critical for audit readiness. This consolidates references already embedded in P1–P4 into a single navigable index and ensures complete traceability across the full regulatory hierarchy: federal laws (FISMA, EO 14028), OMB mandates (M-22-09, M-21-31), NIST standards (FIPS, SP 800-series), DoD requirements (STIGs, CMMC, SRG), and CISA directives.

**Independent Test**: Select any configuration decision from any service's artifacts. Verify that the reference index contains an entry for that decision with: the service name, the configuration setting, the mapped control ID(s), the compliance framework(s), and a working URL to the source documentation.

**Acceptance Scenarios**:

1. **Given** any Azure Policy definition, Terraform module, or security control document, **When** a configuration decision is identified, **Then** the reference index contains a corresponding entry with: service, setting, control ID(s), framework(s), and source URL.
2. **Given** the reference index, **When** filtered by compliance framework (FISMA, FedRAMP, NIST 800-53, FIPS 140, NIST 800-171/172, CMMC 2.0, STIG, DFARS/CUI, EO 14028, OMB M-22-09, OMB M-21-31), **Then** every framework shows coverage across all in-scope services.
3. **Given** a DISA STIG applicable to an in-scope service, **When** reviewed, **Then** the STIG finding ID is mapped to the corresponding Azure Policy definition and Terraform configuration setting.
4. **Given** the complete reference index, **When** cross-referenced against all GA Azure Commercial services, **Then** every covered service has at least one reference entry — no service is unaddressed without a documented exclusion.

---

### Edge Cases

- What happens when a NIST 800-53 control maps to a service that does not support the required configuration (e.g., no Private Endpoint support)? Document the compensating control or risk acceptance.
- How does the system handle Azure services that have no applicable DISA STIG? Mark as "No STIG available" with rationale and rely on NIST 800-53 and FedRAMP mappings.
- What happens when Microsoft documentation conflicts with NIST/STIG guidance? Document the conflict, the chosen resolution, and the justification.
- How are security controls enforced when primary domain users access the parent org tenant as B2B guests? Document the Conditional Access policy chain (home tenant policies + resource tenant policies) as Azure tenant configuration, and identify gaps where guest policies cannot match member-equivalent controls.
- How are configuration differences between production and the lower (test/dev) environment documented? Each lower environment deviation from production MUST include: setting changed, production value, lower value, and justification. The minimum compliance threshold for the lower environment is: encryption in transit, diagnostic logging to Log Analytics, and identity controls matching production.
- How are Windows Server STIG findings handled when they conflict with Azure platform constraints (e.g., Azure-managed OS components that cannot be modified)? Document the constraint, the STIG finding, and whether Azure's platform controls satisfy the intent.
- How are Azure AD B2C's limited FedRAMP/STIG documentation gaps handled? Document known gaps where Microsoft has not published explicit FedRAMP or STIG guidance for B2C, identify compensating controls, and note that B2C's underlying platform inherits Azure Commercial's FedRAMP High authorization.
- How are third-party Terraform providers and modules assessed for supply chain risk per NIST SP 800-161? Document provider source verification (HashiCorp registry, GPG signature validation), version pinning, and lock file integrity.

## Requirements *(mandatory)*

### Functional Requirements

**Azure Policy and Governance**:
- **FR-001**: The project MUST produce Azure Policy definitions for every GA Azure Commercial service that is not formally excluded in `docs/azure-service-exclusions.md`, covering at minimum: encryption at rest (FIPS 140-2 validated), encryption in transit (TLS 1.2+ per NIST SP 800-52 Rev 2), network isolation, identity/authentication, and diagnostic logging.
- **FR-002**: Policy definitions MUST be organized into policy initiatives (policy sets), grouped by NIST 800-53 Rev 5 control family (e.g., AC, AU, SC, IA, CM).
- **FR-003**: Every policy definition MUST include metadata specifying the mapped NIST 800-53 control ID(s), severity, applicable compliance framework(s) (FedRAMP, FISMA, DFARS/CUI, CMMC, EO 14028), and FIPS 140 applicability where encryption is involved.
- **FR-004**: Policy definitions MUST target Azure Commercial endpoints and resource provider APIs only — no Azure Government-specific policies.
- **FR-005**: Every policy definition MUST support a configurable effect parameter. The default effect MUST vary by environment: **Deny** for critical controls (encryption at rest, encryption in transit, network isolation, identity/authentication) in the **production** environment; **Audit** for all controls in the **lower (test/dev)** environment. Advisory controls (tagging, naming conventions) default to Audit in both environments.
- **FR-006**: The project MUST define a policy lifecycle framework covering: effect escalation path (Audit → Deny), exemption process for documented exceptions with expiration dates, remediation task guidance for DeployIfNotExists and Modify effects, and a versioning schema for policy definition updates.
- **FR-007**: Policy initiatives MUST be assignable at the management group level and MUST document the assignment scope for all in-scope tenants: Primary Azure Commercial (production), Parent Org Azure Commercial (cross-tenant B2B controls), and the Lower Environment (test/dev) tenant.

**Terraform Infrastructure as Code**:
- **FR-008**: The project MUST produce Terraform modules for every GA Azure Commercial service that is not formally excluded in `docs/azure-service-exclusions.md`, deploying a FedRAMP-High-compliant resource with secure defaults.
- **FR-009**: Terraform modules MUST configure: private endpoints (where supported), encryption at rest using FIPS 140-2 validated cryptographic modules (customer-managed keys where supported), TLS 1.2+ enforcement per NIST SP 800-52 Rev 2, diagnostic settings routed to a Log Analytics workspace, and Managed Identity for authentication.
- **FR-010**: Terraform modules MUST include inline comments mapping configuration blocks to NIST 800-53 control IDs.
- **FR-011**: Terraform modules MUST be usable independently (per service) and composable for full-environment deployment.
- **FR-012**: The Terraform state backend MUST be secured: Azure Storage Account with encryption at rest (customer-managed key), RBAC-only access (shared access keys disabled), state file locking via Azure Storage lease, and private endpoint access.
- **FR-013**: Shared infrastructure modules (Log Analytics workspace, Key Vault, Virtual Network, Private DNS Zones) MUST be defined as foundational modules with explicit dependency ordering. Service modules MUST consume shared infrastructure outputs (e.g., Log Analytics workspace ID, subnet IDs) rather than creating duplicate resources.
- **FR-014**: Every Terraform module MUST support an `environment` parameter that selects between production (strict) and lower (relaxed) configurations. Lower environment deviations from production MUST be documented inline with justification for each relaxed setting.

**Security Control Configuration**:
- **FR-015**: The project MUST produce a security control baseline document for every Azure service, covering: identity and access, network security, encryption, and audit logging.
- **FR-016**: Security controls MUST map to the full regulatory framework defined in the constitution: FISMA, FedRAMP High, NIST 800-53 Rev 5, FIPS 140-2/140-3, DISA STIGs (where applicable), DFARS 252.204-7012 / NIST 800-171 Rev 3 / NIST 800-172 (CUI), CMMC 2.0 (Level 2 and Level 3 where applicable), EO 14028, and OMB M-22-09 (Zero Trust).
- **FR-017**: Azure AD B2C security controls MUST define: custom policy and user flow hardening, token lifetime and claims configuration, identity provider federation security, MFA/CAPTCHA enforcement, and account lockout/rate limiting. B2C controls MUST map to the NIST 800-53 IA (Identification and Authentication) family and document NIST SP 800-63-4 identity assurance levels (IAL, AAL, FAL) for each B2C authentication flow.
- **FR-018**: VMs for DNS MUST have a documented OS-level security baseline including: Windows Server DISA STIG application, Azure Guest Configuration policies for continuous OS-level compliance assessment, CIS benchmark alignment where STIGs are insufficient, and FIPS 140-2 mode enablement for the operating system.
- **FR-019**: Cross-cutting Azure identity controls MUST be documented as part of each service's security control baseline: Conditional Access policies that gate access to Azure resources, MFA requirements (aligned with NIST SP 800-63-4 AAL2/AAL3), PIM configuration for privileged Azure roles, and Azure RBAC assignments. This documents how Azure services consume Entra ID identity features — not the configuration of Entra ID as a standalone service.
- **FR-020**: Cross-tenant B2B guest access between the Primary Azure Commercial tenant and the Parent Org Azure Commercial tenant MUST be documented as Azure tenant configuration: Conditional Access policies for guest users accessing Azure resources, external collaboration settings (allowed/blocked domains, guest invite restrictions), guest access review processes, and cross-tenant access settings trust configuration.
- **FR-021**: Incident Response (IR) and Contingency Planning (CP) control requirements MUST be documented per NIST 800-53 Rev 5 IR and CP families: required configurations for automated incident detection and alerting, backup and recovery settings per service (backup frequency, recovery point objectives, recovery time objectives), and geo-redundancy requirements. Actual IR playbooks and CP operational procedures are out of scope; this deliverable focuses on the technical configuration requirements that enable IR and CP. Reference NIST SP 800-61 Rev 3 for IR framework alignment.
- **FR-022**: Supply chain risk management MUST be documented per NIST SP 800-161 Rev 1 and EO 14028 software supply chain requirements: Terraform provider integrity verification (HashiCorp GPG signatures), module source validation, version pinning with lock files, and third-party dependency attestation practices.

**Logging and Monitoring**:
- **FR-023**: The project MUST produce a logging configuration for every Azure service, specifying: enabled diagnostic log categories, Log Analytics workspace destination, retention period (minimum 12 months online in Log Analytics, 18 months total in archived/cold storage per FedRAMP High AU-11), and alert rules.
- **FR-024**: A centralized logging strategy document MUST define: Log Analytics workspace topology (one per environment), data retention policies (12 months online, 18 months archived) per NIST 800-53 AU family, OMB M-21-31 event logging maturity tier targets (EL3 for critical security events, EL1 minimum for all other events), NIST SP 800-137 continuous monitoring alignment, and cross-service log correlation approach.
- **FR-025**: Alert rules MUST be defined for critical security events: authentication failures, policy violations, configuration drift, resource modifications, and indicators aligned with CISA BOD 22-01 (Known Exploited Vulnerabilities).

**Source References and Compliance Mapping**:
- **FR-026**: The project MUST produce a consolidated compliance mapping index covering all in-scope services against the full regulatory hierarchy: FISMA, FedRAMP High, NIST 800-53 Rev 5, FIPS 140-2/140-3, NIST 800-171 Rev 3 / 800-172, CMMC 2.0, DISA STIGs, EO 14028, OMB M-22-09, OMB M-21-31, NIST SP 800-207, NIST SP 800-63-4, DoD Cloud Computing SRG, CISA BODs, and applicable Microsoft security baselines.
- **FR-027**: Every configuration decision across all artifacts MUST include a source reference (URL) to authoritative documentation — Microsoft Learn, NIST publications, DISA STIG viewer, FedRAMP.gov, DFARS regulatory text, OMB memoranda, Executive Orders, or CISA directives.
- **FR-028**: Where a DISA STIG exists for a service or technology, the STIG finding IDs MUST be mapped to the corresponding policy definition and Terraform configuration.
- **FR-029**: Every encryption-related configuration MUST document the specific FIPS 140-2 validation certificate number (or reference that the Azure service's underlying cryptographic module is FIPS-validated) and the FIPS-approved algorithm used.
- **FR-030**: Identity and authentication configurations MUST reference NIST SP 800-63-4 assurance levels (IAL, AAL, FAL) and document the achieved assurance level for each authentication flow.
- **FR-031**: Zero Trust architecture decisions MUST trace to NIST SP 800-207 tenets and EO 14028 / OMB M-22-09 requirements.

**GovRAMP Applicability Guide**:
- **FR-036**: The project MUST produce a GovRAMP Applicability Guide (`docs/govramp-applicability-guide.md`) that describes how to use the FedRAMP High compliance configurations, policy definitions, control mappings, and Terraform modules produced by this project to satisfy GovRAMP verification requirements for state, local, and education (SLED) cloud procurements. The guide MUST include: (a) an overview of GovRAMP and its relationship to FedRAMP, (b) GovRAMP impact levels (Low, Low+, Moderate) mapped to FedRAMP baselines, (c) GovRAMP verification statuses (Security Snapshot, Progressing, Core, Ready, Authorized), (d) step-by-step guidance for reusing this project's control mappings, policy definitions, and Terraform artifacts for GovRAMP documentation, (e) the GovRAMP Fast Track path for FedRAMP-authorized providers, (f) continuous monitoring alignment between FedRAMP and GovRAMP, (g) a comparison table of key differences between FedRAMP and GovRAMP, (h) state-level reciprocity (e.g., TX-RAMP), and (i) scope limitations clarifying that no GovRAMP-specific configurations or policy definitions are produced — FedRAMP High configurations satisfy all GovRAMP impact levels by inheritance. The guide MUST include source references to govramp.org and NIST publications.

**Cross-Cutting**:
- **FR-032**: All artifacts MUST be anonymized per Constitution Principle VIII — no customer-specific names, tenant IDs, subscription IDs, or domain names.
- **FR-033**: All artifacts MUST align with the established multi-tenant topology and environment isolation.
- **FR-034**: The complete set of deliverables MUST cover every GA Azure Commercial service that is not formally excluded in `docs/azure-service-exclusions.md` — no service may be unaddressed without a documented exclusion (Constitution Principle II).
- **FR-035**: All deliverables MUST define applicability to both Production and Lower (test/dev) environments. Production configurations are the primary deliverable. Lower environment configurations MUST document justified deviations from production with rationale. Minimum lower environment baseline: encryption in transit, diagnostic logging to Log Analytics, and identity controls (MFA, Conditional Access, RBAC) MUST match production.
- **FR-037**: The project MUST produce and maintain an Azure Service Exclusions Tracker (`docs/azure-service-exclusions.md`) that documents every GA Azure Commercial service that cannot be configured to meet FedRAMP High requirements. For each excluded service, the tracker MUST include: (a) the service name, (b) the specific exclusion reason, (c) the FedRAMP High control(s) that cannot be satisfied, (d) the date of assessment, (e) a reference to Microsoft documentation substantiating the limitation, and (f) a re-evaluation trigger (e.g., "re-evaluate when Microsoft adds Private Endpoint support"). The tracker MUST be reviewed periodically and exclusions removed when services gain compliance capabilities.

### Key Entities

- **Azure Policy Definition**: A single policy rule targeting a specific configuration aspect of an Azure service (e.g., "Storage Account must use Private Endpoint"). Includes effect (configurable: Audit/Deny), condition, metadata, and control mapping.
- **Policy Initiative (Policy Set)**: A collection of policy definitions grouped by control family or service, assignable as a unit to a management group or subscription.
- **Policy Exemption**: A documented, time-bound exception to a specific policy assignment for a specific resource or scope, with justification and expiration.
- **Management Group**: Azure management group hierarchy defining the policy assignment scope across subscriptions and the governance boundary for each tenant.
- **Terraform Module**: A self-contained, parameterized Terraform configuration for deploying a single Azure service with FedRAMP-compliant defaults. Supports an environment parameter for production/lower configuration selection.
- **Shared Infrastructure Module**: A foundational Terraform module (Log Analytics workspace, Key Vault, VNet, Private DNS Zones) that other service modules depend on.
- **Security Control Baseline**: A per-service document defining the required identity, network, encryption, and logging configuration with control mappings and source references.
- **Conditional Access Policy**: An access control rule (configured in Entra ID but consumed by Azure services) defining conditions (user, device, location, risk level) under which access to Azure resources is granted, challenged (MFA), or blocked. Documented as an Azure service dependency, not as Entra ID service configuration. Distinct from Azure Policy.
- **B2C User Flow / Custom Policy**: Azure AD B2C identity experience definitions — user flows for standard sign-up/sign-in scenarios, custom policies (XML-based Identity Experience Framework) for complex identity orchestration.
- **Guest Configuration Assignment**: An Azure Policy–based mechanism for assessing and enforcing OS-level configuration compliance within VMs. Used for Windows Server STIG and CIS benchmark enforcement.
- **Compliance Mapping Entry**: A row in the reference index linking a specific configuration → service → control ID(s) → framework(s) → source URL.
- **Diagnostic Setting Configuration**: Per-service specification of log categories, metrics, destination, and retention period (12 months online, 18 months archived).
- **Environment Configuration Delta**: A documented deviation between production and lower environment configurations, including: setting name, production value, lower value, justification, and risk assessment.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of GA Azure Commercial services have a corresponding policy initiative, Terraform module, security control baseline, and logging configuration — or a documented exclusion in `docs/azure-service-exclusions.md` with justification. Zero services are unaddressed.
- **SC-002**: Every policy definition maps to at least one NIST 800-53 Rev 5 control ID, and 100% of applicable FedRAMP High baseline controls (per NIST SP 800-53B) are addressed across the full service set.
- **SC-003**: Every Terraform module, when deployed with defaults, produces a resource that passes its corresponding policy initiative with zero violations.
- **SC-004**: Every configuration decision across all artifacts includes a source reference URL to authoritative documentation from the regulatory framework hierarchy defined in the constitution.
- **SC-005**: DISA STIG mappings are provided for every in-scope service/technology where a published STIG exists.
- **SC-006**: DFARS 252.204-7012 / NIST 800-171 Rev 3 control mappings are provided for all CUI-relevant controls, plus NIST 800-172 enhanced requirements where applicable. CMMC 2.0 Level 2 and Level 3 practice mappings are documented.
- **SC-007**: Logging configurations meet OMB M-21-31 event logging maturity tier EL3 for critical security events across all services, with minimum 12 months online retention and 18 months total archived retention.
- **SC-008**: All deliverables contain zero customer-specific identifiers — fully anonymized and reusable.
- **SC-009**: A compliance officer can trace any single configuration setting to its justification (standard, control ID, source URL) within 2 minutes using the reference index.
- **SC-010**: 100% of encryption configurations across all services document FIPS 140-2/140-3 validated cryptographic module usage. No non-FIPS encryption is present in any deliverable.
- **SC-011**: Zero Trust architecture configurations are traceable to NIST SP 800-207 tenets and EO 14028 / OMB M-22-09 requirements.
- **SC-012**: Identity and authentication controls document NIST SP 800-63-4 assurance levels achieved for each authentication flow.
- **SC-013**: All 2 production tenants (Primary Azure Commercial, Parent Org Azure Commercial) and the Lower Environment tenant have documented deliverables addressing their in-scope services and cross-tenant controls.
- **SC-014**: Lower environment configurations are documented with explicit deviations from production, each with justification. Minimum baseline controls (encryption in transit, diagnostic logging, identity/access) match production.
- **SC-015**: 100% of policy definitions support a configurable effect parameter. Production defaults to Deny for critical controls (encryption, network isolation, identity); lower environment defaults to Audit for all controls.
- **SC-016**: VMs for DNS have a complete Windows Server DISA STIG baseline and Azure Guest Configuration policies for continuous OS-level compliance assessment.
- **SC-017**: NIST 800-53 IR and CP family control requirements are documented for all in-scope services, with backup/recovery configuration settings and incident detection/response settings specified per service.
- **SC-018**: Azure AD B2C has a dedicated security control baseline covering custom policies, user flows, identity provider federation, MFA enforcement, and NIST SP 800-63-4 assurance levels.
- **SC-019**: Cross-cutting Azure identity controls (Conditional Access, MFA, PIM, RBAC) are documented within each service's security control baseline, covering how Azure services consume Entra ID identity features for access control.
- **SC-020**: A GovRAMP Applicability Guide exists at `docs/govramp-applicability-guide.md` that enables a SLED compliance officer to determine how to reuse FedRAMP High artifacts for GovRAMP verification without requiring GovRAMP-specific configurations. The guide covers impact level mapping, verification statuses, artifact reuse instructions, Fast Track path, continuous monitoring alignment, FedRAMP/GovRAMP comparison, and state reciprocity.
- **SC-021**: An Azure Service Exclusions Tracker exists at `docs/azure-service-exclusions.md` that documents every GA Azure Commercial service excluded from scope. Each exclusion entry includes: service name, exclusion reason, specific FedRAMP High control(s) not satisfiable, assessment date, Microsoft documentation reference, and re-evaluation trigger. The tracker is maintained as a living document.

## Assumptions

- The target Terraform provider version is `azurerm` (HashiCorp AzureRM) at whatever the latest stable version is at time of implementation. Provider version will be pinned in modules.
- Azure Policy definitions will use the Azure Policy JSON schema — both built-in policies (referenced) and custom policies (defined in this repo) are in scope.
- DISA STIGs referenced are the latest published versions available from the DISA STIG Viewer as of implementation date. Where a STIG does not exist for a specific Azure service, this is documented rather than fabricated.
- DFARS/CUI requirements are scoped to DFARS 252.204-7012 and its referenced standards NIST SP 800-171 Rev 3 and NIST SP 800-172 (Enhanced Security for CUI). CMMC 2.0 Level 2 (maps to 800-171) and Level 3 (maps to 800-172) practice mappings are included. The project documents control mappings but does not make legal compliance or certification determinations.
- FIPS 140-2 validation status for Azure services is based on Microsoft's published FIPS 140-2 validation certificates and documentation. Where a service's FIPS status is unclear, this is flagged for verification rather than assumed.
- OMB M-21-31 logging maturity tiers (EL0–EL3) are used to set logging depth targets. EL3 (advanced) is the target for critical security events; EL1 (basic) is the minimum for all other events.
- NIST SP 800-63-4 identity assurance levels (IAL, AAL, FAL) are documented for identity flows. FedRAMP High typically requires AAL2 or AAL3 for privileged access.
- DoD Cloud Computing SRG Impact Levels are documented for reference where applicable to Azure service configurations.
- M365 policy configurations are out of scope. Where Azure services have interoperability considerations with M365, a brief statement that M365 considerations need to be made is included, but M365 configuration is not covered in this content.
- The Log Analytics workspace topology follows a centralized model (one workspace per environment) per the architecture reference. Multi-workspace architectures are out of scope unless the architecture reference is amended.
- FedRAMP authorization boundary is the Azure Commercial subscription(s) described in the project constitution. Physical security, personnel security, and organizational controls (PS, PE, PL families) are out of scope for this deliverable.
- All 2 production tenants (Primary Azure Commercial, Parent Org Azure Commercial) and the lower environment tenant are in scope. The Parent Org tenant scope is limited to cross-tenant security controls (B2B guest access, Conditional Access for external identities, external collaboration governance) — not full service deployment into the parent org tenant.
- Production is the primary deliverable environment. Lower environment receives documented configuration deltas with justified deviations. Minimum lower environment baseline: encryption in transit, diagnostic logging, and identity controls (MFA, Conditional Access, RBAC) MUST match production.
- Policy effect strategy: production defaults to Deny for critical controls (encryption at rest, encryption in transit, network isolation, identity/authentication) and Audit for advisory controls. Lower environment defaults to Audit for all controls to support iterative development without blocking. All policy definitions accept a configurable effect parameter.
- VMs for DNS run Windows Server. OS-level hardening includes Windows Server DISA STIG baselines and Azure Guest Configuration policies for continuous assessment. Linux VM STIG baselines are out of scope unless the architecture reference is amended to include Linux VMs.
- Incident Response playbooks and Contingency Planning operational procedures are out of scope for this deliverable. The project documents IR and CP technical configuration requirements (automated detection, backup settings, recovery objectives) but does not produce operational runbooks or tabletop exercise plans.
- Terraform state is stored in Azure Storage per standard Azure backend configuration. State backend security (encryption, RBAC, locking, private endpoint) is an in-scope deliverable.
- Data retention: minimum 12 months online retention in Log Analytics, 18 months total including archived/cold storage, per FedRAMP High AU-11 control requirements.
- GovRAMP applicability guidance is a project deliverable but does not include GovRAMP-specific configurations or policy definitions. FedRAMP High is a superset of all GovRAMP impact levels (Low, Low+, Moderate); GovRAMP compliance is achieved by inheritance. GovRAMP membership, PMO engagement, and verification status determinations are the adopter's responsibility.
