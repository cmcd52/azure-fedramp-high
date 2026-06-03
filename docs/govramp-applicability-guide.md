# GovRAMP Applicability Guide

**Purpose**: Guidance for applying this project's FedRAMP High compliance configurations, policy definitions, control mappings, and Terraform modules to satisfy GovRAMP verification requirements for state, local, and education (SLED) cloud procurements.

**Governing Standard**: FedRAMP High remains the standard for all configuration and policy guidance in this project. No GovRAMP-specific configurations or policy definitions are produced. GovRAMP compliance is achieved by inheritance — FedRAMP High is a superset of all GovRAMP impact levels.

> **Disclaimer**: GovRAMP™ is a 501(c)(6) nonprofit membership organization. GovRAMP™ is **not** endorsed by or affiliated with FedRAMP or the United States Government, and any views or opinions expressed in this guide do not necessarily state or reflect those of GovRAMP or the United States Government. This guide does not constitute legal, regulatory, or compliance advice. GovRAMP verification status determinations are made solely by the GovRAMP PMO and/or authorized government sponsors.

---

## Table of Contents

- [1. GovRAMP Overview](#1-govramp-overview)
- [2. GovRAMP Impact Levels](#2-govramp-impact-levels)
- [3. GovRAMP Verification Statuses](#3-govramp-verification-statuses)
- [4. How to Use This Project's Artifacts for GovRAMP](#4-how-to-use-this-projects-artifacts-for-govramp)
  - [4.1 Control Mapping Reuse](#41-control-mapping-reuse)
  - [4.2 Policy Definition Applicability](#42-policy-definition-applicability)
  - [4.3 Terraform Module Applicability](#43-terraform-module-applicability)
  - [4.4 Logging and Monitoring Applicability](#44-logging-and-monitoring-applicability)
- [5. GovRAMP Fast Track Path](#5-govramp-fast-track-path)
- [6. Continuous Monitoring Alignment](#6-continuous-monitoring-alignment)
- [7. Key Differences Between FedRAMP and GovRAMP](#7-key-differences-between-fedramp-and-govramp)
- [8. State-Level Reciprocity](#8-state-level-reciprocity)
- [9. Scope Limitations](#9-scope-limitations)
- [10. Source References](#10-source-references)

---

## 1. GovRAMP Overview

GovRAMP (formerly StateRAMP, rebranded February 2025) is a nonprofit membership organization that provides standardized cybersecurity verification and validation for cloud services used by state, local, and education (SLED) entities. Founded in 2020, GovRAMP was created to address the need for a consistent approach to cybersecurity standards for cloud service providers serving state and local governments.

**Relationship to FedRAMP**: GovRAMP derives its security verification framework from **NIST SP 800-53 Rev 5** — the same control framework that underpins FedRAMP. Both programs structure security assessment reports, system security plans, and continuous monitoring around NIST 800-53 controls. GovRAMP additionally incorporates **MITRE ATT&CK Framework** control protection values for scoring and prioritization at certain verification tiers.

**Shared NIST Foundation**: Because both programs are built on NIST 800-53 Rev 5, a cloud service provider that has achieved FedRAMP authorization has already demonstrated compliance with the controls required for GovRAMP verification. GovRAMP recognizes this through its **Fast Track** process, which allows FedRAMP-authorized providers to reuse their existing security packages.

> **Source**: [GovRAMP About Us](https://govramp.org/about-us/) | [NIST SP 800-53 Rev 5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)

---

## 2. GovRAMP Impact Levels

GovRAMP defines the following impact levels for data classification, aligned with NIST SP 800-53 Rev 5 control baselines:

| GovRAMP Impact Level | NIST 800-53 Baseline | Relationship to FedRAMP | Typical Data Types |
|---------------------|----------------------|------------------------|-------------------|
| **Low** | NIST 800-53 Rev 5 Low baseline | Equivalent to FedRAMP Low | Public/non-confidential information |
| **Low+** | NIST 800-53 Rev 5 Low baseline + additional controls | Between FedRAMP Low and Moderate | Low-sensitivity data requiring additional protections |
| **Moderate** | NIST 800-53 Rev 5 Moderate baseline | Equivalent to FedRAMP Moderate | Confidential/regulated data (PII, PHI, PCI, CJI) |

### Key Implication for This Project

GovRAMP does not currently define a **High** impact level. FedRAMP High configurations produced by this project — which implement the full NIST 800-53 Rev 5 High baseline — **exceed all GovRAMP impact level requirements**. A FedRAMP High–compliant configuration inherently satisfies:

- GovRAMP **Moderate** (the highest GovRAMP impact level)
- GovRAMP **Low+**
- GovRAMP **Low**

Organizations adopting this project's configurations for GovRAMP purposes do not need to modify or supplement them — the FedRAMP High baseline is a strict superset.

> **Source**: [GovRAMP Authorized Process](https://govramp.org/providers/authorized/) | [NIST SP 800-53B Control Baselines](https://csrc.nist.gov/publications/detail/sp/800-53b/final)

---

## 3. GovRAMP Verification Statuses

GovRAMP defines a progression of verification statuses, each representing increasing levels of security assurance:

| Status | Description | Assessment Method | 3PAO Required | Continuous Monitoring |
|--------|-------------|-------------------|---------------|----------------------|
| **Security Snapshot** | Gap analysis measuring current maturity against minimum mandatory requirements | GovRAMP PMO assessment | No | No |
| **Progressing Snapshot** | Quarterly assessments with monthly PMO consultative calls; subscription-based mentoring program | GovRAMP PMO subscription | No | Quarterly snapshots |
| **Core** | Validated implementation of 60 foundational NIST controls selected based on MITRE ATT&CK Framework, aligned with Moderate Impact Level baseline | GovRAMP PMO assessment | No | Quarterly |
| **Ready** | Meets GovRAMP minimum mandatory requirements demonstrated by a readiness assessment report; no government sponsor required | 3PAO readiness assessment | Yes | Per GovRAMP ConMon guide |
| **Authorized** | Meets all required security controls by impact level; requires 3PAO attestation and government sponsor or GovRAMP Approvals Committee acceptance | 3PAO full assessment + government sponsor | Yes | Monthly + annual |
| **Provisionally Authorized** | Provisional authorization pending completion of remaining items; same requirements as Authorized | 3PAO attestation + government sponsor | Yes | Monthly + annual |

### Verification Progression Path

```
Security Snapshot → Progressing Snapshot → Core → Ready → Authorized
                                                    ↑
                                          Fast Track (for FedRAMP-authorized providers)
```

Organizations with existing FedRAMP authorization can bypass the early stages and enter directly via the **Fast Track** process (see Section 5).

> **Source**: [GovRAMP for Service Providers](https://govramp.org/providers/) | [GovRAMP Core Status](https://govramp.org/providers/core/) | [GovRAMP Authorized](https://govramp.org/providers/authorized/)

---

## 4. How to Use This Project's Artifacts for GovRAMP

### 4.1 Control Mapping Reuse

Every NIST 800-53 Rev 5 control mapping in this project directly maps to GovRAMP requirements because GovRAMP uses the same control catalog. When preparing GovRAMP documentation:

**System Security Plan (SSP)**:
- Reference the per-service security control baselines located in `services/<group>/<service>/controls/`
- Each control mapping to a NIST 800-53 Rev 5 control ID satisfies the corresponding GovRAMP requirement at the applicable impact level
- The GovRAMP PMO explicitly **accepts documentation in FedRAMP format**, so artifacts structured per FedRAMP conventions do not require reformatting

**Control Implementation Statements**:
- The Terraform module inline comments and security control documents provide the implementation narrative that can be transcribed into GovRAMP SSP format
- Each configuration block maps to specific NIST 800-53 control IDs — these same IDs are used by GovRAMP

**Compliance Mapping Index**:
- The project's consolidated compliance mapping index (per FR-026 in the spec) maps configurations to the full regulatory hierarchy including NIST 800-53 Rev 5
- This index can be used as a cross-reference when completing GovRAMP documentation to identify which project artifacts satisfy each required control

### 4.2 Policy Definition Applicability

Azure Policy definitions and initiatives in this project enforce FedRAMP High controls. For GovRAMP scenarios:

- **All policy definitions remain applicable as-is** — FedRAMP High is a superset of every GovRAMP impact level
- **No GovRAMP-specific policy definitions are needed** — the FedRAMP High enforcement level exceeds GovRAMP Moderate requirements
- Policy initiatives organized by NIST 800-53 control family (AC, AU, SC, IA, CM, etc.) can be referenced directly when mapping to GovRAMP control requirements
- Organizations targeting only GovRAMP Low or Moderate **may** choose to relax certain policy effects (e.g., from Deny to Audit) for controls that are in the FedRAMP High baseline but outside the GovRAMP Low/Moderate baseline — such relaxation is the adopter's responsibility and is **not** documented in this project

### 4.3 Terraform Module Applicability

Terraform modules in this project deploy FedRAMP High–compliant Azure resources by default. For GovRAMP:

- All Terraform modules produce resources that satisfy GovRAMP Moderate requirements without modification
- The inline NIST 800-53 control ID comments in each Terraform module serve as the traceability link to GovRAMP requirements
- Shared infrastructure modules (Log Analytics, Key Vault, VNet, Private DNS Zones) provide the foundational secure architecture required by both FedRAMP and GovRAMP

### 4.4 Logging and Monitoring Applicability

Logging configurations in this project target OMB M-21-31 EL3 maturity for critical security events. For GovRAMP:

- GovRAMP continuous monitoring requires vulnerability scans, POA&M tracking, and security event logging — all of which are addressed by the project's logging strategy
- Diagnostic settings routing to a centralized Log Analytics workspace provide the audit trail required for GovRAMP continuous monitoring submissions
- Alert rules for authentication failures, policy violations, and configuration drift support both FedRAMP and GovRAMP incident notification requirements

---

## 5. GovRAMP Fast Track Path

The GovRAMP Fast Track process allows providers with existing or in-progress FedRAMP authorization to achieve GovRAMP Authorized status using their existing FedRAMP security package.

### Fast Track Process

1. **Become a GovRAMP Member** — Membership is required before products can be validated by the PMO
2. **Engage the GovRAMP PMO** — Complete a Security Review Request Form
3. **Submit FedRAMP Documentation** — Provide the federal-approved security package, 90 days of continuous monitoring data (if applicable), and any necessary GovRAMP templates. The GovRAMP PMO **accepts documents in FedRAMP formatting**
4. **PMO Review** — The PMO reviews the complete package and conducts a review call with the provider and 3PAO
5. **Obtain GovRAMP Authorized Status** — Upon successful review, the product is listed on the GovRAMP Authorized Product List (APL)
6. **Begin Continuous Monitoring** — Monthly and annual reporting as specified in the GovRAMP Continuous Monitoring Guide

### How This Project Supports Fast Track

The artifacts produced by this project are structured per FedRAMP conventions and include:
- NIST 800-53 Rev 5 control mappings (directly usable for GovRAMP)
- Security control baselines per service (transcribable to SSP control implementation statements)
- Policy definitions with control metadata (auditable evidence of control implementation)
- Terraform configurations with inline control references (evidence of infrastructure compliance)

These artifacts can be assembled into the FedRAMP security package that the GovRAMP PMO accepts via Fast Track, eliminating duplicate documentation effort.

> **Source**: [GovRAMP Fast Track](https://govramp.org/providers/fast-track/)

---

## 6. Continuous Monitoring Alignment

Both FedRAMP and GovRAMP require ongoing continuous monitoring after authorization. The table below shows how this project's monitoring configurations support both programs:

| Monitoring Requirement | FedRAMP Requirement | GovRAMP Requirement | Project Coverage |
|-----------------------|--------------------|--------------------|-----------------|
| **Vulnerability scanning** | Monthly per ConMon guide | Monthly for Authorized; quarterly for Core | Logging configurations capture scan results; alert rules flag critical findings |
| **POA&M management** | Monthly updates | Monthly for Authorized; quarterly for Core | Control mapping index identifies controls with known gaps |
| **Security event logging** | OMB M-21-31 EL3 for critical events | NIST 800-53 AU family controls | Diagnostic settings per service; centralized Log Analytics; 12-month online + 18-month archived retention |
| **Configuration drift detection** | Continuous per ConMon | Per GovRAMP ConMon guide | Azure Policy compliance state; alert rules for configuration changes |
| **Incident notification** | Per FedRAMP IR guidance | Per GovRAMP PMO requirements | Alert rules for security events; IR technical configurations per service |
| **Annual reassessment** | Full 3PAO reassessment | Full 3PAO reassessment for Authorized | Control baselines and compliance mappings provide assessment evidence |

> **Source**: [GovRAMP Continuous Monitoring Guide](https://govramp.org/blog/document/stateramp-continuous-monitoring-guide/) | [NIST SP 800-137](https://csrc.nist.gov/publications/detail/sp/800-137/final)

---

## 7. Key Differences Between FedRAMP and GovRAMP

| Aspect | FedRAMP | GovRAMP |
|--------|---------|---------|
| **Governing body** | GSA (federal government program) | 501(c)(6) nonprofit membership organization |
| **Statutory authority** | FedRAMP Authorization Act (44 USC § 3607–3616); FISMA | No statutory authority; voluntary adoption by SLED entities |
| **Target consumers** | Federal agencies | State, local, and education (SLED) entities |
| **Impact levels** | Low, Moderate, High | Low, Low+, Moderate (no High) |
| **Control framework** | NIST SP 800-53 Rev 5 | NIST SP 800-53 Rev 5 + MITRE ATT&CK (for scoring) |
| **Authorization path** | JAB P-ATO or Agency ATO (Rev5); FedRAMP 20x (new automation-based path) | PMO verification + government sponsor or Approvals Committee |
| **Fast Track from FedRAMP** | N/A | Available — submit FedRAMP package to GovRAMP PMO |
| **3PAO requirement** | Required for all authorization levels | Required only for Ready and Authorized statuses |
| **Intermediate tiers** | None (directly pursue authorization) | Security Snapshot → Progressing → Core → Ready → Authorized |
| **Continuous monitoring** | Monthly (ConMon) per FedRAMP guidelines | Monthly/annual for Authorized; quarterly for Core |
| **Documentation format** | FedRAMP templates (SSP, SAR, SAP, POA&M) | Accepts FedRAMP formatting; also provides own templates |
| **MITRE ATT&CK integration** | Not a formal component of Rev5 or 20x | Used for control prioritization and scoring at Core/Snapshot levels |
| **State reciprocity** | N/A (federal program) | TX-RAMP automatic reciprocity; growing list of participating governments |
| **Cost model** | No fee to CSPs for authorization (assessment costs borne by CSP) | Membership fees ($1,500–$7,500/yr) + tiered PMO assessment fees |
| **FedRAMP 20x** | New automation-based path (Phase 2 active as of FY26 Q1–Q2; High pilot planned FY27) | No equivalent; GovRAMP Core uses PMO-assessed automation concepts |

### Implications for This Project

1. **No additional configurations needed**: FedRAMP High exceeds all GovRAMP impact levels. Organizations using this project's configurations are already above GovRAMP Moderate requirements.
2. **Documentation portability**: GovRAMP accepts FedRAMP-formatted documentation. Artifacts in this repository follow FedRAMP conventions and are directly usable.
3. **MITRE ATT&CK gap**: GovRAMP's Core status uses MITRE ATT&CK for control prioritization. This project does not include MITRE ATT&CK mappings, but the 60 Core controls are a subset of NIST 800-53 Rev 5 Moderate — which is a subset of the High baseline this project implements.
4. **Intermediate tiers**: GovRAMP's intermediate tiers (Snapshot, Progressing, Core) have no FedRAMP equivalent. Organizations pursuing these tiers can still use this project's artifacts as evidence, selecting the subset of controls required at each tier.

---

## 8. State-Level Reciprocity

GovRAMP verification is recognized by a growing number of state programs, enabling cloud service providers to satisfy multiple state procurement cybersecurity requirements through a single verification.

### TX-RAMP (Texas)

Texas law requires vendors using cloud solutions to serve Texas to become TX-RAMP authorized. By administrative rule, TX-RAMP recognizes GovRAMP with **automatic reciprocity**:

- GovRAMP **Progressing Snapshot** and **Ready** status qualify for TX-RAMP Provisionally Authorized status with no expiration
- GovRAMP provides a **weekly sync** with TX-RAMP — GovRAMP Authorized products appear on the TX-RAMP list automatically
- TX-RAMP Level 1 applies to public/non-confidential information (low impact systems)
- TX-RAMP Level 2 applies to confidential/regulated data (moderate/high impact systems)

### Broader Adoption Path

Organizations leveraging this project's FedRAMP High configurations can:

1. Achieve FedRAMP authorization using this project's artifacts
2. Pursue GovRAMP Fast Track authorization using the same FedRAMP package
3. Through GovRAMP, obtain reciprocal recognition from TX-RAMP and other participating state programs

This creates a single-effort path to federal, state, and local compliance using the FedRAMP High configurations in this project as the foundation.

> **Source**: [GovRAMP Participating Governments](https://govramp.org/participating-governments/) | [GovRAMP Fast Track — Texas Note](https://govramp.org/providers/fast-track/)

---

## 9. Scope Limitations

- This project does **not** produce GovRAMP-specific configurations, policy definitions, or templates. All configurations target FedRAMP High; GovRAMP compliance is achieved by inheritance from the shared NIST 800-53 Rev 5 foundation.
- GovRAMP SSP templates, POA&M formats, and continuous monitoring report templates are available from the GovRAMP PMO (govramp.org) and are **not** reproduced in this repository.
- Organizations must independently determine their required GovRAMP **impact level** (Low, Low+, or Moderate) based on the data classification of their specific deployment. The GovRAMP Data Classification Tool is available from govramp.org.
- **GovRAMP membership** and PMO engagement are prerequisites for verification and are the responsibility of the adopting organization.
- GovRAMP **verification status determinations** are made solely by the GovRAMP PMO and/or authorized government sponsors — this project provides technical artifacts only, not certification or authorization determinations.
- This guide does not address GovRAMP's **MITRE ATT&CK** control scoring methodology in detail. Organizations pursuing GovRAMP Core status should consult the GovRAMP Core Control Evidence Examples package available from govramp.org.
- **State reciprocity programs** beyond TX-RAMP are not enumerated here. Consult the GovRAMP Participating Governments page for the current list.

---

## 10. Source References

| Reference | URL |
|-----------|-----|
| GovRAMP Homepage | https://govramp.org/ |
| GovRAMP About Us | https://govramp.org/about-us/ |
| GovRAMP for Service Providers | https://govramp.org/providers/ |
| GovRAMP Core Status | https://govramp.org/providers/core/ |
| GovRAMP Authorized Process | https://govramp.org/providers/authorized/ |
| GovRAMP Fast Track | https://govramp.org/providers/fast-track/ |
| GovRAMP Adopting for Government | https://govramp.org/governments/adopting-for-government/ |
| GovRAMP Participating Governments | https://govramp.org/participating-governments/ |
| GovRAMP Continuous Monitoring Guide | https://govramp.org/blog/document/stateramp-continuous-monitoring-guide/ |
| GovRAMP Authorized Product List | https://govramp.org/product-list/ |
| NIST SP 800-53 Rev 5 | https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final |
| NIST SP 800-53B (Control Baselines) | https://csrc.nist.gov/publications/detail/sp/800-53b/final |
| NIST SP 800-137 (Continuous Monitoring) | https://csrc.nist.gov/publications/detail/sp/800-137/final |
| MITRE ATT&CK Framework | https://attack.mitre.org/ |
| FedRAMP Homepage | https://www.fedramp.gov/ |
| FedRAMP 20x | https://www.fedramp.gov/20x/ |
