# Azure Commercial vs Azure Government (Virginia) — Feature Parity Research

## Executive Summary

**Date**: 2026-06-04  
**Scope**: 23 Azure services listed in `azure-services-reference.md` v3.0.0  
**Comparison**: Azure Commercial (public cloud) vs Azure Government (US Gov Virginia region)  
**Compliance Context**: FedRAMP High

---

## Critical Findings

### Services with Showstopper Parity Gaps

| # | Service | Gap Severity | Summary |
|---|---------|-------------|---------|
| 1 | **Azure AD B2C** | **NOT AVAILABLE** | Azure Active Directory B2C is not available in Azure Government. This is a complete service absence — there is no equivalent offering in Gov. |
| 2 | **Azure AI Foundry** | **NOT AVAILABLE (as standalone portal)** | Microsoft Foundry projects list does not include any Azure Government regions. Gov customers access AI capabilities through the Gov-specific portal (ai.azure.us) with limited feature surface compared to the commercial Foundry experience. |

### Services with Significant Feature Gaps

| # | Service | Gap Count | Key Gaps |
|---|---------|-----------|----------|
| 3 | **AI Speech Service** | 10 features missing | Custom Voice, Personal Voice, TTS Avatar, Fast Transcription, Pronunciation Assessment, Custom Keyword, Voice Live, Live Interpreter, Video Translation, LLM Speech |
| 4 | **Azure OpenAI** | 3+ features missing | Batch Deployments not supported; Connect your data (web app/Copilot Studio deployment) not supported; Abuse Monitoring partial; reduced model availability in US Gov Virginia vs US Gov Arizona; reduced max context window for some models |
| 5 | **Azure App Service** | 3 resources + 1 feature missing | App Service Certificate, App Service Managed Certificate, App Service Domain not available; Deployment limited to Local Git Repository and External Repository only |
| 6 | **Azure Front Door** | Region limitation | Standard/Premium tiers available only in US Gov Arizona and US Gov Texas — **US Gov Virginia not listed** for Front Door availability |
| 7 | **Azure Bastion** | 1 critical limitation | Azure Private DNS Zones integration not supported in national clouds |

### Services with Configuration/Endpoint Differences (Functional Parity)

| # | Service | Impact |
|---|---------|--------|
| 8 | Azure Functions | Must use `APPLICATIONINSIGHTS_CONNECTION_STRING` (not `APPINSIGHTS_INSTRUMENTATIONKEY`) |
| 9 | Key Vault | Endpoint: `vault.usgovcloudapi.net` (not `vault.azure.net`) |
| 10 | Azure Storage Account | Endpoint: `*.core.usgovcloudapi.net` (not `*.core.windows.net`) |
| 11 | Azure Monitor / Log Analytics | Endpoints differ; cannot migrate data between clouds |
| 12 | Azure Application Insights | Requires SDK endpoint modifications; different IP addresses |
| 13 | ExpressRoute | BGP communities differ in national clouds |
| 14 | Private Endpoint | Private DNS zone names use `.usgovcloudapi.net` suffix |
| 15 | Private DNS Zone | Zone names differ for all Gov-linked services |
| 16 | Event Hubs | Endpoint: `servicebus.usgovcloudapi.net` |
| 17 | Azure AI Search | Endpoint: `search.azure.us` |
| 18 | Azure Maps | Endpoint: `atlas.azure.us` |
| 19 | Azure Document Intelligence | Endpoint: `cognitiveservices.azure.us` |
| 20 | Azure Purview | Endpoint: `purview.azure.us` / `purviewstudio.azure.us` |

### Services with Full Parity (No Known Gaps)

| # | Service | Notes |
|---|---------|-------|
| 21 | Managed Identity | Part of Entra ID identity platform; available in Gov via `login.microsoftonline.us` |
| 22 | DNS Private Resolver | Available in Gov; no documented feature limitations |
| 23 | VMs for DNS | Standard Azure VMs; fully available in Gov |

---

## Impact Assessment for FedRAMP High Compliance

### High Impact

- **Azure AD B2C**: If the solution requires B2C for customer identity, an alternative architecture is required for Gov deployment. Consider Entra ID External ID or a custom identity solution.
- **Azure Front Door (US Gov Virginia)**: If Front Door is required specifically in US Gov Virginia, this is a gap. However, Front Door is a global/anycast service — Arizona/Texas deployment may still serve Virginia-hosted backends.
- **Azure AI Foundry**: Gov customers must use the Gov-specific AI portal (`ai.azure.us`) with a reduced feature set compared to the commercial Foundry portal.

### Medium Impact

- **AI Speech Service**: 10 features unavailable in Gov. If the solution requires Custom Voice, Pronunciation Assessment, or avatar capabilities, these cannot be delivered in Gov.
- **Azure OpenAI**: Batch Deployments unavailability affects bulk processing workloads. Model availability varies by Gov region — some models available in Arizona but not Virginia.
- **App Service**: Missing managed certificates requires bringing your own certificates (BYOC). Limited deployment options may affect CI/CD pipeline design.
- **Azure Bastion**: Private DNS Zone limitation in national clouds requires alternative DNS resolution strategies.

### Low Impact (Configuration Only)

- All services with endpoint differences: These are well-documented and require configuration changes only. Terraform modules and application code must parameterize endpoints based on cloud environment.

---

## Research File Index

| File | Contents |
|------|----------|
| [01-ai-data-services.md](01-ai-data-services.md) | Azure OpenAI, Azure AI Search, Azure AI Foundry, Azure Document Intelligence, Azure Maps, Azure Purview, AI Speech Service, Event Hubs |
| [02-identity-services.md](02-identity-services.md) | Azure AD B2C, Managed Identity |
| [03-compute-storage-services.md](03-compute-storage-services.md) | Azure App Service, Azure Functions, Azure Storage Account |
| [04-networking-security-services.md](04-networking-security-services.md) | Bastion, DNS Private Resolver, Private DNS Zone, Private Endpoint, ExpressRoute, Azure Front Door, Azure Monitor, Azure Application Insights, VMs for DNS, Key Vault |

---

## Source References

All findings in this research are sourced from official Microsoft documentation:

1. [Compare Azure Government and global Azure](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure) — Primary parity reference
2. [Azure OpenAI in Azure Government](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/azure-government) — OpenAI Gov-specific features and model availability
3. [Speech service in sovereign clouds](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/sovereign-clouds) — Speech feature limitations
4. [Microsoft Foundry feature availability across cloud regions](https://learn.microsoft.com/en-us/azure/ai-foundry/reference/region-support) — AI Foundry region support
5. [Azure Private Endpoint private DNS zone values](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns) — Gov DNS zone mappings
6. [Products available by region](https://azure.microsoft.com/global-infrastructure/services/) — Service availability matrix
7. [Azure Government developer guide](https://learn.microsoft.com/en-us/azure/azure-government/documentation-government-developer-guide) — Endpoint and configuration guidance
