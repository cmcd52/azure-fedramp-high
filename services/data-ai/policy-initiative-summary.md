# Data & AI Services — Policy Initiative Summary

> **Version**: 1.0.0 | **Date**: 2026-03-27 | **FR**: FR-007

## Custom Initiatives

| Service | Initiative | Scope | Policy Count |
|---------|-----------|-------|-------------|
| Azure OpenAI | openai-fedramp-high | AI subscription | 3 |
| Azure AI Search | aisearch-fedramp-high | AI subscription | 3 |
| Azure AI Foundry | aifoundry-fedramp-high | AI subscription | 3 |
| Document Intelligence | docintel-fedramp-high | AI subscription | 2 |
| Azure Maps | maps-fedramp-high | App subscription | 2 |
| Azure Purview | purview-fedramp-high | Governance subscription | 3 |
| AI Speech Service | speech-fedramp-high | AI subscription | 2 |
| Event Hubs | eventhubs-fedramp-high | Data subscription | 3 |

### Common AI Service Pattern

Most Cognitive Services / AI services follow a 3-policy pattern (OpenAI, AI Search, AI Foundry, Purview, Event Hubs). Speech Service, Document Intelligence, and Maps use a 2-policy variant:

**3-Policy Pattern** (OpenAI, AI Search, AI Foundry, Purview, Event Hubs):

| # | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
|---|--------|---------------|----------------|-------------|
| 1 | deny-{service}-public-access | Deny | Audit | SC-7 |
| 2 | audit-{service}-managed-identity | Audit | Audit | IA-2, IA-5 |
| 3 | audit/deny-{service}-{additional} | Varies | Varies | Varies |

**2-Policy Pattern** (Speech Service, Document Intelligence, Maps):

| # | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
|---|--------|---------------|----------------|-------------|
| 1 | deny-{service}-public-access | Deny | Audit | SC-7 |
| 2 | audit-{service}-managed-identity | Audit | Audit | IA-2, IA-5 |

### Azure Maps (Exception — 2 Policies Only)

| # | Policy | Effect | NIST Control | Note |
|---|--------|--------|-------------|------|
| 1 | audit-maps-managed-identity | Audit | IA-2, IA-5 | Managed identity enforcement |
| 2 | audit-maps-cors-restrictions | Audit | SC-7 | CORS restriction auditing |

> **Note**: Azure Maps lacks Private Endpoint support. Compensating controls documented in [controls/baseline.md](azure-maps/controls/baseline.md).

### Event Hubs

| # | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
|---|--------|---------------|----------------|-------------|
| 1 | deny-eventhubs-public-access | Deny | Audit | SC-7 |
| 2 | deny-eventhubs-local-auth | Deny | Audit | IA-2, IA-5 |
| 3 | audit-eventhubs-diagnostic-settings | AuditIfNotExists | AuditIfNotExists | AU-2, AU-12 |

## Built-In Policy References

| Service | Built-In Policy | NIST Control |
|---------|----------------|-------------|
| Cognitive Services (shared) | Cognitive Services should disable public network access | SC-7 |
| Cognitive Services (shared) | Cognitive Services should use private link | SC-7 |
| Cognitive Services (shared) | Cognitive Services should use CMK | SC-13, SC-28 |
| AI Search | Azure Cognitive Search should use private link | SC-7 |
| Event Hubs | Event Hub namespaces should use private link | SC-7 |
| Event Hubs | Event Hub should use CMK for encryption | SC-13, SC-28 |
| Purview | Azure Purview should use private link | SC-7 |

## Assignment Strategy

- **AI Subscription**: OpenAI, AI Search, AI Foundry, Document Intelligence, Speech initiatives
- **App Subscription**: Maps initiative
- **Governance Subscription**: Purview initiative
- **Data Subscription**: Event Hubs initiative
- **Exemption Process**: Per organizational policy lifecycle governance

---

*Data & AI Services — Azure Policy compliance artifacts.*
