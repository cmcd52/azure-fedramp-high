# Compute, Storage, and Web Hosting Services — Azure Commercial vs Azure Government (Virginia) Feature Parity

**Services Covered**: Azure App Service, Azure Functions, Azure Storage Account

---

## 1. Azure App Service

### Commercial Features
- Web Apps (Windows and Linux)
- App Service Plans (Free, Shared, Basic, Standard, Premium, Isolated)
- App Service Certificates and Managed Certificates
- App Service Domains (custom domain purchase)
- Deployment options: Local Git, GitHub Actions, Azure DevOps, Bitbucket, External Repository, FTP, ZIP deploy, Docker Hub, Azure Container Registry
- Deployment slots for staging
- Custom domains with SSL/TLS
- Virtual Network integration
- Hybrid connections
- Authentication/Authorization (Easy Auth)
- Diagnostic logging
- Auto-scaling
- Endpoint: `<app-name>.azurewebsites.net`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- **Service endpoint**: `<app-name>.azurewebsites.us`
- **Private DNS zone**: `privatelink.azurewebsites.us` (with SCM: `scm.privatelink.azurewebsites.us`)

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **App Service Certificate** | Available | **Not available** | Cannot purchase SSL certificates through Azure; must bring your own certificate (BYOC) |
| **App Service Managed Certificate** | Available (free SSL for custom domains) | **Not available** | Cannot use Azure-managed free certificates; must provision and manage certificates externally |
| **App Service Domain** | Available | **Not available** | Cannot purchase custom domains through Azure; must use external registrar |
| **Deployment options** | Full suite (GitHub Actions, Azure DevOps, Bitbucket, etc.) | **Limited**: Only Local Git Repository and External Repository | CI/CD pipeline must use Local Git push or external repo configuration |
| **Endpoint** | `azurewebsites.net` | `azurewebsites.us` | Configuration change only |
| **Private DNS zone** | `privatelink.azurewebsites.net` | `privatelink.azurewebsites.us` | Must use Gov-specific DNS zone |

### Impact Assessment
- **Certificate management**: Moderate impact. Organizations must implement their own certificate lifecycle (acquisition, renewal, revocation) instead of relying on Azure-managed certificates. For FedRAMP High, this may actually be preferred as it provides more control over the certificate chain.
- **Deployment options**: Significant impact on CI/CD. GitHub Actions integration, Azure DevOps integration, and Bitbucket integration are not natively supported. Workaround: Configure GitHub Actions/Azure DevOps to push via Local Git endpoint or deploy via External Repository reference.
- **Domain purchasing**: Low impact. Most enterprise Gov customers already have domain registrars.

### Source References
- [Compare Azure Government and global Azure — App Service](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#app-service)
- [Private Endpoint DNS — Government — Web](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#government)

---

## 2. Azure Functions

### Commercial Features
- Serverless compute (Consumption, Premium, Dedicated plans)
- Durable Functions for stateful workflows
- Multiple language runtimes (.NET, Node.js, Python, Java, PowerShell, Custom handlers)
- Triggers: HTTP, Timer, Blob, Queue, Event Hub, Service Bus, Cosmos DB, etc.
- Bindings for input/output
- Application Insights integration via `APPINSIGHTS_INSTRUMENTATIONKEY` or `APPLICATIONINSIGHTS_CONNECTION_STRING`
- Virtual Network integration
- Deployment slots
- Endpoint: `<app-name>.azurewebsites.net`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- **Service endpoint**: `<app-name>.azurewebsites.us`
- Same App Service deployment constraints apply (Local Git and External Repository only)

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Application Insights integration** | Both `APPINSIGHTS_INSTRUMENTATIONKEY` and `APPLICATIONINSIGHTS_CONNECTION_STRING` work | **Must use `APPLICATIONINSIGHTS_CONNECTION_STRING`** | Connection string format is required to specify Gov-specific Application Insights endpoint |
| **Endpoint** | `azurewebsites.net` | `azurewebsites.us` | Configuration change only |
| **Deployment options** | Full suite | **Limited** (inherits App Service limitations) | Same restrictions as App Service: Local Git and External Repository only |
| **Feature set** | Full | **No additional function-specific gaps documented** | Microsoft's "Compare" doc only notes the Application Insights configuration requirement |

### Impact Assessment
- **Application Insights configuration**: Low impact. The `APPLICATIONINSIGHTS_CONNECTION_STRING` is actually the recommended approach in commercial too — it's just the only option in Gov. Terraform modules should always use connection string format.
- **Deployment limitations**: Same as App Service (see above).

### Source References
- [Compare Azure Government and global Azure — Azure Functions](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#azure-functions)
- [APPLICATIONINSIGHTS_CONNECTION_STRING](https://learn.microsoft.com/en-us/azure/azure-functions/functions-app-settings#applicationinsights_connection_string)

---

## 3. Azure Storage Account

### Commercial Features
- Blob Storage (Block, Append, Page blobs)
- Azure Data Lake Storage Gen2
- File Storage (SMB, NFS)
- Queue Storage
- Table Storage
- Storage account types: General-purpose v2, BlobStorage, BlockBlobStorage, FileStorage
- Redundancy: LRS, ZRS, GRS, RA-GRS, GZRS, RA-GZRS
- Encryption at rest with Microsoft-managed or customer-managed keys
- Immutable storage (WORM)
- Lifecycle management
- Private endpoint support
- Firewall and virtual network rules
- Soft delete and versioning
- Endpoints:
  - Blob: `<account>.blob.core.windows.net`
  - File: `<account>.file.core.windows.net`
  - Queue: `<account>.queue.core.windows.net`
  - Table: `<account>.table.core.windows.net`
  - DFS: `<account>.dfs.core.windows.net`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- **Endpoints**:
  - Blob: `<account>.blob.core.usgovcloudapi.net`
  - File: `<account>.file.core.usgovcloudapi.net`
  - Queue: `<account>.queue.core.usgovcloudapi.net`
  - Table: `<account>.table.core.usgovcloudapi.net`
  - DFS: `<account>.dfs.core.usgovcloudapi.net`
- **Private DNS zones**:
  - `privatelink.blob.core.usgovcloudapi.net`
  - `privatelink.file.core.usgovcloudapi.net`
  - `privatelink.queue.core.usgovcloudapi.net`
  - `privatelink.table.core.usgovcloudapi.net`
  - `privatelink.web.core.usgovcloudapi.net`
  - `privatelink.dfs.core.usgovcloudapi.net`

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Blob endpoint** | `blob.core.windows.net` | `blob.core.usgovcloudapi.net` | Configuration change only |
| **File endpoint** | `file.core.windows.net` | `file.core.usgovcloudapi.net` | Configuration change only |
| **Queue endpoint** | `queue.core.windows.net` | `queue.core.usgovcloudapi.net` | Configuration change only |
| **Table endpoint** | `table.core.windows.net` | `table.core.usgovcloudapi.net` | Configuration change only |
| **DFS endpoint** | `dfs.core.windows.net` | `dfs.core.usgovcloudapi.net` | Configuration change only |
| **Private DNS zones** | `*.core.windows.net` suffix | `*.core.usgovcloudapi.net` suffix | All 6 zones must use Gov suffix |
| **Feature set** | Full | **No documented feature gaps** | Microsoft's "Compare" doc has a Storage section but does not list Storage Account-specific limitations in Gov (only mentions Azure NetApp Files and Import/Export variations) |

### Impact Assessment
- **Endpoint differences**: Moderate impact on Terraform and application code. All storage connection strings, SDKs, and tools must be configured to use `usgovcloudapi.net` suffix. Azure SDK `AzureUSGovernment` cloud configuration handles this automatically when set.
- **Private DNS zones**: Moderate impact on networking modules. All 6 private DNS zones must be created with Gov-specific names.

### Source References
- [Compare Azure Government and global Azure — Storage](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#storage)
- [Compare Azure Government and global Azure — Guidance for developers](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#guidance-for-developers) (endpoint table)
- [Private Endpoint DNS — Government — Storage](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#government)
