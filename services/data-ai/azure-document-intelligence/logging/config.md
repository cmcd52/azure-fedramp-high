# Logging Configuration: Azure Document Intelligence

**Service**: Azure Document Intelligence (Microsoft.CognitiveServices/accounts, kind: FormRecognizer)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate) for audit and request/response logs

---

## Log Collection Architecture

Azure Document Intelligence diagnostic logs are forwarded to the centralized Log Analytics workspace via Azure Monitor diagnostic settings. Audit events capture authentication and authorization, RequestResponse captures document analysis API call metadata, and Trace provides diagnostic details.

```
Azure Document Intelligence → Diagnostic Settings → Log Analytics Workspace
```

---

## Diagnostic Log Categories

All diagnostic log categories below MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| Audit | Authentication events, authorization decisions, administrative operations, and configuration changes | EL2 | AU-2, AU-3, AU-12 |
| RequestResponse | API call metadata: document type, model used, page count, response codes, latency. Does NOT log document content for privacy. | EL2 | AU-2, AU-3, AU-12 |
| Trace | Detailed diagnostic trace information for troubleshooting and performance analysis | EL2 | AU-2, AU-12 |

### Metrics

| Metric Category | Description | OMB M-21-31 Tier | NIST Control |
|----------------|-------------|-------------------|--------------|
| AllMetrics | Request count, latency, error rate, successful calls, data processed | EL1 | SI-4 |

---

## RequestResponse Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `operationName` | API operation (AnalyzeDocument, GetAnalyzeResult, BuildModel, etc.) | AU-3 |
| `resultType` | Success or failure | AU-3 |
| `callerIpAddress` | Source IP of the API caller | AU-3 |
| `identity` | Caller identity (managed identity principal ID or user UPN) | AU-3, IA-2 |
| `properties.modelId` | Model used for analysis (prebuilt-invoice, prebuilt-receipt, custom, etc.) | AU-3 |
| `properties.apiVersion` | API version used for the request | AU-3 |
| `durationMs` | Request duration in milliseconds | SI-4 |
| `httpStatusCode` | HTTP response status code | AU-3 |

> **Privacy Note**: Document content (text, images, extracted fields) is NOT logged in RequestResponse to protect PII/CUI. Only metadata (model, page count, status) is captured.

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The Cognitive Services account resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.CognitiveServices/accounts
Name: "{docintel_account_name}-diag"
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
| API Key Usage in Production | Audit where authentication type is API key (not Entra ID) | Sev 1 (Error) | SOC | IA-2 |
| Configuration Change | Audit where operationName contains "accounts/write" or "accounts/delete" | Sev 2 (Warning) | SOC + Platform Team | CM-3, SI-4 |
| Unusual Document Volume | AllMetrics where request count > 2x baseline in 15 minutes | Sev 2 (Warning) | SOC + Application Team | SI-4 |

---

## Log Query Examples

### Unauthorized Access Attempts
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "Audit"
| where Resource has "docintel" or Resource has "formrecognizer"
| where httpStatusCode_d == 401 or httpStatusCode_d == 403
| project TimeGenerated, Resource, CallerIPAddress, OperationName, ResultType, httpStatusCode_d
| order by TimeGenerated desc
```

### Document Analysis Activity
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "RequestResponse"
| where Resource has "docintel" or Resource has "formrecognizer"
| where OperationName has "AnalyzeDocument"
| extend ModelId = tostring(parse_json(properties_s).modelId)
| summarize RequestCount = count(), AvgLatency = avg(DurationMs) by ModelId, bin(TimeGenerated, 1h)
| order by RequestCount desc
```

### High Error Rate Detection
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "RequestResponse"
| where Resource has "docintel" or Resource has "formrecognizer"
| where httpStatusCode_d >= 500
| summarize ErrorCount = count() by Resource, bin(TimeGenerated, 5m)
| where ErrorCount > 10
| order by ErrorCount desc
```

### API Key Usage Detection (Should Not Occur in Production)
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.COGNITIVESERVICES"
| where Category == "Audit"
| where Resource has "docintel" or Resource has "formrecognizer"
| where properties_s has "ApiKey"
| project TimeGenerated, Resource, CallerIPAddress, OperationName, properties_s
| order by TimeGenerated desc
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Document Intelligence monitoring | https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/how-to-guides/monitor |
| 2 | Azure Cognitive Services diagnostic logs | https://learn.microsoft.com/en-us/azure/ai-services/diagnostic-logging |
| 3 | Azure Document Intelligence data privacy | https://learn.microsoft.com/en-us/legal/cognitive-services/document-intelligence/data-privacy-security |
| 4 | OMB M-21-31 logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
