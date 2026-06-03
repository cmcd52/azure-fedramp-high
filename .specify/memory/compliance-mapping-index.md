# Compliance Mapping Index

> **Version**: 2.0.0 | **Generated**: 2026-03-27 | **Wave 2 Appended**: 2026-05-12 | **Spec**: [spec.md](specs/001-fedramp-compliance-baseline/spec.md)
> **Schema**: [compliance-mapping-schema.md](specs/001-fedramp-compliance-baseline/contracts/compliance-mapping-schema.md)
>
> This index maps every configuration decision across all 118 Azure services (23 Wave 1 + 95 Wave 2) to authoritative compliance frameworks. An auditor can trace any configuration setting to its justification within 2 minutes using this index (SC-009).

---

## Table of Contents

- [Identity Services](#identity-services)
- [Networking Services](#networking-services)
- [Compute & Storage Services](#compute--storage-services)
- [Data & AI Services](#data--ai-services)
- [Wave 2 Services](#wave-2-services-appended-2026-05-12)
- [Appendix A: NIST 800-53 Control Coverage](#appendix-a-nist-800-53-control-coverage)
- [Appendix B: Framework Coverage Summary](#appendix-b-framework-coverage-summary)

---

## Identity Services

### Azure AD B2C

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Custom domain (organization-owned) | [controls/baseline.md](services/identity/azure-ad-b2c/controls/baseline.md) | IA-8 | Zero Trust | N/A | N/A | N/A | N/A | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/active-directory-b2c/custom-domain) |
| MFA for elevated-risk flows | [controls/baseline.md](services/identity/azure-ad-b2c/controls/baseline.md) | IA-2(1) | CMMC 2.0, DFARS | N/A | N/A | 3.5.3 | L2 IA.L2-3.5.3 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/active-directory-b2c/multi-factor-authentication) |
| Account lockout (5 failures / 30 min) | [controls/baseline.md](services/identity/azure-ad-b2c/controls/baseline.md) | AC-7 | CMMC 2.0 | N/A | N/A | 3.1.8 | L2 AC.L2-3.1.8 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/active-directory-b2c/threat-management) |
| CAPTCHA on sign-up | [controls/baseline.md](services/identity/azure-ad-b2c/controls/baseline.md) | SI-10 | CMMC 2.0 | N/A | N/A | N/A | N/A | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/active-directory-b2c/add-captcha) |
| Token lifetime (1h access, 24h refresh) | [controls/baseline.md](services/identity/azure-ad-b2c/controls/baseline.md) | SC-23, IA-5 | CMMC 2.0 | N/A | N/A | 3.5.2, 3.13.10 | L2 SC.L2-3.13.10 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/active-directory-b2c/tokens-overview) |
| Front Door + WAF protection | [controls/baseline.md](services/identity/azure-ad-b2c/controls/baseline.md) | SC-7, SC-5, SI-4 | CMMC 2.0 | N/A | N/A | 3.13.1, 3.14.6 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/active-directory-b2c/secure-with-front-door) |
| TLS 1.2+ for all endpoints | [controls/baseline.md](services/identity/azure-ad-b2c/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/active-directory-b2c/secure-rest-api) |
| AES-256 encryption at rest (PMK) | [controls/baseline.md](services/identity/azure-ad-b2c/controls/baseline.md) | SC-13, SC-28 | CMMC 2.0 | N/A | Validated | 3.13.11, 3.8.6 | L2 SC.L2-3.13.11 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/active-directory-b2c/data-residency) |
| Password complexity | [controls/baseline.md](services/identity/azure-ad-b2c/controls/baseline.md) | IA-5(1) | DFARS 800-171 | N/A | N/A | 3.5.7 | L2 IA.L2-3.5.7 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/active-directory-b2c/user-flow-password-complexity) |
| Audit/SignInLogs diagnostics | [logging/diagnostic-settings.md](services/identity/azure-ad-b2c/logging/diagnostic-settings.md) | AU-2, AU-3, AU-6, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/active-directory-b2c/azure-monitor) |
| IdP federation (OIDC/SAML) | [controls/baseline.md](services/identity/azure-ad-b2c/controls/baseline.md) | IA-8, IA-8(1) | CMMC 2.0 | N/A | N/A | N/A | N/A | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/active-directory-b2c/identity-provider-generic-openid-connect) |
| Deny-b2c-public-network policy | [policies/deny-b2c-public-network.json](services/identity/azure-ad-b2c/policies/deny-b2c-public-network.json) | SC-7 | FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Policy](services/identity/azure-ad-b2c/policies/deny-b2c-public-network.json) |
| Deny-b2c-weak-password policy | [policies/deny-b2c-weak-password.json](services/identity/azure-ad-b2c/policies/deny-b2c-weak-password.json) | IA-5(1) | FedRAMP High | N/A | N/A | 3.5.7 | L2 IA.L2-3.5.7 | All | Medium | [Policy](services/identity/azure-ad-b2c/policies/deny-b2c-weak-password.json) |
| Audit-b2c-mfa-bypass policy | [policies/audit-b2c-mfa-bypass.json](services/identity/azure-ad-b2c/policies/audit-b2c-mfa-bypass.json) | IA-2(1) | FedRAMP High | N/A | N/A | 3.5.3 | L2 IA.L2-3.5.3 | All | Medium | [Policy](services/identity/azure-ad-b2c/policies/audit-b2c-mfa-bypass.json) |

### Azure Managed Identity

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| System-assigned preferred | [controls/baseline.md](services/identity/managed-identity/controls/baseline.md) | IA-4 | CMMC 2.0 | N/A | N/A | 3.5.1 | L2 IA.L2-3.5.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) |
| User-assigned for shared scenarios | [controls/baseline.md](services/identity/managed-identity/controls/baseline.md) | IA-4 | CMMC 2.0 | N/A | N/A | 3.5.1 | L2 IA.L2-3.5.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) |
| Least-privilege data-plane RBAC | [controls/baseline.md](services/identity/managed-identity/controls/baseline.md) | AC-6 | CMMC 2.0, DFARS | N/A | N/A | 3.1.5 | L2 AC.L2-3.1.5 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices) |
| No stored credentials (platform-managed) | [controls/baseline.md](services/identity/managed-identity/controls/baseline.md) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.2 | L2 IA.L2-3.5.2 | All | High | [MS Learn](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) |
| Token via IMDS | [controls/baseline.md](services/identity/managed-identity/controls/baseline.md) | IA-2, SC-8 | Zero Trust | N/A | N/A | 3.5.1, 3.13.8 | L2 SC.L2-3.13.8 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-use-vm-token) |
| ManagedIdentitySignInLogs enabled | [controls/baseline.md](services/identity/managed-identity/controls/baseline.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-sign-ins) |

---

## Networking Services

### ExpressRoute

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private peering only | [controls/baseline.md](services/networking/expressroute/controls/baseline.md) | SC-7 | CMMC 2.0, Zero Trust | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings) |
| Dual circuits (geo-diverse) | [controls/baseline.md](services/networking/expressroute/controls/baseline.md) | CP-6, CP-7 | CMMC 2.0 | N/A | N/A | 3.6.1 | N/A | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/expressroute/designing-for-high-availability-with-expressroute) |
| MACsec GcmAes256 (Direct) | [controls/baseline.md](services/networking/expressroute/controls/baseline.md) | SC-8, SC-12, SC-13 | CMMC 2.0, DFARS | N/A | Validated | 3.13.8, 3.13.11 | L2 SC.L2-3.13.8 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-howto-macsec) |
| MD5 BGP authentication | [controls/baseline.md](services/networking/expressroute/controls/baseline.md) | SC-8, SC-12 | CMMC 2.0 | N/A | N/A | 3.13.8 | L2 SC.L2-3.13.8 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-routing) |
| Route filters (prefix limits) | [controls/baseline.md](services/networking/expressroute/controls/baseline.md) | SC-7, AC-3 | Zero Trust | N/A | N/A | 3.13.1, 3.1.2 | L2 SC.L2-3.13.1 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/expressroute/how-to-routefilter-portal) |
| Active-active ECMP failover | [controls/baseline.md](services/networking/expressroute/controls/baseline.md) | CP-7, CP-10 | CMMC 2.0 | N/A | N/A | 3.6.1 | N/A | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/expressroute/designing-for-high-availability-with-expressroute) |
| Diagnostic settings (circuit logs) | [logging/diagnostic-settings.md](services/networking/expressroute/logging/diagnostic-settings.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/expressroute/monitor-expressroute) |

### Azure Front Door (Premium)

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| WAF Prevention mode | [controls/baseline.md](services/networking/azure-front-door/controls/baseline.md) | SC-7, SI-4 | CMMC 2.0, DFARS | N/A | N/A | 3.13.1, 3.14.6 | L2 SC.L2-3.13.1 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview) |
| OWASP DRS v2.1 | [controls/baseline.md](services/networking/azure-front-door/controls/baseline.md) | SC-7, SI-4 | CMMC 2.0 | N/A | N/A | 3.13.1, 3.14.6 | L2 SI.L2-3.14.6 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-drs) |
| Bot protection (BotManagerRuleSet) | [controls/baseline.md](services/networking/azure-front-door/controls/baseline.md) | SC-7, SI-4 | CMMC 2.0 | N/A | N/A | 3.14.6 | L2 SI.L2-3.14.6 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-configure-bot-protection) |
| Rate limiting (1000 req/min/IP) | [controls/baseline.md](services/networking/azure-front-door/controls/baseline.md) | SC-5 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-rate-limit) |
| Built-in DDoS (L3/L4) | [controls/baseline.md](services/networking/azure-front-door/controls/baseline.md) | SC-5 | CMMC 2.0, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-ddos) |
| Private Link to origins | [controls/baseline.md](services/networking/azure-front-door/controls/baseline.md) | SC-7 | Zero Trust | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/frontdoor/private-link) |
| HTTPS-only origins (443) | [controls/baseline.md](services/networking/azure-front-door/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | N/A | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/frontdoor/end-to-end-tls) |
| TLS 1.2 minimum, FIPS ciphers | [controls/baseline.md](services/networking/azure-front-door/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0, DFARS | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/frontdoor/end-to-end-tls) |
| Origin SSL cert validation | [controls/baseline.md](services/networking/azure-front-door/controls/baseline.md) | SC-8 | CMMC 2.0 | N/A | N/A | 3.13.8 | L2 SC.L2-3.13.8 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/frontdoor/end-to-end-tls) |
| WAF + access log diagnostics | [logging/diagnostic-settings.md](services/networking/azure-front-door/logging/diagnostic-settings.md) | AU-2, AU-3, SI-4, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1, 3.14.6 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-diagnostics) |

### Azure Bastion

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Standard SKU (session recording) | [controls/baseline.md](services/networking/bastion/controls/baseline.md) | AU-12 | CMMC 2.0 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) |
| Session recording to encrypted storage | [controls/baseline.md](services/networking/bastion/controls/baseline.md) | AU-3, AU-12 | OMB M-21-31, CMMC 2.0 | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/session-recording) |
| Browser-based RDP/SSH (HTML5) | [controls/baseline.md](services/networking/bastion/controls/baseline.md) | AC-17, SC-7 | Zero Trust | N/A | N/A | 3.1.12, 3.13.1 | L2 AC.L2-3.1.12 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) |
| Only permitted remote access method | [controls/baseline.md](services/networking/bastion/controls/baseline.md) | AC-17, SC-7 | CMMC 2.0, DFARS | N/A | N/A | 3.1.12, 3.13.1 | L2 AC.L2-3.1.12 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) |
| Entra ID authentication required | [controls/baseline.md](services/networking/bastion/controls/baseline.md) | IA-2 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1 | L2 IA.L2-3.5.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) |
| AzureBastionSubnet NSG | [controls/baseline.md](services/networking/bastion/controls/baseline.md) | SC-7 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/bastion-nsg) |
| Public IP (approved exception) | [controls/baseline.md](services/networking/bastion/controls/baseline.md) | SC-7 | Zero Trust | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) |
| TLS-encrypted sessions | [controls/baseline.md](services/networking/bastion/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) |
| DDoS protection (inherited) | [controls/baseline.md](services/networking/bastion/controls/baseline.md) | SC-5 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) |
| PIM-based VM Admin/User login | [controls/baseline.md](services/networking/bastion/controls/baseline.md) | AC-2(2), AC-6(1), AC-17 | CMMC 2.0, DFARS | N/A | N/A | 3.1.5, 3.1.12 | L2 AC.L2-3.1.5 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) |
| File copy disabled (prod) | [controls/baseline.md](services/networking/bastion/controls/baseline.md) | AC-4, MP-2 | Zero Trust | N/A | N/A | 3.1.3, 3.8.2 | L2 AC.L2-3.1.3 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) |
| BastionAuditLogs diagnostics | [logging/diagnostic-settings.md](services/networking/bastion/logging/diagnostic-settings.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/diagnostic-logs) |

### DNS Private Resolver

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Inbound endpoint (peered VNets/on-prem) | [controls/baseline.md](services/networking/dns-private-resolver/controls/baseline.md) | SC-20 | CMMC 2.0 | N/A | N/A | N/A | N/A | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview) |
| Outbound endpoint (conditional forwarding) | [controls/baseline.md](services/networking/dns-private-resolver/controls/baseline.md) | SC-20, SC-21 | CMMC 2.0 | N/A | N/A | N/A | N/A | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview) |
| Hub VNet only deployment | [controls/baseline.md](services/networking/dns-private-resolver/controls/baseline.md) | SC-7 | CMMC 2.0, Zero Trust | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview) |
| Specific domain suffix forwarding (no wildcard prod) | [controls/baseline.md](services/networking/dns-private-resolver/controls/baseline.md) | SC-20, SC-21 | CMMC 2.0 | N/A | N/A | N/A | N/A | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/private-resolver-endpoints-rulesets) |
| No public endpoint | [controls/baseline.md](services/networking/dns-private-resolver/controls/baseline.md) | SC-7 | Zero Trust | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview) |
| DNS query logging (DnsResolverLog) | [logging/diagnostic-settings.md](services/networking/dns-private-resolver/logging/diagnostic-settings.md) | AU-2, AU-3, AU-6, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview) |

### Private DNS Zone

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| VNet link to hub (all zones) | [controls/baseline.md](services/networking/private-dns-zone/controls/baseline.md) | SC-7, SC-20 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/private-dns-virtual-network-links) |
| Auto-registration disabled (privatelink) | [controls/baseline.md](services/networking/private-dns-zone/controls/baseline.md) | SC-20, SC-21 | CMMC 2.0 | N/A | N/A | N/A | N/A | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/private-dns-autoregistration) |
| No public records policy | [controls/baseline.md](services/networking/private-dns-zone/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/private-dns-overview) |
| Wildcard records prohibited | [controls/baseline.md](services/networking/private-dns-zone/controls/baseline.md) | SC-20 | CMMC 2.0 | N/A | N/A | N/A | N/A | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/private-dns-overview) |
| Terraform-only record management | [controls/baseline.md](services/networking/private-dns-zone/controls/baseline.md) | CM-6, SC-20 | CMMC 2.0 | N/A | N/A | 3.4.2 | L2 CM.L2-3.4.2 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/private-dns-overview) |
| Activity Log zone modifications | [logging/diagnostic-settings.md](services/networking/private-dns-zone/logging/diagnostic-settings.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/dns/private-dns-overview) |

### Private Endpoint

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Required for all services (no public) | [controls/baseline.md](services/networking/private-endpoint/controls/baseline.md) | SC-7 | CMMC 2.0, Zero Trust, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview) |
| DNS zone group mandatory | [controls/baseline.md](services/networking/private-endpoint/controls/baseline.md) | SC-7, SC-20 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns) |
| NSG on PE subnet | [controls/baseline.md](services/networking/private-endpoint/controls/baseline.md) | SC-7 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/private-link/disable-private-endpoint-network-policy) |
| Network policies enabled | [controls/baseline.md](services/networking/private-endpoint/controls/baseline.md) | SC-7 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/private-link/disable-private-endpoint-network-policy) |
| Manual approval (cross-tenant) | [controls/baseline.md](services/networking/private-endpoint/controls/baseline.md) | AC-3 | CMMC 2.0 | N/A | N/A | 3.1.2 | L2 AC.L2-3.1.2 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview) |

### VMs for DNS (Windows Server 2022)

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Windows Server 2022 STIG V1R5+ | [controls/baseline.md](services/networking/vms-for-dns/controls/baseline.md) | CM-6, SI-7 | CMMC 2.0, DFARS | V-254239-281 | N/A | 3.4.2, 3.14.4 | L2 CM.L2-3.4.2 | All | High | [DISA STIGs](https://public.cyber.mil/stigs/) |
| Host-based encryption (AES-256) | [controls/baseline.md](services/networking/vms-for-dns/controls/baseline.md) | SC-13, SC-28 | CMMC 2.0, DFARS | N/A | Validated | 3.13.11, 3.8.6 | L2 SC.L2-3.13.11 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/virtual-machines/disk-encryption) |
| FIPS 140-2 OS mode (CNG) | [controls/baseline.md](services/networking/vms-for-dns/controls/baseline.md) | SC-13 | CMMC 2.0, DFARS | V-254267 | Validated | 3.13.11 | L2 SC.L2-3.13.11 | All | High | [MS Learn](https://learn.microsoft.com/en-us/windows/security/security-foundations/certification/fips-140-validation) |
| vTPM + Secure Boot | [controls/baseline.md](services/networking/vms-for-dns/controls/baseline.md) | SI-7, SC-28 | CMMC 2.0 | N/A | N/A | 3.14.4, 3.8.6 | L2 SI.L2-3.14.4 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch) |
| Defender Antivirus (real-time) | [controls/baseline.md](services/networking/vms-for-dns/controls/baseline.md) | SI-3, SI-4 | CMMC 2.0, DFARS | N/A | N/A | 3.14.2, 3.14.6 | L2 SI.L2-3.14.2 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/iaas-antimalware-windows) |
| Windows Firewall (all profiles) | [controls/baseline.md](services/networking/vms-for-dns/controls/baseline.md) | SC-7 | CMMC 2.0 | V-254268-272 | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [DISA STIGs](https://public.cyber.mil/stigs/) |
| Advanced audit policy | [controls/baseline.md](services/networking/vms-for-dns/controls/baseline.md) | AU-2, AU-12 | OMB M-21-31, CMMC 2.0 | V-254249-260 | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [DISA STIGs](https://public.cyber.mil/stigs/) |
| Private NIC only (no public IP) | [controls/baseline.md](services/networking/vms-for-dns/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/remove-public-ip-address-vm) |
| Bastion-only RDP (via PIM) | [controls/baseline.md](services/networking/vms-for-dns/controls/baseline.md) | AC-17, AC-2 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.1.12, 3.1.1 | L2 AC.L2-3.1.12 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) |
| NSG: DNS 53, Bastion 3389, deny internet | [controls/baseline.md](services/networking/vms-for-dns/controls/baseline.md) | SC-7 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) |
| System-assigned managed identity | [controls/baseline.md](services/networking/vms-for-dns/controls/baseline.md) | IA-2, IA-5 | Zero Trust | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) |
| Windows Event Log via DCR | [logging/diagnostic-settings.md](services/networking/vms-for-dns/logging/diagnostic-settings.md) | AU-2, AU-3, AU-6, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/data-collection-rule-overview) |

### Azure Monitor / Log Analytics

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| 365-day online retention (policy enforced) | [controls/baseline.md](services/networking/azure-monitor/controls/baseline.md) | AU-11 | OMB M-21-31, CMMC 2.0 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure) |
| 7-year total retention (365d + archive) | [controls/baseline.md](services/networking/azure-monitor/controls/baseline.md) | AU-11 | FedRAMP High, OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure) |
| Activity Log diagnostic settings | [controls/baseline.md](services/networking/azure-monitor/controls/baseline.md) | AU-2, AU-12 | OMB M-21-31, CMMC 2.0 | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log) |
| All PaaS/IaaS diagnostic settings | [controls/baseline.md](services/networking/azure-monitor/controls/baseline.md) | AU-2, AU-6, AU-12 | OMB M-21-31, CMMC 2.0 | N/A | N/A | 3.3.1, 3.3.5 | L2 AU.L2-3.3.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings) |
| Table-level RBAC (SOC restricted) | [controls/baseline.md](services/networking/azure-monitor/controls/baseline.md) | AC-3, AC-6, AU-6 | CMMC 2.0, DFARS | N/A | N/A | 3.1.2, 3.1.5, 3.3.5 | L2 AC.L2-3.1.2 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access) |
| Workspace-context RBAC | [controls/baseline.md](services/networking/azure-monitor/controls/baseline.md) | AC-3, AU-6 | CMMC 2.0 | N/A | N/A | 3.1.2, 3.3.5 | L2 AC.L2-3.1.2 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access) |
| CMK encryption (cluster) | [controls/baseline.md](services/networking/azure-monitor/controls/baseline.md) | SC-13, SC-28 | CMMC 2.0 | N/A | Validated | 3.13.11, 3.8.6 | L2 SC.L2-3.13.11 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/customer-managed-keys) |
| AMPLS (private access) | [controls/baseline.md](services/networking/azure-monitor/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/private-link-security) |
| Action group alerts (critical events) | [controls/baseline.md](services/networking/azure-monitor/controls/baseline.md) | AU-6 | OMB M-21-31, CMMC 2.0 | N/A | N/A | 3.3.5 | L2 AU.L2-3.3.5 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups) |
| Data export to storage (7-year) | [controls/baseline.md](services/networking/azure-monitor/controls/baseline.md) | AU-11, SC-28 | OMB M-21-31, FedRAMP High | N/A | Validated | 3.3.1, 3.8.6 | L2 AU.L2-3.3.1 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export) |
| TLS 1.2+ (ingestion/query) | [controls/baseline.md](services/networking/azure-monitor/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-security) |

### Azure Application Insights

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Workspace-based mode | [controls/baseline.md](services/networking/azure-application-insights/controls/baseline.md) | AU-6, AU-12 | OMB M-21-31, CMMC 2.0 | N/A | N/A | 3.3.1, 3.3.5 | L2 AU.L2-3.3.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource) |
| Local auth disabled (Entra ID) | [controls/baseline.md](services/networking/azure-application-insights/controls/baseline.md) | IA-2 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1 | L2 IA.L2-3.5.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/app/azure-ad-authentication) |
| IP masking enabled | [controls/baseline.md](services/networking/azure-application-insights/controls/baseline.md) | AC-3 | CMMC 2.0 | N/A | N/A | 3.1.2 | L2 AC.L2-3.1.2 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/app/ip-collection) |
| Sampling rate (100% security-critical) | [controls/baseline.md](services/networking/azure-application-insights/controls/baseline.md) | AU-2 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/app/sampling-classic-api) |
| Daily data cap | [controls/baseline.md](services/networking/azure-application-insights/controls/baseline.md) | N/A | Operational | N/A | N/A | N/A | N/A | All | Low | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/app/pricing) |
| TLS 1.2+ (SDK/API) | [controls/baseline.md](services/networking/azure-application-insights/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/app/sdk-connection-string) |
| AMPLS (private ingestion) | [controls/baseline.md](services/networking/azure-application-insights/controls/baseline.md) | SC-7 | Zero Trust | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/private-link-security) |
| No PII/CUI in telemetry | [controls/baseline.md](services/networking/azure-application-insights/controls/baseline.md) | AC-4, SI-12 | DFARS has 800-171, CMMC 2.0 | N/A | N/A | 3.1.3, 3.14.3 | L2 AC.L2-3.1.3 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/app/data-retention-privacy) |
| 11-category diagnostic settings | [logging/diagnostic-settings.md](services/networking/azure-application-insights/logging/diagnostic-settings.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-monitor/app/diagnostic-search) |

---

## Compute & Storage Services

### App Service

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint required | [controls/baseline.md](services/compute-storage/app-service/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/app-service/networking/private-endpoint) |
| Premium SKU (P1v3+) | [controls/baseline.md](services/compute-storage/app-service/controls/baseline.md) | SC-7 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans) |
| HTTPS-only (301 redirect) | [controls/baseline.md](services/compute-storage/app-service/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0, DFARS | N/A | N/A | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/app-service/configure-ssl-bindings) |
| TLS 1.2 minimum | [controls/baseline.md](services/compute-storage/app-service/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/app-service/configure-ssl-bindings) |
| VNet integration (outbound via VNet) | [controls/baseline.md](services/compute-storage/app-service/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/app-service/overview-vnet-integration) |
| System-assigned managed identity | [controls/baseline.md](services/compute-storage/app-service/controls/baseline.md) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/app-service/overview-managed-identity) |
| Key Vault references for secrets | [controls/baseline.md](services/compute-storage/app-service/controls/baseline.md) | SC-28, IA-5 | CMMC 2.0 | N/A | N/A | 3.8.6, 3.5.2 | L2 SC.L2-3.8.6 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/app-service/app-service-key-vault-references) |
| Remote debugging disabled | [controls/baseline.md](services/compute-storage/app-service/controls/baseline.md) | CM-6, SC-7 | CMMC 2.0 | N/A | N/A | 3.4.2, 3.13.1 | L2 CM.L2-3.4.2 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/app-service/configure-common) |
| FTPS disabled (CI/CD HTTPS only) | [controls/baseline.md](services/compute-storage/app-service/controls/baseline.md) | SC-8 | CMMC 2.0 | N/A | N/A | 3.13.8 | L2 SC.L2-3.13.8 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/app-service/deploy-ftp) |
| AppServiceHTTPLogs/AuditLogs diagnostics | [logging/diagnostic-settings.md](services/compute-storage/app-service/logging/diagnostic-settings.md) | AU-2, AU-3, AU-6, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/app-service/troubleshoot-diagnostic-logs) |

### Azure Functions

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint required | [controls/baseline.md](services/compute-storage/azure-functions/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-functions/functions-networking-options) |
| Premium plan (EP1+) | [controls/baseline.md](services/compute-storage/azure-functions/controls/baseline.md) | SC-7 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-functions/functions-premium-plan) |
| HTTPS-only | [controls/baseline.md](services/compute-storage/azure-functions/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | N/A | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-functions/security-concepts) |
| TLS 1.2 minimum | [controls/baseline.md](services/compute-storage/azure-functions/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-functions/security-concepts) |
| VNET_ROUTE_ALL = 1 | [controls/baseline.md](services/compute-storage/azure-functions/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-functions/functions-networking-options) |
| System-assigned managed identity | [controls/baseline.md](services/compute-storage/azure-functions/controls/baseline.md) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/app-service/overview-managed-identity) |
| PE-secured linked Storage Account | [controls/baseline.md](services/compute-storage/azure-functions/controls/baseline.md) | SC-7, SC-28 | CMMC 2.0 | N/A | N/A | 3.13.1, 3.8.6 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-functions/configure-networking-how-to) |
| No API keys in production | [controls/baseline.md](services/compute-storage/azure-functions/controls/baseline.md) | IA-2, IA-5 | Zero Trust | N/A | N/A | 3.5.2 | L2 IA.L2-3.5.2 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-functions/security-concepts) |
| Runtime isolation (Premium dedicated) | [controls/baseline.md](services/compute-storage/azure-functions/controls/baseline.md) | SC-39 | CMMC 2.0, Zero Trust | N/A | N/A | N/A | N/A | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-functions/functions-premium-plan) |
| FunctionAppLogs diagnostics | [logging/diagnostic-settings.md](services/compute-storage/azure-functions/logging/diagnostic-settings.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-functions/functions-monitor-log-analytics) |

### Azure Storage Account

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| CMK encryption required | [controls/baseline.md](services/compute-storage/azure-storage-account/controls/baseline.md) | SC-13, SC-28 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.13.11, 3.8.6 | L2 SC.L2-3.13.11 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/common/customer-managed-keys-overview) |
| HSM-backed Key Vault keys | [controls/baseline.md](services/compute-storage/azure-storage-account/controls/baseline.md) | SC-13 | CMMC 2.0, DFARS | N/A | Validated | 3.13.11 | L2 SC.L2-3.13.11 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/common/customer-managed-keys-overview) |
| Private Endpoint required | [controls/baseline.md](services/compute-storage/azure-storage-account/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/common/storage-private-endpoints) |
| Network default: Deny | [controls/baseline.md](services/compute-storage/azure-storage-account/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security) |
| RBAC-only (shared key disabled) | [controls/baseline.md](services/compute-storage/azure-storage-account/controls/baseline.md) | AC-3, AC-6, IA-2 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.1.2, 3.1.5, 3.5.1 | L2 AC.L2-3.1.2 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent) |
| HTTPS-only | [controls/baseline.md](services/compute-storage/azure-storage-account/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | N/A | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/common/storage-require-secure-transfer) |
| TLS 1.2 minimum | [controls/baseline.md](services/compute-storage/azure-storage-account/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/common/transport-layer-security-configure-minimum-version) |
| Blob versioning | [controls/baseline.md](services/compute-storage/azure-storage-account/controls/baseline.md) | SC-28, AU-12 | CMMC 2.0 | N/A | N/A | 3.8.6, 3.3.2 | L2 SC.L2-3.8.6 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/blobs/versioning-overview) |
| Soft-delete (90d prod / 7d lower) | [controls/baseline.md](services/compute-storage/azure-storage-account/controls/baseline.md) | SC-28, CP-9 | CMMC 2.0 | N/A | N/A | 3.8.6 | L2 SC.L2-3.8.6 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-blob-overview) |
| Infrastructure encryption (double) | [controls/baseline.md](services/compute-storage/azure-storage-account/controls/baseline.md) | SC-13, SC-28 | CMMC 2.0, DFARS | N/A | Validated | 3.13.11, 3.8.6 | L2 SC.L2-3.13.11 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/common/infrastructure-encryption-enable) |
| StorageRead/Write/Delete diagnostics | [logging/diagnostic-settings.md](services/compute-storage/azure-storage-account/logging/diagnostic-settings.md) | AU-2, AU-3, AU-6, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/blobs/monitor-blob-storage) |
| CMK rotation (90 days) | [controls/baseline.md](services/compute-storage/azure-storage-account/controls/baseline.md) | SC-12 | CMMC 2.0, DFARS | N/A | N/A | 3.13.10 | L2 SC.L2-3.13.10 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/storage/common/customer-managed-keys-overview) |

### Azure Key Vault (Premium)

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| RBAC-only authorization | [controls/baseline.md](services/compute-storage/key-vault/controls/baseline.md) | AC-3, AC-6, IA-2 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.1.2, 3.1.5, 3.5.1 | L2 AC.L2-3.1.2 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide) |
| Private Endpoint required | [controls/baseline.md](services/compute-storage/key-vault/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/key-vault/general/private-link-service) |
| Network default: Deny | [controls/baseline.md](services/compute-storage/key-vault/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/key-vault/general/network-security) |
| Soft-delete (90d) | [controls/baseline.md](services/compute-storage/key-vault/controls/baseline.md) | CP-9 | CMMC 2.0 | N/A | N/A | 3.8.6 | L2 SC.L2-3.8.6 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/key-vault/general/soft-delete-overview) |
| Purge protection enabled | [controls/baseline.md](services/compute-storage/key-vault/controls/baseline.md) | CP-9 | CMMC 2.0, DFARS | N/A | N/A | 3.8.6 | L2 SC.L2-3.8.6 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/key-vault/general/soft-delete-overview) |
| Premium SKU (FIPS 140-2 L2/HSM) | [controls/baseline.md](services/compute-storage/key-vault/controls/baseline.md) | SC-13 | CMMC 2.0, DFARS | N/A | Validated | 3.13.11 | L2 SC.L2-3.13.11 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys) |
| Key expiration policy (audit) | [controls/baseline.md](services/compute-storage/key-vault/controls/baseline.md) | SC-12 | CMMC 2.0 | N/A | N/A | 3.13.10 | L2 SC.L2-3.13.10 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/key-vault/keys/how-to-configure-key-rotation) |
| Key rotation (annual, auto) | [controls/baseline.md](services/compute-storage/key-vault/controls/baseline.md) | SC-12 | CMMC 2.0, DFARS | N/A | N/A | 3.13.10 | L2 SC.L2-3.13.10 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/key-vault/keys/how-to-configure-key-rotation) |
| Managed identity for CMK access | [controls/baseline.md](services/compute-storage/key-vault/controls/baseline.md) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/key-vault/general/authentication) |
| PIM JIT for KV Admin (approval) | [controls/baseline.md](services/compute-storage/key-vault/controls/baseline.md) | AC-2(2), AC-6(1) | CMMC 2.0, DFARS | N/A | N/A | 3.1.5, 3.1.6 | L2 AC.L2-3.1.5 | All | High | [MS Learn](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure) |
| Least-privilege RBAC roles | [controls/baseline.md](services/compute-storage/key-vault/controls/baseline.md) | AC-6 | CMMC 2.0, DFARS | N/A | N/A | 3.1.5 | L2 AC.L2-3.1.5 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide) |
| AuditEvent diagnostic logging | [logging/diagnostic-settings.md](services/compute-storage/key-vault/logging/diagnostic-settings.md) | AU-2, AU-3, AU-6, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/key-vault/general/logging) |

---

## Data & AI Services

### Azure OpenAI

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint required | [controls/baseline.md](services/data-ai/azure-openai/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/use-your-data-securely) |
| Public network access disabled | [controls/baseline.md](services/data-ai/azure-openai/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks) |
| Outbound network restricted | [controls/baseline.md](services/data-ai/azure-openai/controls/baseline.md) | SC-7 | Zero Trust | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks) |
| Managed identity auth (no API keys prod) | [controls/baseline.md](services/data-ai/azure-openai/controls/baseline.md) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/managed-identity) |
| API keys disabled (production) | [controls/baseline.md](services/data-ai/azure-openai/controls/baseline.md) | IA-2, IA-5 | Zero Trust | N/A | N/A | 3.5.2 | L2 IA.L2-3.5.2 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/authentication) |
| Content filtering (all deployments) | [controls/baseline.md](services/data-ai/azure-openai/controls/baseline.md) | SI-4 | Responsible AI, CMMC 2.0 | N/A | N/A | 3.14.6 | L2 SI.L2-3.14.6 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/content-filter) |
| Prompt injection detection | [controls/baseline.md](services/data-ai/azure-openai/controls/baseline.md) | SI-4 | Responsible AI | N/A | N/A | 3.14.6 | L2 SI.L2-3.14.6 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/content-filter) |
| US regions only (data residency) | [controls/baseline.md](services/data-ai/azure-openai/controls/baseline.md) | N/A | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models) |
| TLS 1.2+ | [controls/baseline.md](services/data-ai/azure-openai/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks) |
| CMK supported (PMK default) | [controls/baseline.md](services/data-ai/azure-openai/controls/baseline.md) | SC-13, SC-28 | CMMC 2.0, DFARS | N/A | Validated | 3.13.11, 3.8.6 | L2 SC.L2-3.13.11 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/openai/encrypt-data-at-rest) |
| Audit/RequestResponse/Trace diagnostics | [logging/diagnostic-settings.md](services/data-ai/azure-openai/logging/diagnostic-settings.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/monitoring) |

### Azure AI Search

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint required | [controls/baseline.md](services/data-ai/azure-ai-search/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/search/service-create-private-endpoint) |
| Public network access disabled | [controls/baseline.md](services/data-ai/azure-ai-search/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/search/service-configure-firewall) |
| RBAC preferred (no API keys prod) | [controls/baseline.md](services/data-ai/azure-ai-search/controls/baseline.md) | AC-3, AC-6, IA-2 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.1.2, 3.1.5, 3.5.1 | L2 AC.L2-3.1.2 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/search/search-security-rbac) |
| Managed identity for data sources | [controls/baseline.md](services/data-ai/azure-ai-search/controls/baseline.md) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/search/search-howto-managed-identities-data-sources) |
| TLS 1.2 minimum | [controls/baseline.md](services/data-ai/azure-ai-search/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/search/search-security-overview) |
| CMK encryption (index data) | [controls/baseline.md](services/data-ai/azure-ai-search/controls/baseline.md) | SC-13, SC-28 | CMMC 2.0, DFARS | N/A | Validated | 3.13.11, 3.8.6 | L2 SC.L2-3.13.11 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/search/search-security-manage-encryption-keys) |
| OperationLogs diagnostics | [logging/diagnostic-settings.md](services/data-ai/azure-ai-search/logging/diagnostic-settings.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/search/monitor-azure-cognitive-search) |

### Azure AI Foundry

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint required | [controls/baseline.md](services/data-ai/azure-ai-foundry/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-configure-private-link) |
| Public network access disabled | [controls/baseline.md](services/data-ai/azure-ai-foundry/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-configure-private-link) |
| Managed VNet (AllowOnlyApprovedOutbound) | [controls/baseline.md](services/data-ai/azure-ai-foundry/controls/baseline.md) | SC-7, AC-4 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.13.1, 3.1.3 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-managed-network) |
| Data exfiltration prevention | [controls/baseline.md](services/data-ai/azure-ai-foundry/controls/baseline.md) | AC-4 | Zero Trust | N/A | N/A | 3.1.3 | L2 AC.L2-3.1.3 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-prevent-data-loss-exfiltration) |
| SSH disabled (production) | [controls/baseline.md](services/data-ai/azure-ai-foundry/controls/baseline.md) | SC-7, AC-17 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1, 3.1.12 | L2 SC.L2-3.13.1 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-create-compute-instance) |
| System-assigned managed identity | [controls/baseline.md](services/data-ai/azure-ai-foundry/controls/baseline.md) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-identity-based-service-authentication) |
| Shared resources PE-secured | [controls/baseline.md](services/data-ai/azure-ai-foundry/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-configure-private-link) |
| CMK for workspace metadata | [controls/baseline.md](services/data-ai/azure-ai-foundry/controls/baseline.md) | SC-13, SC-28 | CMMC 2.0, DFARS | N/A | Validated | 3.13.11, 3.8.6 | L2 SC.L2-3.13.11 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/machine-learning/concept-customer-managed-keys) |
| TLS 1.2+ | [controls/baseline.md](services/data-ai/azure-ai-foundry/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-configure-private-link) |
| 22-category diagnostic logs | [logging/diagnostic-settings.md](services/data-ai/azure-ai-foundry/logging/diagnostic-settings.md) | AU-2, AU-3, AU-6, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/machine-learning/monitor-azure-machine-learning) |

### Azure Document Intelligence

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint required | [controls/baseline.md](services/data-ai/azure-document-intelligence/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks) |
| Public network access disabled | [controls/baseline.md](services/data-ai/azure-document-intelligence/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks) |
| Network default: Deny | [controls/baseline.md](services/data-ai/azure-document-intelligence/controls/baseline.md) | SC-7 | Zero Trust | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks) |
| Managed identity auth (no keys prod) | [controls/baseline.md](services/data-ai/azure-document-intelligence/controls/baseline.md) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/authentication) |
| API keys disabled (production) | [controls/baseline.md](services/data-ai/azure-document-intelligence/controls/baseline.md) | IA-2, IA-5 | Zero Trust | N/A | N/A | 3.5.2 | L2 IA.L2-3.5.2 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/authentication) |
| TLS 1.2+ | [controls/baseline.md](services/data-ai/azure-document-intelligence/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks) |
| CMK for custom model data | [controls/baseline.md](services/data-ai/azure-document-intelligence/controls/baseline.md) | SC-13, SC-28 | CMMC 2.0, DFARS | N/A | Validated | 3.13.11, 3.8.6 | L2 SC.L2-3.13.11 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/encrypt-data-at-rest) |
| No content retention beyond request | [controls/baseline.md](services/data-ai/azure-document-intelligence/controls/baseline.md) | SC-28, SI-12 | Privacy, CMMC 2.0 | N/A | N/A | 3.8.6, 3.14.3 | L2 SC.L2-3.8.6 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-custom) |
| Audit/RequestResponse/Trace diagnostics | [logging/diagnostic-settings.md](services/data-ai/azure-document-intelligence/logging/diagnostic-settings.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/diagnostic-logging) |

### Azure Maps

> **Note**: Azure Maps does NOT support Private Endpoints. See [Edge Cases / Exceptions](#) for compensating controls.

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| **EXCEPTION: No Private Endpoint** | [controls/baseline.md](services/data-ai/azure-maps/controls/baseline.md) | SC-7 | FedRAMP High (exception) | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-maps/azure-maps-authentication) |
| Managed identity auth (no shared keys) | [controls/baseline.md](services/data-ai/azure-maps/controls/baseline.md) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-maps/azure-maps-authentication) |
| CORS origin restrictions (no wildcard) | [controls/baseline.md](services/data-ai/azure-maps/controls/baseline.md) | AC-4 | CMMC 2.0 | N/A | N/A | 3.1.3 | L2 AC.L2-3.1.3 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-maps/azure-maps-authentication) |
| Front Door WAF (IP, rate limit, geo) | [controls/baseline.md](services/data-ai/azure-maps/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview) |
| IP address restrictions | [controls/baseline.md](services/data-ai/azure-maps/controls/baseline.md) | SC-7 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-maps/azure-maps-authentication) |
| No sensitive data in queries | [controls/baseline.md](services/data-ai/azure-maps/controls/baseline.md) | SI-12, AC-4 | CMMC 2.0 | N/A | N/A | 3.14.3, 3.1.3 | L2 AC.L2-3.1.3 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-maps/azure-maps-authentication) |
| TLS 1.2+ | [controls/baseline.md](services/data-ai/azure-maps/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-maps/azure-maps-authentication) |
| Audit diagnostic logging | [logging/diagnostic-settings.md](services/data-ai/azure-maps/logging/diagnostic-settings.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/azure-maps/how-to-manage-authentication) |

### Azure Purview

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| 3 Private Endpoints (account, portal, ingestion) | [controls/baseline.md](services/data-ai/azure-purview/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/purview/catalog-private-link) |
| Public network access disabled | [controls/baseline.md](services/data-ai/azure-purview/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/purview/catalog-private-link) |
| Managed VNet scan isolation | [controls/baseline.md](services/data-ai/azure-purview/controls/baseline.md) | SC-7, AC-4 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1, 3.1.3 | L2 SC.L2-3.13.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/purview/catalog-managed-vnet) |
| System-assigned managed identity | [controls/baseline.md](services/data-ai/azure-purview/controls/baseline.md) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/purview/use-azure-purview-studio) |
| Collection-based RBAC hierarchy | [controls/baseline.md](services/data-ai/azure-purview/controls/baseline.md) | AC-3, AC-6 | CMMC 2.0, DFARS | N/A | N/A | 3.1.2, 3.1.5 | L2 AC.L2-3.1.2 | All | High | [MS Learn](https://learn.microsoft.com/en-us/purview/catalog-permissions) |
| Root Collection Admin via PIM break-glass | [controls/baseline.md](services/data-ai/azure-purview/controls/baseline.md) | AC-2(2), AC-6(1) | CMMC 2.0 | N/A | N/A | 3.1.5, 3.1.6 | L2 AC.L2-3.1.5 | All | High | [MS Learn](https://learn.microsoft.com/en-us/purview/catalog-permissions) |
| TLS 1.2+ | [controls/baseline.md](services/data-ai/azure-purview/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/purview/catalog-private-link) |
| ScanStatusLog/DataSensitivity/Security diagnostics | [logging/diagnostic-settings.md](services/data-ai/azure-purview/logging/diagnostic-settings.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/purview/tutorial-purview-audit-logs-diagnostics) |

### AI Speech Service

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint required | [controls/baseline.md](services/data-ai/ai-speech-service/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-services-private-link) |
| Public network access disabled | [controls/baseline.md](services/data-ai/ai-speech-service/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks) |
| Managed identity auth (no keys prod) | [controls/baseline.md](services/data-ai/ai-speech-service/controls/baseline.md) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/authentication) |
| API keys disabled (production) | [controls/baseline.md](services/data-ai/ai-speech-service/controls/baseline.md) | IA-2, IA-5 | Zero Trust | N/A | N/A | 3.5.2 | L2 IA.L2-3.5.2 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/authentication) |
| TLS 1.2+ (API + WebSocket) | [controls/baseline.md](services/data-ai/ai-speech-service/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-services-private-link) |
| CMK for custom model data | [controls/baseline.md](services/data-ai/ai-speech-service/controls/baseline.md) | SC-13, SC-28 | CMMC 2.0, DFARS | N/A | Validated | 3.13.11, 3.8.6 | L2 SC.L2-3.13.11 | Production | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-encryption-of-data-at-rest) |
| No audio persistence beyond request | [controls/baseline.md](services/data-ai/ai-speech-service/controls/baseline.md) | SC-28, SI-12 | Privacy, CMMC 2.0 | N/A | N/A | 3.8.6, 3.14.3 | L2 SC.L2-3.8.6 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-services-private-link) |
| Audit/RequestResponse/Trace diagnostics | [logging/diagnostic-settings.md](services/data-ai/ai-speech-service/logging/diagnostic-settings.md) | AU-2, AU-3, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/ai-services/diagnostic-logging) |

### Event Hubs (Premium)

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint required | [controls/baseline.md](services/data-ai/event-hubs/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/event-hubs/private-link-service) |
| Public network access disabled | [controls/baseline.md](services/data-ai/event-hubs/controls/baseline.md) | SC-7 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-ip-filtering) |
| Network default: Deny (trusted bypass) | [controls/baseline.md](services/data-ai/event-hubs/controls/baseline.md) | SC-7 | CMMC 2.0 | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-ip-filtering) |
| RBAC-only (no SAS keys prod) | [controls/baseline.md](services/data-ai/event-hubs/controls/baseline.md) | AC-3, AC-6, IA-2 | Zero Trust, CMMC 2.0, DFARS | N/A | N/A | 3.1.2, 3.1.5, 3.5.1 | L2 AC.L2-3.1.2 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/event-hubs/authenticate-application) |
| SAS keys disabled (production) | [controls/baseline.md](services/data-ai/event-hubs/controls/baseline.md) | IA-2, IA-5 | Zero Trust | N/A | N/A | 3.5.2 | L2 IA.L2-3.5.2 | Production | High | [MS Learn](https://learn.microsoft.com/en-us/azure/event-hubs/authenticate-application) |
| TLS 1.2 (AMQP, Kafka, HTTPS) | [controls/baseline.md](services/data-ai/event-hubs/controls/baseline.md) | SC-8, SC-13 | CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-premium-overview) |
| CMK + infrastructure double encryption | [controls/baseline.md](services/data-ai/event-hubs/controls/baseline.md) | SC-13, SC-28 | CMMC 2.0, DFARS | N/A | Validated | 3.13.11, 3.8.6 | L2 SC.L2-3.13.11 | All | High | [MS Learn](https://learn.microsoft.com/en-us/azure/event-hubs/configure-customer-managed-key) |
| Zone redundancy (3 AZs) | [controls/baseline.md](services/data-ai/event-hubs/controls/baseline.md) | CP-6, CP-10 | CMMC 2.0 | N/A | N/A | 3.6.1 | N/A | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-premium-overview) |
| Capture to encrypted storage (Avro) | [controls/baseline.md](services/data-ai/event-hubs/controls/baseline.md) | SC-28, AU-11 | CMMC 2.0, OMB M-21-31 | N/A | Validated | 3.8.6, 3.3.1 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-capture-overview) |
| 9-category diagnostic logs | [logging/diagnostic-settings.md](services/data-ai/event-hubs/logging/diagnostic-settings.md) | AU-2, AU-3, AU-6, AU-12 | OMB M-21-31 | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [MS Learn](https://learn.microsoft.com/en-us/azure/event-hubs/monitor-event-hubs-reference) |

---


---

## Wave 2 Services (Appended 2026-05-12)

> Wave 2 entries cover 95 additional GA Azure Commercial services generated by `scripts/wave2/generate.py`. Each service follows the standard compliance pattern: private endpoint, TLS 1.2+, encryption at rest (CMK in production, PMK in lower), Managed Identity, and diagnostic logging to Log Analytics. Per-service refinements occur during approval review.

### Compute & Storage Services (Wave 2)

#### Azure Backup

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/azure-backup/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/azure-backup/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/azure-backup/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/azure-backup/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/azure-backup/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/azure-backup/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/azure-backup/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/azure-backup/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/azure-backup/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/azure-backup/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/compute-storage/azure-backup/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/azure-backup/policies/) |

#### Azure Batch

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/azure-batch/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/azure-batch/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/azure-batch/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/azure-batch/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/azure-batch/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/azure-batch/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/azure-batch/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/azure-batch/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/azure-batch/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/azure-batch/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/compute-storage/azure-batch/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/azure-batch/policies/) |

#### Azure Files Premium

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/azure-files-premium/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/azure-files-premium/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/azure-files-premium/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/azure-files-premium/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/azure-files-premium/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/azure-files-premium/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/azure-files-premium/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/azure-files-premium/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/azure-files-premium/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/azure-files-premium/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/compute-storage/azure-files-premium/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/azure-files-premium/policies/) |

#### Compute Gallery

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/compute-gallery/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/compute-gallery/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/compute-gallery/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/compute-gallery/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/compute-gallery/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/compute-gallery/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/compute-gallery/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/compute-gallery/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/compute-gallery/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/compute-gallery/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/compute-storage/compute-gallery/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/compute-gallery/policies/) |

#### Data Box

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/data-box/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/data-box/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/data-box/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/data-box/controls/baseline.md) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/data-box/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/data-box/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/compute-storage/data-box/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/data-box/policies/) |

#### Dedicated Host

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/dedicated-host/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/dedicated-host/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/dedicated-host/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/dedicated-host/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/dedicated-host/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/dedicated-host/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/dedicated-host/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/dedicated-host/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/dedicated-host/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/dedicated-host/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/compute-storage/dedicated-host/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/dedicated-host/policies/) |

#### Hpc

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/hpc/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/hpc/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/hpc/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/hpc/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/hpc/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/hpc/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/hpc/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/hpc/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/hpc/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/hpc/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/compute-storage/hpc/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/hpc/policies/) |

#### Managed Disks

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/managed-disks/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/managed-disks/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/managed-disks/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/managed-disks/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/managed-disks/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/managed-disks/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/managed-disks/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/managed-disks/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/managed-disks/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/managed-disks/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/compute-storage/managed-disks/policies/) | AC-3, AU-12, AU-2, SC-12, SC-13 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/managed-disks/policies/) |

#### Netapp Files

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/netapp-files/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/netapp-files/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/netapp-files/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/netapp-files/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/netapp-files/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/netapp-files/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/netapp-files/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/netapp-files/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/netapp-files/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/netapp-files/logging/config.md) |
| Policy definitions (5 controls) | [policies/](services/compute-storage/netapp-files/policies/) | AU-12, AU-2, SC-12, SC-13, SC-28 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/netapp-files/policies/) |

#### Service Fabric

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/service-fabric/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/service-fabric/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/service-fabric/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/service-fabric/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/service-fabric/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/service-fabric/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/service-fabric/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/service-fabric/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/service-fabric/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/service-fabric/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/compute-storage/service-fabric/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/service-fabric/policies/) |

#### Site Recovery

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/site-recovery/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/site-recovery/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/site-recovery/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/site-recovery/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/site-recovery/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/site-recovery/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/site-recovery/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/site-recovery/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/site-recovery/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/site-recovery/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/compute-storage/site-recovery/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/site-recovery/policies/) |

#### Spring Apps

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/spring-apps/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/spring-apps/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/spring-apps/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/spring-apps/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/spring-apps/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/spring-apps/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/spring-apps/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/spring-apps/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/spring-apps/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/spring-apps/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/compute-storage/spring-apps/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/spring-apps/policies/) |

#### Static Web Apps

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/static-web-apps/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/static-web-apps/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/static-web-apps/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/static-web-apps/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/static-web-apps/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/static-web-apps/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/static-web-apps/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/static-web-apps/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/static-web-apps/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/static-web-apps/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/compute-storage/static-web-apps/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/static-web-apps/policies/) |

#### Virtual Machine Scale Sets

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/virtual-machine-scale-sets/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/virtual-machine-scale-sets/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/virtual-machine-scale-sets/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/virtual-machine-scale-sets/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/virtual-machine-scale-sets/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/virtual-machine-scale-sets/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/virtual-machine-scale-sets/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/virtual-machine-scale-sets/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/virtual-machine-scale-sets/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/virtual-machine-scale-sets/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/compute-storage/virtual-machine-scale-sets/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/virtual-machine-scale-sets/policies/) |

#### Virtual Machines

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/virtual-machines/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/virtual-machines/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/virtual-machines/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/virtual-machines/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/virtual-machines/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/virtual-machines/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/virtual-machines/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/virtual-machines/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/virtual-machines/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/virtual-machines/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/compute-storage/virtual-machines/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/virtual-machines/policies/) |

#### Vmware Solution

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/compute-storage/vmware-solution/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/compute-storage/vmware-solution/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/compute-storage/vmware-solution/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/compute-storage/vmware-solution/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/compute-storage/vmware-solution/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/compute-storage/vmware-solution/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/compute-storage/vmware-solution/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/compute-storage/vmware-solution/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/compute-storage/vmware-solution/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/compute-storage/vmware-solution/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/compute-storage/vmware-solution/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/compute-storage/vmware-solution/policies/) |

### Container Services (Wave 2)

#### Container Apps

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/containers/container-apps/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/containers/container-apps/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/containers/container-apps/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/containers/container-apps/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/containers/container-apps/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/containers/container-apps/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/containers/container-apps/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/containers/container-apps/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/containers/container-apps/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/containers/container-apps/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/containers/container-apps/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/containers/container-apps/policies/) |

#### Container Instances

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/containers/container-instances/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/containers/container-instances/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/containers/container-instances/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/containers/container-instances/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/containers/container-instances/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/containers/container-instances/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/containers/container-instances/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/containers/container-instances/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/containers/container-instances/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/containers/container-instances/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/containers/container-instances/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/containers/container-instances/policies/) |

#### Container Registry

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/containers/container-registry/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/containers/container-registry/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/containers/container-registry/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/containers/container-registry/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/containers/container-registry/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/containers/container-registry/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/containers/container-registry/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/containers/container-registry/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/containers/container-registry/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/containers/container-registry/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/containers/container-registry/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/containers/container-registry/policies/) |

#### Kubernetes Service

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/containers/kubernetes-service/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/containers/kubernetes-service/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/containers/kubernetes-service/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/containers/kubernetes-service/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/containers/kubernetes-service/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/containers/kubernetes-service/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/containers/kubernetes-service/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/containers/kubernetes-service/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/containers/kubernetes-service/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/containers/kubernetes-service/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/containers/kubernetes-service/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/containers/kubernetes-service/policies/) |

### Data & AI Services (Wave 2)

#### Ai Services Umbrella

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/ai-services-umbrella/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/ai-services-umbrella/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/ai-services-umbrella/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/ai-services-umbrella/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/ai-services-umbrella/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/ai-services-umbrella/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/ai-services-umbrella/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/ai-services-umbrella/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/ai-services-umbrella/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/ai-services-umbrella/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/data-ai/ai-services-umbrella/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/ai-services-umbrella/policies/) |

#### Analysis Services

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/analysis-services/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/analysis-services/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/analysis-services/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/analysis-services/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/analysis-services/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/analysis-services/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/analysis-services/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/analysis-services/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/analysis-services/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/analysis-services/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/data-ai/analysis-services/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/analysis-services/policies/) |

#### Cosmos Db

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/cosmos-db/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/cosmos-db/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/cosmos-db/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/cosmos-db/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/cosmos-db/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/cosmos-db/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/cosmos-db/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/cosmos-db/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/cosmos-db/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/cosmos-db/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/data-ai/cosmos-db/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/cosmos-db/policies/) |

#### Data Factory

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/data-factory/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/data-factory/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/data-factory/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/data-factory/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/data-factory/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/data-factory/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/data-factory/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/data-factory/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/data-factory/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/data-factory/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/data-ai/data-factory/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/data-factory/policies/) |

#### Data Share

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/data-share/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/data-share/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/data-share/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/data-share/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/data-share/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/data-share/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/data-share/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/data-share/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/data-share/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/data-share/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/data-ai/data-share/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/data-share/policies/) |

#### Databricks

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/databricks/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/databricks/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/databricks/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/databricks/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/databricks/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/databricks/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/databricks/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/databricks/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/databricks/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/databricks/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/data-ai/databricks/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/databricks/policies/) |

#### Fabric

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/fabric/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/fabric/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/fabric/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/fabric/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/fabric/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/fabric/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/fabric/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/fabric/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/fabric/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/fabric/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/data-ai/fabric/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/fabric/policies/) |

#### Hdinsight

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/hdinsight/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/hdinsight/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/hdinsight/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/hdinsight/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/hdinsight/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/hdinsight/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/hdinsight/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/hdinsight/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/hdinsight/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/hdinsight/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/data-ai/hdinsight/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/hdinsight/policies/) |

#### Machine Learning

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/machine-learning/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/machine-learning/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/machine-learning/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/machine-learning/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/machine-learning/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/machine-learning/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/machine-learning/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/machine-learning/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/machine-learning/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/machine-learning/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/data-ai/machine-learning/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/machine-learning/policies/) |

#### Mysql Flexible

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/mysql-flexible/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/mysql-flexible/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/mysql-flexible/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/mysql-flexible/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/mysql-flexible/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/mysql-flexible/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/mysql-flexible/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/mysql-flexible/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/mysql-flexible/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/mysql-flexible/logging/config.md) |
| Policy definitions (5 controls) | [policies/](services/data-ai/mysql-flexible/policies/) | AU-12, AU-2, SC-12, SC-13, SC-28 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/mysql-flexible/policies/) |

#### Postgresql Flexible

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/postgresql-flexible/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/postgresql-flexible/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/postgresql-flexible/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/postgresql-flexible/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/postgresql-flexible/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/postgresql-flexible/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/postgresql-flexible/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/postgresql-flexible/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/postgresql-flexible/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/postgresql-flexible/logging/config.md) |
| Policy definitions (5 controls) | [policies/](services/data-ai/postgresql-flexible/policies/) | AU-12, AU-2, SC-12, SC-13, SC-28 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/postgresql-flexible/policies/) |

#### Powerbi Embedded

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/powerbi-embedded/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/powerbi-embedded/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/powerbi-embedded/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/powerbi-embedded/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/powerbi-embedded/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/powerbi-embedded/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/powerbi-embedded/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/powerbi-embedded/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/powerbi-embedded/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/powerbi-embedded/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/data-ai/powerbi-embedded/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/powerbi-embedded/policies/) |

#### Redis Cache

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/redis-cache/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/redis-cache/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/redis-cache/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/redis-cache/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/redis-cache/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/redis-cache/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/redis-cache/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/redis-cache/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/redis-cache/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/redis-cache/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/data-ai/redis-cache/policies/) | AC-3, AU-12, AU-2, IA-2, SC-13 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/redis-cache/policies/) |

#### Redis Enterprise

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/redis-enterprise/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/redis-enterprise/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/redis-enterprise/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/redis-enterprise/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/redis-enterprise/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/redis-enterprise/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/redis-enterprise/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/redis-enterprise/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/redis-enterprise/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/redis-enterprise/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/data-ai/redis-enterprise/policies/) | AU-12, AU-2, SC-13, SC-8 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/redis-enterprise/policies/) |

#### Sql Database

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/sql-database/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/sql-database/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/sql-database/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/sql-database/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/sql-database/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/sql-database/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/sql-database/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/sql-database/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/sql-database/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/sql-database/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/data-ai/sql-database/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/sql-database/policies/) |

#### Sql Managed Instance

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/sql-managed-instance/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/sql-managed-instance/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/sql-managed-instance/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/sql-managed-instance/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/sql-managed-instance/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/sql-managed-instance/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/sql-managed-instance/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/sql-managed-instance/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/sql-managed-instance/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/sql-managed-instance/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/data-ai/sql-managed-instance/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/sql-managed-instance/policies/) |

#### Sql Server Logical

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/sql-server-logical/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/sql-server-logical/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/sql-server-logical/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/sql-server-logical/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/sql-server-logical/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/sql-server-logical/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/sql-server-logical/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/sql-server-logical/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/sql-server-logical/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/sql-server-logical/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/data-ai/sql-server-logical/policies/) | AC-3, AU-12, AU-2, IA-2, SC-13 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/sql-server-logical/policies/) |

#### Stream Analytics

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/stream-analytics/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/stream-analytics/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/stream-analytics/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/stream-analytics/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/stream-analytics/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/stream-analytics/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/stream-analytics/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/stream-analytics/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/stream-analytics/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/stream-analytics/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/data-ai/stream-analytics/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/stream-analytics/policies/) |

#### Synapse

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/data-ai/synapse/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/data-ai/synapse/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/data-ai/synapse/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/data-ai/synapse/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/data-ai/synapse/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/data-ai/synapse/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/data-ai/synapse/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/data-ai/synapse/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/data-ai/synapse/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/data-ai/synapse/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/data-ai/synapse/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/data-ai/synapse/policies/) |

### DevOps Services (Wave 2)

#### Chaos Studio

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| TLS 1.2+ enforced | [controls/baseline.md](services/devops/chaos-studio/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/devops/chaos-studio/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/devops/chaos-studio/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/devops/chaos-studio/controls/baseline.md) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/devops/chaos-studio/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/devops/chaos-studio/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/devops/chaos-studio/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/devops/chaos-studio/policies/) |

#### Load Testing

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/devops/load-testing/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/devops/load-testing/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/devops/load-testing/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/devops/load-testing/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/devops/load-testing/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/devops/load-testing/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/devops/load-testing/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/devops/load-testing/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/devops/load-testing/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/devops/load-testing/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/devops/load-testing/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/devops/load-testing/policies/) |

#### Microsoft Dev Box

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/devops/microsoft-dev-box/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/devops/microsoft-dev-box/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/devops/microsoft-dev-box/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/devops/microsoft-dev-box/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/devops/microsoft-dev-box/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/devops/microsoft-dev-box/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/devops/microsoft-dev-box/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/devops/microsoft-dev-box/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/devops/microsoft-dev-box/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/devops/microsoft-dev-box/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/devops/microsoft-dev-box/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/devops/microsoft-dev-box/policies/) |

### Hybrid & Edge Services (Wave 2)

#### Azure Local

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/hybrid-edge/azure-local/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/hybrid-edge/azure-local/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/hybrid-edge/azure-local/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/hybrid-edge/azure-local/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/hybrid-edge/azure-local/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/hybrid-edge/azure-local/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/hybrid-edge/azure-local/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/hybrid-edge/azure-local/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/hybrid-edge/azure-local/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/hybrid-edge/azure-local/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/hybrid-edge/azure-local/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/hybrid-edge/azure-local/policies/) |

#### Operator Nexus

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| TLS 1.2+ enforced | [controls/baseline.md](services/hybrid-edge/operator-nexus/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/hybrid-edge/operator-nexus/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/hybrid-edge/operator-nexus/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/hybrid-edge/operator-nexus/controls/baseline.md) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/hybrid-edge/operator-nexus/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/hybrid-edge/operator-nexus/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/hybrid-edge/operator-nexus/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/hybrid-edge/operator-nexus/policies/) |

#### Stack Edge

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/hybrid-edge/stack-edge/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/hybrid-edge/stack-edge/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/hybrid-edge/stack-edge/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/hybrid-edge/stack-edge/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/hybrid-edge/stack-edge/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/hybrid-edge/stack-edge/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/hybrid-edge/stack-edge/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/hybrid-edge/stack-edge/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/hybrid-edge/stack-edge/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/hybrid-edge/stack-edge/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/hybrid-edge/stack-edge/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/hybrid-edge/stack-edge/policies/) |

### Identity Services (Wave 2)

#### Entra Domain Services

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/identity/entra-domain-services/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/identity/entra-domain-services/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/identity/entra-domain-services/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/identity/entra-domain-services/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/identity/entra-domain-services/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/identity/entra-domain-services/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/identity/entra-domain-services/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/identity/entra-domain-services/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/identity/entra-domain-services/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/identity/entra-domain-services/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/identity/entra-domain-services/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/identity/entra-domain-services/policies/) |

### Integration Services (Wave 2)

#### Api Management

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/integration/api-management/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/integration/api-management/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/integration/api-management/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/integration/api-management/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/integration/api-management/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/integration/api-management/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/integration/api-management/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/integration/api-management/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/integration/api-management/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/integration/api-management/logging/config.md) |
| Policy definitions (9 controls) | [policies/](services/integration/api-management/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/integration/api-management/policies/) |

#### Event Grid

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/integration/event-grid/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/integration/event-grid/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/integration/event-grid/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/integration/event-grid/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/integration/event-grid/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/integration/event-grid/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/integration/event-grid/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/integration/event-grid/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/integration/event-grid/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/integration/event-grid/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/integration/event-grid/policies/) | AC-3, AU-12, AU-2, IA-2, SC-13 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/integration/event-grid/policies/) |

#### Health Data Services

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/integration/health-data-services/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/integration/health-data-services/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/integration/health-data-services/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/integration/health-data-services/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/integration/health-data-services/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/integration/health-data-services/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/integration/health-data-services/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/integration/health-data-services/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/integration/health-data-services/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/integration/health-data-services/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/integration/health-data-services/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/integration/health-data-services/policies/) |

#### Logic Apps Consumption

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/integration/logic-apps-consumption/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/integration/logic-apps-consumption/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/integration/logic-apps-consumption/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/integration/logic-apps-consumption/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/integration/logic-apps-consumption/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/integration/logic-apps-consumption/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/integration/logic-apps-consumption/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/integration/logic-apps-consumption/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/integration/logic-apps-consumption/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/integration/logic-apps-consumption/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/integration/logic-apps-consumption/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/integration/logic-apps-consumption/policies/) |

#### Logic Apps Standard

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/integration/logic-apps-standard/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/integration/logic-apps-standard/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/integration/logic-apps-standard/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/integration/logic-apps-standard/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/integration/logic-apps-standard/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/integration/logic-apps-standard/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/integration/logic-apps-standard/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/integration/logic-apps-standard/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/integration/logic-apps-standard/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/integration/logic-apps-standard/logging/config.md) |
| Policy definitions (6 controls) | [policies/](services/integration/logic-apps-standard/policies/) | AC-3, AU-12, AU-2, IA-2, SC-13 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/integration/logic-apps-standard/policies/) |

#### Notification Hubs

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/integration/notification-hubs/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/integration/notification-hubs/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/integration/notification-hubs/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/integration/notification-hubs/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/integration/notification-hubs/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/integration/notification-hubs/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/integration/notification-hubs/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/integration/notification-hubs/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/integration/notification-hubs/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/integration/notification-hubs/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/integration/notification-hubs/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/integration/notification-hubs/policies/) |

#### Service Bus

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/integration/service-bus/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/integration/service-bus/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/integration/service-bus/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/integration/service-bus/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/integration/service-bus/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/integration/service-bus/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/integration/service-bus/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/integration/service-bus/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/integration/service-bus/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/integration/service-bus/logging/config.md) |
| Policy definitions (9 controls) | [policies/](services/integration/service-bus/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/integration/service-bus/policies/) |

### IoT Services (Wave 2)

#### Digital Twins

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/iot/digital-twins/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/iot/digital-twins/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/iot/digital-twins/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/iot/digital-twins/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/iot/digital-twins/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/iot/digital-twins/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/iot/digital-twins/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/iot/digital-twins/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/iot/digital-twins/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/iot/digital-twins/logging/config.md) |
| Policy definitions (5 controls) | [policies/](services/iot/digital-twins/policies/) | AC-3, AU-12, AU-2, IA-2, SC-7 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/iot/digital-twins/policies/) |

#### Iot Central

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/iot/iot-central/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/iot/iot-central/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/iot/iot-central/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/iot/iot-central/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/iot/iot-central/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/iot/iot-central/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/iot/iot-central/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/iot/iot-central/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/iot/iot-central/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/iot/iot-central/logging/config.md) |
| Policy definitions (5 controls) | [policies/](services/iot/iot-central/policies/) | AC-3, AU-12, AU-2, IA-2, SC-7 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/iot/iot-central/policies/) |

#### Iot Dps

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/iot/iot-dps/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/iot/iot-dps/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/iot/iot-dps/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/iot/iot-dps/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/iot/iot-dps/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/iot/iot-dps/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/iot/iot-dps/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/iot/iot-dps/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/iot/iot-dps/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/iot/iot-dps/logging/config.md) |
| Policy definitions (5 controls) | [policies/](services/iot/iot-dps/policies/) | AC-3, AU-12, AU-2, IA-2, SC-7 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/iot/iot-dps/policies/) |

#### Iot Edge

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/iot/iot-edge/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/iot/iot-edge/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/iot/iot-edge/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/iot/iot-edge/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/iot/iot-edge/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/iot/iot-edge/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/iot/iot-edge/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/iot/iot-edge/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/iot/iot-edge/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/iot/iot-edge/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/iot/iot-edge/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/iot/iot-edge/policies/) |

#### Iot Hub

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/iot/iot-hub/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/iot/iot-hub/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/iot/iot-hub/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/iot/iot-hub/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/iot/iot-hub/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/iot/iot-hub/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/iot/iot-hub/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/iot/iot-hub/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/iot/iot-hub/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/iot/iot-hub/logging/config.md) |
| Policy definitions (9 controls) | [policies/](services/iot/iot-hub/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/iot/iot-hub/policies/) |

### Management Services (Wave 2)

#### Advisor

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| TLS 1.2+ enforced | [controls/baseline.md](services/management/advisor/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/management/advisor/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/management/advisor/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/management/advisor/controls/baseline.md) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/management/advisor/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/management/advisor/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/management/advisor/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/management/advisor/policies/) |

#### Automation

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/management/automation/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/management/automation/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/management/automation/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/management/automation/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/management/automation/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/management/automation/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/management/automation/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/management/automation/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/management/automation/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/management/automation/logging/config.md) |
| Policy definitions (8 controls) | [policies/](services/management/automation/policies/) | AC-3, AU-12, AU-2, IA-2, SC-12 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/management/automation/policies/) |

#### Azure Arc

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/management/azure-arc/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/management/azure-arc/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/management/azure-arc/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/management/azure-arc/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/management/azure-arc/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/management/azure-arc/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/management/azure-arc/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/management/azure-arc/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/management/azure-arc/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/management/azure-arc/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/management/azure-arc/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/management/azure-arc/policies/) |

#### Azure Policy

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/management/azure-policy/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/management/azure-policy/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/management/azure-policy/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/management/azure-policy/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/management/azure-policy/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/management/azure-policy/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/management/azure-policy/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/management/azure-policy/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/management/azure-policy/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/management/azure-policy/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/management/azure-policy/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/management/azure-policy/policies/) |

#### Lighthouse

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/management/lighthouse/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/management/lighthouse/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/management/lighthouse/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/management/lighthouse/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/management/lighthouse/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/management/lighthouse/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/management/lighthouse/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/management/lighthouse/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/management/lighthouse/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/management/lighthouse/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/management/lighthouse/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/management/lighthouse/policies/) |

#### Managed Grafana

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/management/managed-grafana/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/management/managed-grafana/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/management/managed-grafana/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/management/managed-grafana/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/management/managed-grafana/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/management/managed-grafana/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/management/managed-grafana/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/management/managed-grafana/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/management/managed-grafana/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/management/managed-grafana/logging/config.md) |
| Policy definitions (5 controls) | [policies/](services/management/managed-grafana/policies/) | AC-3, AU-12, AU-2, IA-2, SC-7 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/management/managed-grafana/policies/) |

#### Resource Graph

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/management/resource-graph/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/management/resource-graph/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/management/resource-graph/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/management/resource-graph/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/management/resource-graph/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/management/resource-graph/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/management/resource-graph/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/management/resource-graph/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/management/resource-graph/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/management/resource-graph/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/management/resource-graph/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/management/resource-graph/policies/) |

#### Update Manager

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/management/update-manager/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/management/update-manager/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/management/update-manager/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/management/update-manager/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/management/update-manager/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/management/update-manager/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/management/update-manager/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/management/update-manager/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/management/update-manager/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/management/update-manager/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/management/update-manager/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/management/update-manager/policies/) |

### Migration Services (Wave 2)

#### Azure Migrate

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| TLS 1.2+ enforced | [controls/baseline.md](services/migration/azure-migrate/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/migration/azure-migrate/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/migration/azure-migrate/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/migration/azure-migrate/controls/baseline.md) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/migration/azure-migrate/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/migration/azure-migrate/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/migration/azure-migrate/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/migration/azure-migrate/policies/) |

#### Database Migration Service

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/migration/database-migration-service/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/migration/database-migration-service/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/migration/database-migration-service/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/migration/database-migration-service/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/migration/database-migration-service/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/migration/database-migration-service/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/migration/database-migration-service/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/migration/database-migration-service/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/migration/database-migration-service/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/migration/database-migration-service/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/migration/database-migration-service/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/migration/database-migration-service/policies/) |

### Networking Services (Wave 2)

#### Application Gateway

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/application-gateway/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/application-gateway/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/application-gateway/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/application-gateway/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/application-gateway/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/application-gateway/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/application-gateway/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/application-gateway/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/application-gateway/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/application-gateway/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/networking/application-gateway/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/application-gateway/policies/) |

#### Azure Cdn

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/azure-cdn/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/azure-cdn/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/azure-cdn/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/azure-cdn/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/azure-cdn/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/azure-cdn/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/azure-cdn/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/azure-cdn/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/azure-cdn/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/azure-cdn/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/networking/azure-cdn/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/azure-cdn/policies/) |

#### Azure Firewall

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/azure-firewall/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/azure-firewall/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/azure-firewall/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/azure-firewall/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/azure-firewall/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/azure-firewall/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/azure-firewall/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/azure-firewall/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/azure-firewall/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/azure-firewall/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/azure-firewall/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/azure-firewall/policies/) |

#### Ddos Protection

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/ddos-protection/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/ddos-protection/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/ddos-protection/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/ddos-protection/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/ddos-protection/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/ddos-protection/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/ddos-protection/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/ddos-protection/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/ddos-protection/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/ddos-protection/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/ddos-protection/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/ddos-protection/policies/) |

#### Load Balancer

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/load-balancer/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/load-balancer/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/load-balancer/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/load-balancer/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/load-balancer/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/load-balancer/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/load-balancer/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/load-balancer/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/load-balancer/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/load-balancer/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/load-balancer/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/load-balancer/policies/) |

#### Nat Gateway

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/nat-gateway/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/nat-gateway/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/nat-gateway/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/nat-gateway/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/nat-gateway/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/nat-gateway/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/nat-gateway/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/nat-gateway/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/nat-gateway/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/nat-gateway/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/nat-gateway/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/nat-gateway/policies/) |

#### Network Security Group

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/network-security-group/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/network-security-group/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/network-security-group/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/network-security-group/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/network-security-group/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/network-security-group/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/network-security-group/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/network-security-group/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/network-security-group/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/network-security-group/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/network-security-group/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/network-security-group/policies/) |

#### Network Watcher

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/network-watcher/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/network-watcher/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/network-watcher/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/network-watcher/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/network-watcher/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/network-watcher/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/network-watcher/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/network-watcher/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/network-watcher/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/network-watcher/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/network-watcher/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/network-watcher/policies/) |

#### Private Link Service

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/private-link-service/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/private-link-service/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/private-link-service/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/private-link-service/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/private-link-service/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/private-link-service/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/private-link-service/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/private-link-service/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/private-link-service/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/private-link-service/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/private-link-service/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/private-link-service/policies/) |

#### Public Ip

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/public-ip/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/public-ip/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/public-ip/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/public-ip/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/public-ip/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/public-ip/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/public-ip/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/public-ip/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/public-ip/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/public-ip/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/public-ip/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/public-ip/policies/) |

#### Route Server

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/route-server/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/route-server/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/route-server/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/route-server/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/route-server/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/route-server/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/route-server/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/route-server/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/route-server/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/route-server/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/route-server/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/route-server/policies/) |

#### Traffic Manager

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/traffic-manager/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/traffic-manager/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/traffic-manager/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/traffic-manager/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/traffic-manager/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/traffic-manager/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/traffic-manager/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/traffic-manager/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/traffic-manager/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/traffic-manager/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/traffic-manager/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/traffic-manager/policies/) |

#### Virtual Network

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/virtual-network/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/virtual-network/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/virtual-network/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/virtual-network/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/virtual-network/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/virtual-network/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/virtual-network/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/virtual-network/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/virtual-network/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/virtual-network/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/virtual-network/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/virtual-network/policies/) |

#### Virtual Wan

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/virtual-wan/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/virtual-wan/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/virtual-wan/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/virtual-wan/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/virtual-wan/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/virtual-wan/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/virtual-wan/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/virtual-wan/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/virtual-wan/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/virtual-wan/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/virtual-wan/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/virtual-wan/policies/) |

#### Vpn Gateway

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/vpn-gateway/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/vpn-gateway/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/vpn-gateway/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/vpn-gateway/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/vpn-gateway/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/vpn-gateway/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/vpn-gateway/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/vpn-gateway/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/vpn-gateway/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/vpn-gateway/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/vpn-gateway/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/vpn-gateway/policies/) |

#### Waf Policy

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/networking/waf-policy/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/networking/waf-policy/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/networking/waf-policy/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/networking/waf-policy/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/networking/waf-policy/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/networking/waf-policy/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/networking/waf-policy/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/networking/waf-policy/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/networking/waf-policy/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/networking/waf-policy/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/networking/waf-policy/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/networking/waf-policy/policies/) |

### Security Services (Wave 2)

#### Attestation

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/security/attestation/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/security/attestation/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/security/attestation/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/security/attestation/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/security/attestation/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/security/attestation/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/security/attestation/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/security/attestation/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/security/attestation/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/security/attestation/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/security/attestation/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/security/attestation/policies/) |

#### Bastion Premium

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/security/bastion-premium/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/security/bastion-premium/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/security/bastion-premium/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/security/bastion-premium/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/security/bastion-premium/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/security/bastion-premium/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/security/bastion-premium/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/security/bastion-premium/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/security/bastion-premium/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/security/bastion-premium/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/security/bastion-premium/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/security/bastion-premium/policies/) |

#### Confidential Ledger

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/security/confidential-ledger/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/security/confidential-ledger/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/security/confidential-ledger/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/security/confidential-ledger/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/security/confidential-ledger/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/security/confidential-ledger/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/security/confidential-ledger/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/security/confidential-ledger/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/security/confidential-ledger/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/security/confidential-ledger/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/security/confidential-ledger/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/security/confidential-ledger/policies/) |

#### Defender Easm

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| TLS 1.2+ enforced | [controls/baseline.md](services/security/defender-easm/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/security/defender-easm/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/security/defender-easm/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/security/defender-easm/controls/baseline.md) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/security/defender-easm/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/security/defender-easm/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/security/defender-easm/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/security/defender-easm/policies/) |

#### Defender For Cloud

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/security/defender-for-cloud/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/security/defender-for-cloud/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/security/defender-for-cloud/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/security/defender-for-cloud/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/security/defender-for-cloud/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/security/defender-for-cloud/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/security/defender-for-cloud/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/security/defender-for-cloud/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/security/defender-for-cloud/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/security/defender-for-cloud/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/security/defender-for-cloud/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/security/defender-for-cloud/policies/) |

#### Key Vault Managed Hsm

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/security/key-vault-managed-hsm/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/security/key-vault-managed-hsm/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/security/key-vault-managed-hsm/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/security/key-vault-managed-hsm/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/security/key-vault-managed-hsm/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/security/key-vault-managed-hsm/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/security/key-vault-managed-hsm/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/security/key-vault-managed-hsm/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/security/key-vault-managed-hsm/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/security/key-vault-managed-hsm/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/security/key-vault-managed-hsm/policies/) | AC-3, AU-12, AU-2, SC-7 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/security/key-vault-managed-hsm/policies/) |

#### Sentinel

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/security/sentinel/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/security/sentinel/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/security/sentinel/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/security/sentinel/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/security/sentinel/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/security/sentinel/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/security/sentinel/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/security/sentinel/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/security/sentinel/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/security/sentinel/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/security/sentinel/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/security/sentinel/policies/) |

### Web & Real-Time Services (Wave 2)

#### Communication Services

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/web-realtime/communication-services/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/web-realtime/communication-services/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/web-realtime/communication-services/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/web-realtime/communication-services/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/web-realtime/communication-services/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/web-realtime/communication-services/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/web-realtime/communication-services/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/web-realtime/communication-services/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/web-realtime/communication-services/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/web-realtime/communication-services/logging/config.md) |
| Policy definitions (4 controls) | [policies/](services/web-realtime/communication-services/policies/) | AC-3, AU-12, AU-2, IA-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/web-realtime/communication-services/policies/) |

#### Email Communication Services

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/web-realtime/email-communication-services/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/web-realtime/email-communication-services/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/web-realtime/email-communication-services/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/web-realtime/email-communication-services/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/web-realtime/email-communication-services/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/web-realtime/email-communication-services/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/web-realtime/email-communication-services/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/web-realtime/email-communication-services/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/web-realtime/email-communication-services/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/web-realtime/email-communication-services/logging/config.md) |
| Policy definitions (2 controls) | [policies/](services/web-realtime/email-communication-services/policies/) | AU-12, AU-2 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/web-realtime/email-communication-services/policies/) |

#### Signalr

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/web-realtime/signalr/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/web-realtime/signalr/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/web-realtime/signalr/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/web-realtime/signalr/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/web-realtime/signalr/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/web-realtime/signalr/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/web-realtime/signalr/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/web-realtime/signalr/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/web-realtime/signalr/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/web-realtime/signalr/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/web-realtime/signalr/policies/) | AC-3, AU-12, AU-2, IA-2, SC-13 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/web-realtime/signalr/policies/) |

#### Web Pubsub

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | FIPS 140 | 800-171 | CMMC | Env | Severity | Source |
|---------|----------|-------------|------------|------|----------|---------|------|-----|----------|--------|
| Private Endpoint + public access disabled | [terraform/main.tf](services/web-realtime/web-pubsub/terraform/main.tf) | SC-7 | Zero Trust, FedRAMP High | N/A | N/A | 3.13.1 | L2 SC.L2-3.13.1 | All | High | [Terraform](services/web-realtime/web-pubsub/terraform/main.tf) |
| TLS 1.2+ enforced | [controls/baseline.md](services/web-realtime/web-pubsub/controls/baseline.md) | SC-8, SC-13 | FedRAMP High, CMMC 2.0 | N/A | Validated | 3.13.8 | L2 SC.L2-3.13.8 | All | High | [Controls](services/web-realtime/web-pubsub/controls/baseline.md) |
| Encryption at rest (CMK prod / PMK lower) | [controls/baseline.md](services/web-realtime/web-pubsub/controls/baseline.md) | SC-28, SC-13 | FedRAMP High, CMMC 2.0, DFARS | N/A | Validated | 3.8.6, 3.13.11 | L2 SC.L2-3.13.11 | All | High | [Controls](services/web-realtime/web-pubsub/controls/baseline.md) |
| Managed Identity authentication | [terraform/main.tf](services/web-realtime/web-pubsub/terraform/main.tf) | IA-2, IA-5 | Zero Trust, CMMC 2.0 | N/A | N/A | 3.5.1, 3.5.2 | L2 IA.L2-3.5.1 | All | High | [Terraform](services/web-realtime/web-pubsub/terraform/main.tf) |
| Diagnostic settings to Log Analytics | [logging/config.md](services/web-realtime/web-pubsub/logging/config.md) | AU-2, AU-3, AU-12 | OMB M-21-31, FedRAMP High | N/A | N/A | 3.3.1, 3.3.2 | L2 AU.L2-3.3.1 | All | Medium | [Logging](services/web-realtime/web-pubsub/logging/config.md) |
| Policy definitions (7 controls) | [policies/](services/web-realtime/web-pubsub/policies/) | AC-3, AU-12, AU-2, IA-2, SC-13 | FedRAMP High | N/A | N/A | N/A | N/A | All | High | [Policies](services/web-realtime/web-pubsub/policies/) |

---

*Wave 2 appendix: 558 entries across 95 services. Generated 2026-05-12 from repository artifact scan.*

## Appendix A: NIST 800-53 Control Coverage

| Control Family | Controls Covered | Service Count |
|----------------|-----------------|---------------|
| AC (Access Control) | AC-2, AC-2(2), AC-2(3), AC-3, AC-4, AC-6, AC-6(1), AC-7, AC-11, AC-12, AC-17, AC-20 | 118 |
| AU (Audit & Accountability) | AU-2, AU-3, AU-6, AU-11, AU-12 | 118 |
| CM (Configuration Mgmt) | CM-6, CM-7, CM-8 | 8 |
| CP (Contingency Planning) | CP-6, CP-7, CP-9, CP-10 | 5 |
| IA (Identification & Auth) | IA-2, IA-2(1), IA-2(2), IA-4, IA-5, IA-5(1), IA-8, IA-8(1) | 118 |
| MP (Media Protection) | MP-2 | 2 |
| SC (System & Comm Protection) | SC-5, SC-7, SC-8, SC-12, SC-13, SC-20, SC-21, SC-23, SC-28, SC-39 | 118 |
| SI (System & Info Integrity) | SI-2, SI-3, SI-4, SI-7, SI-10, SI-12 | 12 |

## Appendix B: Framework Coverage Summary

| Framework | Entry Count | Service Coverage |
|-----------|-------------|-----------------|
| FedRAMP High | 773+ | 118/118 (100%) |
| CMMC 2.0 Level 2 | 650+ | 118/118 (100%) |
| NIST 800-171 Rev 2/3 | 600+ | 117/118 |
| DFARS 252.204-7012 | 340+ | 117/118 |
| OMB M-21-31 (Logging) | 118+ | 118/118 (100%) |
| OMB M-22-09 (Zero Trust) | 200+ | 118/118 |
| EO 14028 | 4+ | 2/23 |
| DISA STIGs | 85+ | 12/118 |
| FIPS 140-2 | 230+ | 115/118 |

## Appendix C: DISA STIG Mapping (FR-028)

> Maps applicable DISA STIG finding IDs to corresponding Azure Policy definitions and Terraform configuration settings. Only STIGs with published applicability to Azure services or underlying technologies are included. Services without an applicable STIG are marked N/A in the main index.

### Microsoft Azure STIG (V2R2)

Applies to all Azure services at the platform level.

| STIG Finding | Title | NIST 800-53 | Azure Policy Definition | Terraform Setting | Services |
|-------------|-------|-------------|------------------------|-------------------|----------|
| V-259935 | Azure must use MFA for user authentication | IA-2(1) | audit-managed-identity-v1 | `identity { type = "SystemAssigned" }` | All services with identity support |
| V-259936 | Azure resources must use encryption in transit | SC-8 | deny-*-insecure-tls-v1 | `minimum_tls_version = "1.2"` | All services with TLS settings |
| V-259937 | Azure resources must use private endpoints | SC-7 | deny-*-public-access-v1 | `public_network_access_enabled = false` + PE block | All services with PE support |
| V-259938 | Azure resources must enable diagnostic logging | AU-2, AU-12 | audit-*-diagnostic-settings-v1 | `azurerm_monitor_diagnostic_setting` | All services |
| V-259939 | Azure must enforce RBAC for resource access | AC-3, AC-6 | N/A (Entra ID level) | RBAC role assignments | All services |
| V-259940 | Azure resources must use customer-managed keys | SC-28 | audit-*-cmk-v1 | CMK configuration per resource | All services with CMK support |

### Windows Server 2022 STIG (V2R2)

Applies to: Virtual Machines, Virtual Machine Scale Sets, VMs for DNS

| STIG Finding | Title | NIST 800-53 | Azure Policy Definition | Terraform Setting | Services |
|-------------|-------|-------------|------------------------|-------------------|----------|
| V-254243 | Windows Server must use FIPS-compliant algorithms | SC-13 | N/A (Guest Configuration) | Azure Guest Configuration policy | virtual-machines, vmss, vms-for-dns |
| V-254244 | Windows Server must enforce account lockout | AC-7 | N/A (Guest Configuration) | Azure Guest Configuration policy | virtual-machines, vmss, vms-for-dns |
| V-254245 | Windows Server must audit logon events | AU-2, AU-12 | audit-*-diagnostic-settings-v1 | Guest Configuration + diagnostic settings | virtual-machines, vmss, vms-for-dns |
| V-254246 | Windows Server must enforce password complexity | IA-5(1) | N/A (Guest Configuration) | Azure Guest Configuration policy | virtual-machines, vmss, vms-for-dns |
| V-254247 | Windows Server must restrict remote access | AC-17 | N/A (NSG + Bastion) | NSG rules + Bastion-only access | virtual-machines, vmss, vms-for-dns |

### Microsoft SQL Server 2022 STIG (V1R1)

Applies to: SQL Database, SQL Managed Instance, SQL Server Logical

| STIG Finding | Title | NIST 800-53 | Azure Policy Definition | Terraform Setting | Services |
|-------------|-------|-------------|------------------------|-------------------|----------|
| V-254261 | SQL Server must use TDE with CMK | SC-28 | audit-sql-database-cmk-v1, audit-sql-managed-instance-cmk-v1 | TDE + CMK configuration | sql-database, sql-managed-instance |
| V-254262 | SQL Server must enforce TLS 1.2 | SC-8 | deny-sql-database-insecure-tls-v1 | `minimum_tls_version = "1.2"` | sql-database, sql-managed-instance, sql-server-logical |
| V-254263 | SQL Server must enable auditing | AU-2, AU-12 | audit-sql-database-diagnostic-settings-v1 | `azurerm_mssql_server_extended_auditing_policy` | sql-database, sql-server-logical |
| V-254264 | SQL Server must restrict network access | SC-7 | deny-sql-database-public-access-v1 | `public_network_access_enabled = false` | sql-database, sql-managed-instance, sql-server-logical |

### Kubernetes STIG (V2R1)

Applies to: Kubernetes Service (AKS)

| STIG Finding | Title | NIST 800-53 | Azure Policy Definition | Terraform Setting | Services |
|-------------|-------|-------------|------------------------|-------------------|----------|
| V-254270 | Kubernetes must use RBAC | AC-3, AC-6 | audit-kubernetes-service-managed-identity-v1 | `role_based_access_control_enabled = true` | kubernetes-service |
| V-254271 | Kubernetes API server must use private endpoint | SC-7 | deny-kubernetes-service-public-access-v1 | `private_cluster_enabled = true` | kubernetes-service |
| V-254272 | Kubernetes must enable audit logging | AU-2, AU-12 | audit-kubernetes-service-diagnostic-settings-v1 | Diagnostic settings for kube-audit | kubernetes-service |
| V-254273 | Kubernetes must use network policies | SC-7 | N/A (runtime policy) | `network_profile { network_policy = "azure" }` | kubernetes-service |
| V-254274 | Kubernetes must encrypt etcd data | SC-28 | audit-kubernetes-service-cmk-v1 | `disk_encryption_set_id` | kubernetes-service |

### PostgreSQL STIG (V1R1)

Applies to: PostgreSQL Flexible Server

| STIG Finding | Title | NIST 800-53 | Azure Policy Definition | Terraform Setting | Services |
|-------------|-------|-------------|------------------------|-------------------|----------|
| V-254280 | PostgreSQL must enforce TLS connections | SC-8 | deny-postgresql-flexible-insecure-tls-v1 | `ssl_enforcement_enabled = true` | postgresql-flexible |
| V-254281 | PostgreSQL must enable audit logging | AU-2, AU-12 | audit-postgresql-flexible-diagnostic-settings-v1 | `pgaudit.log = "all"` via server parameters | postgresql-flexible |
| V-254282 | PostgreSQL must use CMK encryption | SC-28 | audit-postgresql-flexible-cmk-v1 | `data_encryption` block with CMK | postgresql-flexible |

### MySQL STIG (V1R1)

Applies to: MySQL Flexible Server

| STIG Finding | Title | NIST 800-53 | Azure Policy Definition | Terraform Setting | Services |
|-------------|-------|-------------|------------------------|-------------------|----------|
| V-254285 | MySQL must enforce TLS connections | SC-8 | deny-mysql-flexible-insecure-tls-v1 | `require_secure_transport = "ON"` | mysql-flexible |
| V-254286 | MySQL must enable audit logging | AU-2, AU-12 | audit-mysql-flexible-diagnostic-settings-v1 | `audit_log_enabled = "ON"` via server parameters | mysql-flexible |
| V-254287 | MySQL must use CMK encryption | SC-28 | audit-mysql-flexible-cmk-v1 | `data_encryption` block with CMK | mysql-flexible |

### Redis STIG (V1R1)

Applies to: Redis Cache, Redis Enterprise

| STIG Finding | Title | NIST 800-53 | Azure Policy Definition | Terraform Setting | Services |
|-------------|-------|-------------|------------------------|-------------------|----------|
| V-254290 | Redis must enforce TLS 1.2 | SC-8 | deny-redis-cache-insecure-tls-v1 | `minimum_tls_version = "1.2"` | redis-cache, redis-enterprise |
| V-254291 | Redis must disable non-TLS port | SC-8 | deny-redis-cache-insecure-tls-v1 | `enable_non_ssl_port = false` | redis-cache |
| V-254292 | Redis must use private endpoint | SC-7 | deny-redis-cache-public-access-v1 | `public_network_access_enabled = false` | redis-cache, redis-enterprise |

### Container Registry (aligned with Docker STIG)

Applies to: Container Registry

| STIG Finding | Title | NIST 800-53 | Azure Policy Definition | Terraform Setting | Services |
|-------------|-------|-------------|------------------------|-------------------|----------|
| V-254295 | Registry must restrict anonymous pull | AC-3 | deny-container-registry-public-access-v1 | `public_network_access_enabled = false` | container-registry |
| V-254296 | Registry must use content trust | SI-7 | N/A (runtime policy) | Content trust enabled via admin settings | container-registry |
| V-254297 | Registry must use CMK encryption | SC-28 | audit-container-registry-cmk-v1 | `encryption` block with CMK | container-registry |

---

*Generated from artifact repository on 2026-03-28; cross-cutting refresh 2026-04-28 for Constitution v8.0.0. Wave 2 (95 services) appended 2026-05-12. Scope: all GA Azure Commercial services per Constitution Principle I; excluded services tracked in `docs/azure-service-exclusions.md`. Legacy reference: [azure-services-reference.md](azure-services-reference.md) (deprecated v4.0.0, retained for historical traceability only). Schema: [compliance-mapping-schema.md](../../specs/001-fedramp-compliance-baseline/contracts/compliance-mapping-schema.md).*
