# Built-in Policy References: Azure Monitor

**Service**: Azure Monitor / Log Analytics
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Azure Monitor / Log Analytics Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Log Analytics workspaces should block log ingestion and querying from public networks | `6c53d030-cc64-46f0-906d-2bc061cd1334` | Audit/Deny | SC-7 | Network isolation |
| Log Analytics agent should be installed on your virtual machine | `a70ca396-0a34-413a-88e1-b956c1e683be` | Audit | AU-12 | Agent deployment |
| Azure Monitor should collect activity logs from all regions | `41388f1c-2db0-4c25-95b2-35d7f5ccbfa9` | Audit | AU-2, AU-12 | Activity log coverage |
| Azure Monitor log profile should collect logs for categories 'write,' 'delete,' and 'action' | `1a4e592a-6a6e-44a5-9814-e36264ca96e7` | Audit | AU-2, AU-3 | Activity log categories |
| Azure Monitor Logs clusters should be created with infrastructure-encryption enabled (double encryption) | `ea0dfaed-95fb-448c-934e-d6e713ce393d` | Audit/Deny | SC-28 | Double encryption |
| Azure Monitor Logs clusters should be encrypted with customer-managed key | `1f68a601-6e6d-4e42-babf-3f643a047ea2` | Audit/Deny | SC-28 | CMK encryption |
| Saved-queries in Azure Monitor should be saved in customer storage account for logs encryption | `fa298e57-9444-42ba-bf04-86e8470e32c7` | Audit | SC-28 | Query encryption |
| Azure subscriptions should have a log profile for Activity Log | `7796937f-307b-4598-941c-67d3a05ebfe7` | Audit | AU-12 | Log profile |
| Azure Monitor should collect activity logs from all subscriptions | `32f22a76-e181-4e8d-b694-6b4070022d72` | Audit | AU-2, AU-12 | Cross-subscription |
| Deploy Diagnostic Settings for Log Analytics to Event Hub | `3e16bed7-3c57-4171-bb4b-29e8e1fe7024` | DeployIfNotExists | AU-12 | Event Hub export |
| Resource logs in Log Analytics should be encrypted | `encrypt-la-logs` | Audit | SC-28 | Data encryption |

### Diagnostic Settings Built-in Policies (Broad Coverage)

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Deploy diagnostic settings for Azure services to Log Analytics workspace | Multiple per service | DeployIfNotExists | AU-12 | Per-service diagnostic forwarding |
| Audit diagnostic setting | `7f89b1eb-583c-429a-8828-af049802c1d9` | Audit | AU-12 | Generic diagnostic audit |
| Resource logs should be enabled for audit | `cf820ca0-f99e-429e-bae1-c0df2e2b38c4` | Audit | AU-2, AU-12 | Resource log verification |

### Azure Monitor Action Groups and Alerts

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| An activity log alert should exist for specific Administrative operations | `b954148f-4c11-4c38-8221-be76711e194a` | Audit | AU-6, IR-4 | Admin operation alerts |
| An activity log alert should exist for specific Security operations | `3b980d31-7904-4bb7-8575-5665739a8052` | Audit | AU-6, IR-4 | Security operation alerts |
| An activity log alert should exist for specific Policy operations | `c5447c04-a4d7-4ba8-a263-c9ee321a6858` | Audit | AU-6, CM-6 | Policy operation alerts |

> **Note**: The FedRAMP High built-in initiative (`d5264498-16f4-418a-b659-fa7ef418175f`) includes extensive diagnostic settings policies for most Azure services. Custom policies supplement coverage specific to Azure Monitor platform-level requirements (workspace retention, CMK, Activity Log forwarding).

---

## Custom Policy Requirement (per R-001)

Custom policy definitions supplement built-in policies for Azure Monitor-specific enforcement:

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-loganalytics-retention-minimum-v1` | Deny/Audit | AU-11 | Workspace retention >= 365 days |
| `audit-loganalytics-cmk-encryption-v1` | Audit | SC-28 | CMK encryption for workspace data |
| `audit-monitor-diagnostic-settings-v1` | AuditIfNotExists | AU-12 | Activity Log diagnostic settings to Log Analytics |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Monitor documentation | https://learn.microsoft.com/en-us/azure/azure-monitor/overview |
| 2 | Log Analytics workspace overview | https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview |
| 3 | Azure Monitor customer-managed keys | https://learn.microsoft.com/en-us/azure/azure-monitor/logs/customer-managed-keys |
| 4 | Azure Activity Log | https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log |
| 5 | Azure Policy built-in definitions for Monitoring | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#monitoring |
| 6 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
