# Azure Commercial vs. Government Cloud — Pricing & Availability Baseline

> **Regions Used as Constants:** East US 2 (Commercial) | US Gov Virginia (Government)
> **Tier Constant:** Premium (where applicable)
> **Date of Research:** March 2026
> **Sources:** See [Appendix A — Sources & References](#appendix-a--sources--references) for full citation list

> [!CAUTION]
> ### Disclaimer
>
> **IMPORTANT — PLEASE READ**
>
> **Independent Research.** This document was independently compiled from **publicly available** Microsoft Azure pricing pages and documentation. It is **not** produced by, endorsed by, or affiliated with Microsoft Corporation. All Microsoft and Azure trademarks referenced herein are the property of Microsoft Corporation.
>
> **No Warranty.** THE INFORMATION IN THIS DOCUMENT IS PROVIDED "AS-IS," WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT. The data presented may contain inaccuracies or typographical errors.
>
> **Not a Cost Guarantee.** The pricing figures cited herein reflect publicly available Pay-As-You-Go (PAYG) list prices observed at the time of research. They **do not constitute a guarantee of actual costs** your organization will incur. Actual costs may vary based on, but not limited to: negotiated Enterprise Agreement (EA) or Microsoft Customer Agreement (MCA) rates, Reserved Instance discounts, Azure Savings Plans, Azure Hybrid Benefit, Dev/Test subscription pricing, volume commitments, promotional offers, currency exchange fluctuations, or any other cost reduction or optimization mechanisms.
>
> **Subject to Change.** Microsoft may update its pricing, service availability, features, and terms at any time without prior notice. Information in this document may become outdated between the date of research and the date of reading.
>
> **Reader Responsibility.** Readers are solely responsible for validating all pricing and availability information through:
> - The [Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/) (selecting the appropriate region and agreement type)
> - Their Microsoft Account Representative, Customer Success Account Manager (CSAM), or Cloud Solution Architect (CSA)
> - Their Enterprise Agreement (EA) or MCA price sheet
> - The [Azure Government Portal](https://portal.azure.us) for Government-specific pricing
>
> **Not Professional Advice.** This document does not constitute financial, legal, procurement, or compliance advice. Readers should engage their own qualified advisors for decisions involving procurement, budgeting, or regulatory compliance.
>
> **Scope.** This analysis covers only the services and tiers explicitly listed. It does not represent the full breadth of Azure services, SKUs, or configurations available. Government cloud availability and feature parity should be independently verified for production planning.

---

## Key Takeaways

| Dimension | Summary |
|---|---|
| **Pricing Model** | Azure Government pricing is **not published on the same public pricing pages** as Commercial. Government-specific pricing is available through the [Azure Government Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/) (select a US Gov region) or through your Microsoft account team / EA agreement. |
| **General Premium** | Azure Government services typically carry a **~10–25% premium** over Commercial pricing, varying by service. Some services (e.g., Private Endpoints, Key Vault operations) may have identical pricing; others (e.g., AI/ML, networking) may carry a higher premium. |
| **Availability Gap** | Most core IaaS/PaaS services are GA in US Gov Virginia. AI services have a **narrower model catalog** in Government. Some services (e.g., Azure Front Door Standard/Premium) are only GA in US Gov Arizona and US Gov Texas, not US Gov Virginia. |
| **Recommendation** | Always validate pricing through the Azure Pricing Calculator with `US Gov Virginia` selected, or via your EA rate sheet. The Commercial pricing below provides the **baseline** for comparison. |

---

## 1. AI & Machine Learning Services

### 1.1 Azure OpenAI Service

| Pricing Dimension | Commercial (East US 2) | Gov Availability (US Gov Virginia) |
|---|---|---|
| GPT-4o (Global Standard) | $2.50 / $10.00 per 1M tokens (input/output) | **Available** — Limited model catalog; see [Azure OpenAI in Azure Gov](https://learn.microsoft.com/en-us/azure/ai-services/openai/azure-government) |
| GPT-4.1 (Global Standard) | $2.00 / $8.00 per 1M tokens | Check regional model availability |
| GPT-4.1 mini (Global Standard) | $0.40 / $1.60 per 1M tokens | Check regional model availability |
| o3 (Global Standard) | $2.00 / $8.00 per 1M tokens | Limited availability |
| o4-mini (Global Standard) | $1.10 / $4.40 per 1M tokens | Limited availability |
| Provisioned (Global PTU) | From $1.00/hr per PTU | Available — Provisioned throughput supported |
| Embeddings (Ada) | $0.00011 per 1K tokens | Available |
| Image Generation (GPT-Image-1) | $0.01 (low) / $0.04 (high) per image | Check availability |

**Gov Notes:** Azure OpenAI is available in Azure Government with a reduced set of models. Government pricing is obtained via the Gov pricing calculator; expect a premium. Refer to [Azure OpenAI Azure Government docs](https://learn.microsoft.com/en-us/azure/ai-services/openai/azure-government) for the current model list.

---

### 1.2 Azure AI Search

| Tier | Commercial (East US 2) | Gov Availability |
|---|---|---|
| Free | $0 (50 MB storage, 3 indexes) | Available |
| Basic | $73.73/month per SU | Available |
| S1 (Standard) | $245.28/month per SU | Available |
| S2 | $981.12/month per SU | Available |
| S3 | $1,962.24/month per SU | Available |
| S3 HD | $2,452.80/month per SU | Available |
| L1 (Storage Optimized) | $2,802.47/month per SU | Available |
| L2 | $5,604.21/month per SU | Available |
| Semantic Ranker | $1.00 per 1,000 queries | Available |

**Gov Notes:** Azure AI Search available in US Gov Virginia (`search.azure.us` endpoint). Government pricing expected to be at a premium.

---

### 1.3 Azure AI Foundry (Microsoft Foundry)

| Component | Commercial Pricing | Gov Availability |
|---|---|---|
| Foundry Models | Varies by model — uses underlying Azure OpenAI, marketplace model pricing | **Limited** — Gov availability of Foundry marketplace models is narrower |
| Agents Service | Pre-purchase plans available; per-agent execution pricing | Check Gov availability |
| Knowledge & Tools | Pricing determined by underlying services (AI Search, Storage) | Dependent on underlying service availability |

**Gov Notes:** Azure AI Foundry (formerly AI Studio) is a portal/orchestration layer. Pricing depends on the underlying services consumed. In Government, the catalog of available models and integrations is more limited. Consult your account team for Gov-specific capabilities.

---

### 1.4 Azure Document Intelligence

| Tier | Commercial (East US 2) | Gov Availability |
|---|---|---|
| Read | $1.50 per 1,000 pages | **Available** (`cognitiveservices.azure.us`) |
| Prebuilt (Invoice, Receipt, ID, etc.) | $10.00 per 1,000 pages | Available |
| Custom Extraction | $30.00 per 1,000 pages | Available |
| Custom Classification | $10.00 per 1,000 pages | Available |
| Add-on: Query Fields | $3.50 per 1,000 pages | Available |
| Commitment Tiers | Discounted from 15M pages+ | Available |

**Gov Notes:** Document Intelligence is available in Azure Government at the `cognitiveservices.azure.us` endpoint.

---

### 1.5 Azure Maps

| Feature | Commercial (East US 2) | Gov Availability |
|---|---|---|
| Base Map Tiles (Gen2) | 5,000 free, then $4.50 per 1,000 txns | **Available** (`atlas.azure.us`) |
| Search | 5,000 free, then $4.50 per 1,000 txns | Available |
| Routing | 5,000 free, then $4.50 per 1,000 txns | Available |
| Geolocation | 5,000 free, then $4.50 per 1,000 txns | Available |
| Weather | 5,000 free, then $0.50 per 1,000 txns | Available |

**Gov Notes:** Azure Maps available in US Gov Virginia with Government-specific endpoint.

---

### 1.6 Azure AI Speech Service

| Feature | Commercial (East US 2) | Gov Availability |
|---|---|---|
| Speech-to-Text (Real-time) | $1.00 per audio hour | **Available** (Gov-specific endpoints) |
| Speech-to-Text (Batch) | $0.40 per audio hour | Available |
| Text-to-Speech (Neural) | $15.00 per 1M characters | Available |
| Text-to-Speech (Personal Voice) | $60.00 per 1M characters | Check availability |
| Custom Voice (Neural) | $24.00 per 1M characters | Available |
| Speech Translation | $2.50 per audio hour | Available |
| Speaker Recognition | $10.00 per 1,000 txns | Check availability |

**Gov Notes:** Speech Service is available in Azure Government with Gov-specific endpoints (e.g., `usgovvirginia.s2s.speech.azure.us`). Some features like Speech Requests may have limitations. Refer to [Speech service in sovereign clouds](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/sovereign-clouds).

---

### 1.7 Microsoft Purview

| Component | Commercial Pricing | Gov Availability |
|---|---|---|
| In Transit Protection | $0.50 per 10K requests | **Limited** — Data governance consumption features may not be available in all Gov regions |
| Insider Risk Management | $25 per data security processing unit | Check availability |
| OCR | $1.00 per 1,000 images (2,500 free/mo) | Check availability |
| Data Governance (Classic) | Consumption-based scanning | Limited Gov support |

**Gov Notes:** Microsoft Purview's availability in Azure Government varies by component. The data governance experience (formerly Azure Purview) has limited Gov region support. Data security features tied to Microsoft 365 E5/Compliance licensing may be available independently. Verify current availability via [Products by region](https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/).

---

## 2. Compute & Application Services

### 2.1 Azure App Service (Premium v3 / v4)

| SKU | vCPU / Memory | Commercial (East US 2) / month | Gov Availability |
|---|---|---|---|
| P1v3 | 2 vCPU / 8 GB | $124.10 | **Available** (`azurewebsites.us`) |
| P2v3 | 4 vCPU / 16 GB | $248.20 | Available |
| P3v3 | 8 vCPU / 32 GB | $496.40 | Available |
| P0v3 | 1 vCPU / 4 GB | $78.84 | Available |
| P1mv3 | 2 vCPU / 16 GB | $176.66 | Available |
| P2mv3 | 4 vCPU / 32 GB | $353.32 | Available |
| P3mv3 | 8 vCPU / 64 GB | $706.64 | Available |

**Gov Notes:** App Service is available in Azure Government. Note: App Service Certificate, Managed Certificate, and App Service Domain are **not available** in Government. Deployment options are limited to Local Git Repository and External Repository.

---

### 2.2 Azure Functions (Premium Plan)

| Meter | Commercial (East US 2) | Gov Availability |
|---|---|---|
| vCPU Duration | $126.29/month (~$0.173/vCPU-hr) | **Available** (`azurewebsites.us`) |
| Memory Duration | $8.979/GB/month (~$0.0123/GB-hr) | Available |
| **Consumption Plan (reference)** | | |
| Execution Time | $0.000016/GB-s | Available |
| Total Executions | $0.20 per million | Available |

**Gov Notes:** Functions available in Azure Government. When connecting to Application Insights in Gov, use the `APPLICATIONINSIGHTS_CONNECTION_STRING` setting to customize the endpoint.

---

### 2.3 Virtual Machines (Select Premium-class SKUs)

| VM Series / SKU | vCPU / Memory | Commercial (East US 2) PAYG/month | Gov Availability |
|---|---|---|---|
| D4s v5 | 4 vCPU / 16 GB | ~$140.16 | **Available** |
| D8s v5 | 8 vCPU / 32 GB | ~$280.32 | Available |
| D16s v5 | 16 vCPU / 64 GB | ~$560.64 | Available |
| E4s v5 | 4 vCPU / 32 GB | ~$182.50 | Available |
| E8s v5 | 8 vCPU / 64 GB | ~$365.00 | Available |
| E16s v5 | 16 vCPU / 128 GB | ~$730.00 | Available |
| F4s v2 | 4 vCPU / 8 GB | ~$122.64 | Available |
| F8s v2 | 8 vCPU / 16 GB | ~$245.28 | Available |

**Gov Notes:** Most VM series are available in US Gov Virginia. Government VM pricing is typically 10–20% higher than Commercial. Validate specific SKU availability and pricing through the Gov pricing calculator. For DNS VMs, standard D-series or B-series SKUs are commonly used.

---

## 3. Networking Services

### 3.1 Azure Bastion

| SKU | Commercial (East US 2) | Gov Availability |
|---|---|---|
| Developer | Free | **Available** |
| Basic | $0.19/hour (~$138.70/mo) | Available |
| Standard | $0.29/hour (~$211.70/mo) | Available |
| Premium | **$0.45/hour (~$328.50/mo)** | Available |
| Additional Standard Instance | $0.14/hour | Available |
| Additional Premium Instance | $0.22/hour | Available |
| Outbound Data (5–10 TB) | $0.087/GB | Available |

**Gov Notes:** Azure Bastion is listed as available in Azure Government networking services.

---

### 3.2 Azure DNS & DNS Private Resolver

| Component | Commercial (East US 2) | Gov Availability |
|---|---|---|
| **Public DNS Zones** | | |
| First 25 zones | $0.50/zone/month | **Available** |
| Additional zones (>25) | $0.10/zone/month | Available |
| DNS Queries (first 1B/mo) | $0.40 per million | Available |
| **DNS Private Resolver** | | |
| Inbound Endpoint | $180/month | **Available** |
| Outbound Endpoint | $180/month | Available |
| Rulesets | $2.50/month | Available |
| **DNS Security Policy** | | |
| Queries (with rules) | $0.60 per million queries | Check availability |
| Domain Lists | $0.50/month per 1,000 domains | Check availability |

---

### 3.3 Private DNS Zone

| Component | Commercial (East US 2) | Gov Availability |
|---|---|---|
| Hosted Zones | Included with DNS pricing | **Available** |
| Private Endpoint DNS | Azure Government uses `.us` suffixed zones | Available — see [Private Endpoint DNS for Government](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#government) |

---

### 3.4 Azure Private Endpoint / Private Link

| Meter | Commercial (East US 2) | Gov Availability |
|---|---|---|
| Private Link Service | No charge | **Available** |
| Private Endpoint | $0.01/hour (~$7.30/mo) | Available |
| Inbound Data Processed (0–1 PB) | $0.01/GB | Available |
| Outbound Data Processed (0–1 PB) | $0.01/GB | Available |
| Data (1–5 PB) | $0.006/GB | Available |
| Data (5+ PB) | $0.004/GB | Available |

**Gov Notes:** Private Link is available in Azure Government. Gov-specific private DNS zone names apply. See [Azure Private Link availability](https://learn.microsoft.com/en-us/azure/private-link/availability).

---

### 3.5 Azure ExpressRoute

| Plan / Speed | Commercial Zone 1 (East US 2) | Gov Availability |
|---|---|---|
| **Metered Data Plan** | | |
| 1 Gbps | $436/month | **Available** |
| 2 Gbps | $872/month | Available |
| 5 Gbps | $2,180/month | Available |
| 10 Gbps | $3,400/month | Available |
| Outbound Data (Zone 1) | $0.025/GB | Available |
| **Unlimited Data Plan** | | |
| 1 Gbps (Standard) | $5,700/month | Available |
| 1 Gbps (Premium) | $6,450/month | Available |
| **Global Reach** | | |
| 1 Gbps | $436/month | Available |

**Gov Notes:** ExpressRoute is available in Azure Government. For BGP community support in Government, see [ExpressRoute routing](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-routing#bgp-community-support-in-national-clouds). Government ExpressRoute pricing may differ; verify through your service provider and EA.

---

### 3.6 Azure Front Door

| Meter | Commercial | Gov Availability |
|---|---|---|
| **Base Fee (Monthly)** | | |
| Standard | $35/month | **GA in US Gov Arizona & US Gov Texas only** |
| Premium | $330/month | GA in US Gov Arizona & US Gov Texas only |
| **Outbound Data (NA, first 10 TB)** | $0.083/GB | Same regions |
| **Requests (Premium, first 250M)** | $0.015 per 10K requests (NA) | Same regions |

**Gov Notes:** Azure Front Door Standard & Premium are GA in US Gov Arizona and US Gov Texas — **not US Gov Virginia**. This is a significant consideration for architectures targeting US Gov Virginia.

---

## 4. Storage & Data Services

### 4.1 Azure Storage Account (Blob — Hot Tier, LRS)

| Meter | Commercial (East US 2) | Gov Availability |
|---|---|---|
| Data Storage (first 50 TB) | $0.018/GB/month | **Available** (`blob.core.usgovcloudapi.net`) |
| Data Storage (50–500 TB) | $0.0173/GB/month | Available |
| Write Operations (per 10K) | $0.0065 | Available |
| Read Operations (per 10K) | $0.0005 | Available |
| List/Create Operations (per 10K) | $0.065 | Available |
| Data Retrieval | Free | Available |

**Gov Notes:** Storage accounts are fully available in Azure Government with Government-specific endpoints (`.usgovcloudapi.net`).

---

### 4.2 Azure Event Hubs

| Tier | Commercial (East US 2) | Gov Availability |
|---|---|---|
| Basic | $0.015/hr per TU (~$11/mo) | **Available** (`servicebus.usgovcloudapi.net`) |
| Standard | $0.03/hr per TU (~$22/mo) | Available |
| **Premium** | **$1.233/hr per PU (~$900/mo)** | Available |
| Dedicated | $6.849/hr per CU (~$5,000/mo) | Available |
| Ingress Events (Standard) | $0.028 per million | Available |
| Capture (Standard) | Available | Available |

**Gov Notes:** Event Hubs is available in Azure Government with Government endpoints.

---

## 5. Monitoring & Observability

### 5.1 Azure Log Analytics (part of Azure Monitor)

| Plan | Commercial (East US 2) | Gov Availability |
|---|---|---|
| **Analytics Logs (Pay-As-You-Go)** | $2.30/GB ingested | **Available** (`oms.opinsights.azure.us`) |
| Analytics Logs 100 GB/day Commitment | $196/day ($1.96/GB, 15% savings) | Available |
| Analytics Logs 500 GB/day Commitment | $865/day ($1.73/GB, 25% savings) | Available |
| **Basic Logs** | $0.50/GB ingested | Available |
| **Auxiliary Logs** | $0.05/GB ingested | Available |
| Log Processing | $0.10/GB | Available |
| Query (Basic/Auxiliary) | $0.005/GB scanned | Available |
| Interactive Retention (up to 2 yr) | $0.10/GB/month | Available |
| Long-term Retention (up to 12 yr) | $0.02/GB/month | Available |
| Data Export | $0.10/GB | Available |

**Gov Notes:** Log Analytics is fully available in Azure Government with Gov-specific endpoints. Data cannot be migrated between Azure Commercial and Azure Government workspaces.

---

### 5.2 Azure Application Insights (part of Azure Monitor)

| Meter | Commercial (East US 2) | Gov Availability |
|---|---|---|
| Data Ingestion | Same as Log Analytics pricing above | **Available** (`{region}.in.applicationinsights.azure.us`) |
| Retention (31/90 days) | Included with Analytics Logs | Available |
| Multi-step Web Tests | $10/month per test | Available |

**Gov Notes:** Application Insights is available in Azure Government. SDK endpoint modifications are required — use the `APPLICATIONINSIGHTS_CONNECTION_STRING` and reference [Application Insights endpoint overrides](https://learn.microsoft.com/en-us/previous-versions/azure/azure-monitor/app/create-new-resource#override-default-endpoints). Visual Studio integration requires adding Azure US Government as a registered cloud.

---

## 6. Security

### 6.1 Azure Key Vault

| Tier / Operation | Commercial (East US 2) | Gov Availability |
|---|---|---|
| Secrets Operations | $0.03 per 10,000 txns | **Available** (`vault.usgovcloudapi.net`) |
| Certificate Renewals | $3.00 per renewal | Available |
| Software-Protected Keys (RSA 2048) | $0.03 per 10,000 txns | Available |
| Advanced Keys (RSA 3072/4096, ECC) | $0.15 per 10,000 txns | Available |
| **HSM-Protected Keys (Premium)** | $1/key/month + $0.03/10K txns | Available |
| Key Rotation (Automated) | $1 per scheduled rotation | Available |
| **Managed HSM Pool (Standard B1)** | $3.20/hour (~$2,336/mo) | Available (`managedhsm.usgovcloudapi.net`) |

**Gov Notes:** Key Vault is fully available in Azure Government with Government endpoints.

---

## Pricing Comparison Summary Matrix

The table below summarizes the **Commercial baseline pricing** for the Premium/recommended tier of each service. Government pricing is not directly published on public pricing pages; use the Gov Pricing Calculator or EA rate sheet for exact figures.

| Service | Tier/Unit | Commercial Baseline (East US 2) | Gov Availability (US Gov Virginia) | Expected Gov Premium |
|---|---|---|---|---|
| Azure OpenAI | GPT-4o per 1M tokens (in/out) | $2.50 / $10.00 | ✅ (limited models) | ~10–25% |
| Azure AI Search | S1 per SU/month | $245.28 | ✅ | ~10–20% |
| Azure AI Foundry | Platform layer (underlying services) | Varies | ⚠️ Limited | Service-dependent |
| Document Intelligence | Read per 1K pages | $1.50 | ✅ | ~10–20% |
| Azure Maps | Per 1K transactions | $4.50 | ✅ | ~10–20% |
| AI Speech (STT Real-time) | Per audio hour | $1.00 | ✅ | ~10–20% |
| Microsoft Purview | Data governance (consumption) | Varies | ⚠️ Limited | TBD |
| Event Hubs (Premium) | Per PU/hour | $1.233 | ✅ | ~10–20% |
| App Service (P1v3) | Per month | $124.10 | ✅ | ~10–20% |
| Functions (Premium vCPU) | Per month | $126.29 | ✅ | ~10–20% |
| Storage (Blob Hot LRS) | Per GB/month (first 50 TB) | $0.018 | ✅ | ~10–15% |
| Bastion (Premium) | Per hour | $0.45 | ✅ | ~10–20% |
| DNS Private Resolver | Per endpoint/month | $180.00 | ✅ | ~10–15% |
| Private DNS Zone | Per zone/month | $0.50 | ✅ | ~10–15% |
| Private Endpoint | Per hour | $0.01 | ✅ | ~10–15% |
| ExpressRoute (1 Gbps Metered) | Per month | $436.00 | ✅ | ~10–20% |
| Front Door (Premium) | Base fee/month | $330.00 | ⚠️ Gov AZ/TX only | ~10–20% |
| Log Analytics (PAYG) | Per GB ingested | $2.30 | ✅ | ~10–15% |
| Application Insights | Per GB ingested | $2.30 | ✅ | ~10–15% |
| VMs (D4s v5) | Per month PAYG | ~$140.16 | ✅ | ~10–20% |
| Key Vault (Premium HSM) | Per key/month | $1.00 | ✅ | ~10–15% |

**Legend:** ✅ = GA in US Gov Virginia | ⚠️ = Limited availability or not in US Gov Virginia

---

## How to Obtain Exact Government Pricing

1. **Azure Pricing Calculator:** Navigate to [https://azure.microsoft.com/en-us/pricing/calculator/](https://azure.microsoft.com/en-us/pricing/calculator/) → Sign in → Select **US Gov Virginia** as the region for each service to see Government-specific pricing.

2. **Enterprise Agreement (EA) Rate Sheet:** For customers with an EA, Government pricing is available on the EA price sheet downloadable from the Azure Enterprise Portal.

3. **Azure Government Portal:** Use [https://portal.azure.us](https://portal.azure.us) to view pricing during resource provisioning.

4. **Microsoft Account Team:** Contact your Microsoft account representative or CSA for custom pricing quotes and volume discounts.

---

## Important Caveats

- **Prices are estimates** and may not reflect negotiated EA discounts, Reserved Instance pricing, or Savings Plan rates.
- **Government pricing varies** and the ~10–25% premium is a general industry observation, not an official Microsoft specification. Individual service premiums may be higher or lower.
- **Availability is dynamic** — Microsoft regularly adds services to Azure Government. Always check [Products available by region](https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/) for the latest status.
- **Feature parity** is not guaranteed. Even when a service is listed as available in Government, some features may be missing or limited (see service-specific Gov notes above).
- Azure AI Foundry has been rebranded to **Microsoft Foundry** as of 2025. Pricing is determined by the underlying consumed services.

---

*This document provides a baseline for planning and discussion. Exact Government pricing should be validated through the Azure Pricing Calculator with Government region selected or through your Enterprise Agreement rate sheet.*

---

## Appendix A — Sources & References

All pricing data was gathered from publicly available Azure pricing pages and Microsoft Learn documentation. Prices reflect **Pay-As-You-Go (PAYG)** rates in **USD** for the **East US 2** region unless otherwise noted. Government availability was cross-referenced against the Azure Government comparison documentation.

### Pricing Pages (Commercial Baseline)

| # | Service | Source URL | Accessed |
|---|---|---|---|
| 1 | Azure OpenAI Service | [azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/) | Mar 2026 |
| 2 | Azure AI Search | [azure.microsoft.com/en-us/pricing/details/search/](https://azure.microsoft.com/en-us/pricing/details/search/) | Mar 2026 |
| 3 | Microsoft Foundry (AI Foundry) | [azure.microsoft.com/en-us/pricing/details/ai-studio/](https://azure.microsoft.com/en-us/pricing/details/ai-studio/) | Mar 2026 |
| 4 | Azure Document Intelligence | [azure.microsoft.com/en-us/pricing/details/ai-document-intelligence/](https://azure.microsoft.com/en-us/pricing/details/ai-document-intelligence/) | Mar 2026 |
| 5 | Azure Maps | [azure.microsoft.com/en-us/pricing/details/azure-maps/](https://azure.microsoft.com/en-us/pricing/details/azure-maps/) | Mar 2026 |
| 6 | Azure AI Speech Service | [azure.microsoft.com/en-us/pricing/details/cognitive-services/speech-services/](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/speech-services/) | Mar 2026 |
| 7 | Microsoft Purview | [azure.microsoft.com/en-us/pricing/details/purview/](https://azure.microsoft.com/en-us/pricing/details/purview/) | Mar 2026 |
| 8 | Azure App Service | [azure.microsoft.com/en-us/pricing/details/app-service/linux/](https://azure.microsoft.com/en-us/pricing/details/app-service/linux/) | Mar 2026 |
| 9 | Azure Functions | [azure.microsoft.com/en-us/pricing/details/functions/](https://azure.microsoft.com/en-us/pricing/details/functions/) | Mar 2026 |
| 10 | Virtual Machines (Linux) | [azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/) | Mar 2026 |
| 11 | Azure Event Hubs | [azure.microsoft.com/en-us/pricing/details/event-hubs/](https://azure.microsoft.com/en-us/pricing/details/event-hubs/) | Mar 2026 |
| 12 | Azure Storage (Blob) | [azure.microsoft.com/en-us/pricing/details/storage/blobs/](https://azure.microsoft.com/en-us/pricing/details/storage/blobs/) | Mar 2026 |
| 13 | Azure Bastion | [azure.microsoft.com/en-us/pricing/details/azure-bastion/](https://azure.microsoft.com/en-us/pricing/details/azure-bastion/) | Mar 2026 |
| 14 | Azure DNS & DNS Private Resolver | [azure.microsoft.com/en-us/pricing/details/dns/](https://azure.microsoft.com/en-us/pricing/details/dns/) | Mar 2026 |
| 15 | Azure Private Link / Private Endpoint | [azure.microsoft.com/en-us/pricing/details/private-link/](https://azure.microsoft.com/en-us/pricing/details/private-link/) | Mar 2026 |
| 16 | Azure ExpressRoute | [azure.microsoft.com/en-us/pricing/details/expressroute/](https://azure.microsoft.com/en-us/pricing/details/expressroute/) | Mar 2026 |
| 17 | Azure Front Door | [azure.microsoft.com/en-us/pricing/details/frontdoor/](https://azure.microsoft.com/en-us/pricing/details/frontdoor/) | Mar 2026 |
| 18 | Azure Monitor (Log Analytics & App Insights) | [azure.microsoft.com/en-us/pricing/details/monitor/](https://azure.microsoft.com/en-us/pricing/details/monitor/) | Mar 2026 |
| 19 | Azure Key Vault | [azure.microsoft.com/en-us/pricing/details/key-vault/](https://azure.microsoft.com/en-us/pricing/details/key-vault/) | Mar 2026 |

### Government Availability & Comparison

| # | Document | Source URL | Accessed |
|---|---|---|---|
| 20 | Compare Azure Government and global Azure | [learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure) | Mar 2026 |
| 21 | Products available by region (Gov filter) | [azure.microsoft.com/en-us/explore/global-infrastructure/geographies/](https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/) | Mar 2026 |
| 22 | Azure OpenAI in Azure Government | [learn.microsoft.com/en-us/azure/ai-services/openai/azure-government](https://learn.microsoft.com/en-us/azure/ai-services/openai/azure-government) | Mar 2026 |
| 23 | Speech service in sovereign clouds | [learn.microsoft.com/en-us/azure/ai-services/speech-service/sovereign-clouds](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/sovereign-clouds) | Mar 2026 |
| 24 | Azure Private Endpoint DNS configuration (Gov) | [learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#government](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#government) | Mar 2026 |
| 25 | Azure Private Link availability | [learn.microsoft.com/en-us/azure/private-link/availability](https://learn.microsoft.com/en-us/azure/private-link/availability) | Mar 2026 |
| 26 | ExpressRoute BGP communities in National Clouds | [learn.microsoft.com/en-us/azure/expressroute/expressroute-routing#bgp-community-support-in-national-clouds](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-routing#bgp-community-support-in-national-clouds) | Mar 2026 |

### Pricing Tools

| # | Tool | URL |
|---|---|---|
| 27 | Azure Pricing Calculator (select Gov regions) | [azure.microsoft.com/en-us/pricing/calculator/](https://azure.microsoft.com/en-us/pricing/calculator/) |
| 28 | Azure Government Portal | [portal.azure.us](https://portal.azure.us) |
