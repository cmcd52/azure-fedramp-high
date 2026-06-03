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


## Wave 2 (Pending Approval)

_Generated 2026-04-28 by `scripts/wave2/generate.py`. Each row is **** per FedRAMP High compliance baseline._

| Initiative | Service | NIST Families | Path |
|---|---|---|---|
| `fedramp-high-ai-services-umbrella-v1` | Azure AI Services (Umbrella) | AC, SC, AU | [policies/](./ai-services-umbrella/policies/) |
| `fedramp-high-analysis-services-v1` | Azure Analysis Services | AC, SC, AU | [policies/](./analysis-services/policies/) |
| `fedramp-high-cosmos-db-v1` | Azure Cosmos DB | AC, SC, AU, IR, CP | [policies/](./cosmos-db/policies/) |
| `fedramp-high-data-factory-v1` | Azure Data Factory | AC, SC, AU | [policies/](./data-factory/policies/) |
| `fedramp-high-data-share-v1` | Azure Data Share | AC, AU | [policies/](./data-share/policies/) |
| `fedramp-high-databricks-v1` | Azure Databricks | AC, SC, AU | [policies/](./databricks/policies/) |
| `fedramp-high-fabric-v1` | Microsoft Fabric | AC, AU | [policies/](./fabric/policies/) |
| `fedramp-high-hdinsight-v1` | Azure HDInsight | AC, SC, AU | [policies/](./hdinsight/policies/) |
| `fedramp-high-machine-learning-v1` | Azure Machine Learning | AC, SC, AU | [policies/](./machine-learning/policies/) |
| `fedramp-high-mysql-flexible-v1` | Azure Database for MySQL Flexible Server | AC, SC, AU, IR | [policies/](./mysql-flexible/policies/) |
| `fedramp-high-postgresql-flexible-v1` | Azure Database for PostgreSQL Flexible Server | AC, SC, AU, IR | [policies/](./postgresql-flexible/policies/) |
| `fedramp-high-powerbi-embedded-v1` | Power BI Embedded | AC, AU | [policies/](./powerbi-embedded/policies/) |
| `fedramp-high-redis-cache-v1` | Azure Cache for Redis | AC, SC, AU | [policies/](./redis-cache/policies/) |
| `fedramp-high-redis-enterprise-v1` | Azure Cache for Redis Enterprise | AC, SC, AU | [policies/](./redis-enterprise/policies/) |
| `fedramp-high-sql-database-v1` | Azure SQL Database | AC, SC, AU, IR | [policies/](./sql-database/policies/) |
| `fedramp-high-sql-managed-instance-v1` | Azure SQL Managed Instance | AC, SC, AU, IR | [policies/](./sql-managed-instance/policies/) |
| `fedramp-high-sql-server-logical-v1` | Azure SQL Server (Logical) | AC, SC, AU, IA | [policies/](./sql-server-logical/policies/) |
| `fedramp-high-stream-analytics-v1` | Azure Stream Analytics | AC, SC, AU | [policies/](./stream-analytics/policies/) |
| `fedramp-high-synapse-v1` | Azure Synapse Analytics | AC, SC, AU, IR | [policies/](./synapse/policies/) |
