# Azure Commercial — FedRAMP High Compliance Baseline

A reference repository of Azure Policy definitions, Terraform modules, security control baselines, and logging configurations designed to help organizations prepare **Azure Commercial** cloud environments for **FedRAMP High** authorization and related federal regulatory standards.

> **Disclaimer**: This repository is provided **as-is**, without warranty of any kind, express or implied. The content herein represents **general guidelines and a starting point** — not a turnkey compliance solution. Every organization's environment, risk tolerance, authorization boundary, and regulatory obligations are unique. All configurations, policies, control mappings, and documentation **must be reviewed, customized, and validated** by qualified security and compliance professionals before use in any production environment. This project does not constitute legal, regulatory, or compliance advice. Use of this material does not guarantee FedRAMP authorization or compliance with any regulatory standard.

---

## Table of Contents

- [Project Scope](#project-scope)
- [Shared Responsibility Model](#shared-responsibility-model)
- [Getting Started](#getting-started)
- [Repository Structure](#repository-structure)
- [Azure Services In Scope](#azure-services-in-scope)
- [Per-Service Artifacts](#per-service-artifacts)
- [Shared Infrastructure](#shared-infrastructure)
- [Compliance Mapping](#compliance-mapping)
- [Documentation](#documentation)
- [Appendix A — Regulatory and Standards Framework](#appendix-a--regulatory-and-standards-framework)
- [Appendix B — Microsoft Documentation References](#appendix-b--microsoft-documentation-references)

---

## Project Scope

This repository addresses **Azure IaaS and PaaS services** deployed in **Azure Commercial** regions. The goal is to provide a documented, auditable starting point for meeting the following regulatory and security objectives:

- **FedRAMP High** authorization readiness (FIPS 199 High impact level)
- **NIST SP 800-53 Rev 5** control implementation at the High baseline
- **FIPS 140-2 / 140-3** cryptographic module compliance
- **NIST SP 800-171 Rev 3 / 800-172** protections for Controlled Unclassified Information (CUI)
- **CMMC 2.0** Level 2 and Level 3 assessment readiness
- **Zero Trust** architecture per Executive Order 14028, OMB M-22-09, and NIST SP 800-207
- **OMB M-21-31** event logging maturity (EL3 for critical security events)
- **DISA STIG** alignment where applicable STIGs exist

### What Is Out of Scope

- **Azure Government** — all configurations target Azure Commercial only
- **SaaS identity platforms as standalone service deliverables** — Entra ID and Microsoft Intune are SaaS services without Azure ARM resource types and do not receive their own service directories. However, Azure services depend on Entra ID features (Conditional Access, MFA, PIM, RBAC, B2B guest access) for access control — each in-scope service's security control baseline documents how that service consumes Entra ID identity features as Azure tenant configuration, not Entra ID service administration.
- **Microsoft 365** — GCC, GCC High, and all M365 workloads are excluded
- **Customer-specific data** — all configurations use anonymized, generic identifiers

### Customer Responsibility

This repository provides Azure service configuration guidance and technical configuration requirements. The following operational concerns are the responsibility of the customer/consumer to develop, implement, and maintain according to their own organizational requirements:

- **Incident Response (IR) operations** — playbooks, runbooks, escalation procedures, and tabletop exercises per NIST SP 800-61 Rev 3 and NIST 800-53 IR family. Note: this repo includes IR/CP *technical configuration requirements* (automated detection settings, backup frequency, RPO/RTO targets) but not operational procedures.
- **Contingency Planning (CP) operations** — business continuity plans, disaster recovery procedures, and backup/restore testing per NIST 800-53 CP family
- **Policy Lifecycle Management** — Azure Policy naming conventions, versioning, assignment strategy, exemption governance, and drift remediation workflows
- **Personnel Security and Physical Security** — NIST 800-53 PS and PE control families
- **Organizational Policies and Procedures** — security awareness training, acceptable use policies, risk assessment processes

---

## Shared Responsibility Model

Cloud compliance operates under a **shared responsibility model** between Microsoft and the customer. Understanding this boundary is critical to interpreting the contents of this repository.

| Responsibility | Microsoft (Cloud Provider) | Customer (You) |
|---------------|---------------------------|-----------------|
| Physical security of datacenters | ✔ | |
| Host infrastructure, network fabric | ✔ | |
| Hypervisor and virtualization layer | ✔ | |
| Operating system (PaaS) | ✔ | |
| Identity platform (Entra ID) | ✔ | |
| Application-level configuration | | ✔ |
| Network security rules, NSGs, firewalls | | ✔ |
| Data classification and protection | | ✔ |
| Identity and access management (RBAC, MFA, Conditional Access) | | ✔ |
| Encryption key management (CMK) | | ✔ |
| Logging, monitoring, and alerting configuration | | ✔ |
| Azure Policy definition and assignment | | ✔ |
| Regulatory compliance documentation | | ✔ |
| Operating system (IaaS VMs) | | ✔ |

**This repository focuses on the customer's side of the shared responsibility model** — the configurations, policies, and documentation that customers must implement and maintain to meet FedRAMP High requirements on Azure Commercial.

For authoritative details, see [Microsoft Azure Shared Responsibility Model](https://learn.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility).

---

## Getting Started

1. **Review the shared responsibility model** — understand which controls are your responsibility vs. Microsoft's.
2. **Start with identity and networking** — `services/identity/` and `services/networking/` establish the foundation (RBAC, Managed Identity, Private Endpoints, ExpressRoute).
3. **Review per-service control baselines** — each `controls/baseline.md` documents the security posture with NIST 800-53 control mappings.
4. **Customize Terraform modules** — modules in `services/*/terraform/` and `shared/terraform/` use variables for environment conditioning. Update variables to match your environment.
5. **Review and assign Azure Policies** — review and customize policy definitions in `services/*/policies/` before assignment. Effect matrices (Deny vs. Audit) must be validated against your organization's enforcement posture.
6. **Trace compliance controls** — each service's `controls/baseline.md` and `policies/` directory maps configurations to NIST 800-53 controls with full regulatory justification.

> **Important**: All Terraform modules target the `azurerm` provider (~> 3.100) and require Terraform >= 1.5.0.

---

## Repository Structure

```
.gitattributes
.gitignore
README.md

.github/                                     # SpecKit agents and prompts for GitHub Copilot

.specify/                                    # SpecKit project config, memory, scripts, and templates

docs/                                        # Research and reference documentation
├── azure-gov-parity-research/               # Azure Commercial vs Gov Virginia feature parity
│   ├── 00-executive-summary.md
│   ├── 01-ai-data-services.md
│   ├── 02-identity-services.md
│   ├── 03-compute-storage-services.md
│   └── 04-networking-security-services.md
└── pricing/
    └── Azure_Commercial_vs_Government_Pricing_Comparison.md

services/                                    # Per-service compliance artifacts (23 services)
├── compute-storage/
│   ├── policy-initiative-summary.md
│   ├── app-service/
│   │   ├── controls/baseline.md
│   │   ├── logging/config.md
│   │   ├── policies/                        # README, built-in-references, definitions/, initiatives/
│   │   └── terraform/                       # README, main.tf, variables.tf, outputs.tf, locals.tf, versions.tf
│   ├── azure-functions/
│   │   ├── controls/  logging/  policies/  terraform/
│   │   └── (same structure as app-service)
│   ├── azure-storage-account/
│   │   ├── controls/  logging/  policies/  terraform/
│   │   └── (same structure as app-service)
│   └── key-vault/
│       ├── controls/  logging/  policies/  terraform/
│       └── (same structure as app-service)
├── data-ai/
│   ├── policy-initiative-summary.md
│   ├── ai-speech-service/
│   │   ├── controls/  logging/  policies/  terraform/
│   │   └── (same structure as app-service)
│   ├── azure-ai-foundry/
│   │   ├── controls/  logging/  policies/  terraform/
│   │   └── (same structure)
│   ├── azure-ai-search/
│   │   ├── controls/  logging/  policies/  terraform/
│   │   └── (same structure)
│   ├── azure-document-intelligence/
│   │   ├── controls/  logging/  policies/  terraform/
│   │   └── (same structure)
│   ├── azure-maps/
│   │   ├── controls/  logging/  policies/  terraform/
│   │   └── (same structure)
│   ├── azure-openai/
│   │   ├── controls/  logging/  policies/  terraform/
│   │   └── (same structure)
│   ├── azure-purview/
│   │   ├── controls/  logging/  policies/  terraform/
│   │   └── (same structure)
│   └── event-hubs/
│       ├── controls/  logging/  policies/  terraform/
│       └── (same structure)
├── identity/
│   ├── policy-initiative-summary.md
│   ├── azure-ad-b2c/
│   │   ├── controls/  logging/  policies/  terraform/
│   │   └── (same structure as app-service)
│   └── managed-identity/
│       └── controls/baseline.md             # Controls only (not a standalone deployed resource)
└── networking/
    ├── policy-initiative-summary.md
    ├── azure-application-insights/
    │   ├── controls/  logging/  policies/  terraform/
    │   └── (same structure)
    ├── azure-front-door/
    │   ├── controls/  logging/  policies/  terraform/
    │   └── (same structure)
    ├── azure-monitor/
    │   ├── controls/  logging/  policies/  terraform/
    │   └── (same structure)
    ├── bastion/
    │   ├── controls/  logging/  policies/  terraform/
    │   └── (same structure)
    ├── dns-private-resolver/
    │   ├── controls/  logging/  policies/  terraform/
    │   └── (same structure)
    ├── expressroute/
    │   ├── controls/  logging/  policies/  terraform/
    │   └── (same structure)
    ├── private-dns-zone/
    │   ├── controls/  logging/  policies/  terraform/
    │   └── (same structure)
    ├── private-endpoint/
    │   ├── controls/  logging/  policies/  terraform/
    │   └── (same structure)
    └── vms-for-dns/
        ├── controls/  logging/  policies/  terraform/
        └── (same structure)

shared/                                      # Cross-cutting Azure configuration
├── logging-strategy.md
└── terraform/
    ├── key-vault/                           # README, main.tf, variables.tf, outputs.tf, versions.tf
    ├── log-analytics/                       # README, main.tf, variables.tf, outputs.tf, locals.tf, versions.tf
    ├── private-dns-zones/                   # README, main.tf, variables.tf, outputs.tf, locals.tf, versions.tf
    ├── state-backend/                       # README, main.tf, variables.tf, outputs.tf, versions.tf
    └── virtual-network/                     # README, main.tf, variables.tf, outputs.tf, locals.tf, versions.tf

specs/                                       # SpecKit feature specs, plans, tasks, contracts, and checklists
```

### SpecKit — AI-Assisted Specification Workflow

This project was built using [SpecKit](https://github.com/Serdra/speckit), an AI-assisted specification and implementation workflow for VS Code. SpecKit provides a structured process for moving from natural language requirements through feature specifications, implementation plans, and actionable task lists — all driven by conversational AI agents.

- **`.github/agents/` and `.github/prompts/`** — SpecKit agent and prompt definitions that integrate with GitHub Copilot to power the specification workflow.
- **`.specify/`** — Project configuration including the project constitution (guiding principles and constraints), the authoritative Azure services reference, compliance mapping index, validation scripts, and document templates.
- **`specs/`** — Feature-level artifacts: specifications, implementation plans, data models, interface contracts, verification checklists, and dependency-ordered task lists.

These artifacts document **how** the project was designed and built but are not part of the compliance deliverable content. They are retained in the repository for project history, traceability, and to support future feature development.

---

## Azure Services In Scope

23 Azure IaaS and PaaS services are covered, organized by service group:

### AI and Data Services
| Service | Resource Provider |
|---------|-------------------|
| Azure OpenAI | `Microsoft.CognitiveServices` |
| Azure AI Search | `Microsoft.Search` |
| Azure AI Foundry | `Microsoft.MachineLearningServices` |
| Azure Document Intelligence | `Microsoft.CognitiveServices` |
| AI Speech Service | `Microsoft.CognitiveServices` |
| Azure Maps | `Microsoft.Maps` |
| Azure Purview | `Microsoft.Purview` |
| Event Hubs | `Microsoft.EventHub` |

### Identity and Access Management
| Service | Resource Provider |
|---------|-------------------|
| Azure AD B2C | `Microsoft.AzureActiveDirectory` |
| Managed Identity | `Microsoft.ManagedIdentity` |

### Compute, Storage, and Web Hosting
| Service | Resource Provider |
|---------|-------------------|
| Azure App Service | `Microsoft.Web` |
| Azure Functions | `Microsoft.Web` |
| Azure Storage Account | `Microsoft.Storage` |
| Key Vault | `Microsoft.KeyVault` |

### Networking, Monitoring, and Security
| Service | Resource Provider |
|---------|-------------------|
| ExpressRoute | `Microsoft.Network` |
| Azure Front Door | `Microsoft.Cdn` |
| Bastion | `Microsoft.Network` |
| DNS Private Resolver | `Microsoft.Network` |
| Private DNS Zone | `Microsoft.Network` |
| Private Endpoint | `Microsoft.Network` |
| Azure Monitor | `Microsoft.OperationalInsights` |
| Azure Application Insights | `Microsoft.Insights` |
| VMs for DNS | `Microsoft.Compute` |

---

## Per-Service Artifacts

Each service directory contains up to four artifact types:

| Directory | Contents | Purpose |
|-----------|----------|---------|
| `policies/` | Azure Policy definitions (JSON), built-in references, initiative bundles | Enforce guardrails via Deny, Audit, and DeployIfNotExists effects |
| `terraform/` | Terraform module (`main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`) | Codify the compliant resource configuration with environment conditioning |
| `controls/` | Security control baseline (Markdown) | Document RBAC, encryption, network, and logging controls mapped to NIST 800-53 |
| `logging/` | Logging and diagnostic configuration (Markdown) | Define log categories, retention, alert rules, and OMB M-21-31 maturity tier |

> **Note**: Managed Identity has `controls/` only (configuration pattern, not a standalone deployed resource).

---

## Shared Infrastructure

The `shared/terraform/` directory provides reusable Terraform modules for foundational resources referenced by multiple services:

| Module | Purpose |
|--------|---------|
| `log-analytics/` | Centralized Log Analytics workspace (per-environment) |
| `key-vault/` | Shared Key Vault for secrets, certificates, and CMK |
| `virtual-network/` | Hub VNet with subnet structure |
| `private-dns-zones/` | Private DNS Zones for private endpoint resolution |
| `state-backend/` | Terraform remote state (Storage Account + container) |

---

## Compliance Mapping

A consolidated compliance mapping index maps every in-scope service's configuration decisions to authoritative compliance frameworks. Both Markdown and CSV formats are maintained at `.specify/memory/compliance-mapping-index.md` and `.specify/memory/compliance-mapping-index.csv` for audit traceability.

Frameworks mapped include: NIST 800-53 Rev 5, FedRAMP High, FIPS 140-2/140-3, NIST 800-171/172, CMMC 2.0, DISA STIGs, OMB M-21-31, OMB M-22-09, EO 14028, NIST SP 800-207, and NIST CSF 2.0.

---

## Documentation

The `docs/` directory contains research and reference documentation produced during the project:

| Directory | Contents |
|-----------|----------|
| `docs/azure-gov-parity-research/` | Feature parity analysis comparing all 23 in-scope Azure services between Azure Commercial and Azure Government (US Gov Virginia). Includes an executive summary, per-service-group research files, and source references from official Microsoft documentation. |
| `docs/pricing/` | Pricing comparison between Azure Commercial and Azure Government cloud offerings for the in-scope services. |

> **Note**: The `docs/` directory is supplementary research material. It is not part of the compliance deliverable content but provides valuable context for organizations evaluating Azure Government deployment alongside Azure Commercial.

---

## Appendix A — Regulatory and Standards Framework

### Tier 1 — Federal Laws and Executive Orders

| Authority | Description | Reference |
|-----------|-------------|-----------|
| **FISMA** | Federal Information Security Modernization Act (44 U.S.C. § 3551 et seq.) — requires federal agencies to implement information security programs. FedRAMP is the FISMA-derived cloud authorization program. | [congress.gov](https://www.congress.gov/bill/113th-congress/senate-bill/2521) |
| **Executive Order 14028** | Improving the Nation's Cybersecurity (May 2021) — mandates zero trust, software supply chain security, improved detection and response. | [whitehouse.gov](https://www.whitehouse.gov/briefing-room/presidential-actions/2021/05/12/executive-order-on-improving-the-nations-cybersecurity/) |
| **DFARS 252.204-7012** | Safeguarding Covered Defense Information and Cyber Incident Reporting — requires NIST 800-171 for CUI in non-federal systems. | [acquisition.gov](https://www.acquisition.gov/dfars/252.204-7012) |

### Tier 2 — OMB Memoranda and Federal Mandates

| Authority | Description | Reference |
|-----------|-------------|-----------|
| **OMB M-22-09** | Federal Zero Trust Strategy — specific zero trust goals for federal agencies. | [whitehouse.gov](https://www.whitehouse.gov/wp-content/uploads/2022/01/M-22-09.pdf) |
| **OMB M-21-31** | Improving Investigative and Remediation Capabilities — event logging maturity tiers (EL0–EL3). | [whitehouse.gov](https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf) |
| **FedRAMP** | Federal Risk and Authorization Management Program — standardized cloud security assessment and authorization. | [fedramp.gov](https://www.fedramp.gov/) |

### Tier 3 — NIST Standards (Mandatory for Federal Systems)

| Standard | Description | Reference |
|----------|-------------|-----------|
| **FIPS 140-2 / FIPS 140-3** | Security Requirements for Cryptographic Modules. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/fips/140/3/final) |
| **FIPS 199** | Standards for Security Categorization of Federal Information and Information Systems. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/fips/199/final) |
| **FIPS 200** | Minimum Security Requirements for Federal Information and Information Systems. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/fips/200/final) |
| **NIST SP 800-53 Rev 5** | Security and Privacy Controls for Information Systems and Organizations. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) |
| **NIST SP 800-53A Rev 5** | Assessing Security and Privacy Controls in Information Systems and Organizations. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-53a/rev-5/final) |
| **NIST SP 800-53B** | Control Baselines for Information Systems and Organizations. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-53b/final) |
| **NIST SP 800-37 Rev 2** | Risk Management Framework for Information Systems and Organizations. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-37/rev-2/final) |
| **NIST SP 800-171 Rev 3** | Protecting Controlled Unclassified Information in Nonfederal Systems and Organizations. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-171/rev-3/final) |
| **NIST SP 800-172** | Enhanced Security Requirements for Protecting Controlled Unclassified Information. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-172/final) |

### Tier 4 — NIST Guidance (Recommended / Supporting)

| Standard | Description | Reference |
|----------|-------------|-----------|
| **NIST SP 800-207** | Zero Trust Architecture. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-207/final) |
| **NIST SP 800-63-4** | Digital Identity Guidelines (identity proofing, authentication, federation). | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-63/4/final) |
| **NIST SP 800-52 Rev 2** | Guidelines for the Selection, Configuration, and Use of TLS Implementations. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-52/rev-2/final) |
| **NIST SP 800-57 Part 1 Rev 5** | Recommendation for Key Management. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final) |
| **NIST SP 800-137** | Information Security Continuous Monitoring for Federal Information Systems and Organizations. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-137/final) |
| **NIST SP 800-61 Rev 3** | Computer Security Incident Handling Guide. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-61/rev-3/final) |
| **NIST SP 800-161 Rev 1** | Cybersecurity Supply Chain Risk Management Practices. | [csrc.nist.gov](https://csrc.nist.gov/publications/detail/sp/800-161/rev-1/final) |
| **NIST CSF 2.0** | Cybersecurity Framework 2.0. | [nist.gov](https://www.nist.gov/cyberframework) |

### Tier 5 — DoD and Defense-Specific

| Standard | Description | Reference |
|----------|-------------|-----------|
| **DISA STIGs** | Security Technical Implementation Guides — configuration checklists for specific technologies. | [public.cyber.mil](https://public.cyber.mil/stigs/) |
| **CMMC 2.0** | Cybersecurity Maturity Model Certification — DoD enforcement mechanism for NIST 800-171/172. Level 2 = 800-171; Level 3 = 800-172. | [dodcio.defense.gov](https://dodcio.defense.gov/CMMC/) |
| **DoD Cloud Computing SRG** | Security Requirements Guide for cloud services — defines Impact Levels (IL2–IL6). | [public.cyber.mil](https://public.cyber.mil/stigs/) |

### Tier 6 — CISA Directives

| Directive | Description | Reference |
|-----------|-------------|-----------|
| **CISA BOD 22-01** | Reducing the Significant Risk of Known Exploited Vulnerabilities. | [cisa.gov](https://www.cisa.gov/binding-operational-directive-22-01) |
| **CISA BOD 23-01** | Improving Asset Visibility and Vulnerability Detection on Federal Networks. | [cisa.gov](https://www.cisa.gov/binding-operational-directive-23-01) |

---

## Appendix B — Microsoft Documentation References

### Azure Compliance and Trust

| Topic | Link |
|-------|------|
| Azure Shared Responsibility Model | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility) |
| Azure Compliance Offerings | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/compliance/offerings/) |
| Azure FedRAMP Documentation | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-fedramp) |
| Microsoft Trust Center | [microsoft.com](https://www.microsoft.com/en-us/trust-center) |
| Azure FIPS 140 Validated Cryptographic Modules | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-fips-140-2) |
| FedRAMP High Authorized Services in Azure | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/azure-government/compliance/azure-services-in-fedramp-auditscope) |

### Azure Security Fundamentals

| Topic | Link |
|-------|------|
| Azure Security Baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/security/benchmark/azure/overview) |
| Azure Policy Built-in Definitions | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies) |
| Azure Policy Regulatory Compliance — FedRAMP High | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high) |
| Azure Policy Regulatory Compliance — NIST 800-53 Rev 5 | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/governance/policy/samples/nist-sp-800-53-r5) |
| Azure Monitor and Log Analytics | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/azure-monitor/overview) |
| Azure Private Link / Private Endpoint | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview) |
| Azure Key Vault | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) |
| Azure Managed Identity | [learn.microsoft.com](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) |
| Azure Bastion | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) |
| Azure ExpressRoute | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction) |

### Azure Service Configuration

| Service | Topic | Link |
|---------|-------|------|
| Azure OpenAI | Security baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/managed-identity) |
| Azure OpenAI | Virtual network support | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks) |
| Azure AI Search | Security overview | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/search/search-security-overview) |
| Azure AI Search | Private Endpoint | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/search/service-create-private-endpoint) |
| Azure AI Foundry | Security baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/ai-studio/concepts/vulnerability-management) |
| Azure Document Intelligence | Security and data privacy | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/authentication/managed-identities) |
| AI Speech Service | Security baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/cognitive-services-security-baseline) |
| Azure Maps | Security practices | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/azure-maps/azure-maps-authentication) |
| Azure Purview (Microsoft Purview) | Security best practices | [learn.microsoft.com](https://learn.microsoft.com/en-us/purview/concept-best-practices-security) |
| Azure Purview (Microsoft Purview) | Private Endpoints | [learn.microsoft.com](https://learn.microsoft.com/en-us/purview/catalog-private-link) |
| Event Hubs | Security baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/event-hubs-security-baseline) |
| Event Hubs | Network security | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/event-hubs/network-security) |
| Azure AD B2C | Security and technical overview | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/active-directory-b2c/technical-overview) |
| Azure AD B2C | Custom policy overview | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/active-directory-b2c/custom-policy-overview) |
| Managed Identity | Overview | [learn.microsoft.com](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) |
| Azure App Service | Security baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/app-service-security-baseline) |
| Azure App Service | Networking features | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/app-service/networking-features) |
| Azure Functions | Security baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/functions-security-baseline) |
| Azure Functions | Networking options | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/azure-functions/functions-networking-options) |
| Azure Storage Account | Security baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/storage-security-baseline) |
| Azure Storage Account | Network security | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security) |
| Azure Storage Account | Encryption at rest | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/storage/common/storage-service-encryption) |
| Key Vault | Security overview | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/key-vault/general/security-features) |
| Key Vault | Network security | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/key-vault/general/network-security) |
| ExpressRoute | Security best practices | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-prerequisites) |
| ExpressRoute | Encryption over ExpressRoute | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-about-encryption) |
| Azure Front Door | Security baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/azure-front-door-security-baseline) |
| Azure Front Door | WAF overview | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview) |
| Bastion | Security baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/azure-bastion-security-baseline) |
| DNS Private Resolver | Overview | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview) |
| Private DNS Zone | Overview | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/dns/private-dns-overview) |
| Private Endpoint | DNS configuration | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns) |
| Azure Monitor | Security baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/monitor-security-baseline) |
| Azure Monitor | Data security | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-security) |
| Application Insights | Overview | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) |
| VMs (Windows Server) | Security baseline | [learn.microsoft.com](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/virtual-machines-windows-security-baseline) |
| VMs (Windows Server) | Azure Disk Encryption | [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/virtual-machines/disk-encryption-overview) |

### Terraform and Infrastructure as Code

| Topic | Link |
|-------|------|
| Terraform AzureRM Provider | [registry.terraform.io](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) |
| HashiCorp Terraform Security | [developer.hashicorp.com](https://developer.hashicorp.com/terraform/cloud-docs/architectural-details/security) |

---

*This repository is not affiliated with, endorsed by, or sponsored by Microsoft, NIST, FedRAMP, DISA, or any government agency. All trademarks are the property of their respective owners.*
