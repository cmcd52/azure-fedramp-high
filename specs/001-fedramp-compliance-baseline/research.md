# Research: FedRAMP High Compliance Baseline

**Branch**: `001-fedramp-compliance-baseline` | **Date**: 2026-03-27
**Input**: Technical Context from plan.md — resolving all NEEDS CLARIFICATION and dependency best practices.

---

## R-001: Azure Built-in Policies per Service (Reference vs. Custom)

**Decision**: Use Azure built-in policies wherever they exist and meet FedRAMP High requirements. Create custom policies only when no built-in policy exists or when the built-in policy's effect/parameters are insufficient.

**Rationale**: Built-in policies are maintained by Microsoft, automatically updated for new API versions, and recognized by Azure Security Center/Defender for Cloud compliance dashboards. Custom policies carry maintenance burden and must be manually updated when resource provider APIs change.

**Approach per service group**:

| Service Group | Built-in Policy Coverage | Custom Policy Gaps |
|---------------|--------------------------|---------------------|
| **Identity (Entra ID, B2C)** | Limited — Entra ID policies are mostly Conditional Access (not Azure Policy). B2C has minimal built-in policy coverage. | Custom policies needed for B2C configuration enforcement, token lifetime validation. Entra ID compliance is primarily through Conditional Access and admin portal settings, not Azure Policy. |
| **Networking (Front Door, Bastion, ExpressRoute, Private Endpoint, DNS)** | Good coverage — built-in policies exist for Private Endpoint enforcement, TLS version, WAF enablement on Front Door. | Custom policies may be needed for DNS Private Resolver specific configurations, VM-based DNS STIG enforcement via Guest Configuration. |
| **Compute/Storage (App Service, Functions, Storage, Key Vault)** | Strong coverage — Microsoft ships FedRAMP High initiative that includes many of these. Built-in policies for encryption, HTTPS-only, minimum TLS, Private Endpoint, diagnostic settings. | Custom policies for: CMK enforcement where built-in only checks platform keys, specific FIPS-validated cipher suites, environment-aware effect toggling. |
| **Data/AI (OpenAI, AI Search, Purview, etc.)** | Variable — newer AI services have fewer built-in policies. Azure OpenAI has some. Purview and AI Foundry have limited coverage. | Custom policies needed for: AI service network isolation (some lack built-in PE enforcement), content filtering configuration, data residency. |
| **M365 (GCC, GCC-H)** | Not applicable — M365 compliance is managed through Microsoft 365 compliance center, not Azure Policy. | N/A — M365 controls documented as configuration baselines, not Azure Policy definitions. |

**Alternatives considered**:
- Write all custom policies from scratch → Rejected: unnecessary maintenance burden where built-ins exist.
- Use only built-in policies → Rejected: gaps in AI services, B2C, and FIPS-specific enforcement.

**Key reference**: [Microsoft FedRAMP High built-in policy initiative](https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high) — provides a baseline set to reference and extend.

---

## R-002: DISA STIGs per Service Availability

**Decision**: Map DISA STIGs where published. Document "No STIG available" with compensating controls (NIST 800-53 + CIS Benchmarks) for services without STIGs.

**Rationale**: DISA publishes STIGs for specific technologies, not all Azure services. Missing STIGs do not mean non-compliance — NIST 800-53 controls and CIS Benchmarks provide equivalent or broader coverage.

**STIG availability assessment**:

| Service/Technology | STIG Available | STIG ID / Notes |
|--------------------|----------------|-----------------|
| Windows Server (VMs for DNS) | **Yes** | Windows Server 2022 STIG (V1R5+). Directly applicable to DNS VMs. |
| Microsoft 365 (general) | **Yes** | Microsoft 365 STIG (multiple versions for Teams, SharePoint, Exchange, OneDrive). |
| Azure Active Directory / Entra ID | **Yes** | Microsoft Azure Active Directory STIG. Applies to Conditional Access, MFA, guest access. |
| Azure SQL / Databases | **Yes** | Azure SQL Database STIG — not directly in scope but patterns applicable to storage encryption. |
| IIS / Web Applications | **Yes** | Useful patterns for App Service if running on IIS-based plans. |
| Azure Key Vault | **No** | No DISA STIG. Use NIST 800-53 SC (System Communications) and IA (Identification/Authentication) families. CIS Azure benchmark covers Key Vault. |
| Azure Storage Account | **No** | No dedicated STIG. CIS Azure Foundations Benchmark + NIST 800-53 SC family. |
| Azure OpenAI / AI Services | **No** | No STIGs for any Azure AI services. Rely on NIST 800-53 controls and Microsoft security baselines. |
| Azure Networking (Front Door, Bastion, etc.) | **No** | No service-specific STIGs. Network STIG (general) provides some patterns. NIST 800-53 SC family for network controls. |
| Azure Monitor / Log Analytics | **No** | No STIG. NIST 800-53 AU family is the primary control source. |
| Azure Purview | **No** | No STIG. NIST 800-53 controls + CIS benchmarks. |
| Intune / Endpoint Manager | **Partial** | No dedicated Intune STIG, but Microsoft Endpoint Manager is referenced in mobile device STIGs. |

**Key references**:
- [DISA STIG Library](https://public.cyber.mil/stigs/)
- [DISA STIG Viewer](https://www.stigviewer.com/)
- [CIS Microsoft Azure Foundations Benchmark](https://www.cisecurity.org/benchmark/azure)

---

## R-003: Microsoft Security Baselines per Service

**Decision**: Reference Microsoft security baselines from Microsoft Defender for Cloud, Microsoft Learn security documentation, and the Azure Security Benchmark (ASB) v3 / Microsoft Cloud Security Benchmark (MCSB) as the primary Microsoft-authored guidance layer.

**Rationale**: Microsoft publishes security baselines for Azure services that map to CIS, NIST 800-53, and other frameworks. These baselines define the recommended secure configuration per service and are the authoritative Microsoft source for what "compliant" looks like.

**Baseline sources**:
1. **Microsoft Cloud Security Benchmark (MCSB)** — successor to Azure Security Benchmark v3. Maps controls to NIST 800-53, CIS, and PCI-DSS. Per-service security baseline documents published on Microsoft Learn.
2. **Microsoft Defender for Cloud Recommendations** — built-in recommendations per service aligned with regulatory standards. Provides compliance score tracking.
3. **Microsoft Learn service security documentation** — per-service "Security baseline" articles (e.g., "Azure Storage security baseline").
4. **Azure Well-Architected Framework (Security Pillar)** — architectural patterns for secure deployment.

**Per-service baseline mapping approach**:
- For each in-scope service, locate the MCSB security baseline article on Microsoft Learn.
- Cross-reference MCSB control IDs with NIST 800-53 Rev 5 control IDs.
- Document gaps where MCSB recommendations are less strict than FedRAMP High requirements.
- Where Microsoft's baseline is insufficient (e.g., MCSB recommends platform-managed keys but FedRAMP High mandates CMK), document the enhancement.

**Key references**:
- [Microsoft Cloud Security Benchmark overview](https://learn.microsoft.com/en-us/security/benchmark/azure/overview)
- [Azure service security baselines](https://learn.microsoft.com/en-us/security/benchmark/azure/security-baselines-overview)

---

## R-004: FIPS 140-2 Validation Certificates for Azure Services

**Decision**: Document the specific FIPS 140-2/140-3 validation certificate for each service's cryptographic module. Where a service relies on an underlying platform module (e.g., Windows CNG), reference that module's certificate.

**Rationale**: FedRAMP High requires FIPS 140-2 validated cryptographic modules (Constitution Principle IV, FR-035). Azure services use several validated modules depending on the service tier and operation.

**Azure FIPS 140 validation landscape**:

| Cryptographic Module | FIPS 140-2 Certificate | Used By |
|----------------------|----------------------|---------|
| Windows CNG (Cryptographic Next Generation) | Multiple certificates (updated periodically) | VMs for DNS, any service running on Windows Server |
| Azure Storage Service Encryption | Validated via underlying platform module | Storage Account, Blob, Queue, Table, File |
| Azure TLS implementation | Validated via Windows/OpenSSL module | All services enforcing TLS 1.2+ |
| Azure Key Vault HSM | FIPS 140-2 Level 2 (software) / Level 3 (HSM) | Key Vault, CMK for all services |
| Azure SQL TDE | Validated via Windows CNG | Not directly in scope but pattern reference |

**Approach**:
- For each encryption configuration, document: algorithm (AES-256), mode, key length, and FIPS 140-2 certificate reference.
- Where a service's FIPS status is unclear in Microsoft documentation, flag as "FIPS status: requires verification" with the evidence gap documented.
- Reference Microsoft's FIPS 140 validation page: [Azure FIPS 140-2 validation](https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-fips-140-2)

**Alternatives considered**:
- Assume all Azure services are FIPS-validated → Rejected: not all services or configurations use FIPS-validated modules (e.g., some client-side SDKs may use non-FIPS OpenSSL by default).
- Require customer-managed FIPS HSM for everything → Rejected: overkill for services where platform encryption is already FIPS-validated. CMK via Key Vault HSM used where supported.

---

## R-005: Terraform Best Practices for Compliance-as-Code Repositories

**Decision**: Follow HashiCorp's module structure conventions with compliance-specific enhancements: per-service modules, shared infrastructure modules, environment parameterization, and inline control mappings.

**Rationale**: Standard Terraform module patterns ensure the modules are composable, testable, and usable by infrastructure engineers without compliance-specific training.

**Module interface conventions**:
- Each service module: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md`
- Required variables for all modules: `environment` (production/lower), `location`, `resource_group_name`, `log_analytics_workspace_id`, `tags`
- Shared infrastructure outputs consumed by service modules (no hardcoded resource IDs)
- Provider version pinned in `versions.tf` with `~>` constraint
- State backend configuration in a dedicated `state-backend/` module

**Validation approach**:
1. `terraform fmt -check` — formatting
2. `terraform validate` — syntax and provider schema
3. `terraform plan` — dry-run against a test subscription (lower environment)
4. Policy compliance evaluation — assign policy initiative and verify zero violations
5. `tflint` (optional) — linting for common Terraform anti-patterns

**Alternatives considered**:
- Bicep instead of Terraform → Rejected: user specified Terraform/HCL. Bicep is Azure-only and less portable for multi-tool workflows.
- Terraform Cloud for state → Rejected: Azure Storage backend specified for state (FR-012). Keeps state within the Azure compliance boundary.

---

## R-006: Azure Policy Schema and Naming Conventions

**Decision**: Follow the Azure Policy JSON schema with a structured naming convention: `{effect}-{service}-{control}-{version}`.

**Rationale**: Consistent naming enables programmatic discovery, audit trail, and lifecycle management. The Azure Policy JSON schema is the only accepted format for custom policy definitions.

**Naming convention**:
- Policy definition: `deny-storageaccount-public-access-v1`
- Policy initiative: `fedramp-high-{service-group}-v1` (e.g., `fedramp-high-identity-v1`)
- Display name: `[FedRAMP High] {Service}: {Control Description}`
- Category (metadata): `FedRAMP High`
- Version in metadata: semver `1.0.0`

**Effect parameter strategy**:
```json
{
  "effect": {
    "type": "String",
    "defaultValue": "Deny",
    "allowedValues": ["Audit", "Deny", "Disabled"],
    "metadata": {
      "displayName": "Effect",
      "description": "Production: Deny. Lower environment: Audit."
    }
  }
}
```

**Policy lifecycle**:
1. New policies start as `Audit` in lower environment
2. Validate against test resources → confirm expected behavior
3. Promote to `Deny` in production
4. Exemptions documented with expiration date and control mapping justification

---

## R-007: M365 GCC vs. GCC-H Feature and Configuration Divergences

**Decision**: Document each M365 sub-service (SharePoint, Exchange, Teams, OneDrive) with separate GCC and GCC-H sections, explicitly calling out divergences.

**Rationale**: GCC and GCC-H have different feature availability, endpoint URLs, licensing requirements, and compliance certifications. GCC-H operates at DoD IL5 with additional restrictions.

**Key divergence areas**:

| Area | GCC | GCC-H |
|------|-----|-------|
| **Data residency** | US data centers | US data centers (DoD-cleared personnel) |
| **Compliance certification** | FedRAMP High | FedRAMP High + DoD SRG IL5 |
| **Azure AD integration** | Standard Entra ID | Separate GCC-H Entra ID — limited cross-tenant |
| **External sharing** | Configurable (restrict to .gov) | Highly restricted by default |
| **Third-party app availability** | Limited vs. commercial | More limited than GCC |
| **Teams features** | Near-parity with commercial | Reduced feature set (no some third-party integrations) |
| **Licensing** | GCC-specific SKUs | GCC-H-specific SKUs (higher cost) |
| **Interop with Azure Commercial** | Supported with configuration | Requires explicit trust configuration |

**Research references**:
- Existing project research: `research/m365-gcch-azure-commercial-interop/README.md`
- Existing project research: `research/m365-cross-tenant-identity-sync/README.md`
- [Microsoft 365 Government plans](https://learn.microsoft.com/en-us/office365/servicedescriptions/office-365-platform-service-description/office-365-us-government/office-365-us-government)

---

## R-008: Cross-Tenant B2B Guest Access Patterns

**Decision**: Document the Conditional Access policy chain for B2B guest access between Primary and Parent Org tenants, including home tenant policies + resource tenant policies, and identify gaps where guest controls cannot match member-equivalent controls.

**Rationale**: Per the architecture reference, primary domain users access the Parent Org tenant as B2B guests. This creates a dual-policy environment where both the home tenant (Primary) and resource tenant (Parent Org) enforce Conditional Access.

**Key findings**:
- Home tenant Conditional Access policies apply to the user's authentication session.
- Resource tenant Conditional Access policies apply to the resource access decision.
- Cross-tenant access settings (Entra ID → External Identities → Cross-tenant access) define inbound/outbound trust for MFA and device compliance claims.
- **Gap**: Device compliance claims from the home tenant are only trusted by the resource tenant if explicit cross-tenant access settings are configured. Without this, guests may face redundant MFA prompts or be blocked.
- **Gap**: Conditional Access policies for "guest" users in the resource tenant are a separate policy set from "member" policies — this can result in weaker controls unless explicitly configured to match.

---

## R-009: OMB M-21-31 Event Logging Maturity Tiers

**Decision**: Target EL3 (Advanced) for critical security events and EL1 (Basic) minimum for all other events, per the spec requirements.

**Rationale**: OMB M-21-31 defines four tiers (EL0–EL3). FedRAMP High agencies are expected to achieve EL3 for critical security events. Azure diagnostic settings support varying log categories that map to these tiers.

**Tier mapping for Azure services**:
- **EL0 (Not Effective)**: No diagnostic settings enabled → Non-compliant. Not acceptable.
- **EL1 (Basic)**: Activity logs, basic diagnostic logs → Minimum for non-critical service operations.
- **EL2 (Intermediate)**: All diagnostic log categories enabled, centralized in Log Analytics, 12-month online retention.
- **EL3 (Advanced)**: All EL2 + advanced threat detection alerts, cross-service correlation, security event categorization, automated alerting within SLA. Requires Azure Sentinel/Microsoft Defender for Cloud integration for full EL3.

**Per-service implementation**: Each service's `logging/` artifact will specify which diagnostic log categories map to which EL tier and document the maximum achievable tier for that service.

---

## R-010: Hybrid Identity Security — Entra Connect Hardening

**Decision**: Document Entra Connect server hardening as a prerequisite dependency for the cloud identity posture, covering: server OS STIG, sync method selection rationale, and trust boundary definition.

**Rationale**: Per the architecture reference, on-premises AD syncs to Entra ID via hybrid identity (Entra Connect). The Entra Connect server is a Tier 0 asset — compromise of this server compromises the entire cloud identity plane.

**Key security controls**:
1. **Server hardening**: Windows Server DISA STIG + CIS Benchmark. Dedicated server, no co-hosted applications. Limited admin group.
2. **Sync method**: Password Hash Sync (PHS) recommended by Microsoft as most resilient. Pass-through Authentication (PTA) if PHS is not permitted by policy. Federation (AD FS) only if required by specific authentication flows. Document chosen method with NIST 800-53 IA family justification.
3. **Network**: Outbound-only connectivity (no inbound ports). Communication to Azure AD over TLS 1.2.
4. **Monitoring**: Azure AD Connect Health for sync monitoring. Alerts for sync failures, password change events, and suspicious sign-in activities.
5. **Trust boundary**: Document that on-premises AD compromise = cloud identity compromise. Define minimum on-prem hardening requirements as prerequisites.

---

## R-011: NIST SP 800-63-4 Identity Assurance Levels for Authentication Flows

**Decision**: Map each authentication flow in the architecture to NIST SP 800-63-4 assurance levels (IAL, AAL, FAL).

**Rationale**: FedRAMP High typically requires AAL2 minimum for standard access and AAL3 for privileged access (FR-036). The architecture has multiple distinct authentication flows.

**Authentication flow mapping**:

| Flow | Identity Provider | Target AAL | Mechanism |
|------|-------------------|------------|-----------|
| Workforce sign-in (standard) | Entra ID | AAL2 | MFA (phishing-resistant preferred: FIDO2, Windows Hello) |
| Workforce sign-in (privileged/PIM) | Entra ID | AAL3 | Hardware-bound MFA (FIDO2 key or certificate-based auth) |
| B2B Guest access (Primary → Parent Org) | Entra ID (home tenant) | AAL2 | MFA from home tenant, trusted by resource tenant |
| Customer sign-in (B2C) | Azure AD B2C | IAL1/AAL1–AAL2 | Depends on B2C policy — MFA optional per user flow |
| Service-to-service | Managed Identity | N/A | Token-based, no user authentication |
| Admin VM access | Bastion + Entra ID | AAL2+ | MFA + Conditional Access + Bastion session |

---

## R-012: Supply Chain Risk Management for Terraform Providers

**Decision**: Document provider verification, version pinning, and lock file practices per NIST SP 800-161 Rev 1 and EO 14028.

**Rationale**: FR-028 requires supply chain risk documentation. Terraform providers are third-party dependencies that execute with infrastructure-level privileges.

**Controls**:
1. **Provider source**: Only `hashicorp/azurerm` from the official Terraform Registry.
2. **GPG signature verification**: Terraform automatically verifies provider signatures against HashiCorp's GPG key on `terraform init`.
3. **Version pinning**: `required_providers` block with `~>` constraint (e.g., `~> 3.0`). Exact version recorded in `.terraform.lock.hcl`.
4. **Lock file**: `.terraform.lock.hcl` committed to version control. Contains hash checksums for each provider binary.
5. **Update process**: Provider updates reviewed for breaking changes before lock file update. New versions validated in lower environment first.

---

## R-013: Environment Configuration Delta Strategy (Production vs. Lower)

**Decision**: Every Terraform module and control baseline includes an explicit environment parameter. Lower environment deviations are documented inline with justification.

**Rationale**: FR-014 and FR-041 require documented deviations. The lower environment must meet a minimum baseline (encryption in transit, diagnostic logging, identity controls matching production) but may relax certain controls for development velocity.

**Relaxation categories for lower environment**:

| Control Area | Production Default | Lower Default | Justification |
|--------------|-------------------|---------------|---------------|
| Policy effect (critical) | Deny | Audit | Allow iterative development without blocking |
| Encryption at rest | CMK (Key Vault) | Platform-managed key | Avoids Key Vault dependency in dev; TLS in transit still enforced |
| Network isolation | Private Endpoint required | Private Endpoint required | **No relaxation** — minimum baseline |
| Diagnostic logging | Full categories, 12mo retention | Full categories, 30-day retention | Reduced cost; log categories match production |
| Identity/RBAC/MFA | Full enforcement | Full enforcement | **No relaxation** — minimum baseline |
| DISA STIG (VMs) | Full STIG baseline | Reduced — critical findings only | Dev VMs are ephemeral; critical findings still enforced |

---

**Research complete. All NEEDS CLARIFICATION items resolved. Proceeding to Phase 1.**
