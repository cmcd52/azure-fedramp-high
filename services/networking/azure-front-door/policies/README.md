# Policy Coverage: Azure Front Door

**Service**: Azure Front Door
**Category**: Networking
**Last Updated**: 2026-03-27

---

## Overview

Azure Front Door is the primary edge ingress point and global load balancer for the FedRAMP High environment. These policies enforce WAF association, TLS 1.2 minimum, and HTTP-to-HTTPS redirect to meet FedRAMP High boundary protection, encryption, and monitoring requirements.

---

## Custom Policy Definitions

| Policy Definition | Effect | NIST Controls | Severity |
|-------------------|--------|---------------|----------|
| `deny-frontdoor-waf-enabled-v1` | Deny/Audit | SC-7, SI-4 | High |
| `deny-frontdoor-minimum-tls-v1` | Deny/Audit | SC-8, SC-13 | High |
| `audit-frontdoor-https-redirect-v1` | Audit | SC-8 | Medium |

## Policy Initiative

| Initiative | Policies Included | Category |
|-----------|-------------------|----------|
| `fedramp-high-azure-front-door-v1` | All 3 custom definitions | FedRAMP High |

## Built-in Policy References

See [built-in-references.md](built-in-references.md) for details. Summary: Several built-in policies exist for Front Door WAF and TLS. Custom policies provide additional enforcement specificity for HTTPS redirect and custom domain TLS configuration.

## Frameworks Covered

- FedRAMP High
- DFARS 252.204-7012 / NIST 800-171 (CUI)
- CMMC 2.0 Level 2
- DISA STIG: No STIG available for Azure Front Door (per R-002)

---

## File Structure

```text
services/networking/azure-front-door/policies/
├── definitions/
│   ├── deny-frontdoor-waf-enabled-v1.json
│   ├── deny-frontdoor-minimum-tls-v1.json
│   └── audit-frontdoor-https-redirect-v1.json
├── initiatives/
│   └── fedramp-high-azure-front-door-v1.json
├── built-in-references.md
└── README.md                ← this file
```
