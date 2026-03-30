# Networking, Monitoring, and Security Services — Azure Commercial vs Azure Government (Virginia) Feature Parity

**Services Covered**: Bastion, DNS Private Resolver, Private DNS Zone, Private Endpoint, ExpressRoute, Azure Front Door, Azure Monitor, Azure Application Insights, VMs for DNS, Key Vault

---

## 1. Azure Bastion

### Commercial Features
- Browser-based RDP/SSH access to VMs without public IP
- SKUs: Developer, Basic, Standard, Premium
- Native client support
- File transfer (via native client)
- Shareable links
- IP-based connections
- Host scaling (scale units)
- Azure Private DNS Zone support
- Availability zone support
- Virtual network peering support
- Endpoint: Management via `management.azure.com`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- SKU support and feature set generally match commercial

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Azure Private DNS Zones integration** | Supported (with noted DNS zone name restrictions) | **Not supported in national clouds** | Per FAQ: "Azure Bastion isn't supported with Azure Private DNS Zones in national clouds." This affects DNS resolution patterns when Bastion is deployed alongside Private DNS Zones |
| **Feature set (excluding DNS limitation)** | Full | **No other documented gaps** | Microsoft's "Compare" doc does not list Bastion-specific feature limitations; the DNS limitation comes from the Bastion FAQ |

### Impact Assessment
- **Private DNS Zone limitation**: Potentially significant for network architectures that rely on Private DNS Zones for internal name resolution in the same VNet as Bastion. Workaround: Ensure Bastion's host VNet is not linked to private DNS zones with specific reserved names (`management.azure.com`, `blob.core.windows.net`, `core.windows.net`, `vaultcore.windows.net`, `vault.azure.net`, `azure.com`). Using `privatelink.*` prefixed zones is acceptable.

### Source References
- [Azure Bastion FAQ — Force tunneling](https://learn.microsoft.com/en-us/azure/bastion/bastion-faq#can-i-use-azure-bastion-if-im-force-tunneling-internet-traffic-back-to-my-on-premises-location): "Azure Bastion isn't supported with Azure Private DNS Zones in national clouds."
- [Products available by region — Azure Bastion](https://azure.microsoft.com/global-infrastructure/services/?products=azure-bastion&regions=usgov-virginia)

---

## 2. DNS Private Resolver

### Commercial Features
- Inbound endpoints for on-premises to Azure DNS resolution
- Outbound endpoints with DNS forwarding rulesets
- Integration with Private DNS Zones
- Virtual network linking
- Conditional forwarding rules

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- Listed under [Products available by region](https://azure.microsoft.com/global-infrastructure/services/) for Gov regions

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Feature set** | Full | **No documented feature gaps** | Microsoft's "Compare" doc does not have a DNS Private Resolver section with Gov limitations |

### Source References
- [Products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=dns&regions=usgov-virginia)

---

## 3. Private DNS Zone

### Commercial Features
- Custom DNS zones for Azure virtual network name resolution
- Virtual network links (with auto-registration)
- Record types: A, AAAA, CNAME, MX, PTR, SOA, SRV, TXT
- Integration with Private Endpoints (automatic DNS record creation)
- Cross-virtual-network DNS resolution

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- Gov-specific zone names required for all Private Endpoint integrations (see endpoint mapping table below)

### Gov-Specific DNS Zone Mappings

| Service Category | Commercial Zone | Gov Zone |
|-----------------|-----------------|----------|
| Cognitive Services | `privatelink.cognitiveservices.azure.com` | `privatelink.cognitiveservices.azure.us` |
| Event Hubs | `privatelink.servicebus.windows.net` | `privatelink.servicebus.usgovcloudapi.net` |
| Storage (Blob) | `privatelink.blob.core.windows.net` | `privatelink.blob.core.usgovcloudapi.net` |
| Key Vault | `privatelink.vaultcore.azure.net` | `privatelink.vaultcore.usgovcloudapi.net` |
| Azure Monitor | `privatelink.monitor.azure.com` | `privatelink.monitor.azure.us` |
| App Service | `privatelink.azurewebsites.net` | `privatelink.azurewebsites.us` |
| Azure Search | `privatelink.search.windows.net` | `privatelink.search.azure.us` |
| Purview | `privatelink.purview.azure.com` | `privatelink.purview.azure.us` |

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Zone naming** | Standard Azure zones | **Gov-specific zone names** | All Private DNS zones must use `.us` or `.usgovcloudapi.net` suffixes |
| **Feature set** | Full | **Full** | No feature limitations; only naming differs |

### Source References
- [Azure Private Endpoint DNS — Government](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#government) — Complete Gov DNS zone mapping table

---

## 4. Private Endpoint

### Commercial Features
- Private IP connectivity to PaaS services
- Automatic DNS record creation in linked Private DNS Zones
- Network security group (NSG) support
- Application security group support
- Supports 100+ Azure services
- Approval workflow (auto-approve or manual)

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- Same core functionality as commercial
- Private DNS zone names differ (see Private DNS Zone section above)

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Private DNS zone names** | Standard Azure names | **Gov-specific names** | All associated DNS zones must use Gov naming convention |
| **Service coverage** | 100+ services | **Potentially fewer services supported** | Only services available in Gov can have Private Endpoints; per [Azure Private Link availability](https://learn.microsoft.com/en-us/azure/private-link/availability) |
| **Feature set** | Full | **Full** | No Private Endpoint feature limitations documented |

### Source References
- [Compare Azure Government and global Azure — Private Link](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#private-link)
- [Azure Private Link availability](https://learn.microsoft.com/en-us/azure/private-link/availability)

---

## 5. ExpressRoute

### Commercial Features
- Private peering to Azure virtual networks
- Microsoft peering for Microsoft 365 and Azure PaaS
- Global Reach for cross-circuit connectivity
- ExpressRoute Direct (10G/100G)
- FastPath for improved performance
- BGP community tagging for route filtering
- Multiple bandwidth tiers (50 Mbps to 10 Gbps)

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- ExpressRoute circuits connect to Azure Government PoPs
- Gov-specific BGP communities

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **BGP communities** | Standard Azure BGP communities | **National Cloud BGP communities** | BGP community values differ; must use Gov-specific community strings for route filtering |
| **Peering locations** | 70+ global locations | **Fewer peering locations** | Limited to peering locations that serve Azure Government regions |
| **Feature set** | Full | **No other documented gaps** | Core ExpressRoute functionality is available |

### Source References
- [Compare Azure Government and global Azure — Azure ExpressRoute](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#azure-expressroute)
- [BGP community support in National Clouds](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-routing#bgp-community-support-in-national-clouds)

---

## 6. Azure Front Door

### Commercial Features
- Global load balancing and application acceleration
- Web Application Firewall (WAF)
- SSL offloading and custom domains
- URL-based routing
- Session affinity
- Health probes and failover
- Caching
- SKUs: Classic, Standard, Premium
- Globally distributed PoPs

### Azure Government (Virginia) Features
- **Partially Available** — Standard and Premium tiers are GA in US Gov Arizona and US Gov Texas

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Region availability** | Globally distributed (all regions) | **US Gov Arizona and US Gov Texas only** | **US Gov Virginia is NOT listed** as a region where Front Door Standard/Premium is available in GA |
| **Classic SKU** | Available | **Not documented for Gov** | Only Standard and Premium are mentioned for Gov |

### Impact Assessment
- **Critical consideration**: Azure Front Door is a global/anycast service — it does not require backend resources to be in the same region as the Front Door deployment. Even though Front Door may not be "in" Virginia, it can still serve traffic to backends in Virginia. However, the data plane routing and edge PoP behavior in Gov may differ.
- **Verify with Azure team**: The documentation specifically says "US Gov Arizona and US Gov Texas" — Virginia is absent. This may be an oversight in documentation or an actual regional limitation.

### Source References
- [Compare Azure Government and global Azure — Azure Front Door](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#azure-front-door): "Azure Front Door (AFD) Standard and Premium tiers are available in general availability in Azure Government regions US Gov Arizona and US Gov Texas."

---

## 7. Azure Monitor (includes Log Analytics)

### Commercial Features
- Metrics collection and analysis
- Log Analytics workspaces (KQL queries)
- Alerts (metric, log, activity log)
- Action groups and notifications
- Diagnostic settings
- Azure Monitor Agent (AMA)
- Workbooks and dashboards
- Autoscale
- Change analysis
- SCOM integration
- Endpoints:
  - OMS: `oms.opinsights.azure.com`
  - ODS: `ods.opinsights.azure.com`
  - Portal: `portal.loganalytics.io`
  - API: `api.loganalytics.io`
  - ADX: `adx.monitor.azure.com`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- **Endpoints**:
  - OMS: `oms.opinsights.azure.us`
  - ODS: `ods.opinsights.azure.us`
  - Portal: `portal.loganalytics.us`
  - API: `api.loganalytics.us`
  - ADX: `adx.monitor.azure.us`
- Private DNS zones: `privatelink.monitor.azure.us`, `privatelink.oms.opinsights.azure.us`, `privatelink.ods.opinsights.azure.us`, `privatelink.agentsvc.azure-automation.us`, plus `privatelink.adx.monitor.azure.us`

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **All endpoints** | `.azure.com` / `.opinsights.azure.com` | `.azure.us` / `.opinsights.azure.us` | All endpoints use Gov-specific domains |
| **Data migration** | N/A | **Cannot migrate data between clouds** | Data in a Gov Log Analytics workspace cannot be moved to commercial, and vice versa |
| **Workspace switching** | Can switch between workspaces | **Cannot switch between Gov and commercial** | Gov and commercial portals are separate and don't share information |
| **SCOM 2016** | Supported | **Requires Update Rollup 2 or later** | Gov requires specific Advisor management pack version |
| **Feature set** | Full | **Full** ("Azure Monitor enables the same features in both Azure and Azure Government") | Microsoft explicitly states feature parity |

### Source References
- [Compare Azure Government and global Azure — Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#azure-monitor)

---

## 8. Azure Application Insights

### Commercial Features
- Application performance monitoring (APM)
- Distributed tracing
- Live metrics stream
- Availability testing
- Smart detection and alerts
- Application map
- Profiler and snapshot debugger
- Part of Azure Monitor
- SDK support: .NET, Java, Node.js, Python
- Endpoint: `{region}.in.applicationinsights.azure.com`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- **Endpoint**: `{region}.in.applicationinsights.azure.us`
- Application Insights "enables the same features in both Azure and Azure Government"

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **SDK endpoint** | Default endpoints | **Must modify SDK endpoints** | SDK endpoint overrides required; "you'll need to modify the default endpoint addresses that are used by the Application Insights SDKs" |
| **IP addresses** | Commercial IP ranges | **Different IP addresses** for Gov | Firewall rules may need updating; see [IP addresses used by Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/ip-addresses) |
| **Visual Studio integration** | Default cloud | **Must add Azure US Government cloud** | In Visual Studio: Tools > Options > Accounts > Registered Azure Clouds > Add "Azure US Government" as Discovery endpoint |
| **Connection strings** | Standard connection strings | **Gov-specific endpoint suffix required** | See [Connection strings with endpoint suffix](https://learn.microsoft.com/en-us/azure/azure-monitor/app/connection-strings#connection-string-with-an-endpoint-suffix) |
| **Feature set** | Full | **Full** | Microsoft states: "Application Insights (part of Azure Monitor) enables the same features in both Azure and Azure Government" |

### Source References
- [Compare Azure Government and global Azure — Application Insights](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#application-insights)
- [Application Insights overriding default endpoints](https://learn.microsoft.com/en-us/previous-versions/azure/azure-monitor/app/create-new-resource#override-default-endpoints)

---

## 9. VMs for DNS

### Commercial Features
- Standard Azure Virtual Machines
- Used as DNS forwarders/resolvers
- Support for all VM sizes and OS images
- Availability sets and availability zones
- Managed disks
- Network interfaces, NSGs, ASGs
- VM extensions

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- Azure VMs are a core IaaS service with full availability in Gov

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Feature set** | Full | **Full** | Azure VMs have full feature parity in Gov; no documented limitations |
| **VM image availability** | Full Azure Marketplace | **Potentially reduced Marketplace** | Some third-party VM images may not be available in Gov Marketplace; verify specific images |

### Source References
- [Products available by region — Virtual Machines](https://azure.microsoft.com/global-infrastructure/services/?products=virtual-machines&regions=usgov-virginia)

---

## 10. Key Vault

### Commercial Features
- Secrets management
- Key management (software and HSM-protected)
- Certificate management
- Managed HSM
- Soft delete and purge protection
- RBAC and access policies
- Private endpoint support
- Diagnostic logging
- Event Grid integration
- Endpoint: `<vault-name>.vault.azure.net`
- Managed HSM endpoint: `<name>.managedhsm.azure.net`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- **Endpoint**: `<vault-name>.vault.usgovcloudapi.net`
- **Managed HSM endpoint**: `<name>.managedhsm.usgovcloudapi.net`
- **Private DNS zone**: `privatelink.vaultcore.usgovcloudapi.net`

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Vault endpoint** | `vault.azure.net` | `vault.usgovcloudapi.net` | Configuration change only |
| **Managed HSM endpoint** | `managedhsm.azure.net` | `managedhsm.usgovcloudapi.net` | Configuration change only |
| **Private DNS zone** | `privatelink.vaultcore.azure.net` | `privatelink.vaultcore.usgovcloudapi.net` | Must use Gov-specific DNS zone |
| **Feature set** | Full | **No documented feature gaps** | Microsoft's "Compare" doc does not list Key Vault-specific feature limitations in Gov |

### Source References
- [Compare Azure Government and global Azure — Guidance for developers](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#guidance-for-developers) (endpoint table — Security section)
- [Private Endpoint DNS — Government — Security](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#government)
