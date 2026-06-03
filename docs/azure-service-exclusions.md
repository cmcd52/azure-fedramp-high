# Azure Service Exclusions Tracker — FedRAMP High

**Purpose**: This document tracks all Generally Available (GA) Azure Commercial cloud services that have been assessed and determined **unable to meet FedRAMP High compliance requirements**. Every GA Azure Commercial service is in scope for this project unless formally excluded here with documented justification.

**Governing Principle**: Constitution Principle I ("All Generally Available Azure Commercial Services") and Principle II ("Complete Service Coverage with Exclusion Tracking") require that no GA Azure Commercial service is left unaddressed. A service may only appear in this tracker if it cannot be configured to satisfy FedRAMP High controls.

**Compliance Baseline**: FedRAMP High (NIST SP 800-53 Rev 5 High baseline)
**Target Cloud**: Azure Commercial

---

## Exclusion Criteria

A service may be excluded only if it meets one or more of the following:

1. **Cannot be configured** to satisfy FedRAMP High control requirements (e.g., lacks encryption at rest, does not support private endpoints where required, cannot meet FIPS 140-2 cryptographic requirements)
2. **Not available** in Azure Commercial regions (Azure Government-only services)
3. **SaaS platform without Azure ARM resource types** (e.g., Microsoft 365, Entra ID as standalone, Microsoft Intune) — outside Azure IaaS/PaaS scope
4. **Preview only** (not Generally Available) at time of assessment

## Required Fields per Exclusion

| Field | Description |
|-------|-------------|
| **Service Name** | Official Azure service name |
| **Exclusion Reason** | Which exclusion criterion (1–4 above) applies, with specific details |
| **FedRAMP High Control(s) Not Satisfied** | The specific NIST 800-53 Rev 5 control ID(s) that cannot be met |
| **Assessment Date** | Date the service was evaluated |
| **Microsoft Documentation Reference** | URL to Microsoft documentation substantiating the limitation |
| **Re-evaluation Trigger** | Condition under which this exclusion should be revisited (e.g., "Re-evaluate when Microsoft adds Private Endpoint support") |

---

## Standing Exclusions (SaaS / Out-of-Scope Platform)

These services are excluded because they are SaaS platforms without Azure ARM resource types, falling outside the Azure IaaS/PaaS scope of this project.

| Service | Exclusion Reason | Control(s) N/A | Assessed | Reference | Re-evaluation Trigger |
|---------|-----------------|----------------|----------|-----------|----------------------|
| Microsoft 365 (all workloads) | SaaS platform — no Azure ARM resource types; GCC/GCC High are separate compliance boundaries | N/A (out of scope category) | 2026-03-27 | [M365 compliance](https://learn.microsoft.com/en-us/compliance/regulatory/offering-fedramp) | Not applicable — M365 is a separate compliance program |
| Entra ID (standalone) | SaaS identity platform — no Azure ARM resource type. Note: Azure services' consumption of Entra ID features (Conditional Access, RBAC, MFA, PIM) is documented per-service as Azure tenant configuration | N/A (out of scope category) | 2026-03-27 | [Entra ID overview](https://learn.microsoft.com/en-us/entra/fundamentals/whatis) | Not applicable — Entra ID dependency is covered per-service |
| Microsoft Intune | SaaS endpoint management — no Azure ARM resource type | N/A (out of scope category) | 2026-03-27 | [Intune overview](https://learn.microsoft.com/en-us/mem/intune/fundamentals/what-is-intune) | Not applicable — separate compliance boundary |

---

## Service-Specific Exclusions

Services that have been assessed and determined unable to meet FedRAMP High requirements due to technical limitations.

| Service | Exclusion Reason | Control(s) Not Satisfied | Assessed | Reference | Re-evaluation Trigger |
|---------|-----------------|-------------------------|----------|-----------|----------------------|
| Azure Lab Services (classic) | Service retirement announced (criterion 4 — not GA / decommissioned). Retiring August 2027. Replacement: Microsoft Dev Box. | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/lab-services/lab-services-whats-new> | Re-evaluate only if Microsoft un-retires; otherwise track Microsoft Dev Box (covered in `services/devops/microsoft-dev-box/`) |
| Azure StorSimple | Service retired December 2022 (criterion 4) | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/previous-versions/azure/storsimple/> | Not applicable — service permanently retired |
| Azure HPC Cache | Service retired September 2025 (criterion 4) | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/hpc-cache/hpc-cache-overview> | Not applicable — service retired |
| Visual Studio App Center | Service retired March 2025 (criterion 4); replacement: GitHub Actions / Azure DevOps Pipelines | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/appcenter/retirement> | Not applicable — service retired |
| Cloud Services (classic) | Classic deployment model retired August 2024 (criterion 1 — cannot satisfy modern controls); migration path: Cloud Services (extended support) on Resource Manager, but new workloads SHOULD use App Service / VM Scale Sets | AC-3, SC-7, SC-8, SC-13, SC-28 (cannot satisfy on classic stack) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/cloud-services/> | Not applicable — classic deployment permanently retired |
| Azure Sphere | Service retiring September 2027 (criterion 4) | N/A (retiring) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure-sphere/product-overview/retirement> | Not applicable — retirement announced; track Microsoft IoT Operations (Edge) replacement |
| Azure Internet Analyzer | Preview only; never reached GA (criterion 4) | N/A (preview) | 2026-04-28 | <https://azure.microsoft.com/en-us/products/internet-analyzer/> | Re-evaluate if Microsoft GAs the service |
| Azure Database for MariaDB | Service retired September 2025 (criterion 4); migrate to Azure Database for MySQL Flexible Server | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/mariadb/migrate/whats-happening-to-mariadb> | Not applicable — service retired |
| Azure Database for PostgreSQL Single Server | Service retired March 2025 (criterion 4); migrate to Flexible Server | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/postgresql/migrate/whats-happening-to-postgresql-single-server> | Not applicable — service retired |
| Azure Database for MySQL Single Server | Service retired September 2024 (criterion 4); migrate to Flexible Server | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/mysql/single-server/whats-happening-to-mysql-single-server> | Not applicable — service retired |
| Azure Data Lake Analytics | Service retired February 2024 (criterion 4); migrate to Synapse / Databricks | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/data-lake-analytics/data-lake-analytics-overview> | Not applicable — service retired |
| Azure Time Series Insights | Service retired March 2025 (criterion 4); migrate to Microsoft Fabric Real-Time Intelligence | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/time-series-insights/migration-to-fabric> | Not applicable — service retired |
| Azure AI Personalizer | Service retiring October 2026 (criterion 4); cannot establish multi-year FedRAMP High coverage | N/A (retiring) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/ai-services/personalizer/> | Not applicable — retirement announced |
| Azure AI Metrics Advisor | Service retiring October 2026 (criterion 4) | N/A (retiring) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/ai-services/metrics-advisor/> | Not applicable — retirement announced |
| Azure RMS / Information Protection (classic) | Classic AIP labeling client retired (criterion 1, 3); modern Microsoft Purview Information Protection is part of M365 standing exclusion | N/A (out of scope category) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/information-protection/removed-sunset-services> | Re-evaluate only if Microsoft introduces a new ARM-based Azure-tenant-scoped IP service |
| Microsoft Defender EASM Legacy (RiskIQ Discovery) | Service retired August 2025 (criterion 4); replaced by integrated Defender EASM (`Microsoft.Easm/workspaces`) which is policy-eligible | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/external-attack-surface-management/> | Not applicable — service retired |
| Azure Blueprints | Service deprecation announced (retiring July 2026, criterion 4); replacement: Template Specs + Deployment Stacks | N/A (deprecated) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/governance/blueprints/overview> | Not applicable — deprecation announced; Template Specs and Deployment Stacks are evaluated via the broader Azure Resource Manager / Azure Policy controls |
| Azure Modular Datacenter | Service retired (criterion 4); replaced by Azure Local | N/A (retired) | 2026-04-28 | <https://azure.microsoft.com/en-us/products/azure-modular-datacenter/> | Not applicable — service retired |
| Azure DevOps Services | SaaS without Azure ARM resource types (criterion 3); separate FedRAMP authorization at Azure DevOps Services tenant level | N/A (out of scope category) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/devops/organizations/security/data-protection> | Re-evaluate only if Microsoft introduces ARM-based organization/project resources |
| GitHub Enterprise Cloud | SaaS without Azure ARM resource types (criterion 3); separate FedRAMP authorization at GitHub.com | N/A (out of scope category) | 2026-04-28 | <https://docs.github.com/en/enterprise-cloud@latest/admin/overview/about-github-for-enterprises> | Not applicable — separate compliance boundary |
| Azure Spatial Anchors | Service retired November 2024 (criterion 4) | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/spatial-anchors/> | Not applicable — service retired |
| Azure Remote Rendering | Service retired September 2025 (criterion 4) | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/remote-rendering/> | Not applicable — service retired |
| Azure Object Anchors | Service retired May 2024 (criterion 4) | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/object-anchors/> | Not applicable — service retired |
| Azure Blockchain Service | Service retired September 2021 (criterion 4); replacement: Quorum Blockchain Service from Consensys (third-party) | N/A (retired) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure/blockchain/service/overview> | Not applicable — Microsoft service retired |
| Power BI (Service tenant) | SaaS service whose tenant is governed by Microsoft 365 / Power BI compliance program (criterion 3); Power BI Embedded *capacity* is in scope as `Microsoft.PowerBIDedicated/capacities` | N/A (out of scope category) | 2026-04-28 | <https://learn.microsoft.com/en-us/power-bi/admin/service-admin-where-is-my-tenant-located> | Not applicable — covered under M365 / Power BI compliance program |
| Azure Stack Hub | Customer-operated on-premises hardware (criterion 1); compliance is the operator's responsibility under operator-attested controls; Azure Local (formerly HCI) is the modern Arc-enabled successor and is policy-eligible | N/A (operator-attested) | 2026-04-28 | <https://learn.microsoft.com/en-us/azure-stack/operator/> | Not applicable — separate operator-attested compliance boundary; Azure Local supersedes for new deployments |

---

## Review Process

- This tracker MUST be reviewed when new Azure services reach General Availability.
- When a previously excluded service gains capabilities that allow FedRAMP High compliance (e.g., Microsoft adds Private Endpoint support, FIPS 140-2 validated encryption, or diagnostic logging), the exclusion MUST be removed and the service brought into full project scope.
- All exclusion additions and removals MUST be noted with the assessment date.

---

**Version**: 2.0.0 | **Created**: 2026-04-26 | **Last Reviewed**: 2026-04-28 | **Wave 2 sweep**: 26 service-specific exclusions appended 2026-04-28 (T022)
