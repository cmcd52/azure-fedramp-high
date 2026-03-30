# AI and Data Services — Azure Commercial vs Azure Government (Virginia) Feature Parity

**Services Covered**: Azure OpenAI, Azure AI Search, Azure AI Foundry, Azure Document Intelligence, Azure Maps, Azure Purview, AI Speech Service, Event Hubs

---

## 1. Azure OpenAI

### Commercial Features
- Model deployments: GPT-4.1, GPT-4.1-mini, GPT-4o, GPT-4o-mini, GPT-3.5-Turbo, and others
- Deployment types: Standard, Provisioned, Global Standard, Global Provisioned, Data Zone
- Batch Deployments for bulk processing
- Connect your data (with RAG): Virtual network, private links, web app deployment, Copilot Studio deployment
- Abuse Monitoring with automated content classification and filtering
- Customer Managed Keys (CMK)
- Azure OpenAI Studio / Foundry portal (ai.azure.com)
- On Your Data (BYOD) with Azure AI Search, Blob Storage, etc.
- All regions broadly available

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia and US Gov Arizona
- Deployment types: Standard, Provisioned, USGov DataZone
- **Service endpoint**: `openai.azure.us`
- **Foundry portal**: `ai.azure.us` | **Azure OpenAI Studio**: `aoai.azure.us` | **Azure portal**: `portal.azure.us`
- USGov DataZone provides cross-region (Arizona + Virginia) dynamic routing

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Batch Deployments** | Available | **Not supported** | Batch processing of large request sets is unavailable in Gov |
| **Connect your data — Web App / Copilot Studio** | Available | **Not supported** | Only VNet and private link connectivity are supported for data connection |
| **Abuse Monitoring** | Full monitoring suite | **Partial** | Not all abuse monitoring features are enabled; customer responsible for implementing additional monitoring |
| **Model availability (Virginia vs Arizona)** | All models in all supported regions | **Virginia has fewer models available** than Arizona for Standard deployments | Several models show ✅ for Arizona but ❌ for Virginia in Standard deployment |
| **Max context window (GPT-4.1/4.1-mini)** | 1,047,576 tokens | **300,000 tokens** | Gov caps input at 300K for standard & provisioned managed deployments |
| **Model retirement timing** | Standard schedule | **Some models retire earlier or later** | gpt-4o 0513 retires March 31, 2026 (all types) in Gov; gpt-35-turbo 0125 retires later |
| **Default model versions** | Standard schedule | **Some defaults change earlier** | gpt-4o defaults to 2024-11-20 starting October 13, 2025 in Gov (vs 2024-08-06 in commercial) |
| **Data Storage** | Various features store customer data | **No features currently store customer data at rest** in Gov | CMK can still be enabled proactively |

### Source References
- [Azure OpenAI in Azure Government](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/azure-government)
- [Compare Azure Government and global Azure — Foundry Tools: OpenAI Service](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#foundry-tools-openai-service)

---

## 2. Azure AI Search

### Commercial Features
- Full-text search, vector search, hybrid search
- Semantic ranker
- AI enrichment (skillsets)
- Knowledge store
- Index projections
- All regions broadly available
- Endpoint: `<service-name>.search.windows.net`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- **Service endpoint**: `<service-name>.search.azure.us`
- **Private DNS zone**: `privatelink.search.azure.us`

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Endpoint** | `search.windows.net` | `search.azure.us` | Configuration change only |
| **Private DNS zone** | `privatelink.search.windows.net` | `privatelink.search.azure.us` | Must use Gov-specific DNS zone |
| **Feature set** | Full | **No documented feature gaps** | Microsoft's "Compare" doc does not list any Azure AI Search feature limitations in Gov |

### Source References
- [Compare Azure Government and global Azure — Guidance for developers](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#guidance-for-developers) (endpoint table)
- [Private Endpoint DNS — Government](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#government)

---

## 3. Azure AI Foundry

### Commercial Features
- Unified AI portal at `ai.azure.com`
- Foundry projects for model management, evaluation, and deployment
- Model catalog with Azure OpenAI, Meta, Mistral, and other models
- Agent Service
- Speech capabilities integration
- Content Safety APIs
- Available in 30+ commercial regions (East US, West US, Europe, Asia, etc.)

### Azure Government (Virginia) Features
- **Gov-specific portals**: `ai.azure.us` and `aoai.azure.us`
- Access to Azure OpenAI models available in Gov
- Access to Cognitive Services models available in Gov

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Foundry project region list** | 30+ regions listed | **No Gov regions listed** in the official Foundry projects region list | Gov customers access via `ai.azure.us` but this is not the same as the full commercial Foundry portal experience |
| **Model catalog breadth** | Hundreds of models from multiple providers | **Limited to Azure-native models** | Third-party models (Meta Llama, Mistral, etc.) availability in Gov is limited or absent |
| **Agent Service** | Available in multiple regions | **Not documented for Gov** | No Gov-specific documentation for Agent Service availability |
| **Feature-specific availability** | Full surface area | **Reduced** | Some features depend on underlying services that have limited Gov availability (e.g., Content Safety) |

### Source References
- [Microsoft Foundry feature availability across cloud regions](https://learn.microsoft.com/en-us/azure/ai-foundry/reference/region-support)
- [Azure OpenAI in Azure Government](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/azure-government)

---

## 4. Azure Document Intelligence

### Commercial Features
- Pre-built models (Invoice, Receipt, ID Document, Tax, etc.)
- Custom template and neural models
- Layout analysis, document classification
- Analyze API with REST and SDKs
- Endpoint: `<resource-name>.cognitiveservices.azure.com`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- **Service endpoint**: `<resource-name>.cognitiveservices.azure.us`
- Gov portal endpoint listed in "Compare Azure Government and global Azure" endpoint table

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Endpoint** | `cognitiveservices.azure.com` | `cognitiveservices.azure.us` | Configuration change only |
| **Feature set** | Full | **No documented feature gaps** | Microsoft's "Compare" doc does not list Document Intelligence-specific limitations in Gov |
| **Private DNS zone** | `privatelink.cognitiveservices.azure.com` | `privatelink.cognitiveservices.azure.us` | Must use Gov-specific DNS zone |

### Source References
- [Compare Azure Government and global Azure — Guidance for developers](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#guidance-for-developers) (endpoint table)
- [Document Intelligence service limits](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/service-limits)

---

## 5. Azure Maps

### Commercial Features
- Geocoding, routing, traffic, weather, spatial operations
- Map rendering (raster and vector tiles)
- Search APIs
- Creator for indoor mapping
- Endpoint: `atlas.microsoft.com`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- **Service endpoint**: `atlas.azure.us`

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Endpoint** | `atlas.microsoft.com` | `atlas.azure.us` | Configuration change only |
| **Feature set** | Full | **No documented feature gaps** | Microsoft's "Compare" doc does not list Azure Maps-specific limitations in Gov |

### Source References
- [Compare Azure Government and global Azure — Internet of Things](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#internet-of-things) (Azure Maps listed under IoT endpoint table)

---

## 6. Azure Purview (Microsoft Purview)

### Commercial Features
- Data catalog and data map
- Data governance policies
- Data lineage
- Classifications and sensitivity labels
- Integration with Azure Data Factory, Synapse, etc.
- Endpoint: `purview.azure.com` / `purviewstudio.azure.com`
- Private DNS zones: `privatelink.purview.azure.com`, `privatelink.purviewstudio.azure.com`, `privatelink.purview-service.microsoft.com`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- **Service endpoint**: `purview.azure.us` / `purviewstudio.azure.us`
- **Private DNS zones**: `privatelink.purview.azure.us`, `privatelink.purviewstudio.azure.us`

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Endpoint** | `purview.azure.com` | `purview.azure.us` | Configuration change only |
| **Private DNS zones** | 3 zones (including `purview-service.microsoft.com`) | **2 zones** (no `purview-service` zone listed for Gov) | Gov has fewer private link sub-resources documented |
| **Feature set** | Full | **No sweeping limitations documented** | Microsoft's primary "Compare" doc does not have a dedicated Azure Purview section for Gov feature limitations |

### Important Note
Microsoft Purview is a broad platform spanning both Azure data governance and M365 compliance solutions. The Azure Purview data governance capabilities (data catalog, data map, lineage) are the only components in scope for this project. M365 compliance features (Communication Compliance, eDiscovery, etc.) are out of scope per the project constitution.

### Source References
- [Azure Private Endpoint DNS — Government — Management and Governance](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#government)
- [Microsoft Purview data compliance solutions](https://learn.microsoft.com/en-us/purview/purview-compliance) (scope context)

---

## 7. AI Speech Service

### Commercial Features
- Speech to text: Real-time, batch transcription, language ID, speaker diarization, custom speech
- Text to speech: Standard voice, neural voice, custom voice, personal voice
- Speech translation: Real-time
- Keyword recognition, custom keyword
- Pronunciation assessment
- Text to speech avatar
- Fast transcription
- Voice Live, Live Interpreter, Video Translation, LLM Speech
- Speech Studio at `speech.azure.com`
- Available in all major commercial regions

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia and US Gov Arizona
- **Speech Studio**: `speech.azure.us`
- **Supported** (in Gov):
  - Speech to text: Real-time, batch transcription, language ID, speaker diarization, custom speech
  - Text to speech: Standard voice, neural voice
  - Speech translation: Real-time
  - Keyword recognition

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Custom Voice** | Available | **Not supported** | Cannot create custom voice fonts |
| **Personal Voice** | Available | **Not supported** | Cannot use personal voice cloning |
| **Text to Speech Avatar** | Available | **Not supported** | No avatar generation capability |
| **Fast Transcription** | Available | **Not supported** | No accelerated batch transcription |
| **Pronunciation Assessment** | Available | **Not supported** | Cannot evaluate pronunciation quality |
| **Custom Keyword** | Available | **Not supported** | Cannot create custom wake words |
| **Voice Live** | Available | **Not supported** | Real-time voice streaming unavailable |
| **Live Interpreter** | Available | **Not supported** | Real-time interpretation unavailable |
| **Video Translation** | Available | **Not supported** | Cannot translate video audio tracks |
| **LLM Speech** | Available | **Not supported** | LLM-powered speech interactions unavailable |
| **REST API endpoints** | `<region>.api.cognitive.microsoft.com` | `<region>.api.cognitive.microsoft.us` | Different base domain |
| **STT short audio** | `<region>.stt.speech.azure.com` | `<region>.stt.speech.azure.us` | Different base domain |
| **TTS API** | `<region>.tts.speech.azure.com` | `<region>.tts.speech.azure.us` | Different base domain |
| **SDK configuration** | Standard `SpeechConfig` | **Must use "from endpoint"** instantiation | `SpeechConfig.Endpoint(new Uri(usGovEndpoint), subscriptionKey)` |

**Total: 10 features unavailable in Gov**

### Source References
- [Speech service in sovereign clouds — Azure Government](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/sovereign-clouds#azure-government-united-states)
- [Compare Azure Government and global Azure — Azure Speech in Foundry Tools](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#azure-speech-in-foundry-tools)

---

## 8. Event Hubs

### Commercial Features
- Real-time event streaming and ingestion
- Kafka protocol support
- Capture to Azure Storage or Data Lake
- Schema Registry
- Event Hubs namespaces with throughput units
- Endpoint: `<namespace>.servicebus.windows.net`

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- **Service endpoint**: `<namespace>.servicebus.usgovcloudapi.net`
- **Private DNS zone**: `privatelink.servicebus.usgovcloudapi.net`

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Endpoint** | `servicebus.windows.net` | `servicebus.usgovcloudapi.net` | Configuration change only |
| **Private DNS zone** | `privatelink.servicebus.windows.net` | `privatelink.servicebus.usgovcloudapi.net` | Must use Gov-specific DNS zone |
| **Feature set** | Full | **No documented feature gaps** | Microsoft's "Compare" doc does not list Event Hubs-specific limitations in Gov |

### Source References
- [Compare Azure Government and global Azure — Guidance for developers](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#guidance-for-developers) (endpoint table — Analytics section)
- [Private Endpoint DNS — Government — Analytics](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#government)
