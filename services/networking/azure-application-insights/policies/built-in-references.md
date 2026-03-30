# Built-in Policy References: Application Insights

**Service**: Azure Application Insights
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Application Insights Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Application Insights components should block log ingestion and querying from public networks | `1bc02227-0cb6-4e11-8f53-eb0b22eab7e8` | Audit/Deny | SC-7 | Network isolation |
| Application Insights components should disable non-AAD based ingestion | `199d5677-e4d9-4264-9465-efe1839c06bd` | Audit/Deny | IA-2 | Entra ID authentication |
| Application Insights components with Private Link enabled should use Bring Your Own Storage accounts for profiler and debugger | `0c4bd2e8-8872-4f37-a654-03d0b537744e` | Audit | SC-28 | Storage for profiler |
| Azure Monitor Logs for Application Insights should be linked to a Log Analytics workspace | `d550e854-df1a-4de9-bf44-cd894b39a95e` | Audit | AU-6 | Workspace-based mode |
| Application Insights component should block non-Azure Active Directory based ingestion | Multiple | Audit | IA-2 | AAD-only ingestion |

### Diagnostic Settings Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Deploy diagnostic settings for Application Insights to Log Analytics workspace | Service-specific | DeployIfNotExists | AU-12 | Diagnostic forwarding |
| Resource logs should be enabled for audit | `cf820ca0-f99e-429e-bae1-c0df2e2b38c4` | Audit | AU-2, AU-12 | Resource log verification |

> **Note**: The FedRAMP High built-in initiative (`d5264498-16f4-418a-b659-fa7ef418175f`) includes Application Insights policies for network isolation and authentication. Custom policies supplement coverage specific to workspace-based mode enforcement and local authentication disablement.

---

## Custom Policy Requirement (per R-001)

Custom policy definitions supplement built-in policies for Application Insights-specific enforcement:

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `audit-appinsights-workspace-based-v1` | Audit | AU-6 | Workspace-based mode required (not classic) |
| `audit-appinsights-local-auth-disabled-v1` | Audit | IA-2 | Local authentication disabled, Entra ID only |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Application Insights documentation | https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview |
| 2 | Workspace-based Application Insights | https://learn.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource |
| 3 | Disable local authentication | https://learn.microsoft.com/en-us/azure/azure-monitor/app/azure-ad-authentication |
| 4 | Azure Policy built-in definitions for Monitoring | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#monitoring |
| 5 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
