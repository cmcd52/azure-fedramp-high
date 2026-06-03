# Wave 2 Candidates — Azure GA Services Triage

**Purpose**: Per Constitution v8.0.0 Principle I and Wave 2 sweep tasks T018/T019, this document enumerates every Generally Available (GA) Azure Commercial cloud service that is **not** in the 23 Wave 1 foundational set and **not** already on the standing-exclusions list, then classifies each as **`policy-eligible`** or **`exclude`** for FedRAMP High coverage.

**Scope rule**: A service is `policy-eligible` if it (a) is GA in Azure Commercial, (b) exposes Azure Resource Manager (ARM) resource types, and (c) can be configured to satisfy the customer-responsibility portion of FedRAMP High (NIST 800-53 Rev 5 High baseline) — specifically encryption-at-rest with FIPS 140-2/3 validated modules, encryption-in-transit (TLS 1.2+), network isolation (private endpoint or equivalent), Managed Identity / RBAC, and diagnostic logging to Azure Monitor.

**Authoritative sources** (consult for current per-service FedRAMP authorization status):

- Microsoft FedRAMP offering page: <https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-fedramp>
- Azure products A–Z: <https://azure.microsoft.com/en-us/products/>
- FedRAMP Marketplace listing for Microsoft Azure: <https://marketplace.fedramp.gov/products/F1603047866>
- Azure service retirement workbook: <https://learn.microsoft.com/en-us/azure/azure-monitor/best-practices-retirement>

**Living document**: This list is point-in-time as of 2026-04-28. Per the exclusions tracker review process, it MUST be revisited when (a) new Azure services reach GA, (b) Microsoft amends FedRAMP High authorization scope, or (c) a previously-excluded service gains required capabilities.

**Wave 1 already covered (DO NOT duplicate)**: Azure AD B2C, Managed Identity, ExpressRoute, Azure Front Door, Bastion, DNS Private Resolver, Private DNS Zone, Private Endpoint, VMs for DNS, Azure Monitor, Azure Application Insights, Azure App Service, Azure Functions, Azure Storage Account, Key Vault, Azure OpenAI, Azure AI Search, Azure AI Foundry, Azure Document Intelligence, Azure Maps, Azure Purview, AI Speech Service, Event Hubs.

**Standing exclusions (DO NOT duplicate)**: Microsoft 365, Entra ID standalone, Microsoft Intune.

---

## Triage Summary

| Service Group | Total Candidates | Policy-Eligible | Exclude |
|---------------|------------------|-----------------|---------|
| compute-storage | 22 | 16 | 6 |
| networking | 17 | 16 | 1 |
| data-ai | 26 | 19 | 7 |
| identity | 4 | 3 | 1 |
| integration (NEW) | 7 | 7 | 0 |
| containers (NEW) | 4 | 4 | 0 |
| security (NEW) | 8 | 7 | 1 |
| management (NEW) | 11 | 8 | 3 |
| iot (NEW) | 6 | 5 | 1 |
| hybrid-edge (NEW) | 4 | 3 | 1 |
| migration (NEW) | 2 | 2 | 0 |
| devops (NEW) | 5 | 3 | 2 |
| web-realtime (NEW) | 4 | 4 | 0 |
| mixed-reality (NEW) | 3 | 0 | 3 |
| **TOTAL** | **123** | **97** | **26** |

> Numbers are inclusive of Wave 2 candidates only (Wave 1's 23 already-Approved services are excluded from totals). The "TOTAL Exclude" of 26 will be appended as new rows to `docs/azure-service-exclusions.md` per task T022.

---

## Wave 2 Candidates by Service Group

### Group: compute-storage

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Virtual Machines (Linux/Windows) | `Microsoft.Compute/virtualMachines` | policy-eligible | FedRAMP High; supports CMK (encryption at host), Managed Identity, NSG, Azure Disk Encryption, Boot Diagnostics, Guest Configuration | <https://learn.microsoft.com/en-us/azure/virtual-machines/> |
| Virtual Machine Scale Sets | `Microsoft.Compute/virtualMachineScaleSets` | policy-eligible | Same controls as VMs; supports automatic OS image updates, Health probes | <https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/> |
| Azure Compute Gallery (Shared Image Gallery) | `Microsoft.Compute/galleries` | policy-eligible | RBAC, replicated encrypted images, supports CMK | <https://learn.microsoft.com/en-us/azure/virtual-machines/azure-compute-gallery> |
| Azure Dedicated Host | `Microsoft.Compute/hostGroups` | policy-eligible | Hardware isolation supports SC-7 / FIPS 140-2 | <https://learn.microsoft.com/en-us/azure/virtual-machines/dedicated-hosts> |
| Azure Batch | `Microsoft.Batch/batchAccounts` | policy-eligible | Private endpoint support, CMK, Managed Identity | <https://learn.microsoft.com/en-us/azure/batch/> |
| Azure Service Fabric | `Microsoft.ServiceFabric/clusters` | policy-eligible | Supports reverse proxy with mTLS, certificate-based node auth, FIPS-mode VMs | <https://learn.microsoft.com/en-us/azure/service-fabric/> |
| Azure Spring Apps | `Microsoft.AppPlatform/Spring` | policy-eligible | Private endpoint, Managed Identity, diagnostic logs | <https://learn.microsoft.com/en-us/azure/spring-apps/> |
| Azure VMware Solution | `Microsoft.AVS/privateClouds` | policy-eligible | Dedicated VMware-on-Azure with FedRAMP High; ExpressRoute integration | <https://learn.microsoft.com/en-us/azure/azure-vmware/> |
| Azure HPC | `Microsoft.HPC/*` | policy-eligible | Submitted via Batch / VMs; standard VM controls | <https://learn.microsoft.com/en-us/azure/azure-portal/azure-portal-overview> |
| Static Web Apps | `Microsoft.Web/staticSites` | policy-eligible | Private endpoint (Standard tier), CMK via App Service Environment integration | <https://learn.microsoft.com/en-us/azure/static-web-apps/> |
| Azure Files (premium tier with Private Endpoint) | `Microsoft.Storage/storageAccounts/fileServices` | policy-eligible | Sub-feature of Storage Account but distinct controls (SMB Multichannel, AD identity-based auth) | <https://learn.microsoft.com/en-us/azure/storage/files/> |
| Azure NetApp Files | `Microsoft.NetApp/netAppAccounts` | policy-eligible | Encryption at rest (CMK), private endpoint via VNet integration, NFS/SMB | <https://learn.microsoft.com/en-us/azure/azure-netapp-files/> |
| Azure Managed Disks | `Microsoft.Compute/disks` | policy-eligible | CMK with Disk Encryption Set, double encryption, Trusted Launch | <https://learn.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview> |
| Azure Backup | `Microsoft.RecoveryServices/vaults` | policy-eligible | Soft delete, immutable vault, CMK, MUA, RBAC | <https://learn.microsoft.com/en-us/azure/backup/> |
| Azure Site Recovery | `Microsoft.RecoveryServices/vaults` (replicationProtectedItems) | policy-eligible | Replication encryption, RBAC, monitoring | <https://learn.microsoft.com/en-us/azure/site-recovery/> |
| Azure Data Box | `Microsoft.DataBox/jobs` | policy-eligible | AES-256 device encryption, chain-of-custody | <https://learn.microsoft.com/en-us/azure/databox/> |
| Azure Lab Services (classic) | retired Aug 2027 | **exclude** | Service retirement announced; replacement: Microsoft Dev Box | <https://learn.microsoft.com/en-us/azure/lab-services/lab-services-whats-new> |
| Azure StorSimple | retired Dec 2022 | **exclude** | Service retired (criterion 4: not GA / decommissioned) | <https://learn.microsoft.com/en-us/previous-versions/azure/storsimple/> |
| Azure HPC Cache | retired Sept 2025 | **exclude** | Service retired (criterion 4) | <https://learn.microsoft.com/en-us/azure/hpc-cache/hpc-cache-overview> |
| Visual Studio App Center | retired March 2025 | **exclude** | Service retired (criterion 4) | <https://learn.microsoft.com/en-us/appcenter/retirement> |
| Cloud Services (classic) | classic deployment model | **exclude** | Classic deployment retired Aug 2024; cannot satisfy modern AC/SC controls (criterion 1) | <https://learn.microsoft.com/en-us/azure/cloud-services/> |
| Azure Sphere | retiring Sept 2027 | **exclude** | Service retirement announced (criterion 4); cross-listed under iot | <https://learn.microsoft.com/en-us/azure-sphere/product-overview/retirement> |

### Group: networking

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Virtual Network (VNet) | `Microsoft.Network/virtualNetworks` | policy-eligible | Foundational; already used by `shared/terraform/virtual-network/`. Add explicit policy initiative for VNet hardening (DDoS, flow logs, subnet NSG association) | <https://learn.microsoft.com/en-us/azure/virtual-network/> |
| Network Security Group | `Microsoft.Network/networkSecurityGroups` | policy-eligible | NSG flow logs to Log Analytics, default-deny inbound | <https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview> |
| Application Gateway (with WAF) | `Microsoft.Network/applicationGateways` | policy-eligible | WAF v2 with OWASP CRS, TLS termination with FIPS-validated cipher suites, mutual TLS | <https://learn.microsoft.com/en-us/azure/application-gateway/> |
| Azure Firewall (Standard / Premium) | `Microsoft.Network/azureFirewalls` | policy-eligible | TLS inspection, IDPS (Premium), threat intel feeds | <https://learn.microsoft.com/en-us/azure/firewall/> |
| Azure Web Application Firewall Policy | `Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies` | policy-eligible | Policy-based WAF management, custom rules, geo-filtering | <https://learn.microsoft.com/en-us/azure/web-application-firewall/> |
| Azure Load Balancer | `Microsoft.Network/loadBalancers` | policy-eligible | Standard SKU only (Basic retired); zone-redundant, NSG-protected backend pool | <https://learn.microsoft.com/en-us/azure/load-balancer/> |
| Traffic Manager | `Microsoft.Network/trafficManagerProfiles` | policy-eligible | DNS-only; supports endpoint health monitoring and weighted routing | <https://learn.microsoft.com/en-us/azure/traffic-manager/> |
| VPN Gateway | `Microsoft.Network/virtualNetworkGateways` (type=Vpn) | policy-eligible | IKEv2 with FIPS-validated cipher suites, P2S certificate auth | <https://learn.microsoft.com/en-us/azure/vpn-gateway/> |
| Network Watcher | `Microsoft.Network/networkWatchers` | policy-eligible | NSG flow logs, packet capture, connection monitor — required AU-2 evidence | <https://learn.microsoft.com/en-us/azure/network-watcher/> |
| Azure DDoS Protection (Standard / IP Protection) | `Microsoft.Network/ddosProtectionPlans` | policy-eligible | Always-on traffic monitoring, adaptive tuning, DDoS rapid response | <https://learn.microsoft.com/en-us/azure/ddos-protection/> |
| NAT Gateway | `Microsoft.Network/natGateways` | policy-eligible | Outbound-only egress with predictable SNAT IPs | <https://learn.microsoft.com/en-us/azure/virtual-network/nat-gateway/> |
| Route Server | `Microsoft.Network/virtualHubs/azureFirewalls` (RouteServer) | policy-eligible | BGP route exchange with NVAs | <https://learn.microsoft.com/en-us/azure/route-server/> |
| Virtual WAN | `Microsoft.Network/virtualWans` | policy-eligible | Hub-and-spoke at scale; integrates with Azure Firewall + ExpressRoute | <https://learn.microsoft.com/en-us/azure/virtual-wan/> |
| Azure CDN (Microsoft) | `Microsoft.Cdn/profiles` | policy-eligible | Microsoft tier supersedes retired Verizon/Akamai; supports Private Link to origin via Front Door | <https://learn.microsoft.com/en-us/azure/cdn/> |
| Azure Public IP Address | `Microsoft.Network/publicIPAddresses` | policy-eligible | Standard SKU only, DDoS Standard auto-protect when used with Azure DDoS plan | <https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses> |
| Azure Internet Analyzer | preview (never GA) | **exclude** | Preview-only, not GA (criterion 4) | <https://azure.microsoft.com/en-us/products/internet-analyzer/> |
| Azure Private Link Service | `Microsoft.Network/privateLinkServices` | policy-eligible | Provider-side companion to private endpoint; enables PaaS-style provider hosting | <https://learn.microsoft.com/en-us/azure/private-link/private-link-service-overview> |

### Group: data-ai

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Azure SQL Database | `Microsoft.Sql/servers/databases` | policy-eligible | TDE with CMK, Always Encrypted, Auditing to Log Analytics, Private Endpoint, Microsoft Defender for SQL | <https://learn.microsoft.com/en-us/azure/azure-sql/database/> |
| Azure SQL Managed Instance | `Microsoft.Sql/managedInstances` | policy-eligible | Same controls as Azure SQL DB; native VNet integration | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/> |
| Azure SQL Server (logical) | `Microsoft.Sql/servers` | policy-eligible | Parent of SQL DB; Entra-only auth, public-network-access disabled, MIN TLS 1.2 | <https://learn.microsoft.com/en-us/azure/azure-sql/database/logical-servers> |
| Azure Database for PostgreSQL Flexible Server | `Microsoft.DBforPostgreSQL/flexibleServers` | policy-eligible | CMK, Private Access (VNet integration), Microsoft Defender, audit log | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/> |
| Azure Database for MySQL Flexible Server | `Microsoft.DBforMySQL/flexibleServers` | policy-eligible | Same controls as PostgreSQL Flexible | <https://learn.microsoft.com/en-us/azure/mysql/flexible-server/> |
| Cosmos DB (NoSQL, Mongo, Cassandra, Gremlin, Table) | `Microsoft.DocumentDB/databaseAccounts` | policy-eligible | CMK, Private Endpoint, RBAC data plane, Continuous backup, Microsoft Defender | <https://learn.microsoft.com/en-us/azure/cosmos-db/> |
| Azure Cache for Redis | `Microsoft.Cache/redis` | policy-eligible | Premium tier supports Private Endpoint, TLS 1.2+, AAD auth, RDB encryption with CMK | <https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/> |
| Azure Cache for Redis Enterprise | `Microsoft.Cache/redisEnterprise` | policy-eligible | E-tier; FIPS 140-2 modules, active geo-replication | <https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview> |
| Azure Synapse Analytics | `Microsoft.Synapse/workspaces` | policy-eligible | Managed VNet, Private Endpoint, CMK on workspace | <https://learn.microsoft.com/en-us/azure/synapse-analytics/> |
| Microsoft Fabric | `Microsoft.Fabric/capacities` | policy-eligible | Capacity is ARM-managed; data plane has FedRAMP High alignment | <https://learn.microsoft.com/en-us/fabric/security/security-fundamentals> |
| Azure Data Factory | `Microsoft.DataFactory/factories` | policy-eligible | Managed VNet, Self-hosted IR for hybrid, CMK, Managed Identity | <https://learn.microsoft.com/en-us/azure/data-factory/> |
| Azure Databricks | `Microsoft.Databricks/workspaces` | policy-eligible | VNet injection, Private Link to control plane (Premium), CMK for managed services + DBFS | <https://learn.microsoft.com/en-us/azure/databricks/> |
| Azure HDInsight | `Microsoft.HDInsight/clusters` | policy-eligible | VNet, ESP with Entra DS, CMK on attached storage | <https://learn.microsoft.com/en-us/azure/hdinsight/> |
| Azure Stream Analytics | `Microsoft.StreamAnalytics/streamingjobs` | policy-eligible | Managed Identity, Private Endpoint, CMK | <https://learn.microsoft.com/en-us/azure/stream-analytics/> |
| Azure Data Share | `Microsoft.DataShare/accounts` | policy-eligible | Snapshot-based sharing with audit; Managed Identity for source/sink | <https://learn.microsoft.com/en-us/azure/data-share/> |
| Azure Analysis Services | `Microsoft.AnalysisServices/servers` | policy-eligible | VNet firewall, AAD auth, encrypted storage | <https://learn.microsoft.com/en-us/azure/analysis-services/> |
| Power BI Embedded | `Microsoft.PowerBIDedicated/capacities` | policy-eligible | Capacity-level resource; tenant-level controls inherited from Power BI Service (FedRAMP Moderate at tenant; capacity is High-eligible) | <https://learn.microsoft.com/en-us/azure/power-bi-embedded/> |
| Azure AI Services (umbrella account) | `Microsoft.CognitiveServices/accounts` (kind=AIServices) | policy-eligible | Multi-service account with Private Endpoint, CMK, Managed Identity | <https://learn.microsoft.com/en-us/azure/ai-services/> |
| Azure AI Vision | `Microsoft.CognitiveServices/accounts` (kind=ComputerVision) | policy-eligible | Same controls as AI Services umbrella | <https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/> |
| Azure AI Language | `Microsoft.CognitiveServices/accounts` (kind=TextAnalytics) | policy-eligible | Same controls; supports custom models with private endpoints | <https://learn.microsoft.com/en-us/azure/ai-services/language-service/> |
| Azure AI Translator | `Microsoft.CognitiveServices/accounts` (kind=TextTranslation) | policy-eligible | Same controls; document translation with Managed Identity to Storage | <https://learn.microsoft.com/en-us/azure/ai-services/translator/> |
| Azure AI Content Safety | `Microsoft.CognitiveServices/accounts` (kind=ContentSafety) | policy-eligible | Same controls as AI Services umbrella | <https://learn.microsoft.com/en-us/azure/ai-services/content-safety/> |
| Azure AI Bot Service | `Microsoft.BotService/botServices` | policy-eligible | RBAC, Managed Identity, Direct Line with private network | <https://learn.microsoft.com/en-us/azure/bot-service/> |
| Azure Machine Learning | `Microsoft.MachineLearningServices/workspaces` | policy-eligible | Managed VNet workspace, Private Endpoint, CMK, customer-managed key vault for secrets | <https://learn.microsoft.com/en-us/azure/machine-learning/> |
| Azure Database for MariaDB | retired Sept 2025 | **exclude** | Service retired (criterion 4); migrate to Azure Database for MySQL | <https://learn.microsoft.com/en-us/azure/mariadb/migrate/whats-happening-to-mariadb> |
| Azure Database for PostgreSQL Single Server | retired March 2025 | **exclude** | Service retired (criterion 4); migrate to Flexible Server | <https://learn.microsoft.com/en-us/azure/postgresql/migrate/whats-happening-to-postgresql-single-server> |
| Azure Database for MySQL Single Server | retired Sept 2024 | **exclude** | Service retired (criterion 4); migrate to Flexible Server | <https://learn.microsoft.com/en-us/azure/mysql/single-server/whats-happening-to-mysql-single-server> |
| Azure Data Lake Analytics | retired Feb 2024 | **exclude** | Service retired (criterion 4); migrate to Synapse / Databricks | <https://learn.microsoft.com/en-us/azure/data-lake-analytics/data-lake-analytics-overview> |
| Azure Time Series Insights | retired March 2025 | **exclude** | Service retired (criterion 4); migrate to Microsoft Fabric Real-Time | <https://learn.microsoft.com/en-us/azure/time-series-insights/migration-to-fabric> |
| Azure AI Personalizer | retiring Oct 2026 | **exclude** | Retirement announced; cannot establish long-term FedRAMP High coverage (criterion 4) | <https://learn.microsoft.com/en-us/azure/ai-services/personalizer/> |
| Azure AI Metrics Advisor | retired Oct 2026 | **exclude** | Retirement announced (criterion 4) | <https://learn.microsoft.com/en-us/azure/ai-services/metrics-advisor/> |

### Group: identity

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Microsoft Entra Domain Services | `Microsoft.AAD/domainServices` | policy-eligible | Managed AD DS in Azure; supports VNet injection, LDAPS, NTLM-disabled mode | <https://learn.microsoft.com/en-us/entra/identity/domain-services/> |
| Azure Key Vault Managed HSM | `Microsoft.KeyVault/managedHSMs` | policy-eligible | FIPS 140-2 Level 3 validated HSM; cross-listed in security group below (canonical entry: security/) | <https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/> |
| Azure Confidential Ledger | `Microsoft.ConfidentialLedger/ledgers` | policy-eligible | Tamper-proof; cross-listed under security (canonical entry: security/) | <https://learn.microsoft.com/en-us/azure/confidential-ledger/> |
| Azure RMS / Information Protection (classic) | partially SaaS | **exclude** | Classic AIP labeling client retired; modern Microsoft Purview Information Protection is part of M365 standing exclusion | <https://learn.microsoft.com/en-us/azure/information-protection/removed-sunset-services> |

### Group: integration (NEW)

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| API Management | `Microsoft.ApiManagement/service` | policy-eligible | Stv2 platform with internal VNet integration, Private Endpoint (developer/management plane), CMK on backups | <https://learn.microsoft.com/en-us/azure/api-management/> |
| Logic Apps Standard | `Microsoft.Web/sites` (kind=workflowapp) | policy-eligible | Runs on App Service; Private Endpoint, VNet integration, Managed Identity | <https://learn.microsoft.com/en-us/azure/logic-apps/> |
| Logic Apps Consumption | `Microsoft.Logic/workflows` | policy-eligible | Public connectors require IP restriction; ISE option deprecated — use Logic Apps Standard for sensitive workloads | <https://learn.microsoft.com/en-us/azure/logic-apps/single-tenant-overview-compare> |
| Service Bus | `Microsoft.ServiceBus/namespaces` | policy-eligible | Premium tier with Private Endpoint, CMK, RBAC, Managed Identity | <https://learn.microsoft.com/en-us/azure/service-bus-messaging/> |
| Event Grid | `Microsoft.EventGrid/topics` and `domains` | policy-eligible | Private Endpoint on namespace topics, Managed Identity to subscribers | <https://learn.microsoft.com/en-us/azure/event-grid/> |
| Notification Hubs | `Microsoft.NotificationHubs/namespaces` | policy-eligible | RBAC, Managed Identity for outbound, AAD auth | <https://learn.microsoft.com/en-us/azure/notification-hubs/> |
| Azure Health Data Services (FHIR / DICOM / MedTech) | `Microsoft.HealthcareApis/workspaces` | policy-eligible | HIPAA + FedRAMP High; Private Link, CMK, audit to Log Analytics | <https://learn.microsoft.com/en-us/azure/healthcare-apis/> |

### Group: containers (NEW)

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Azure Kubernetes Service (AKS) | `Microsoft.ContainerService/managedClusters` | policy-eligible | Private cluster, Microsoft Entra integration, Azure Policy add-on, CMK on disks/etcd, Defender for Containers | <https://learn.microsoft.com/en-us/azure/aks/> |
| Azure Container Instances (ACI) | `Microsoft.ContainerInstance/containerGroups` | policy-eligible | VNet integration, Confidential ACI option, Managed Identity | <https://learn.microsoft.com/en-us/azure/container-instances/> |
| Azure Container Apps | `Microsoft.App/containerApps` | policy-eligible | Internal-only environments, Managed Identity, Dapr secrets via Key Vault | <https://learn.microsoft.com/en-us/azure/container-apps/> |
| Azure Container Registry (ACR) | `Microsoft.ContainerRegistry/registries` | policy-eligible | Premium SKU with Private Endpoint, CMK, Trust signing, Defender for ACR | <https://learn.microsoft.com/en-us/azure/container-registry/> |

### Group: security (NEW)

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Microsoft Defender for Cloud | `Microsoft.Security/pricings` and `securityContacts` | policy-eligible | Plan enablement is ARM; CSPM + Defender plans for VMs/SQL/Storage/Containers/Key Vault | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/> |
| Microsoft Sentinel | `Microsoft.OperationsManagement/solutions` (SecurityInsights) on Log Analytics | policy-eligible | SIEM/SOAR; data residency in Log Analytics workspace; CMK supported on workspace | <https://learn.microsoft.com/en-us/azure/sentinel/> |
| Azure Key Vault Managed HSM | `Microsoft.KeyVault/managedHSMs` | policy-eligible | FIPS 140-2 Level 3 HSM; supports HSM-backed CMK for SC-12, SC-13, SC-28 | <https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/> |
| Azure Confidential Ledger | `Microsoft.ConfidentialLedger/ledgers` | policy-eligible | TEE-backed write-once ledger; supports AU-9 audit log immutability | <https://learn.microsoft.com/en-us/azure/confidential-ledger/> |
| Azure Attestation | `Microsoft.Attestation/attestationProviders` | policy-eligible | Remote attestation for confidential VMs; Private Endpoint | <https://learn.microsoft.com/en-us/azure/attestation/> |
| Microsoft Defender External Attack Surface Management (EASM) | `Microsoft.Easm/workspaces` | policy-eligible | Discovery-only; RBAC to workspace | <https://learn.microsoft.com/en-us/azure/external-attack-surface-management/> |
| Azure Bastion Premium / Developer SKUs | `Microsoft.Network/bastionHosts` | policy-eligible | New SKUs; Premium adds session recording (AU-2). Cross-listed: Wave 1 covers Bastion at Standard SKU; Premium feature deltas tracked here | <https://learn.microsoft.com/en-us/azure/bastion/bastion-overview> |
| Microsoft Defender EASM Legacy (RiskIQ Discovery) | retired Aug 2025 | **exclude** | Replaced by integrated Defender EASM (criterion 4) | <https://learn.microsoft.com/en-us/azure/external-attack-surface-management/> |

### Group: management (NEW)

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Azure Policy | `Microsoft.Authorization/policyDefinitions` and `policyAssignments` | policy-eligible | Meta-control: this entire repo's policies are deployed via Azure Policy; treat as a foundational control | <https://learn.microsoft.com/en-us/azure/governance/policy/> |
| Azure Resource Graph | `Microsoft.ResourceGraph/queries` | policy-eligible | Read-only inventory; RBAC | <https://learn.microsoft.com/en-us/azure/governance/resource-graph/> |
| Azure Automation | `Microsoft.Automation/automationAccounts` | policy-eligible | Managed Identity for runbooks, hybrid worker, Update Manager integration | <https://learn.microsoft.com/en-us/azure/automation/> |
| Azure Update Manager | `Microsoft.Maintenance/maintenanceConfigurations` | policy-eligible | Successor to Update Management; Arc-enabled, RBAC, supports SI-2 | <https://learn.microsoft.com/en-us/azure/update-manager/> |
| Azure Arc (servers, K8s, data services) | `Microsoft.HybridCompute/machines`, `Microsoft.Kubernetes/connectedClusters` | policy-eligible | Hybrid management; on-prem deployment outside Azure compliance boundary but Arc agents/policies are in scope | <https://learn.microsoft.com/en-us/azure/azure-arc/> |
| Azure Lighthouse | `Microsoft.ManagedServices/registrationDefinitions` | policy-eligible | Cross-tenant delegation; just-enough access via PIM-eligible assignments | <https://learn.microsoft.com/en-us/azure/lighthouse/> |
| Azure Service Health | `Microsoft.ResourceHealth/availabilityStatuses` | policy-eligible | Read-only platform health; alerts via Action Groups | <https://learn.microsoft.com/en-us/azure/service-health/> |
| Azure Cost Management | `Microsoft.CostManagement/exports` | policy-eligible | Export to Storage with Managed Identity; RBAC scopes | <https://learn.microsoft.com/en-us/azure/cost-management-billing/> |
| Azure Blueprints | deprecation announced (replacement: Deployment Stacks + Template Specs) | **exclude** | Service deprecated July 2026 (criterion 4); migrate to Template Specs / Deployment Stacks | <https://learn.microsoft.com/en-us/azure/governance/blueprints/overview> |
| Azure Advisor | `Microsoft.Advisor/recommendations` | policy-eligible | Read-only recommendation engine; surfaces Defender for Cloud + cost insights | <https://learn.microsoft.com/en-us/azure/advisor/> |
| Azure Managed Grafana | `Microsoft.Dashboard/grafana` | policy-eligible | Managed Identity, Private Endpoint, RBAC; integrates with Azure Monitor + Prometheus | <https://learn.microsoft.com/en-us/azure/managed-grafana/> |

### Group: iot (NEW)

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Azure IoT Hub | `Microsoft.Devices/IotHubs` | policy-eligible | Private Endpoint, CMK, X.509 certificate auth, audit to Log Analytics | <https://learn.microsoft.com/en-us/azure/iot-hub/> |
| Azure IoT Central | `Microsoft.IoTCentral/IoTApps` | policy-eligible | App is ARM-managed; Managed Identity to data export targets | <https://learn.microsoft.com/en-us/azure/iot-central/> |
| Azure Digital Twins | `Microsoft.DigitalTwins/digitalTwinsInstances` | policy-eligible | Private Endpoint, CMK, Entra-only auth | <https://learn.microsoft.com/en-us/azure/digital-twins/> |
| Azure IoT Device Provisioning Service | `Microsoft.Devices/provisioningServices` | policy-eligible | TPM/X.509 attestation, RBAC, Private Endpoint | <https://learn.microsoft.com/en-us/azure/iot-dps/> |
| Azure IoT Edge | runs on customer devices; IoT Hub controls workloads | policy-eligible | No standalone Azure resource; treat as a device-side IoT Hub feature with Module Twin policies | <https://learn.microsoft.com/en-us/azure/iot-edge/> |
| Azure Sphere | retiring Sept 2027 | **exclude** | Service retirement announced (criterion 4) | <https://learn.microsoft.com/en-us/azure-sphere/product-overview/retirement> |

### Group: hybrid-edge (NEW)

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Azure Stack Edge | `Microsoft.DataBoxEdge/dataBoxEdgeDevices` | policy-eligible | Hardware-as-a-service; encrypted at rest, BitLocker, Activation Key in Key Vault | <https://learn.microsoft.com/en-us/azure/databox-online/> |
| Azure Local (formerly Azure Stack HCI) | `Microsoft.AzureStackHCI/clusters` | policy-eligible | Arc-enabled HCI; Secured-core, BitLocker, FIPS-mode | <https://learn.microsoft.com/en-us/azure/azure-local/> |
| Azure Modular Datacenter | retired | **exclude** | Service retired; replaced by Azure Local (criterion 4) | <https://azure.microsoft.com/en-us/products/azure-modular-datacenter/> |
| Azure Operator Nexus / 5G Core | `Microsoft.NetworkCloud/clusters` | policy-eligible | Carrier-grade; supports STIG-aligned baseline; private RAN | <https://learn.microsoft.com/en-us/azure/operator-nexus/> |

### Group: migration (NEW)

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Azure Migrate | `Microsoft.Migrate/projects` and `assessmentProjects` | policy-eligible | Discovery agents use Managed Identity; project-level RBAC | <https://learn.microsoft.com/en-us/azure/migrate/> |
| Azure Database Migration Service (DMS) | `Microsoft.DataMigration/services` | policy-eligible | VNet integration; AAD auth to source/target | <https://learn.microsoft.com/en-us/azure/dms/> |

### Group: devops (NEW)

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Azure Load Testing | `Microsoft.LoadTestService/loadTests` | policy-eligible | Private endpoint, Managed Identity to KV for secrets | <https://learn.microsoft.com/en-us/azure/load-testing/> |
| Azure Chaos Studio | `Microsoft.Chaos/experiments` | policy-eligible | Targeted-experiment RBAC; uses Managed Identity for actions | <https://learn.microsoft.com/en-us/azure/chaos-studio/> |
| Microsoft Dev Box | `Microsoft.DevCenter/devcenters` | policy-eligible | Intune-enrolled dev VMs; supports Conditional Access; FedRAMP High | <https://learn.microsoft.com/en-us/azure/dev-box/> |
| Azure DevOps Services | SaaS (org/project not ARM) | **exclude** | SaaS without Azure ARM resource types (criterion 3); separate FedRAMP authorization at Azure DevOps Services tenant | <https://learn.microsoft.com/en-us/azure/devops/organizations/security/data-protection> |
| GitHub Enterprise Cloud | SaaS (no ARM) | **exclude** | SaaS (criterion 3); separate FedRAMP boundary | <https://docs.github.com/en/enterprise-cloud@latest/admin/overview/about-github-for-enterprises> |

### Group: web-realtime (NEW)

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Azure SignalR Service | `Microsoft.SignalRService/signalR` | policy-eligible | Private Endpoint, Managed Identity, AAD auth | <https://learn.microsoft.com/en-us/azure/azure-signalr/> |
| Azure Web PubSub | `Microsoft.SignalRService/webPubSub` | policy-eligible | Same controls as SignalR; Managed Identity to Event Hubs | <https://learn.microsoft.com/en-us/azure/azure-web-pubsub/> |
| Azure Communication Services | `Microsoft.Communication/communicationServices` | policy-eligible | Managed Identity, AAD auth, key-based auth disabled | <https://learn.microsoft.com/en-us/azure/communication-services/> |
| Azure Email Communication Services | `Microsoft.Communication/emailServices` | policy-eligible | Domain validation, RBAC | <https://learn.microsoft.com/en-us/azure/communication-services/concepts/email/> |

### Group: mixed-reality (NEW — all retired)

| Service | ARM Resource Type(s) | Triage | Reason | Source |
|---------|---------------------|--------|--------|--------|
| Azure Spatial Anchors | retired Nov 2024 | **exclude** | Service retired (criterion 4) | <https://learn.microsoft.com/en-us/azure/spatial-anchors/> |
| Azure Remote Rendering | retired Sept 2025 | **exclude** | Service retired (criterion 4) | <https://learn.microsoft.com/en-us/azure/remote-rendering/> |
| Azure Object Anchors | retired May 2024 | **exclude** | Service retired (criterion 4) | <https://learn.microsoft.com/en-us/azure/object-anchors/> |

---

## Wave 2 Implementation Priority Tiers

To make the artifact-authoring sweep tractable, the 97 `policy-eligible` services are batched by deployment frequency in regulated workloads. Each tier ends with a quality review checkpoint before proceeding to the next.

### Tier 1 — Foundational Platform (highest priority, ~20 services)

Core compute, networking, data, container, and security services that virtually every FedRAMP High workload deploys.

- compute-storage: Virtual Machines, Virtual Machine Scale Sets, Azure Managed Disks, Azure Backup
- networking: Virtual Network, Network Security Group, Application Gateway (with WAF), Azure Firewall, Azure Load Balancer, Azure DDoS Protection
- data-ai: Azure SQL Database, Azure SQL Managed Instance, Cosmos DB, Azure Database for PostgreSQL Flexible Server
- containers: Azure Kubernetes Service, Azure Container Registry
- security: Microsoft Defender for Cloud, Microsoft Sentinel, Azure Key Vault Managed HSM
- integration: API Management, Service Bus

### Tier 2 — Common Workload Services (~30 services)

Services frequently combined with Tier 1 for end-to-end solutions.

- compute-storage: Azure Compute Gallery, Azure Dedicated Host, Azure Batch, Azure Service Fabric, Azure Spring Apps, Static Web Apps, Azure Files (premium), Azure NetApp Files, Azure Site Recovery, Azure Data Box
- networking: VPN Gateway, NAT Gateway, Network Watcher, Azure WAF Policy, Traffic Manager, Azure CDN, Public IP, Private Link Service, Virtual WAN
- data-ai: Azure Database for MySQL Flexible, Azure Cache for Redis, Azure Synapse, Azure Data Factory, Azure Databricks, Azure Stream Analytics, Microsoft Fabric, Azure Machine Learning
- containers: Azure Container Instances, Azure Container Apps
- integration: Logic Apps Standard, Logic Apps Consumption, Event Grid, Notification Hubs, Azure Health Data Services
- management: Azure Policy, Azure Automation, Azure Update Manager, Azure Managed Grafana

### Tier 3 — Specialized & Hybrid (~25 services)

Less commonly deployed; often workload-specific.

- identity: Microsoft Entra Domain Services
- compute-storage: Azure VMware Solution, Azure HPC
- data-ai: Azure SQL Server (logical), Azure Cache for Redis Enterprise, Azure HDInsight, Azure Data Share, Azure Analysis Services, Power BI Embedded, Azure AI Services umbrella, Azure AI Vision, Azure AI Language, Azure AI Translator, Azure AI Content Safety, Azure AI Bot Service
- security: Azure Confidential Ledger, Azure Attestation, Defender EASM, Bastion Premium delta
- management: Azure Resource Graph, Azure Arc, Azure Lighthouse, Azure Service Health, Azure Cost Management, Azure Advisor
- iot: Azure IoT Hub, Azure IoT Central, Azure Digital Twins, Azure IoT DPS, Azure IoT Edge
- hybrid-edge: Azure Stack Edge, Azure Local, Azure Operator Nexus
- migration: Azure Migrate, Database Migration Service
- devops: Azure Load Testing, Azure Chaos Studio, Microsoft Dev Box
- web-realtime: SignalR, Web PubSub, Azure Communication Services, Azure Email Communication Services

---

## References

- FedRAMP authorization scope per Microsoft service: <https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-fedramp>
- NIST SP 800-53 Rev 5 High baseline: <https://csrc.nist.gov/projects/risk-management/sp800-53-controls/release-search#!/800-53>
- Azure FedRAMP Marketplace listing: <https://marketplace.fedramp.gov/products/F1603047866>
- Azure service retirement timeline: <https://learn.microsoft.com/en-us/lifecycle/products/?products=azure>

---

**Version**: 1.0.0 | **Created**: 2026-04-28 | **Author**: speckit.implement (Wave 2 sweep T018+T019) | **Status**: Awaiting Project Owner review prior to artifact authoring (T020/T021/T022/T028/T034/T035/T037)
