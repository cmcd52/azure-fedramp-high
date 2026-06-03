# Azure Services Reference — FedRAMP High (Legacy)

> **DEPRECATED**: As of Constitution v6.0.0, the project scope covers **all Generally Available (GA) Azure Commercial cloud services**. This document is no longer the scope gate. Services that cannot meet FedRAMP High requirements are tracked in `docs/azure-service-exclusions.md`. This file is retained as a historical reference of the original in-scope services that have existing deliverable artifacts.

**Entra ID dependency note**: Entra ID is out of scope as a standalone service deliverable. However, Azure services depend on Entra ID features (Conditional Access, MFA, PIM, RBAC, B2B guest access) for access control. Each service's security control baseline documents how that service consumes Entra ID identity features — this is Azure tenant configuration, not Entra ID service administration.

**Compliance Baseline**: FedRAMP High  
**Target Cloud**: Azure Commercial (Azure Government is explicitly out of scope)

---

## Services with Existing Deliverable Artifacts

## AI and Data Services

| Service | Notes |
|---------|-------|
| Azure OpenAI | |
| Azure AI Search | |
| Azure AI Foundry | |
| Azure Document Intelligence | |
| Azure Maps | |
| Azure Purview | |
| AI Speech Service | |
| Event Hubs | |

## Identity and Access Management

| Service | Notes |
|---------|-------|
| Azure AD B2C | Customer Identity |
| Managed Identity | |

## Compute, Storage, and Web Hosting

| Service | Notes |
|---------|-------|
| Azure App Service | Includes App Service Plans |
| Azure Functions | |
| Azure Storage Account | |

## Networking, Monitoring, and Security

| Service | Notes |
|---------|-------|
| Bastion | |
| DNS Private Resolver | |
| Private DNS Zone | |
| Private Endpoint | |
| ExpressRoute | |
| Azure Front Door | |
| Azure Monitor | Includes Log Analytics |
| Azure Application Insights | |
| VMs for DNS | |
| Key Vault | |

---

**Version**: 4.0.0 (Legacy) | **Created**: 2026-03-27 | **Last Amended**: 2026-04-26 | **Status**: Deprecated — see Constitution v6.0.0
