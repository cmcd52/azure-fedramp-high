# Security Control Baseline: Azure Front Door

**Service**: Azure Front Door (Premium)
**Category**: Networking
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Front Door is the global edge ingress point for the FedRAMP High environment. It provides Layer 7 load balancing, SSL/TLS termination, Web Application Firewall (WAF), DDoS protection, and content acceleration. All external-facing HTTP/HTTPS traffic enters the environment through Front Door.

Front Door Premium tier is required for managed WAF rule sets (OWASP DefaultRuleSet, BotManagerRuleSet) and Private Link to origin connectivity, which routes traffic from Front Door to backend origins over the Microsoft backbone instead of the public internet.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the Front Door profile, WAF policy, endpoints, origins, routes, and diagnostic settings.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| CDN Profile Contributor | Resource group (via PIM) | Manages Front Door profiles, endpoints, origins, and routes. JIT activation required. | AC-2, AC-3, AC-6 |
| Security Admin | Resource group (via PIM) | Manages WAF policies, custom rules, and security configurations. JIT activation required. | AC-2, AC-3, AC-6 |
| CDN Profile Reader | Resource group | Read-only access to Front Door configuration for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to Front Door metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: Not applicable — Front Door is a global service that does not use Managed Identity for its own operations
- Service-to-service: Front Door connects to origins via HTTPS or Private Link; origin authentication is managed at the origin level
- NIST: N/A

---

## WAF Rules

### Managed Rule Sets

| Rule Set | Version | Action | Purpose | NIST Control |
|----------|---------|--------|---------|--------------|
| Microsoft_DefaultRuleSet | 2.1 | Block | OWASP Top 10 protection (SQL injection, XSS, LFI, RFI, command injection) | SC-7, SI-4 |
| Microsoft_BotManagerRuleSet | 1.0 | Block | Bot detection and mitigation (good bots allowed, bad bots blocked) | SC-7, SI-4 |

### Custom Rules (Recommended)

| Rule Name | Priority | Action | Purpose | NIST Control |
|-----------|----------|--------|---------|--------------|
| RateLimitRule | 100 | Block | Rate limiting — 1000 requests per minute per IP | SC-5 |
| GeoFilter | 200 | Block | Block traffic from non-US countries (if applicable) | SC-7 |
| IPAllowList | 50 | Allow | Allow known partner/vendor IP ranges | AC-3 |

### WAF Mode

| Environment | Mode | Justification |
|-------------|------|---------------|
| Production | Prevention | Block malicious traffic; required for FedRAMP High |

---

## TLS Configuration

### FIPS Cipher Suites

- **Minimum TLS version**: TLS 1.2 (TLS 1.0 and 1.1 are prohibited)
- **Cipher suites**: Front Door supports TLS 1.2 cipher suites including AES-GCM and AES-CBC with SHA-256/SHA-384
- **Certificate type**: Azure Front Door managed certificate (auto-renewed) or customer-managed certificate from Key Vault
- **FIPS reference**: Azure Front Door uses Microsoft's FIPS 140-2 validated TLS implementation
- NIST: SC-8, SC-13

---

## Origin Security

### Private Link to Origins

- **Availability**: Front Door Premium tier only
- **Supported origins**: App Service, Azure Storage, Application Gateway, Internal Load Balancer
- **Purpose**: Traffic from Front Door to origin traverses Microsoft backbone, never the public internet
- **Approval**: Private Link connection must be approved at the origin (manual or auto-approve)
- NIST: SC-7

### HTTPS-Only Origins

- **Protocol**: All origin connections use HTTPS (port 443)
- **Certificate validation**: `certificate_name_check_enabled = true` — Front Door validates origin SSL certificate
- **Origin host header**: Set to origin FQDN for correct SNI
- NIST: SC-8

---

## DDoS Protection

### Integrated DDoS

- Azure Front Door includes built-in DDoS protection at the edge
- Layer 3/4 DDoS mitigation is automatic and always-on
- Layer 7 DDoS mitigation via WAF rate limiting rules
- No additional DDoS Protection Plan required for Front Door endpoints
- NIST: SC-5

---

## Network Controls

### No DISA STIG

- Per R-002: No DISA STIG exists for Azure Front Door
- Compensating controls: NIST 800-53 controls applied directly, CIS Azure benchmark networking sections, Microsoft security baseline documentation

---

## NIST 800-53 Control Mapping

| Control | Implementation | Evidence |
|---------|---------------|----------|
| SC-5 | DDoS protection (built-in Layer 3/4 + WAF rate limiting for Layer 7) | WAF rate limit rule; Front Door built-in DDoS |
| SC-7 | WAF policy in Prevention mode; Private Link to origins; geo-filtering | Terraform: WAF policy, private_link block, custom rules |
| SC-8 | TLS 1.2 minimum; HTTPS-only origin connections; HTTP-to-HTTPS redirect | Terraform: forwarding_protocol = HttpsOnly, https_redirect_enabled = true |
| SC-13 | FIPS 140-2 validated TLS implementation; AES-GCM cipher suites | Azure Front Door platform guarantee |
| SI-4 | WAF logging (FrontDoorWebApplicationFirewallLog); access logging | Terraform: diagnostic settings; logging/config.md |
| AU-2 | Diagnostic settings enabled for all log categories | Terraform: azurerm_monitor_diagnostic_setting |
| AU-12 | All available log categories forwarded to Log Analytics | logging/config.md |

---
