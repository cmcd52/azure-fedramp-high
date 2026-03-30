# Policy Coverage: Application Insights

**Service**: Azure Application Insights
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Azure Application Insights provides application performance monitoring (APM) and telemetry collection for web applications. These policies enforce workspace-based mode to ensure all telemetry flows to the centralized Log Analytics workspace for unified query and retention (AU-6), and disable local authentication to require Entra ID for all API access (IA-2). Application telemetry must be treated as audit data when it captures user actions, authentication events, or error conditions that could indicate security incidents.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `audit-appinsights-workspace-based-v1` | Audit | AU-6 | Medium |
| `audit-appinsights-local-auth-disabled-v1` | Audit | IA-2 | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-azure-application-insights-v1` | All 2 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Built-in coverage for network isolation, AAD-based ingestion, and Private Link storage. Custom policies target workspace-based mode enforcement and local authentication disablement.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2

---

## File Structure

```text
services/networking/azure-application-insights/policies/
├── definitions/
│   ├── audit-appinsights-workspace-based-v1.json
│   └── audit-appinsights-local-auth-disabled-v1.json
├── initiatives/
│   └── fedramp-high-azure-application-insights-v1.json
├── built-in-references.md
└── README.md                ← this file
```
