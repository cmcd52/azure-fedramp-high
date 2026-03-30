# Built-in Policy References: Azure Front Door

**Service**: Azure Front Door
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Azure Front Door Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Azure Front Door should have WAF enabled | `055aa869-bc98-4af8-bafc-23f1ab6ffe2c` | Audit/Deny | SC-7, SI-4 | WAF association requirement |
| Azure Front Door Standard and Premium should be running minimum TLS version of 1.2 | `679da822-78a7-4f26-87fb-84539d4cdc20` | Audit | SC-8, SC-13 | TLS version enforcement |
| Azure Front Door profiles should use Premium tier that supports managed WAF rules and private link | `dfc212af-17ea-423a-9dcb-91e2cb2caa6b` | Audit/Deny | SC-7 | Premium tier for WAF + Private Link |

### Web Application Firewall Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Web Application Firewall (WAF) should be enabled for Azure Front Door | `055aa869-bc98-4af8-bafc-23f1ab6ffe2c` | Audit/Deny | SC-7, SI-4 | WAF enablement |
| WAF should use the specified mode for Azure Front Door | `425bea59-a659-4cbb-8d31-34499bd030b8` | Audit/Deny | SC-7, SI-4 | WAF mode (Prevention) |

> **Note**: The FedRAMP High built-in initiative (`d5264498-16f4-418a-b659-fa7ef418175f`) includes some Front Door policies. Custom policies supplement coverage for HTTPS redirect enforcement and specific TLS version requirements.

---

## Custom Policy Requirement (per R-001)

Custom policy definitions supplement built-in policies for comprehensive FedRAMP High coverage:

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `deny-frontdoor-waf-enabled-v1` | Deny/Audit | SC-7, SI-4 | WAF policy must be associated with security policy |
| `deny-frontdoor-minimum-tls-v1` | Deny/Audit | SC-8, SC-13 | TLS 1.2 minimum on custom domains |
| `audit-frontdoor-https-redirect-v1` | Audit | SC-8 | HTTP-to-HTTPS redirect on routes |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Policy built-in definitions for CDN | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#cdn |
| 2 | Azure Front Door documentation | https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview |
| 3 | Azure Front Door WAF documentation | https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview |
| 4 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
