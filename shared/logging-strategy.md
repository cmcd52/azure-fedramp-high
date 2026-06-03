# Centralized Logging Strategy

**Applies to**: All Azure services in scope
**FR**: FR-030 (Centralized logging strategy)
**NIST 800-53**: AU-2, AU-3, AU-6, AU-11, AU-12
**OMB M-21-31**: Event Logging Maturity Tiers EL0–EL3
**NIST SP 800-137**: Continuous monitoring alignment

---

## Log Analytics Workspace Topology

| Environment | Workspace | Retention (Online) | Retention (Archived) | Total Retention |
|-------------|-----------|-------------------|---------------------|-----------------|
| Production | 1 centralized workspace | 365 days (12 months) | 548 days (18 months) | 18 months |

**Rationale**: One workspace per environment provides centralized correlation while maintaining environment isolation. Production retention meets FedRAMP High AU-11 (12 months online minimum, 18 months total).

**Architecture**: Per the architecture reference, each environment has a dedicated Log Analytics workspace deployed via the `shared/terraform/log-analytics/` module. All service diagnostic settings route to the environment's workspace.

---

## OMB M-21-31 Event Logging Maturity Tiers

### Tier Definitions

| Tier | Name | Requirements | Azure Implementation |
|------|------|-------------|---------------------|
| EL0 | Not Effective | No logging | Non-compliant — not acceptable |
| EL1 | Basic | Basic logging, minimum categories | Activity logs + basic diagnostic categories |
| EL2 | Intermediate | Full diagnostic categories, centralized, 12-month retention | All diagnostic categories → Log Analytics, 365-day retention |
| EL3 | Advanced | EL2 + threat detection, cross-correlation, automated alerting | Microsoft Sentinel + Defender for Cloud + custom alert rules |

### Tier Targets per Event Category

| Event Category | Target Tier | Rationale |
|----------------|-------------|-----------|
| Authentication events (sign-in, MFA) | **EL3** | Critical security — credential attacks are #1 threat |
| Authorization events (RBAC changes, policy violations) | **EL3** | Critical — privilege escalation detection |
| Key Vault operations (key/secret access/modification) | **EL3** | Critical — cryptographic material access |
| Network security events (NSG flow, WAF, firewall) | **EL3** | Critical — perimeter breach detection |
| Resource modification events (create, update, delete) | **EL2** | Important — configuration drift detection |
| Diagnostic/operational events (health, performance) | **EL1** | Operational — minimum required |
| Data plane operations (storage access, API calls) | **EL2** | Important — data access auditing |

---

## Data Retention Requirements

### FedRAMP High AU-11

| Retention Phase | Duration | Storage Tier | Purpose |
|----------------|----------|-------------|---------|
| Online (hot) | 12 months (365 days) | Log Analytics workspace | Interactive query, alerting, investigation |
| Archived (cold) | 6 additional months | Log Analytics archive OR Storage Account | Long-term retention, compliance |
| **Total** | **18 months (548 days)** | — | FedRAMP High AU-11 compliance |

### Retention Configuration per Service

Every service's `logging/config.md` specifies:
- Production: 365 days online + archive to 548 days total
- Lower: 30 days online, no archive

---

## Per-Service Diagnostic Settings Standard

Every Azure service diagnostic setting MUST configure:

| Setting | Value | NIST Control |
|---------|-------|--------------|
| All available log categories | Enabled | AU-2, AU-3 |
| All available metric categories | Enabled | AU-2 |
| Destination | Shared Log Analytics workspace | AU-6 |
| Retention (production) | 365 days (workspace-level) | AU-11 |
| Archive | 548 days total | AU-11 |

### Diagnostic Setting Naming Convention

`{resource-name}-diag` — one diagnostic setting per resource, routing all categories to the centralized workspace.

---

## Cross-Service Log Correlation

### Correlation Approach

1. **Common schema fields**: All Azure diagnostic logs include `tenantId`, `subscriptionId`, `resourceId`, `operationName`, `correlationId`, `callerIpAddress`
2. **Sentinel workbooks**: Custom workbooks correlating identity events (Entra ID sign-ins) ↔ resource access (Key Vault, Storage) ↔ network events (NSG flow logs)
3. **Correlation ID tracking**: Azure operation correlation IDs chain related operations across services (e.g., Conditional Access evaluation → Token issuance → Resource access)

### Key Correlation Scenarios

| Scenario | Log Sources | Alert Priority |
|----------|-------------|----------------|
| Credential compromise → data access | Entra ID sign-in logs + Key Vault audit + Storage data plane | Critical |
| Policy violation → configuration drift | Azure Activity Log + Azure Policy state changes | High |
| Network intrusion → lateral movement | NSG flow logs + Bastion session logs + VM security events | Critical |
| Privilege escalation | Entra ID audit logs (role assignments) + PIM logs | Critical |

---

## Alert Rules Standard

### Required Alert Categories

| Alert Category | Condition | Severity | NIST Control | OMB M-21-31 |
|---------------|-----------|----------|--------------|-------------|
| Authentication failure spike | >10 failed sign-ins in 5 min from same IP | Sev 2 (Warning) | IA-5, SI-4 | EL3 |
| Policy violation detected | Any Deny effect triggered | Sev 3 (Informational) | CM-6, SI-4 | EL2 |
| Key Vault critical operation | Key deletion, secret purge | Sev 1 (Error) | SC-12, AU-12 | EL3 |
| RBAC role assignment change | Any role assignment create/delete | Sev 2 (Warning) | AC-2, AC-6 | EL3 |
| Resource deletion | Any critical resource deleted | Sev 1 (Error) | CM-3, CP-9 | EL2 |
| NSG rule modification | Any NSG rule added/changed/deleted | Sev 2 (Warning) | SC-7 | EL3 |
| Diagnostic setting removed | Any diagnostic setting deleted | Sev 1 (Error) | AU-12 | EL3 |

### Alert Action Groups

- **Critical (Sev 0-1)**: Email + SMS + ServiceNow/ITSM integration
- **Warning (Sev 2)**: Email + Logic App automation
- **Informational (Sev 3)**: Log only + dashboard update

---

## NIST SP 800-137 Continuous Monitoring Alignment

| NIST SP 800-137 Requirement | Implementation |
|-----------------------------|---------------|
| Automated monitoring of security controls | Azure Policy continuous compliance evaluation |
| Real-time alerting for security events | Microsoft Sentinel + custom alert rules |
| Security status reporting | Defender for Cloud compliance dashboard |
| Configuration management monitoring | Azure Policy configuration drift detection |
| Vulnerability tracking | Defender for Cloud vulnerability assessment |
| Risk assessment updates | Quarterly compliance review cycle |

---

## CISA BOD 22-01 Alignment

Alert rules include indicators for Known Exploited Vulnerabilities (KEV):
- Defender for Cloud vulnerability assessment maps to CISA KEV catalog
- Custom alerts for exploitation attempts matching KEV signatures
- FR-031: Alert rules aligned with CISA BOD 22-01

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | OMB M-21-31 Improving Investigation Capabilities | https://www.whitehouse.gov/wp-content/uploads/2021/08/M-21-31-Improving-the-Federal-Governments-Investigative-and-Remediation-Capabilities-Related-to-Cybersecurity-Incidents.pdf |
| 2 | NIST SP 800-53 Rev 5 AU Family | https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final |
| 3 | NIST SP 800-137 Continuous Monitoring | https://csrc.nist.gov/publications/detail/sp/800-137/final |
| 4 | Azure Monitor Diagnostic Settings | https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings |
| 5 | Microsoft Sentinel Overview | https://learn.microsoft.com/en-us/azure/sentinel/overview |
| 6 | Log Analytics Data Retention | https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure |
| 7 | CISA BOD 22-01 | https://www.cisa.gov/binding-operational-directive-22-01 |

---

## Wave 2 Service Coverage (Appended 2026-05-12)

All 95 Wave 2 services follow the same diagnostic settings pattern established in Wave 1. Each service module includes an `azurerm_monitor_diagnostic_setting` resource configured identically.

### Diagnostic Settings Pattern (Wave 2)

| Parameter | Value | Rationale |
|-----------|-------|-----------|
| **Destination** | Shared Log Analytics workspace (`var.log_analytics_workspace_id`) | Centralized correlation per workspace topology above |
| **Category group** | `allLogs` | Wave 2 default; captures all available diagnostic categories. Per-service category refinement occurs during service-specific approval review. |
| **Metrics** | `AllMetrics` enabled | Operational monitoring and performance baseline |
| **Retention** | 12 months online (Log Analytics), 18 months total (6 months archived to Storage Account) | FedRAMP High AU-11 compliance |

### OMB M-21-31 Tier Mapping for Wave 2

Wave 2 services inherit the same tier targets defined in the Wave 1 strategy above. By service category:

| Service Category | Event Types | Target Tier | Implementation |
|-----------------|-------------|-------------|----------------|
| **Compute & Storage** (azure-backup, azure-batch, managed-disks, virtual-machines, VMSS, etc.) | Resource CRUD, access audits, backup operations | EL2 | Full diagnostic categories via `allLogs`; Defender for Cloud for EL3 threat detection |
| **Containers** (AKS, container-registry, container-apps, container-instances) | API server audit, image push/pull, container lifecycle | EL2 | Kubernetes audit logs (EL3 for API server auth events); container insights |
| **Data & AI** (cosmos-db, sql-database, databricks, machine-learning, etc.) | Data plane access, query execution, model training | EL2 | SQL auditing (EL3 for auth failures); Cosmos DB data plane logs |
| **Networking** (application-gateway, azure-firewall, load-balancer, WAF, etc.) | Traffic flow, firewall rules, WAF triggers | EL3 | Network security events are critical tier per Wave 1 policy |
| **Security** (key-vault-managed-hsm, defender-for-cloud, sentinel, attestation) | Key operations, security alerts, policy violations | EL3 | All security service events are critical tier |
| **Identity** (entra-domain-services) | Authentication, authorization, directory changes | EL3 | Identity events are critical tier per Wave 1 policy |
| **Integration** (api-management, service-bus, event-grid, logic-apps) | Message delivery, API calls, workflow execution | EL2 | Standard operational logging; auth events elevated to EL3 |
| **IoT** (iot-hub, iot-dps, digital-twins) | Device telemetry, provisioning, twin changes | EL2 | Device authentication events elevated to EL3 |
| **Management** (automation, azure-arc, azure-policy, managed-grafana) | Runbook execution, policy evaluation, configuration changes | EL2 | Policy violation events elevated to EL3 |
| **DevOps** (load-testing, chaos-studio, microsoft-dev-box) | Test execution, experiment results | EL1 | Operational events; no critical security data |

### NIST SP 800-137 Continuous Monitoring Alignment

The Wave 2 logging infrastructure supports NIST SP 800-137 continuous monitoring through three mechanisms:

1. **Automated compliance assessment**: Azure Policy evaluates all 111 service modules continuously. Non-compliant resources generate `AzureActivity` log entries categorized as policy violations (EL3 tier).
2. **Near-real-time security detection**: Microsoft Sentinel ingests Log Analytics data from all services. Analytic rules provide detection within minutes for critical events (authentication anomalies, configuration drift, unauthorized access).
3. **Periodic compliance reporting**: Azure Policy compliance dashboard provides real-time aggregate compliance percentage. Monthly review cadence produces compliance trend reports per NIST 800-53 control family.

### OMB M-21-31 Maturity Tier Rollup

| Tier | Wave 1 Services | Wave 2 Services | Total | Percentage |
|------|----------------|-----------------|-------|------------|
| **EL3** (Advanced) | 9 (networking + security + identity) | 12 (networking, security, identity service categories) | 21 | 19% |
| **EL2** (Intermediate) | 12 (compute, storage, data, AI) | 78 (compute, containers, data, integration, IoT, management) | 90 | 81% |
| **EL1** (Basic) | 2 (operational-only services) | 5 (devops, non-critical management) | 7 | 6% |

> Note: Services may have individual log categories at different tiers (e.g., an EL2 service has authentication events at EL3). The tier above reflects the service's primary classification.

### Cross-Service Log Correlation Approach

All services — Wave 1 and Wave 2 — route diagnostic data to the same per-environment Log Analytics workspace, enabling cross-service correlation:

| Correlation Method | Fields | Use Case |
|-------------------|--------|----------|
| **Resource graph** | `ResourceId`, `ResourceGroup`, `SubscriptionId` | Trace events across resources in the same deployment |
| **Request tracing** | `CorrelationId`, `OperationId` | Track a single API call through dependent resources |
| **Identity correlation** | `CallerObjectId`, `CallerIpAddress` | Link actions by the same identity across services |
| **Time-window correlation** | `TimeGenerated` (±5 min window) | Detect coordinated multi-service attacks |

**Tooling**: Azure Monitor Workbooks provide pre-built cross-service security dashboards. Microsoft Sentinel fusion rules correlate anomalies across identity, network, and data plane logs automatically.
