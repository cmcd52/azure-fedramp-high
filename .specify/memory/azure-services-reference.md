# Azure Services Reference — FedRAMP High

**Purpose**: This is the authoritative list of Azure services in scope for this project. All specifications, plans, tasks, and implementations MUST only reference services listed here. Any service not on this list is explicitly out of scope unless added through a formal amendment to this document. Microsoft 365 (GCC, GCC High, and all M365 workloads), Entra ID, and Microsoft Intune are explicitly out of scope — these are SaaS platforms without Azure ARM resource types.

**Entra ID dependency note**: Entra ID is out of scope as a standalone service deliverable. However, Azure services depend on Entra ID features (Conditional Access, MFA, PIM, RBAC, B2B guest access) for access control. Each in-scope service's security control baseline documents how that service consumes Entra ID identity features — this is Azure tenant configuration, not Entra ID service administration.

**Compliance Baseline**: FedRAMP High  
**Target Cloud**: Azure Commercial (Azure Government is explicitly out of scope)

---

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

**Version**: 3.0.0 | **Created**: 2026-03-27 | **Last Amended**: 2026-03-29
