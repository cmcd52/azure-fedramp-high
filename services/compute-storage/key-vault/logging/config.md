# Logging Configuration: Key Vault

**Service**: Key Vault (Premium SKU)
**Category**: Compute & Storage
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL3 (Advanced) for ALL Key Vault events (critical cryptographic material)

---

## Log Collection Architecture

Key Vault diagnostic logs are forwarded to the centralized Log Analytics workspace via Azure Monitor diagnostic settings. All vault operations — key access, secret retrieval, certificate operations, policy evaluations, and administrative actions — are captured as AuditEvent records.

```
Key Vault → Diagnostic Settings → Log Analytics Workspace
```

---

## Diagnostic Log Categories

All diagnostic log categories below MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| AuditEvent | All Key Vault operations: key access, secret retrieval, certificate operations, vault configuration changes, authentication events, and authorization failures | EL3 | AU-2, AU-3, AU-12 |
| AzurePolicyEvaluationDetails | Azure Policy compliance evaluation results for Key Vault resources | EL2 | AU-2, CM-6 |

### Metrics

| Metric Category | Description | OMB M-21-31 Tier | NIST Control |
|----------------|-------------|-------------------|--------------|
| AllMetrics | Vault availability, saturation, API latency, total transactions, and service API results | EL1 | SI-4 |

---

## AuditEvent Record Fields

| Field | Description | NIST Relevance |
|-------|------------|----------------|
| `operationName` | Vault operation (KeyGet, SecretGet, CertificateCreate, VaultPatch, etc.) | AU-3 |
| `resultType` | Operation result (Success, Failure) | AU-3 |
| `callerIpAddress` | Source IP address of the caller | AU-3 |
| `identity.claim.upn` | User principal name (for interactive calls) | AU-3, IA-2 |
| `identity.claim.oid` | Object ID of the calling principal (user or service principal) | AU-3 |
| `identity.claim.appid` | Application (client) ID for service principal calls | AU-3 |
| `properties.id` | URI of the accessed key, secret, or certificate | AU-3 |
| `properties.clientInfo` | Client SDK/tool information | AU-3 |
| `httpStatusCode` | HTTP response status code | AU-3 |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. The Key Vault resource ID is the target.

### Diagnostic Setting Configuration

```
Resource: Microsoft.KeyVault/vaults
Name: "{key_vault_name}-diag"
Destination: Log Analytics workspace (shared)
Log Categories:
  - AuditEvent: Enabled
  - AzurePolicyEvaluationDetails: Enabled
Metrics:
  - AllMetrics: Enabled
```

---

## Retention

| Tier | Retention Period | Justification |
|------|-----------------|---------------|
| Hot (Log Analytics) | 365 days (production) / 30 days (lower) | Active query and alerting for cryptographic operations |
| Archive (Storage Account) | 548 days (production) | FedRAMP AU-11 audit record retention |

---

## Alert Rules

The following alerts MUST be configured in the shared monitoring infrastructure:

| Alert Name | Condition | Severity | Action Group | NIST Control |
|-----------|-----------|----------|-------------|--------------|
| Key Deleted | AuditEvent where operationName == "KeyDelete" | Sev 1 (Error) | SOC + Key Vault Team | SC-12, CP-9, SI-4 |
| Secret Accessed by Unexpected Principal | AuditEvent where operationName == "SecretGet" AND identity not in approved list | Sev 1 (Error) | SOC + Incident Response | AC-3, SI-4 |
| Certificate Expiration Warning | AuditEvent where certificate expiry < 30 days | Sev 2 (Warning) | SOC + Certificate Team | SC-12, SC-8 |
| Purge Attempt | AuditEvent where operationName contains "Purge" | Sev 1 (Error) | SOC + Incident Response | CP-9, SI-4 |
| Key Vault Access from Unknown IP | AuditEvent where callerIpAddress not in approved ranges | Sev 2 (Warning) | SOC | SC-7, SI-4 |
| Excessive Failed Operations | AuditEvent where resultType == "Failure" count > 10 in 5 minutes | Sev 2 (Warning) | SOC | AC-3, SI-4 |

---

## Log Query Examples

### Key Deletion Events
```kusto
AzureDiagnostics
| where ResourceType == "VAULTS"
| where OperationName == "KeyDelete"
| project TimeGenerated, Resource, CallerIPAddress, Identity, OperationName, ResultType
| order by TimeGenerated desc
```

### Secret Access by Service Principal
```kusto
AzureDiagnostics
| where ResourceType == "VAULTS"
| where OperationName == "SecretGet"
| extend AppId = tostring(parse_json(identity_claim_appid_s))
| summarize AccessCount = count() by Resource, AppId, CallerIPAddress, bin(TimeGenerated, 1h)
| order by AccessCount desc
```

### Failed Authorization Attempts
```kusto
AzureDiagnostics
| where ResourceType == "VAULTS"
| where ResultType == "Failure" or httpStatusCode_d == 403
| summarize FailureCount = count() by Resource, CallerIPAddress, OperationName, bin(TimeGenerated, 5m)
| where FailureCount > 10
| order by FailureCount desc
```

### Purge Operation Attempts
```kusto
AzureDiagnostics
| where ResourceType == "VAULTS"
| where OperationName has "Purge"
| project TimeGenerated, Resource, CallerIPAddress, Identity, OperationName, ResultType
| order by TimeGenerated desc
```

### Certificate Expiration Monitoring
```kusto
AzureDiagnostics
| where ResourceType == "VAULTS"
| where OperationName == "CertificateNearExpiry" or OperationName == "CertificateExpired"
| project TimeGenerated, Resource, OperationName, properties_s
| order by TimeGenerated desc
```

### High-Value Key Operations Summary
```kusto
AzureDiagnostics
| where ResourceType == "VAULTS"
| where OperationName in ("KeyCreate", "KeyDelete", "KeyRotate", "KeyImport", "KeyBackup", "KeyRestore")
| summarize OperationCount = count() by Resource, OperationName, CallerIPAddress, bin(TimeGenerated, 1h)
| order by OperationCount desc
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Key Vault logging | https://learn.microsoft.com/en-us/azure/key-vault/general/logging |
| 2 | Azure Key Vault monitoring | https://learn.microsoft.com/en-us/azure/key-vault/general/monitor-key-vault |
| 3 | Key Vault diagnostic logs reference | https://learn.microsoft.com/en-us/azure/key-vault/general/monitor-key-vault-reference |
| 4 | OMB M-21-31 logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
