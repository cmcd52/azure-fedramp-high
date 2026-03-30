# Security Control Baseline: Azure Application Insights

**Service**: Azure Application Insights
**Category**: Networking
**Last Updated**: 2026-03-27
**Environment**: Production

## Service Overview

Azure Application Insights provides application performance monitoring (APM) for web applications deployed in the FedRAMP High environment. It collects telemetry including requests, dependencies, exceptions, traces, page views, and custom events. Application Insights MUST be deployed in workspace-based mode, linking to the shared Log Analytics workspace for centralized query, unified retention, and consistent RBAC.

Application telemetry can inadvertently capture sensitive data (PII, authentication tokens, query parameters with CUI). Custom telemetry emitted by application code MUST be sanitized before submission — Application Insights does not automatically filter sensitive data.

**Configuration method**: Terraform (`terraform/main.tf`) deploys the Application Insights component with workspace-based mode, local authentication disabled, sampling rate configured, and daily data cap set.

---

## Identity & Access Controls

### RBAC Assignments

| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| Application Insights Component Contributor | Resource (via PIM) | Manages Application Insights configuration, availability tests, and export settings. JIT activation required. | AC-2, AC-3, AC-6 |
| Monitoring Reader | Resource | Read-only access to Application Insights telemetry for developers and NOC team. Standing assignment. | AC-3, AU-6 |
| Reader | Resource group | Read-only access to Application Insights configuration for auditors. Standing assignment. | AC-3, AU-6 |

### Authentication

- **Local authentication**: Disabled — enforced by `audit-appinsights-local-auth-disabled-v1` policy
- **Entra ID**: All API access (ingestion and query) authenticated via Entra ID
- **SDK authentication**: Application SDK uses Entra ID managed identity or connection string with AAD authentication
- NIST: IA-2

### Managed Identity

- Type: Application-level (the application hosting Application Insights SDK uses its managed identity for telemetry ingestion)
- Application Insights component itself: No managed identity — it is a data sink
- NIST: IA-2, IA-5

---

## Data Retention and Sampling Controls

### Retention

- **Component-level retention**: 90 days (default) — configurable up to 730 days
- **Workspace retention**: Telemetry forwarded to Log Analytics workspace inherits workspace retention (365 days minimum per policy)
- **Archive**: Data exported via workspace data export rule to storage for long-term retention
- NIST: AU-11

### Sampling

- **Server-side sampling**: Configured via `sampling_percentage` variable in Terraform
- **Adaptive sampling**: Available in SDK — automatically adjusts volume under load
- **Production recommendation**: 100% sampling for security-critical applications; reduced sampling acceptable for high-volume non-security telemetry
- NIST: AU-2 (ensure security-relevant events are not sampled out)

### Daily Data Cap

- **Purpose**: Prevents unexpected cost spikes from telemetry volume anomalies
- **Default**: 10 GB/day (configurable per application requirements)
- **Alert**: Configure alert when daily cap is approaching to avoid data loss
- NIST: N/A (operational/cost control)

---

## PII Exclusion Controls

### Application Code Requirements

- **Custom telemetry**: Application code MUST NOT emit PII or sensitive data (SSN, email, authentication tokens, CUI) in custom events, traces, or metrics
- **TelemetryInitializers**: Use SDK TelemetryInitializers to strip or hash sensitive fields before submission
- **TelemetryProcessors**: Use SDK TelemetryProcessors to filter events containing sensitive patterns
- **URL scrubbing**: Application Insights automatically strips query parameters from request URLs — verify this for custom URL tracking
- **Exception details**: Exception messages may contain sensitive data — implement exception filtering in the SDK pipeline
- NIST: AC-3, SC-28 (data minimization for audit records)

### IP Masking

- **Default**: IP addresses are masked (last octet zeroed) in Application Insights
- **Configuration**: `disable_ip_masking = false` in Terraform (default — do not change without privacy review)
- NIST: AC-3

---

## Network Security Controls

### Private Link (via AMPLS)

- **Requirement**: Application Insights SHOULD be included in Azure Monitor Private Link Scope (AMPLS) for private-only ingestion and query
- **Configuration**: AMPLS is managed separately from this module — see Azure Monitor service documentation
- **Limitation**: AMPLS has a limit of 50 resources per scope
- NIST: SC-7

### Public Endpoint

- Status: Application Insights has public endpoints for ingestion and query by default
- Mitigation: Configure AMPLS for private-only access when required
- Data in transit: TLS 1.2+ enforced for all SDK and API communications
- NIST: SC-7, SC-8

---

## Encryption Controls

### Encryption at Rest

- **Workspace-based**: Telemetry stored in Log Analytics workspace — encryption managed at workspace level
- **CMK**: If workspace has CMK enabled (via Log Analytics cluster), Application Insights data is encrypted with CMK
- NIST: SC-28

### Encryption in Transit

- Protocol: TLS 1.2+ for all SDK telemetry submission and API queries
- NIST: SC-8, SC-13

---

## Logging & Monitoring Controls

- Diagnostic categories: AppAvailabilityResults, AppBrowserTimings, AppDependencies, AppEvents, AppExceptions, AppMetrics, AppPageViews, AppPerformanceCounters, AppRequests, AppSystemEvents, AppTraces
- Workspace-based: All telemetry forwarded to shared Log Analytics workspace
- Destination: Centralized Log Analytics workspace
- OMB M-21-31 tier: EL1 (operational telemetry)
- NIST: AU-3, AU-6, AU-12
- See: `logging/config.md` for full logging configuration

---

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| AU-3 | Content of Audit Records | Application Insights captures request details (who, what, when, duration, result), dependencies, exceptions with stack traces | Telemetry schema: requests, dependencies, exceptions tables |
| AU-6 | Audit Review, Analysis, and Reporting | Workspace-based mode enables cross-service correlation in Log Analytics; alerts on exception spikes and availability failures | Terraform: workspace_id; audit-appinsights-workspace-based-v1 policy |
| AU-12 | Audit Generation | Application Insights SDK auto-collects requests, dependencies, exceptions; diagnostic settings forward all categories | Terraform: diagnostic settings with all 11 categories |
| IA-2 | Identification and Authentication | Local authentication disabled; Entra ID required for all API access | Terraform: local_authentication_disabled = true; audit-appinsights-local-auth-disabled-v1 policy |

## DISA STIG Mapping

No published DISA STIG for Azure Application Insights. Compensating controls: NIST 800-53 AU-3, AU-6, AU-12, IA-2 applied directly, workspace-based mode enforcement, local authentication disablement, PII exclusion requirements.

---

## Additional Framework Mappings

| Framework | Control | Implementation |
|-----------|---------|----------------|
| DFARS 252.204-7012 | Adequate security for CUI | Telemetry sanitized for PII/CUI; encrypted at rest and in transit |
| CMMC 2.0 L2 | AU.L2-3.3.1 | Application-level auditing via Application Insights |
| OMB M-21-31 | EL1 | Operational telemetry with centralized retention |
