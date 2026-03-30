# Logging Configuration: Azure Front Door

**Service**: Azure Front Door (Premium)
**Category**: Networking
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL3 (Advanced) for WAF events; EL2 for access and health probe logs

---

## Diagnostic Categories

All available Azure Front Door diagnostic log categories MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| FrontDoorAccessLog | All HTTP/HTTPS requests processed by Front Door including client IP, URL, response code, latency, bytes transferred, and cache status | EL2 | AU-2, AU-3, AU-12 |
| FrontDoorHealthProbeLog | Health probe requests to origins including probe result, latency, and origin status | EL2 | AU-2, AU-12, SI-4 |
| FrontDoorWebApplicationFirewallLog | WAF rule evaluations including matched rules, action taken (block/log/redirect), rule set name, and rule ID. **Critical for security monitoring.** | EL3 | AU-2, AU-3, AU-12, SI-4 |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The Front Door profile resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.Cdn/profiles (Front Door Premium)
Name: "{profile_name}-diag"
Destination: Log Analytics workspace (shared)
Log Categories:
  - FrontDoorAccessLog — Enabled
  - FrontDoorHealthProbeLog — Enabled
  - FrontDoorWebApplicationFirewallLog — Enabled
Metrics: AllMetrics — Enabled
```

---

## Retention

| Tier | Retention Period | Justification |
|------|-----------------|---------------|
| Hot (Log Analytics) | 90 days | Active query and alerting |
| Archive (Storage Account) | 7 years | FedRAMP AU-11 audit record retention |

---

## Alert Rules

The following alerts MUST be configured in the shared monitoring infrastructure:

| Alert Name | Condition | Severity | Action Group | NIST Control |
|-----------|-----------|----------|-------------|--------------|
| WAF Block Spike | FrontDoorWebApplicationFirewallLog where action_s == "Block" count > 100 in 5 minutes | Sev 1 (Error) | SOC + Incident Response | SI-4, IR-6 |
| Origin Health Degradation | FrontDoorHealthProbeLog where isHealthy_b == false for any origin > 3 consecutive probes | Sev 1 (Error) | NOC + App Team | CP-7, SI-4 |
| High Error Rate | FrontDoorAccessLog where httpStatusCode_d >= 500 count > 50 in 5 minutes | Sev 2 (Warning) | NOC + App Team | SI-4 |
| Unusual Traffic Volume | FrontDoorAccessLog request count > 200% baseline in 15 minutes | Sev 2 (Warning) | SOC | SC-5, SI-4 |
| WAF Rule Update Needed | FrontDoorWebApplicationFirewallLog where action_s == "Log" (Detection mode) count > 0 in production | Sev 3 (Informational) | Security Team | SI-4 |

---

## Log Query Examples

### WAF Blocked Requests Summary
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.CDN"
| where Category == "FrontDoorWebApplicationFirewallLog"
| where action_s == "Block"
| summarize BlockCount = count() by ruleName_s, ruleSetType_s, bin(TimeGenerated, 1h)
| order by BlockCount desc
```

### Origin Health Status
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.CDN"
| where Category == "FrontDoorHealthProbeLog"
| summarize HealthyCount = countif(isHealthy_b == true), UnhealthyCount = countif(isHealthy_b == false) by originName_s, bin(TimeGenerated, 5m)
| where UnhealthyCount > 0
```

### Top Error URLs
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.CDN"
| where Category == "FrontDoorAccessLog"
| where httpStatusCode_d >= 500
| summarize ErrorCount = count() by requestUri_s, httpStatusCode_d
| order by ErrorCount desc
| take 20
```
