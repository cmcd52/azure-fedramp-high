# Logging Configuration: DNS Private Resolver

**Service**: DNS Private Resolver
**Category**: Networking
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate) for DNS query logs

---

## Diagnostic Categories

All available DNS Private Resolver diagnostic log categories MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| DnsResolverLog | DNS query resolution events including query name, query type, source IP, response code, forwarding destination, and resolution latency | EL2 | AU-2, AU-3, AU-12 |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The DNS Private Resolver resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.Network/dnsResolvers
Name: "{resolver_name}-diag"
Destination: Log Analytics workspace (shared)
Log Categories:
  - DnsResolverLog — Enabled
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
| DNS Query to Known Malicious Domain | DnsResolverLog where queryName matches threat intelligence domain list | Sev 1 (Error) | SOC + Incident Response | SI-4, IR-6 |
| DNS Resolution Failure Spike | DnsResolverLog where responseCode != "NOERROR" count > 100 in 5 minutes | Sev 2 (Warning) | NOC + Network Team | SI-4 |
| Unusual DNS Query Volume | DnsResolverLog query count > 200% baseline in 15 minutes | Sev 2 (Warning) | SOC | SC-7, SI-4 |
| Forwarding Rule Target Unreachable | DnsResolverLog where forwarding queries fail for any target DNS server | Sev 1 (Error) | NOC + Network Team | CP-7, SI-4 |

---

## Log Query Examples

### DNS Queries to Suspicious Domains
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.NETWORK"
| where Category == "DnsResolverLog"
| where queryName_s has_any ("malware", "phishing", "c2")
| summarize QueryCount = count() by queryName_s, sourceIp_s, bin(TimeGenerated, 1h)
| order by QueryCount desc
```

### DNS Resolution Failures
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.NETWORK"
| where Category == "DnsResolverLog"
| where responseCode_s != "NOERROR"
| summarize FailCount = count() by queryName_s, responseCode_s, bin(TimeGenerated, 5m)
| where FailCount > 10
| order by FailCount desc
```

### Top Queried Domains
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.NETWORK"
| where Category == "DnsResolverLog"
| summarize QueryCount = count() by queryName_s
| order by QueryCount desc
| take 50
```

### Forwarding Rule Hit Analysis
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.NETWORK"
| where Category == "DnsResolverLog"
| where isnotempty(forwardingRuleName_s)
| summarize ForwardedCount = count() by forwardingRuleName_s, targetDnsServer_s, bin(TimeGenerated, 1h)
| order by ForwardedCount desc
```
