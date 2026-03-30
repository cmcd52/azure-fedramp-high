# Policy Coverage: Azure Monitor

**Service**: Azure Monitor / Log Analytics
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Azure Monitor and Log Analytics form the centralized audit and monitoring platform for the FedRAMP High environment. These policies enforce workspace retention minimums to meet AU-11 audit record retention requirements, CMK encryption for protection of audit data at rest (SC-28), and Activity Log diagnostic settings to ensure all subscription-level events are captured (AU-12). The monitoring platform's own compliance posture is critical — if audit infrastructure is non-compliant, the entire FedRAMP boundary's audit capability is compromised.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-loganalytics-retention-minimum-v1` | Deny/Audit | AU-11 | High |
| `audit-loganalytics-cmk-encryption-v1` | Audit | SC-28 | High |
| `audit-monitor-diagnostic-settings-v1` | AuditIfNotExists | AU-12 | High |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-azure-monitor-v1` | All 3 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Extensive built-in coverage for diagnostic settings enforcement across all Azure services, Activity Log collection, and Log Analytics encryption. Custom policies target workspace-level retention and CMK requirements specific to the monitoring platform.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2

---

## File Structure

```text
services/networking/azure-monitor/policies/
├── definitions/
│   ├── deny-loganalytics-retention-minimum-v1.json
│   ├── audit-loganalytics-cmk-encryption-v1.json
│   └── audit-monitor-diagnostic-settings-v1.json
├── initiatives/
│   └── fedramp-high-azure-monitor-v1.json
├── built-in-references.md
└── README.md                ← this file
```
