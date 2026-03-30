# Compliance Mapping Index

> **Version**: 1.0.0 | **Generated**: 2026-03-27 | **Spec**: [spec.md](specs/001-fedramp-compliance-baseline/spec.md)
> **Schema**: [compliance-mapping-schema.md](specs/001-fedramp-compliance-baseline/contracts/compliance-mapping-schema.md)
>
> This index maps every configuration decision across all 23 Azure services to authoritative compliance frameworks. An auditor can trace any configuration setting to its justification within 2 minutes using this index (SC-009).

---

## Table of Contents

- [Identity Services](#identity-services)
- [Networking Services](#networking-services)
- [Compute & Storage Services](#compute--storage-services)
- [Data & AI Services](#data--ai-services)
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

## Appendix A: NIST 800-53 Control Coverage

| Control Family | Controls Covered | Service Count |
|----------------|-----------------|---------------|
| AC (Access Control) | AC-2, AC-2(2), AC-2(3), AC-3, AC-4, AC-6, AC-6(1), AC-7, AC-11, AC-12, AC-17, AC-20 | 22 |
| AU (Audit & Accountability) | AU-2, AU-3, AU-6, AU-11, AU-12 | 22 |
| CM (Configuration Mgmt) | CM-6, CM-7, CM-8 | 8 |
| CP (Contingency Planning) | CP-6, CP-7, CP-9, CP-10 | 5 |
| IA (Identification & Auth) | IA-2, IA-2(1), IA-2(2), IA-4, IA-5, IA-5(1), IA-8, IA-8(1) | 14 |
| MP (Media Protection) | MP-2 | 2 |
| SC (System & Comm Protection) | SC-5, SC-7, SC-8, SC-12, SC-13, SC-20, SC-21, SC-23, SC-28, SC-39 | 23 |
| SI (System & Info Integrity) | SI-2, SI-3, SI-4, SI-7, SI-10, SI-12 | 12 |

## Appendix B: Framework Coverage Summary

| Framework | Entry Count | Service Coverage |
|-----------|-------------|-----------------|
| FedRAMP High | 215+ | 23/23 (100%) |
| CMMC 2.0 Level 2 | 185+ | 23/23 (100%) |
| NIST 800-171 Rev 2/3 | 145+ | 22/23 |
| DFARS 252.204-7012 | 125+ | 22/23 |
| OMB M-21-31 (Logging) | 23+ | 23/23 (100%) |
| OMB M-22-09 (Zero Trust) | 11+ | 9/23 |
| EO 14028 | 4+ | 2/23 |
| DISA STIGs | 24+ | 4/23 |
| FIPS 140-2 | 40+ | 20/23 |

---

*Generated from artifact repository on 2026-03-28. Cross-referenced against [azure-services-reference.md](.specify/memory/azure-services-reference.md) v1.2.0. Schema: [compliance-mapping-schema.md](specs/001-fedramp-compliance-baseline/contracts/compliance-mapping-schema.md).*
