# Logging Configuration: AI Speech Service

**Service**: AI Speech Service (Microsoft.CognitiveServices/accounts, kind: SpeechServices)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate) for request/response, EL3 (Advanced) for audit events

---

## Log Collection Architecture

AI Speech Service diagnostic logs are forwarded to the centralized Log Analytics workspace via Azure Monitor diagnostic settings. Audit events capture authentication and authorization, RequestResponse captures API interaction metadata, and Trace provides diagnostic details.

```
AI Speech Service → Diagnostic Settings → Log Analytics Workspace
```

---

## Diagnostic Log Categories

All diagnostic log categories below MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| Audit | Authentication events, authorization decisions, administrative operations, and configuration changes | EL3 | AU-2, AU-3, AU-12 |
| RequestResponse | API call metadata: speech operation type (STT, TTS, translation), audio duration, response codes, latency. Does NOT log audio content for privacy. | EL2 | AU-2, AU-3, AU-12 |
| Trace | Detailed diagnostic trace information for troubleshooting and performance analysis | EL2 | AU-2, AU-12 |

### Metrics

| Metric Category | Description | OMB M-21-31 Tier | NIST Control |
|----------------|-------------|-------------------|--------------|
| AllMetrics | Request count, latency, error rate, audio duration processed, concurrent connection count | EL1 | SI-4 |

---

## RequestResponse Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `operationName` | Speech API operation (SpeechToText, TextToSpeech, Translation, SpeakerRecognition) | AU-3 |
| `resultType` | Success or failure | AU-3 |
| `callerIpAddress` | Source IP of the API caller | AU-3 |
| `identity` | Caller identity (managed identity principal ID or user UPN) | AU-3, IA-2 |
| `properties.region` | Azure region processing the request | AU-3 |
| `properties.requestId` | Unique request identifier for correlation | AU-3 |
| `durationMs` | Request duration in milliseconds | SI-4 |
| `httpStatusCode` | HTTP response status code | AU-3 |

> **Privacy Note**: Audio content is NOT logged in RequestResponse to protect PII in speech data. Only metadata (operation type, duration, status) is captured.

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The Cognitive Services account resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.CognitiveServices/accounts
Name: "{speech_account_name}-diag"
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
| High Error Rate | RequestResponse where httpStatusCode >= 500 count > 10 in 5 minutes | Sev 2 (Warning) | SOC + Application Team | SI-4 |
| Unusual Request Pattern | RequestResponse where request count per caller exceeds 3x baseline in 15 minutes | Sev 2 (Warning) | SOC | SI-4 |
| API Key Usage in Production | Audit where authentication type is API key (not Entra ID) | Sev 1 (Error) | SOC | IA-2 |
| Account Configuration Change | Audit where operationName contains "accounts/write" or "accounts/delete" | Sev 2 (Warning) | SOC + Application Team | CM-3, SI-4 |
| Custom Model Deployment Change | Audit where operationName contains "deployments/write" or "deployments/delete" | Sev 2 (Warning) | SOC + AI Team | CM-3, SI-4 |

---

## Log Query Examples

### Unauthorized Access Attempts
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "Audit"
| where Resource has "speech"
| where httpStatusCode_d == 401 or httpStatusCode_d == 403
| project TimeGenerated, Resource, CallerIPAddress, OperationName, ResultType, httpStatusCode_d
| order by TimeGenerated desc
```

### High Error Rate Detection
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "RequestResponse"
| where Resource has "speech"
| where httpStatusCode_d >= 500
| summarize ErrorCount = count() by Resource, bin(TimeGenerated, 5m)
| where ErrorCount > 10
| order by ErrorCount desc
```

### Unusual Request Patterns (Volume Spike)
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "RequestResponse"
| where Resource has "speech"
| summarize RequestCount = count() by CallerIPAddress, bin(TimeGenerated, 15m)
| order by RequestCount desc
| where RequestCount > 100
```

### API Key Usage Detection (Should Not Occur in Production)
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "Audit"
| where Resource has "speech"
| where properties_s has "ApiKey"
| project TimeGenerated, Resource, CallerIPAddress, OperationName, properties_s
| order by TimeGenerated desc
```

### Speech Operation Summary
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "RequestResponse"
| where Resource has "speech"
| summarize
    TotalRequests = count(),
    SuccessCount = countif(httpStatusCode_d >= 200 and httpStatusCode_d < 300),
    ErrorCount = countif(httpStatusCode_d >= 400),
    AvgDurationMs = avg(DurationMs)
  by OperationName, bin(TimeGenerated, 1h)
| order by TotalRequests desc
```

### Configuration Changes
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "Audit"
| where Resource has "speech"
| where OperationName has_any ("accounts/write", "accounts/delete", "deployments")
| project TimeGenerated, Resource, OperationName, CallerIPAddress, ResultType, Identity
| order by TimeGenerated desc
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure AI Speech Service documentation | https://learn.microsoft.com/en-us/azure/ai-services/speech-service/overview |
| 2 | Azure Cognitive Services diagnostic logs | https://learn.microsoft.com/en-us/azure/ai-services/diagnostic-logging |
| 3 | Azure AI Speech data privacy | https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-services-data-privacy |
| 4 | OMB M-21-31 logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
