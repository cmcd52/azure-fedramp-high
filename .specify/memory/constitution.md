<!--
Sync Impact Report
- Version change: 8.0.0 → 8.1.0 (MINOR — added Documentation Consistency governance rule)
- Changes:
  - Added "Documentation Consistency" governance rule: artifact changes MUST be accompanied by documentation updates
  - Documentation contradicting current artifact state is now a constitution violation
  - Previous: 7.0.0 → 8.0.0 removed Principle IX (Service Approval and Immutability)
  - Constitution has 8 principles (I–VIII); NON-NEGOTIABLE: I, II, III, VIII
-->

# Azure Cloud FedRAMP High — Constitution

## Project Purpose

This repository compiles all necessary Azure Policy definitions, Azure service configurations, documentation, explanations, and source references to ensure **all Generally Available (GA) Azure Commercial cloud services** are designed to meet FedRAMP High Authorization compliance. Azure Government is explicitly out of scope. Services that cannot be configured to meet FedRAMP High requirements are tracked and documented with justification in `docs/azure-service-exclusions.md`.

Because GovRAMP (formerly StateRAMP) verification levels are derived from the same NIST 800-53 Rev 5 control framework that underpins FedRAMP, configurations produced by this project are intended to satisfy GovRAMP Authorized status requirements at the corresponding impact level. GovRAMP alignment is a secondary objective — FedRAMP High remains the primary authorization target.



## Repository Structure

- **`services/`** — Per-service compliance artifacts organized by group (identity, networking, compute-storage, data-ai), each containing `policies/`, `terraform/`, `controls/`, and `logging/` subdirectories
- **`shared/`** — Cross-cutting infrastructure: shared Terraform modules (Log Analytics, Key Vault, VNet, Private DNS, State Backend) and centralized logging strategy
- **`.specify/memory/`** — Project memory: constitution and compliance mapping index
- **`docs/`** — Research, deliverables, and governance ledgers (Azure Gov parity analysis, pricing, GovRAMP applicability guide, service exclusions tracker)
- **`specs/`** — Feature specifications, implementation plans, and task lists


## Core Principles

### I. All Generally Available Azure Commercial Services (NON-NEGOTIABLE)

The scope of this project is **all Generally Available (GA) Azure Commercial cloud services**. There is no pre-defined fixed list of in-scope services. Every Azure service that has reached General Availability in Azure Commercial regions is in scope unless it has been formally excluded and documented in `docs/azure-service-exclusions.md`.

A service may only be excluded if it meets one or more of the following criteria:
- The service **cannot be configured** to satisfy FedRAMP High control requirements (e.g., lacks encryption at rest, does not support private endpoints where required, or cannot meet FIPS 140-2 cryptographic requirements).
- The service is **not available** in Azure Commercial regions (Azure Government-only services are out of scope per Principle III).
- The service is a **SaaS platform without Azure ARM resource types** (e.g., Microsoft 365, Entra ID as a standalone service, Microsoft Intune) and therefore falls outside the Azure IaaS/PaaS scope.
- The service is in **preview** (not Generally Available) at the time of assessment.

Every exclusion MUST be documented in `docs/azure-service-exclusions.md` with: the service name, the exclusion reason, the specific FedRAMP High control(s) that cannot be satisfied, the date of assessment, and a reference to Microsoft documentation substantiating the limitation.

### II. Complete Service Coverage with Exclusion Tracking (NON-NEGOTIABLE)

The project MUST produce deliverable output for **every GA Azure Commercial service** that is not formally excluded in `docs/azure-service-exclusions.md`. No service may be left unaddressed without a documented exclusion. For each covered service, the project MUST deliver at minimum:
- **Azure Policy definitions** applicable to the service for FedRAMP High controls.
- **Service configuration baseline** documenting the compliant configuration (network, identity, encryption, logging).
- **NIST 800-53 Rev 5 control mapping** identifying which controls the service configuration satisfies.
- **Source-referenced documentation** explaining the configuration rationale with links to Microsoft and FedRAMP documentation.

A service is not considered complete until all of the above artifacts exist. Specifications, plans, and task lists MUST account for every covered service — omitting a service without a documented exclusion is a constitution violation.

The exclusion tracker (`docs/azure-service-exclusions.md`) MUST be maintained as a living document. When a previously excluded service gains capabilities that allow FedRAMP High compliance (e.g., Microsoft adds private endpoint support or FIPS 140-2 validated encryption), the exclusion MUST be removed and the service brought into scope.

### III. Azure Commercial Only (NON-NEGOTIABLE)

The target environment is **Azure Commercial**. Azure Government is out of scope. All policy definitions, service configurations, and compliance documentation MUST target Azure Commercial regions and endpoints. Any FedRAMP High control guidance that is specific to Azure Government MUST NOT be included.

### IV. FedRAMP High Compliance First

Every design decision MUST account for FedRAMP High requirements as defined by the **Federal Information Security Modernization Act (FISMA)** and operationalized through the FedRAMP program. This includes data residency, encryption at rest and in transit, audit logging, access control, and network isolation. Compliance is not a follow-up task — it is a prerequisite for every artifact.

The FedRAMP High baseline is derived from:
- **FIPS 199** — Security categorization at the High impact level.
- **FIPS 200** — Minimum security requirements for federal information systems.
- **NIST SP 800-53B** — Control baselines defining which NIST 800-53 Rev 5 controls apply at High.
- **NIST SP 800-37 Rev 2** — Risk Management Framework (RMF) lifecycle under which FedRAMP operates.

**GovRAMP Alignment**: Because GovRAMP (formerly StateRAMP, rebranded February 2025) derives its security verification framework from the same NIST 800-53 Rev 5 controls, artifacts produced under this principle MUST be structured so that GovRAMP Authorized-level verification can be demonstrated without additional rework. Where a FedRAMP High control satisfies a corresponding GovRAMP requirement, the control mapping documentation SHOULD note the GovRAMP applicability. GovRAMP is a 501(c)(6) nonprofit and is not affiliated with FedRAMP or the United States Government.

### V. Source-Referenced Documentation

All compliance claims, policy definitions, and configuration guidance MUST include source references — Microsoft documentation links, FedRAMP control mappings (NIST 800-53 Rev 5), or official Azure compliance documentation. Unsourced claims are not acceptable.

### VI. Zero-Trust Networking

All services MUST use Private Endpoints where available. Public endpoints are prohibited unless explicitly justified and documented. Network traffic MUST flow through approved paths (ExpressRoute, Front Door, Private DNS). Bastion is the only permitted method for administrative VM access.

Zero Trust architecture requirements are mandated by:
- **Executive Order 14028** (Improving the Nation's Cybersecurity, May 2021)
- **OMB Memorandum M-22-09** (Federal Zero Trust Strategy)
- **NIST SP 800-207** (Zero Trust Architecture)

### VII. Least-Privilege Identity

Managed Identity MUST be used for service-to-service authentication. Shared secrets and connection strings stored in application code are prohibited. Key Vault MUST be used for any secrets, certificates, or keys. RBAC assignments MUST follow least-privilege — no standing Owner or Contributor at subscription scope.

### VIII. Customer Data Anonymization (NON-NEGOTIABLE)

This repository MUST NOT contain any customer-specific information. All architecture diagrams, reference documents, configurations, and examples MUST use anonymized/generic identifiers. Specifically:
- No customer or organization names, tenant names, or domain names.
- No real Active Directory domain names, user principal names, or group names.
- No Azure subscription IDs, tenant IDs, or resource names that could identify a customer.
- Source diagrams or documents containing customer information MUST be anonymized before any content is committed to the repository.
- Any image or diagram directory MUST NOT contain files with customer-identifying information in file names or content.
- If customer-specific source materials are used for reference, only the anonymized derivative artifacts may be stored in this repository.



## Compliance and Security Standards

- **Data Classification**: All data handled by these services is assumed to be at the FedRAMP High impact level (FIPS 199 High) until explicitly classified otherwise.
- **Encryption**: All data MUST be encrypted at rest (platform-managed keys minimum; customer-managed keys where supported) and in transit (TLS 1.2+ per NIST SP 800-52 Rev 2). All cryptographic modules MUST be **FIPS 140-2 validated** (or FIPS 140-3 where available). Azure services MUST be configured to use FIPS-compliant encryption algorithms and key lengths. Non-FIPS-validated encryption is prohibited.
- **Logging and Monitoring**: Azure Monitor, Log Analytics, and Application Insights MUST be configured for all deployed services. Diagnostic settings MUST route to a centralized Log Analytics workspace. Logging maturity MUST target **OMB M-21-31** (Improving the Federal Government's Investigative and Remediation Capabilities) event logging tier EL3 for critical security events. **NIST SP 800-137** (Information Security Continuous Monitoring) provides the framework for ongoing compliance verification.
- **Boundary Controls**: Azure Purview MUST be used for data governance and cataloging. All AI/data services MUST operate within the approved network perimeter.
- **Control Framework**: NIST 800-53 Rev 5 at the High baseline (as defined in NIST SP 800-53B) is the governing control framework. All policy definitions MUST map to specific control families. Assessment procedures follow **NIST SP 800-53A Rev 5**.
- **Identity and Authentication**: Digital identity practices MUST align with **NIST SP 800-63-4** (Digital Identity Guidelines) for identity proofing, authentication, and federation assurance levels appropriate to FedRAMP High.
- **DFARS/CUI and CMMC**: For Controlled Unclassified Information (CUI), configurations MUST satisfy **DFARS 252.204-7012**, **NIST SP 800-171 Rev 3** (Protecting CUI), and **NIST SP 800-172** (Enhanced Security Requirements for CUI) where applicable. Configurations MUST also support **CMMC 2.0** Level 2 (aligns with NIST 800-171) and Level 3 (aligns with NIST 800-172) assessment readiness.
- **Vulnerability Management**: Vulnerability management practices MUST account for **CISA Binding Operational Directive (BOD) 22-01** (Known Exploited Vulnerabilities) and **CISA BOD 23-01** (Asset Visibility and Vulnerability Detection) where applicable to the cloud service configuration.
- **GovRAMP Alignment**: Configurations and control mappings produced by this project MUST be structured to support **GovRAMP** (formerly StateRAMP) verification at the Authorized level. Because GovRAMP verification levels are derived from NIST 800-53 Rev 5, FedRAMP High configurations inherently satisfy GovRAMP requirements at or above the corresponding impact level. Control mapping documents SHOULD include a notation where a mapped NIST 800-53 control also satisfies a GovRAMP verification requirement, enabling state and local government adopters to leverage these artifacts for GovRAMP procurement compliance.

## Applicable Regulatory and Standards Framework

The following is the authoritative hierarchy of regulations, standards, and guidance governing this project. All deliverables MUST trace to one or more of these authorities:

### Tier 1 — Federal Laws and Executive Orders
| Authority | Description |
|-----------|-------------|
| **FISMA** (44 U.S.C. § 3551 et seq.) | Federal Information Security Modernization Act — requires federal agencies to implement information security programs. FedRAMP is the FISMA-derived cloud authorization program. |
| **Executive Order 14028** (May 2021) | Improving the Nation's Cybersecurity — mandates zero trust, software supply chain security, improved detection and response, standardized incident response. |
| **DFARS 252.204-7012** | Safeguarding Covered Defense Information and Cyber Incident Reporting — requires NIST 800-171 compliance for CUI in non-federal systems. |

### Tier 2 — OMB Memoranda and Federal Mandates
| Authority | Description |
|-----------|-------------|
| **OMB M-22-09** | Federal Zero Trust Strategy — requires agencies to meet specific zero trust goals by end of FY2024. |
| **OMB M-21-31** | Improving Investigative and Remediation Capabilities — defines event logging maturity tiers (EL0–EL3). |
| **FedRAMP** (fedramp.gov) | Federal Risk and Authorization Management Program — standardized approach to cloud security assessment, authorization, and continuous monitoring. |

### Tier 3 — NIST Standards (Mandatory for Federal Systems)
| Standard | Description |
|----------|-------------|
| **FIPS 140-2 / FIPS 140-3** | Security Requirements for Cryptographic Modules — mandatory for all encryption in federal systems. |
| **FIPS 199** | Standards for Security Categorization of Federal Information and Information Systems. |
| **FIPS 200** | Minimum Security Requirements for Federal Information and Information Systems. |
| **NIST SP 800-53 Rev 5** | Security and Privacy Controls for Information Systems and Organizations. |
| **NIST SP 800-53A Rev 5** | Assessing Security and Privacy Controls. |
| **NIST SP 800-53B** | Control Baselines for Information Systems and Organizations (defines High baseline). |
| **NIST SP 800-37 Rev 2** | Risk Management Framework (RMF). |
| **NIST SP 800-171 Rev 3** | Protecting Controlled Unclassified Information in Nonfederal Systems (CUI). |
| **NIST SP 800-172** | Enhanced Security Requirements for Protecting CUI. |

### Tier 4 — NIST Guidance (Recommended/Supporting)
| Standard | Description |
|----------|-------------|
| **NIST SP 800-207** | Zero Trust Architecture. |
| **NIST SP 800-63-4** | Digital Identity Guidelines (identity proofing, authentication, federation). |
| **NIST SP 800-52 Rev 2** | Guidelines for TLS Implementation. |
| **NIST SP 800-57 Part 1 Rev 5** | Key Management Recommendations. |
| **NIST SP 800-137** | Information Security Continuous Monitoring (ISCM). |
| **NIST SP 800-61 Rev 3** | Incident Response Recommendations. |
| **NIST SP 800-161 Rev 1** | Cybersecurity Supply Chain Risk Management. |
| **NIST CSF 2.0** | Cybersecurity Framework — voluntary but widely adopted risk management complement to 800-53. |

### Tier 5 — DoD and Defense-Specific
| Standard | Description |
|----------|-------------|
| **DISA STIGs** | Security Technical Implementation Guides — configuration checklists for specific technologies. |
| **CMMC 2.0** | Cybersecurity Maturity Model Certification — DoD's enforcement mechanism for NIST 800-171/172 compliance. Level 2 = NIST 800-171; Level 3 = NIST 800-172. |
| **DoD Cloud Computing SRG** | Security Requirements Guide for cloud services — defines Impact Levels (IL2–IL6). Azure Commercial supports IL2; Azure Government supports IL4/IL5. |

### Tier 6 — CISA Directives
| Directive | Description |
|-----------|-------------|
| **CISA BOD 22-01** | Reducing the Significant Risk of Known Exploited Vulnerabilities. |
| **CISA BOD 23-01** | Improving Asset Visibility and Vulnerability Detection on Federal Networks. |

### Tier 7 — State and Local Government Programs
| Program | Description |
|---------|-------------|
| **GovRAMP** (govramp.org) | Formerly StateRAMP (rebranded February 2025). A 501(c)(6) nonprofit membership organization providing standardized cybersecurity verification and validation for cloud services used by state, local, and education (SLED) entities. GovRAMP verification levels (Security Snapshot, Progressing, Ready, Core, Authorized) are derived from NIST 800-53 Rev 5 controls. GovRAMP is **not** affiliated with FedRAMP or the United States Government. Configurations meeting FedRAMP High inherently satisfy GovRAMP Authorized-level requirements at the corresponding impact level. |
| **TX-RAMP** | Texas Risk and Authorization Management Program — state-level program that recognizes GovRAMP Progressing Snapshot and Ready status for Provisionally Authorized status. Referenced as an example of state-level adoption of GovRAMP. |

## Technology Constraints

- **Cloud Provider**: Microsoft Azure Commercial only — no Azure Government, no multi-cloud.
- **Service Scope**: All Generally Available (GA) Azure Commercial services. Excluded services are tracked in `docs/azure-service-exclusions.md`.
- **M365**: Microsoft 365 (GCC, GCC High, and all M365 workloads) is out of scope for this project.

## Governance

- This constitution supersedes all other project guidance. Conflicts are resolved in favor of this document.
- Excluding an Azure service from scope requires documenting the exclusion in `docs/azure-service-exclusions.md` with: service name, exclusion reason, the specific FedRAMP High control(s) that cannot be satisfied, assessment date, and Microsoft documentation reference.
- When a previously excluded service gains FedRAMP High compliance capabilities, the exclusion MUST be removed and the service brought into scope.
- All specifications and plans MUST include a "Constitution Check" confirming alignment with these principles.
- **Documentation Consistency**: Any change to project artifacts (policies, Terraform modules, control baselines, service configurations, exclusions, or scope) MUST be accompanied by corresponding updates to all affected project documentation — including but not limited to README.md, constitution verification checklists, policy initiative summaries, spec documents, and cross-reference guides. Documentation that contradicts the current state of project artifacts is a constitution violation.


**Version**: 8.1.0 | **Ratified**: 2026-03-27 | **Last Amended**: 2026-05-22
