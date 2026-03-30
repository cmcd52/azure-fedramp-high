# Security Control Baseline: Azure AI Foundry

**Service**: Azure AI Foundry (Microsoft.MachineLearningServices/workspaces, kind: Hub/Project)
**Category**: Data & AI
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure AI Foundry provides a unified platform for building, training, and deploying AI models using a Hub/Project architecture. The Hub centralizes shared resources (Key Vault, Storage Account, Application Insights, Container Registry) while Projects provide isolated workspaces for teams. The service enforces defense-in-depth security: managed VNet isolation with approved-outbound-only egress, Private Endpoint access, managed identity authentication, customer-managed key encryption for workspace data, compute isolation, data exfiltration prevention, and comprehensive operation logging.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the AI Foundry Hub, optional Project, Private Endpoint, and diagnostic settings. Model training, deployments, and compute targets are managed separately within the Hub/Project.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Azure AI Developer | Resource (via PIM) | Build and manage AI models, deployments, and compute. JIT activation required. | AC-2, AC-3, AC-6 |
| Azure Machine Learning Workspace Writer | Resource (via PIM) | Manage workspace configuration. JIT activation required. | AC-2, AC-3, AC-6 |
| AzureML Data Scientist | Resource | Submit experiments, manage models, create endpoints for application managed identities. Standing assignment. | AC-3 |
| Reader | Resource group | Read-only access for auditors. Standing assignment. | AC-3, AU-6 |
| Monitoring Reader | Resource group | Read-only access to metrics and logs for NOC team. Standing assignment. | AU-6 |

### Managed Identity

- Type: System-assigned (both Hub and Project)
- Usage: Hub identity accesses associated resources (Key Vault, Storage, Container Registry); Project inherits access via Hub managed VNet
- Compute identity: Managed identity for compute clusters and instances
- NIST: IA-2, IA-5

---

## Network Security Controls

### Managed VNet Isolation

- Isolation mode: **AllowOnlyApprovedOutbound** — all egress restricted to explicitly approved destinations
- Compute clusters and instances run within the managed VNet
- Data exfiltration prevention: Outbound traffic limited to approved Azure services only
- No direct internet egress from compute
- NIST: SC-7

### Private Endpoint

- Status: Required
- Private DNS Zone: `privatelink.api.azureml.ms`
- All workspace API traffic flows exclusively through Private Endpoint
- NIST: SC-7

### Data Exfiltration Prevention

- Managed VNet egress: Approved outbound only
- Storage Account: Private Endpoint access, no public access
- Key Vault: Private Endpoint access, no public access
- Container Registry: Private Endpoint access, no public access
- NIST: SC-7, AC-4

---

## Compute Isolation

### Compute Clusters

- VNet: Managed VNet (no public IP)
- Identity: Managed identity for resource access
- SSH: Disabled in production
- NIST: SC-7, IA-2

### Compute Instances

- VNet: Managed VNet (no public IP)
- Identity: Assigned user identity
- SSH: Disabled in production
- Auto-shutdown: Enabled for cost and security
- NIST: SC-7, IA-2

---

## Encryption Controls

### Encryption at Rest

- Default: Platform-managed keys (AES-256)
- Optional: Customer-managed key via Key Vault (when `key_vault_key_id` provided)
- Scope: Workspace metadata, stored models, datasets, and experiment results
- FIPS 140-2: Azure Machine Learning Services uses FIPS 140-2 validated cryptographic modules
- NIST: SC-13, SC-28

### Encryption in Transit

- Protocol: TLS 1.2+ for all API and compute communication
- FIPS 140-2: Azure TLS uses FIPS 140-2 validated cryptographic modules
- Internal compute: Encrypted inter-node communication
- NIST: SC-8, SC-13

---

## Logging & Monitoring Controls

- Diagnostic categories: AmlComputeClusterEvent, AmlComputeClusterNodeEvent, AmlComputeJobEvent, AmlComputeCpuGpuUtilization, AmlRunStatusChangedEvent, ModelsChangeEvent, ModelsReadEvent, ModelsActionEvent, DeploymentReadEvent, DeploymentEventACI, DeploymentEventAKS, InferencingOperationAKS, EnvironmentChangeEvent, EnvironmentReadEvent, DataLabelChangeEvent, DataLabelReadEvent, DataSetChangeEvent, DataSetReadEvent, PipelineChangeEvent, PipelineReadEvent, RunEvent, RunMetricEvent
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: EL2 for operation logs
- Alert rules: Unauthorized compute access, model deployment failure, data exfiltration attempt
- NIST: AU-2, AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| SC-7 | Boundary Protection | Managed VNet (AllowOnlyApprovedOutbound); Private Endpoint; public access disabled | Terraform: public_network_access_enabled = false, managed_network, PE; Policy: deny-aifoundry-public-access-v1 |
| SC-8 | Transmission Confidentiality | TLS 1.2 for all API and compute communication | Platform guarantee |
| SC-13 | Cryptographic Protection | FIPS 140-2 validated modules; optional CMK | Terraform: encryption block |
| SC-28 | Protection of Information at Rest | CMK for workspace data; platform-managed keys default | Terraform: encryption block |
| IA-2 | Identification and Authentication | Managed identity for Hub, Project, and compute | Terraform: identity; Policy: audit-aifoundry-managed-identity-v1 |
| AU-12 | Audit Generation | 22 diagnostic log categories enabled | Terraform: diagnostic settings; Policy: audit-aifoundry-diagnostic-settings-v1 |

---

## DISA STIG Mapping

No published DISA STIG for Azure AI Foundry / Machine Learning Services. Compensating controls: NIST 800-53 controls + CIS Azure Benchmark (per R-002).

*"No published DISA STIG for this service. Compensating controls: NIST 800-53 + CIS Benchmark."*

---

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)

| NIST 800-171 Control | Implementation | NIST 800-53 Mapping |
|----------------------|----------------|---------------------|
| 3.1.1 Limit system access to authorized users | Managed identity; Entra ID RBAC | AC-2, AC-3, IA-2 |
| 3.5.1 Identify system users | Entra ID authentication; managed identity | IA-2 |
| 3.13.1 Monitor, control, and protect communications at external boundaries | Managed VNet; Private Endpoint; no public access | SC-7 |
| 3.13.8 Implement cryptographic mechanisms for CUI in transit | TLS 1.2 for all communication | SC-8, SC-13 |
| 3.13.11 Employ FIPS-validated cryptography | FIPS 140-2 validated modules | SC-13 |

### CMMC 2.0 Level 2

| Practice | Implementation |
|----------|----------------|
| SC.L2-3.13.1 | Managed VNet; Private Endpoint; data exfiltration prevention |
| SC.L2-3.13.8 | TLS 1.2 for all communication |
| SC.L2-3.13.11 | FIPS 140-2 validated cryptographic modules |
| AC.L2-3.1.1 | Managed identity auth; Entra ID RBAC |
| AU.L2-3.3.1 | 22 diagnostic log categories enabled |

### OMB M-21-31 (Logging Maturity)

- Target tier: EL2
- Achieved tier: EL2 — All compute, model, and pipeline log categories collected

---
