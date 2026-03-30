# Logging Configuration: Azure OpenAI

**Service**: Azure OpenAI (Microsoft.CognitiveServices/accounts, kind: OpenAI)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate) for request/response, EL3 (Advanced) for audit events

---

## Log Collection Architecture

Azure OpenAI diagnostic logs are forwarded to the centralized Log Analytics workspace via Azure Monitor diagnostic settings. Audit events capture authentication and authorization, RequestResponse captures API interaction metadata, and Trace provides diagnostic details.

```
Azure OpenAI → Diagnostic Settings → Log Analytics Workspace
```

---

## Diagnostic Log Categories

All diagnostic log categories below MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| Audit | Authentication events, authorization decisions, administrative operations, and configuration changes | EL3 | AU-2, AU-3, AU-12 |
| RequestResponse | API call metadata: model, deployment, token counts, response codes, latency. Does NOT log prompt/completion content for privacy. | EL2 | AU-2, AU-3, AU-12 |
| Trace | Detailed diagnostic trace information for troubleshooting and performance analysis | EL2 | AU-2, AU-12 |

### Metrics

| Metric Category | Description | OMB M-21-31 Tier | NIST Control |
|----------------|-------------|-------------------|--------------|
| AllMetrics | Token usage, request count, latency, error rate, capacity utilization per deployment | EL1 | SI-4 |

---

## RequestResponse Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `operationName` | API operation (ChatCompletions, Completions, Embeddings, etc.) | AU-3 |
| `resultType` | Success or failure | AU-3 |
| `callerIpAddress` | Source IP of the API caller | AU-3 |
| `identity` | Caller identity (managed identity principal ID or user UPN) | AU-3, IA-2 |
| `properties.modelDeploymentName` | Name of the model deployment invoked | AU-3 |
| `properties.modelName` | Model name (gpt-4, gpt-4o, text-embedding-ada-002, etc.) | AU-3 |
| `properties.tokenCount` | Total tokens consumed (prompt + completion) | AU-3, SI-4 |
| `properties.streamType` | Whether streaming was used | AU-3 |
| `durationMs` | Request duration in milliseconds | SI-4 |
| `httpStatusCode` | HTTP response status code | AU-3 |

> **Privacy Note**: Prompt and completion content is NOT logged in RequestResponse to protect CUI. Only metadata (model, tokens, status) is captured.

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The Cognitive Services account resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.CognitiveServices/accounts
Name: "{openai_account_name}-diag"
Destination: Log Analytics workspace (shared)
Log Categories:
  - Audit: Enabled
  - RequestResponse: Enabled
  - Trace: Enabled
Metrics:
  - AllMetrics: Enabled
```

---

## Retention

| Tier | Retention Period | Justification |
|------|-----------------|---------------|
| Hot (Log Analytics) | 365 days (production) / 30 days (lower) | Active query and alerting |
| Archive (Storage Account) | 548 days (production) | FedRAMP AU-11 audit record retention |

---

## Alert Rules

The following alerts MUST be configured in the shared monitoring infrastructure:

| Alert Name | Condition | Severity | Action Group | NIST Control |
|-----------|-----------|----------|-------------|--------------|
| Unauthorized Access Attempt | Audit where resultType == "Failure" and httpStatusCode == 401 or 403 | Sev 1 (Error) | SOC + Incident Response | AC-3, IA-2, SI-4 |
| Content Filter Triggered | RequestResponse where content filter result indicates blocked content | Sev 2 (Warning) | SOC + AI Safety Team | SI-4 |
| Token Rate Limit Exceeded | AllMetrics where HTTP 429 count > threshold | Sev 2 (Warning) | SOC + Application Team | SI-4 |
| API Key Usage in Production | Audit where authentication type is API key (not Entra ID) | Sev 1 (Error) | SOC | IA-2 |
| Model Deployment Configuration Change | Audit where operationName contains "Deployments/write" or "Deployments/delete" | Sev 2 (Warning) | SOC + AI Team | CM-3, SI-4 |
| High Error Rate | RequestResponse where httpStatusCode >= 500 count > 10 in 5 minutes | Sev 2 (Warning) | SOC + Application Team | SI-4 |

---

## Log Query Examples

### Unauthorized Access Attempts
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "Audit"
| where httpStatusCode_d == 401 or httpStatusCode_d == 403
| project TimeGenerated, Resource, CallerIPAddress, OperationName, ResultType, httpStatusCode_d
| order by TimeGenerated desc
```

### Content Filter Triggers
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "RequestResponse"
| where properties_s has "content_filter" and properties_s has "filtered"
| project TimeGenerated, Resource, OperationName, CallerIPAddress, properties_s
| order by TimeGenerated desc
```

### Token Usage per Deployment
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "RequestResponse"
| extend ModelDeployment = tostring(parse_json(properties_s).modelDeploymentName)
| extend TokenCount = toint(parse_json(properties_s).tokenCount)
| summarize TotalTokens = sum(TokenCount), RequestCount = count() by ModelDeployment, bin(TimeGenerated, 1h)
| order by TotalTokens desc
```

### API Key Usage Detection (Should Not Occur in Production)
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "Audit"
| where properties_s has "ApiKey"
| project TimeGenerated, Resource, CallerIPAddress, OperationName, properties_s
| order by TimeGenerated desc
```

### Rate Limit Events (HTTP 429)
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "RequestResponse"
| where httpStatusCode_d == 429
| extend ModelDeployment = tostring(parse_json(properties_s).modelDeploymentName)
| summarize ThrottleCount = count() by Resource, ModelDeployment, CallerIPAddress, bin(TimeGenerated, 5m)
| where ThrottleCount > 5
| order by ThrottleCount desc
```

### High-Value Operation Summary
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "Audit"
| where OperationName has_any ("Deployments", "accounts/write", "accounts/delete")
| project TimeGenerated, Resource, OperationName, CallerIPAddress, ResultType
| order by TimeGenerated desc
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure OpenAI monitoring | https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/monitoring |
| 2 | Azure Cognitive Services diagnostic logs | https://learn.microsoft.com/en-us/azure/ai-services/diagnostic-logging |
| 3 | Azure OpenAI content filtering | https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/content-filter |
| 4 | OMB M-21-31 logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
