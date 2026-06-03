# FedRAMP High — Consolidated Policy Initiative Summary

> **Version**: 2.0.0 | **Date**: 2026-05-12 | **FR**: FR-007 | **Services**: 118 (Wave 1: 23, Wave 2: 95)

## Overview

This document consolidates policy initiative coverage across all in-scope Azure services organized by service group. Each service defines a custom Azure Policy initiative containing Deny, Audit, or AuditIfNotExists policy definitions mapped to NIST 800-53 Rev 5 controls.

**Totals**: 117 custom initiatives | 271 custom policy definitions | 13 service groups

> **Note**: This document provides detailed policy tables for the 4 Wave 1 service groups (23 services). For the 9 Wave 2 service groups (95 additional services), see the per-group `policy-initiative-summary.md` files under each `services/<group>/` directory. All 117 initiatives follow the same pattern: Deny for critical controls in production, Audit for lower environments.

---

## Compute & Storage (20 services, 16 Wave 1 policies detailed below)

| Service | Initiative | Scope | Policies | Key Effects |
|---------|-----------|-------|----------|-------------|
| App Service | `appservice-fedramp-high` | App subscription(s) | 4 | Deny (HTTPS, TLS, MI), AuditIfNotExists (diag) |
| Azure Functions | `functions-fedramp-high` | App subscription(s) | 3 | Deny (HTTPS, TLS, MI) |
| Azure Storage Account | `storage-fedramp-high` | Root management group | 5 | Deny (public access, shared key, HTTP, TLS), Audit (CMK) |
| Key Vault | `keyvault-fedramp-high` | Root management group | 4 | Deny (soft-delete, purge protection, RBAC), Audit (key expiration) |

### Policy Details — Compute & Storage

| Service | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
|---------|--------|---------------|----------------|--------------|
| App Service | deny-appservice-https-only-v1 | Deny | Audit | SC-8 |
| App Service | deny-appservice-minimum-tls-v1 | Deny | Deny | SC-8, SC-13 |
| App Service | deny-appservice-managed-identity-v1 | Deny | Audit | IA-2 |
| App Service | audit-appservice-diagnostic-settings-v1 | AuditIfNotExists | AuditIfNotExists | AU-12 |
| Azure Functions | deny-functions-https-only-v1 | Deny | Audit | SC-8 |
| Azure Functions | deny-functions-minimum-tls-v1 | Deny | Deny | SC-8, SC-13 |
| Azure Functions | deny-functions-managed-identity-v1 | Deny | Audit | IA-2 |
| Storage Account | deny-storage-public-access | Deny | Deny | SC-7 |
| Storage Account | deny-storage-shared-key | Deny | Audit | AC-3, IA-2 |
| Storage Account | deny-storage-http | Deny | Deny | SC-8 |
| Storage Account | deny-storage-old-tls | Deny | Deny | SC-8, SC-13 |
| Storage Account | audit-storage-cmk | Audit | Audit | SC-13, SC-28 |
| Key Vault | deny-keyvault-soft-delete | Deny | Deny | CP-9 |
| Key Vault | deny-keyvault-purge-protection | Deny | Deny | CP-9 |
| Key Vault | deny-keyvault-rbac-auth | Deny | Audit | AC-3, AC-6 |
| Key Vault | audit-keyvault-key-expiration | Audit | Audit | SC-12 |

---

## Data & AI (27 services, 21 Wave 1 policies detailed below)

| Service | Initiative | Scope | Policies | Key Effects |
|---------|-----------|-------|----------|-------------|
| Azure OpenAI | `openai-fedramp-high` | AI subscription | 3 | Deny (public access), Audit (MI, content filtering) |
| Azure AI Search | `aisearch-fedramp-high` | AI subscription | 3 | Deny (public access, TLS), Audit (MI) |
| Azure AI Foundry | `aifoundry-fedramp-high` | AI subscription | 3 | Deny (public access), Audit (MI, diag) |
| Document Intelligence | `docintel-fedramp-high` | AI subscription | 2 | Deny (public access), Audit (MI) |
| AI Speech Service | `speech-fedramp-high` | AI subscription | 2 | Deny (public access), Audit (MI) |
| Azure Maps | `maps-fedramp-high` | App subscription | 2 | Audit (MI, CORS) |
| Azure Purview | `purview-fedramp-high` | Governance subscription | 3 | Deny (public access), Audit (MI, diag) |
| Event Hubs | `eventhubs-fedramp-high` | Data subscription | 3 | Deny (public access, TLS), Audit (MI) |

### Policy Details — Data & AI

| Service | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
|---------|--------|---------------|----------------|--------------|
| Azure OpenAI | deny-openai-public-access-v1 | Deny | Audit | SC-7 |
| Azure OpenAI | audit-openai-managed-identity-v1 | Audit | Audit | IA-2 |
| Azure OpenAI | audit-openai-content-filtering-v1 | Audit | Audit | SI-4 |
| AI Search | deny-aisearch-public-access-v1 | Deny | Audit | SC-7 |
| AI Search | deny-aisearch-minimum-tls-v1 | Deny | Deny | SC-8 |
| AI Search | audit-aisearch-managed-identity-v1 | Audit | Audit | IA-2 |
| AI Foundry | deny-aifoundry-public-access-v1 | Deny | Audit | SC-7 |
| AI Foundry | audit-aifoundry-managed-identity-v1 | Audit | Audit | IA-2 |
| AI Foundry | audit-aifoundry-diagnostic-settings-v1 | AuditIfNotExists | AuditIfNotExists | AU-12 |
| Document Intelligence | deny-docintel-public-access-v1 | Deny | Audit | SC-7 |
| Document Intelligence | audit-docintel-managed-identity-v1 | Audit | Audit | IA-2 |
| AI Speech | deny-speech-public-access-v1 | Deny | Audit | SC-7 |
| AI Speech | audit-speech-managed-identity-v1 | Audit | Audit | IA-2 |
| Azure Maps | audit-maps-managed-identity-v1 | Audit | Audit | IA-2 |
| Azure Maps | audit-maps-cors-restrictions-v1 | Audit | Audit | AC-4 |
| Purview | deny-purview-public-access-v1 | Deny | Audit | SC-7 |
| Purview | audit-purview-managed-identity-v1 | Audit | Audit | IA-2 |
| Purview | audit-purview-diagnostic-settings-v1 | AuditIfNotExists | AuditIfNotExists | AU-12 |
| Event Hubs | deny-eventhubs-public-access-v1 | Deny | Audit | SC-7 |
| Event Hubs | deny-eventhubs-minimum-tls-v1 | Deny | Deny | SC-8 |
| Event Hubs | audit-eventhubs-managed-identity-v1 | Audit | Audit | IA-2, AC-3 |

---

## Identity (3 services, 3 Wave 1 policies detailed below)

| Service | Initiative | Scope | Policies | Key Effects |
|---------|-----------|-------|----------|-------------|
| Azure AD B2C | `b2c-fedramp-high-initiative` | B2C subscription | 3 | Audit (token lifetime, custom domain, MFA) |

> **Note**: Managed Identity is a configuration pattern, not a deployable ARM resource — no policy initiative applicable.

### Policy Details — Identity

| Service | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
|---------|--------|---------------|----------------|--------------|
| Azure AD B2C | audit-b2c-token-lifetime-v1 | Audit | Audit | SC-23, IA-5 |
| Azure AD B2C | audit-b2c-custom-domain-v1 | Audit | Audit | IA-8 |
| Azure AD B2C | audit-b2c-mfa-enabled-v1 | Audit | Audit | IA-2(1) |

---

## Networking (25 services, 23 Wave 1 policies detailed below)

| Service | Initiative | Scope | Policies | Key Effects |
|---------|-----------|-------|----------|-------------|
| Azure Front Door | `frontdoor-fedramp-high` | App subscription(s) | 3 | Deny (WAF, TLS), Audit (HTTPS redirect) |
| Azure Monitor | `azure-monitor-fedramp-high` | Root management group | 3 | Deny (retention), Audit (CMK, diag) |
| Bastion | `bastion-fedramp-high` | Hub subscription | 2 | Deny (SKU), AuditIfNotExists (diag) |
| DNS Private Resolver | `dns-resolver-fedramp-high` | Hub subscription | 2 | Audit (VNet link, forwarding rules) |
| ExpressRoute | `expressroute-fedramp-high` | Connectivity subscription | 2 | Audit (encryption, private peering) |
| Private DNS Zone | `private-dns-fedramp-high` | Hub subscription | 2 | Deny (public records), Audit (VNet link) |
| Private Endpoint | `private-endpoint-fedramp-high` | Root management group | 3 | Deny (PE required), Audit (DNS zone group, NSG) |
| VMs for DNS | `vms-dns-fedramp-high` | Hub subscription | 4 | Deny (disk encryption, public IP), Audit (guest config, diag) |
| Application Insights | `appinsights-fedramp-high` | App subscription(s) | 2 | Audit (workspace-based, local auth) |

### Policy Details — Networking

| Service | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
|---------|--------|---------------|----------------|--------------|
| Front Door | deny-frontdoor-waf-enabled-v1 | Deny | Audit | SC-7, SI-4 |
| Front Door | deny-frontdoor-minimum-tls-v1 | Deny | Deny | SC-8, SC-13 |
| Front Door | audit-frontdoor-https-redirect-v1 | Audit | Audit | SC-8 |
| Azure Monitor | deny-loganalytics-retention-minimum-v1 | Deny | Deny | AU-11 |
| Azure Monitor | audit-loganalytics-cmk-encryption-v1 | Audit | Audit | SC-28 |
| Azure Monitor | audit-monitor-diagnostic-settings-v1 | AuditIfNotExists | AuditIfNotExists | AU-12 |
| Bastion | deny-bastion-sku-standard-v1 | Deny | Audit | SC-7 |
| Bastion | audit-bastion-diagnostic-settings-v1 | AuditIfNotExists | AuditIfNotExists | AU-12 |
| DNS Resolver | audit-dnsresolver-vnet-link-v1 | Audit | Audit | SC-7, SC-20 |
| DNS Resolver | audit-dnsresolver-forwarding-rules-v1 | Audit | Audit | SC-20, SC-21 |
| ExpressRoute | audit-expressroute-encryption-enabled-v1 | Audit | Audit | SC-8, SC-13 |
| ExpressRoute | audit-expressroute-private-peering-v1 | Audit | Audit | SC-7 |
| Private DNS Zone | deny-privatednszones-public-records-v1 | Deny | Audit | SC-7 |
| Private DNS Zone | audit-privatednszones-vnet-link-v1 | Audit | Audit | SC-7 |
| Private Endpoint | deny-privateendpoint-required-v1 | Deny | Audit | SC-7 |
| Private Endpoint | audit-privateendpoint-dns-configured-v1 | Audit | Audit | SC-7, SC-20 |
| Private Endpoint | audit-privateendpoint-nsg-v1 | Audit | Audit | SC-7 |
| VMs for DNS | deny-vm-disk-encryption-v1 | Deny | Audit | SC-28 |
| VMs for DNS | deny-vm-public-ip-v1 | Deny | Deny | SC-7 |
| VMs for DNS | audit-vm-guest-configuration-v1 | Audit | Audit | CM-6 |
| VMs for DNS | audit-vm-diagnostic-settings-v1 | Audit | Audit | AU-12 |
| App Insights | audit-appinsights-workspace-based-v1 | Audit | Audit | AU-6 |
| App Insights | audit-appinsights-local-auth-disabled-v1 | Audit | Audit | IA-2 |

---

## Assignment Strategy

| Scope | Initiatives Assigned | Rationale |
|-------|---------------------|-----------|
| **Root Management Group** | Storage Account, Key Vault, Private Endpoint, Azure Monitor | Universal services deployed across all subscriptions |
| **Hub Subscription** | Bastion, DNS Resolver, Private DNS Zone, VMs for DNS | Hub-only networking infrastructure |
| **Connectivity Subscription** | ExpressRoute | Dedicated connectivity resources |
| **App Subscription(s)** | App Service, Azure Functions, Front Door, App Insights, Maps | Application-tier services |
| **AI Subscription** | OpenAI, AI Search, AI Foundry, Document Intelligence, Speech | AI/ML workloads |
| **Data Subscription** | Event Hubs | Data ingestion services |
| **Governance Subscription** | Purview | Data governance services |
| **B2C Subscription** | Azure AD B2C | Consumer identity services |

---

## NIST 800-53 Control Coverage

| NIST Control | Description | Policies Mapped |
|-------------|-------------|-----------------|
| **SC-7** | Boundary Protection | 15 (deny public access, PE required, NSG, WAF, VNet link) |
| **SC-8** | Transmission Confidentiality | 8 (TLS 1.2, HTTPS-only, HTTPS redirect) |
| **SC-13** | Cryptographic Protection | 5 (TLS 1.2, FIPS-validated, encryption) |
| **SC-28** | Protection of Information at Rest | 3 (CMK, disk encryption) |
| **SC-12** | Cryptographic Key Management | 1 (key expiration) |
| **SC-20** | Authoritative DNS Source | 3 (DNS zone group, VNet link, forwarding rules) |
| **SC-21** | Recursive/Caching DNS | 1 (forwarding rules) |
| **SC-23** | Session Authenticity | 1 (token lifetime) |
| **IA-2** | Identification & Authentication | 12 (managed identity, local auth disabled, MFA) |
| **IA-5** | Authenticator Management | 2 (token lifetime, managed identity) |
| **IA-8** | Non-Organizational User Auth | 1 (custom domain) |
| **AC-3** | Access Enforcement | 3 (shared key disabled, RBAC) |
| **AC-4** | Information Flow Enforcement | 1 (CORS restrictions) |
| **AC-6** | Least Privilege | 1 (RBAC auth) |
| **AU-6** | Audit Review & Analysis | 1 (workspace-based) |
| **AU-11** | Audit Record Retention | 1 (365-day minimum) |
| **AU-12** | Audit Generation | 8 (diagnostic settings) |
| **CP-9** | System Backup | 2 (soft-delete, purge protection) |
| **CM-6** | Configuration Settings | 1 (guest configuration STIG) |
| **SI-4** | Information System Monitoring | 2 (content filtering, WAF) |

---

## FedRAMP Exceptions

| Service | Exception | Compensating Controls |
|---------|-----------|----------------------|
| Azure AD B2C | No Private Endpoint (consumer-facing) | Front Door WAF, IP restrictions, DDoS protection, rate limiting |
| Azure Maps | No Private Endpoint (service limitation) | Managed identity-only auth, CORS restrictions, WAF, no sensitive data in queries |
| Azure Bastion | Public IP required (architecture) | NSG HTTPS-only inbound, DDoS protection, TLS encryption, Entra ID auth |

---

## Environment Effect Override Pattern

All initiatives support per-environment effect overrides via initiative parameters:

| Environment | Deny Policies | Audit Policies | AuditIfNotExists |
|-------------|--------------|----------------|-----------------|
| **Production** | Deny (block non-compliant) | Audit (compliance report) | AuditIfNotExists |
| **Staging** | Audit (report only) | Audit | AuditIfNotExists |
| **Development** | Audit (report only) | Audit | AuditIfNotExists |

> TLS 1.2 minimum and purge protection policies remain **Deny** across all environments.

---

*Consolidated FedRAMP High policy initiative summary — Wave 1 detail (23 services, 4 groups) with per-group summaries for all 118 in-scope Azure services (13 service groups).*
