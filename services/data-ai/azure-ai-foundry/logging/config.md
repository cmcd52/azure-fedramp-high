# Logging Configuration: Azure AI Foundry

**Service**: Azure AI Foundry (Microsoft.MachineLearningServices/workspaces, kind: Hub/Project)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**NIST 800-53**: AU-2, AU-3, AU-6, AU-12
**OMB M-21-31**: EL2 (Intermediate) for operation logs

---

## Log Collection Architecture

Azure AI Foundry diagnostic logs are forwarded to the centralized Log Analytics workspace via Azure Monitor diagnostic settings. Logs capture compute operations, model lifecycle events, deployment events, pipeline executions, and data operations across the Hub and Project workspaces.

```
Azure AI Foundry Hub/Project → Diagnostic Settings → Log Analytics Workspace
```

---

## Diagnostic Log Categories

All diagnostic log categories below MUST be enabled and forwarded to the centralized Log Analytics workspace.

| Category | Description | OMB M-21-31 Tier | NIST Control |
|----------|------------|-------------------|--------------|
| AmlComputeClusterEvent | Compute cluster provisioning, scaling, and deletion events | EL2 | AU-2, AU-3, AU-12 |
| AmlComputeClusterNodeEvent | Individual node lifecycle events within compute clusters | EL2 | AU-2, AU-12 |
| AmlComputeJobEvent | Training and inference job submission, execution, and completion events | EL2 | AU-2, AU-3, AU-12 |
| AmlComputeCpuGpuUtilization | CPU and GPU utilization metrics for compute resources | EL2 | SI-4 |
| AmlRunStatusChangedEvent | Experiment run state transitions (Queued, Running, Completed, Failed) | EL2 | AU-2, AU-3, AU-12 |
| ModelsChangeEvent | Model registration, update, and deletion events | EL2 | AU-2, AU-3, AU-12, CM-3 |
| ModelsReadEvent | Model metadata read operations | EL2 | AU-2, AU-12 |
| ModelsActionEvent | Model actions (download, deploy, archive) | EL2 | AU-2, AU-3, AU-12 |
| DeploymentReadEvent | Model deployment configuration read operations | EL2 | AU-2, AU-12 |
| DeploymentEventACI | Azure Container Instance deployment events | EL2 | AU-2, AU-3, AU-12 |
| DeploymentEventAKS | Azure Kubernetes Service deployment events | EL2 | AU-2, AU-3, AU-12 |
| InferencingOperationAKS | AKS inference endpoint operation events | EL2 | AU-2, AU-12 |
| EnvironmentChangeEvent | Compute environment creation, update, and deletion events | EL2 | AU-2, AU-3, CM-3 |
| EnvironmentReadEvent | Compute environment read operations | EL2 | AU-2, AU-12 |
| DataLabelChangeEvent | Data labeling project change events | EL2 | AU-2, AU-3, AU-12 |
| DataLabelReadEvent | Data labeling project read events | EL2 | AU-2, AU-12 |
| DataSetChangeEvent | Dataset registration, update, and deletion events | EL2 | AU-2, AU-3, AU-12 |
| DataSetReadEvent | Dataset read and access events | EL2 | AU-2, AU-12 |
| PipelineChangeEvent | ML pipeline creation, update, and deletion events | EL2 | AU-2, AU-3, CM-3 |
| PipelineReadEvent | ML pipeline read and execution history events | EL2 | AU-2, AU-12 |
| RunEvent | Experiment run creation, configuration, and artifact events | EL2 | AU-2, AU-3, AU-12 |
| RunMetricEvent | Experiment run metric logging events | EL2 | AU-2, AU-12 |

### Metrics

| Metric Category | Description | OMB M-21-31 Tier | NIST Control |
|----------------|-------------|-------------------|--------------|
| AllMetrics | Compute utilization, active nodes, run queue depth, model deployment latency, failed runs | EL1 | SI-4 |

---

## Destination

| Environment | Destination | Workspace |
|-------------|------------|-----------|
| Production | Shared Log Analytics workspace | Per `shared/terraform/log-analytics/` |

**Configuration method**: Terraform deploys the diagnostic setting via `azurerm_monitor_diagnostic_setting` in `terraform/main.tf`. Both Hub and Project resources have their own diagnostic settings.

### Diagnostic Setting Configuration

```
Resource: Microsoft.MachineLearningServices/workspaces
Name: "{hub_name}-diag" / "{project_name}-diag"
Destination: Log Analytics workspace (shared)
Log Categories:
  - AmlComputeClusterEvent: Enabled
  - AmlComputeClusterNodeEvent: Enabled
  - AmlComputeJobEvent: Enabled
  - AmlComputeCpuGpuUtilization: Enabled
  - AmlRunStatusChangedEvent: Enabled
  - ModelsChangeEvent: Enabled
  - ModelsReadEvent: Enabled
  - ModelsActionEvent: Enabled
  - DeploymentReadEvent: Enabled
  - DeploymentEventACI: Enabled
  - DeploymentEventAKS: Enabled
  - InferencingOperationAKS: Enabled
  - EnvironmentChangeEvent: Enabled
  - EnvironmentReadEvent: Enabled
  - DataLabelChangeEvent: Enabled
  - DataLabelReadEvent: Enabled
  - DataSetChangeEvent: Enabled
  - DataSetReadEvent: Enabled
  - PipelineChangeEvent: Enabled
  - PipelineReadEvent: Enabled
  - RunEvent: Enabled
  - RunMetricEvent: Enabled
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
| Unauthorized Compute Access | AmlComputeClusterEvent where resultType == "Failure" and error contains "Authorization" | Sev 1 (Error) | SOC + Incident Response | AC-3, IA-2, SI-4 |
| Model Deployment Failure | DeploymentEventACI or DeploymentEventAKS where resultType == "Failure" | Sev 2 (Warning) | SOC + AI Team | SI-4, CM-3 |
| Data Exfiltration Attempt | AmlComputeJobEvent where outbound connection to unapproved destination detected | Sev 1 (Error) | SOC + Incident Response | SC-7, AC-4, SI-4 |
| Compute Cluster Scale Anomaly | AmlComputeClusterEvent where node count exceeds expected threshold | Sev 2 (Warning) | SOC + Platform Team | SI-4 |
| Failed Experiment Runs Spike | AmlRunStatusChangedEvent where status == "Failed" count > 10 in 15 minutes | Sev 2 (Warning) | SOC + AI Team | SI-4 |
| Model Registry Changes | ModelsChangeEvent where operationName contains "delete" or "update" | Sev 3 (Informational) | SOC + AI Team | CM-3, AU-12 |

---

## Log Query Examples

### Unauthorized Compute Access
```kusto
AmlComputeClusterEvent
| where ResultType == "Failure"
| where ResultDescription has_any ("Authorization", "Forbidden", "Unauthorized")
| project TimeGenerated, WorkspaceName, ClusterName, ResultType, ResultDescription, CallerIdentity
| order by TimeGenerated desc
```

### Model Deployment Failures
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.MACHINELEARNINGSERVICES"
| where Category in ("DeploymentEventACI", "DeploymentEventAKS")
| where ResultType == "Failure"
| project TimeGenerated, Resource, OperationName, ResultType, ResultDescription
| order by TimeGenerated desc
```

### Compute Job Activity Summary
```kusto
AmlComputeJobEvent
| summarize JobCount = count(), FailedCount = countif(ResultType == "Failure") by bin(TimeGenerated, 1h), ClusterName
| order by TimeGenerated desc
```

### Model Registry Changes (Audit Trail)
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.MACHINELEARNINGSERVICES"
| where Category == "ModelsChangeEvent"
| project TimeGenerated, Resource, OperationName, CallerIdentity = identity_s, ResultType
| order by TimeGenerated desc
```

### Pipeline Execution History
```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.MACHINELEARNINGSERVICES"
| where Category in ("PipelineChangeEvent", "PipelineReadEvent")
| project TimeGenerated, Resource, OperationName, ResultType, properties_s
| order by TimeGenerated desc
```

### Data Exfiltration Detection (Outbound Anomalies)
```kusto
AmlComputeJobEvent
| where ResultDescription has_any ("outbound", "egress", "external")
| project TimeGenerated, WorkspaceName, ClusterName, JobName, ResultDescription
| order by TimeGenerated desc
```

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure AI Foundry monitoring | https://learn.microsoft.com/en-us/azure/ai-studio/how-to/monitor-applications |
| 2 | Azure Machine Learning diagnostic logs | https://learn.microsoft.com/en-us/azure/machine-learning/monitor-azure-machine-learning |
| 3 | Azure Machine Learning log categories | https://learn.microsoft.com/en-us/azure/machine-learning/monitor-resource-reference |
| 4 | OMB M-21-31 logging maturity model | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
