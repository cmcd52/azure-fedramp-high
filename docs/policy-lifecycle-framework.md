# Azure Policy Lifecycle Framework

**FR**: FR-006 | **NIST 800-53**: CM-2, CM-3, CM-6, CM-8, CA-7, SI-2
**Constitution**: v8.0.0 — All GA Azure Commercial Services
**Last Updated**: 2026-05-12

---

## 1. Effect Escalation Path (Audit → Deny)

All new Azure Policy definitions follow a staged escalation model before reaching enforcement. This approach prevents breaking existing workloads while ensuring compliance gaps are identified and resolved.

### Escalation Stages

| Stage | Effect | Duration | Exit Criteria | Environment |
|-------|--------|----------|---------------|-------------|
| **1 — Baseline** | `Audit` | 30 days minimum | Zero false positives over the observation window | Production + Lower |
| **2 — Enforcement** | `Deny` (critical) / `Audit` (advisory) | Permanent | Stage 1 exit criteria met; change advisory board approval | Production only |
| **3 — Lower Steady-State** | `Audit` | Permanent | N/A — lower environment remains Audit to enable testing | Lower only |

### Control Classification for Effect Selection

| Category | Controls | Production Effect | Lower Effect | Rationale |
|----------|----------|-------------------|--------------|-----------|
| **Critical** | Encryption at rest, encryption in transit, network isolation, identity/authentication | `Deny` | `Audit` | Prevents non-compliant resource creation; too strict for dev/test |
| **Advisory** | Tagging, naming conventions, recommended settings | `Audit` | `Audit` | Informational — does not block |
| **Remediation** | Diagnostic settings, network watcher flow logs, tag corrections | `DeployIfNotExists` / `Modify` | `DeployIfNotExists` / `Modify` | Auto-remediates non-compliant resources |

### Escalation Procedure

1. Deploy policy definition with `Audit` effect (default parameter value).
2. Assign to target scope (management group level per FR-007).
3. Monitor Azure Policy compliance dashboard for 30 days.
4. Review and triage non-compliant resources — confirm they are true positives.
5. Update the policy assignment parameter to `Deny` for critical controls in production.
6. Document the escalation decision in the compliance mapping index.

**Source**: [Azure Policy effects](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effects) | [Azure Policy effect basics](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics)

---

## 2. Exemption Process

Azure Policy exemptions allow documented exceptions for resources that cannot comply due to technical constraints, pending remediation, or approved risk acceptance.

### Exemption Requirements

Every exemption MUST include:

| Field | Description | Example |
|-------|-------------|---------|
| **Resource Scope** | Resource ID, resource group, or subscription | `/subscriptions/.../resourceGroups/rg-legacy/...` |
| **Policy Definition** | The specific policy definition being exempted | `audit-storage-cmk-v1` |
| **Exemption Category** | `Waiver` (risk accepted) or `Mitigated` (compensating control in place) | `Mitigated` |
| **NIST 800-53 Control** | Control(s) impacted by the exemption | SC-28 (Encryption at Rest) |
| **Justification** | Business and technical rationale | "Legacy app migration in progress — CMK not yet configured" |
| **Compensating Control** | Alternative control mitigating the risk (required for `Mitigated`) | "Platform-managed encryption with AES-256 active" |
| **Expiration Date** | Maximum 90 days; renewable with re-approval | 2026-08-10 |
| **Approver** | Name and role of the authorizing official | Security Officer |

### Exemption Lifecycle

1. **Request**: Resource owner submits exemption request with all required fields.
2. **Review**: Security team validates justification and compensating controls.
3. **Approve**: Authorizing official approves with expiration date (max 90 days).
4. **Implement**: Create `Microsoft.Authorization/policyExemptions` resource at the target scope.
5. **Monitor**: Azure Policy compliance dashboard flags exempted resources with `Exempt` status.
6. **Expire/Renew**: At expiration, the exemption is automatically removed. Renewal requires a new review cycle.

### Auto-Expiration Enforcement

- All exemptions MUST use the `expiresOn` property in the Azure Policy exemption resource.
- Azure Policy automatically removes expired exemptions and returns resources to non-compliant status.
- A scheduled alert rule notifies owners 14 days before exemption expiration.

**Source**: [Azure Policy exemptions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure)

---

## 3. Remediation Task Guidance

### DeployIfNotExists (DINE)

Used when a child or extension resource MUST exist alongside the primary resource but is missing.

| Use Case | Policy Pattern | Remediation Action |
|----------|---------------|-------------------|
| **Diagnostic settings** | Check `Microsoft.Insights/diagnosticSettings` exists for the resource | Auto-create diagnostic settings routing to the shared Log Analytics workspace |
| **Network Watcher flow logs** | Check flow logs exist for NSGs | Auto-create flow log resource with retention settings |
| **Microsoft Defender plans** | Check Defender is enabled for the resource type | Auto-enable the appropriate Defender plan |

**Remediation procedure**:
1. Assign the DINE policy with a managed identity (system-assigned).
2. Grant the managed identity the minimum RBAC role required to create the child resource (e.g., `Monitoring Contributor` for diagnostic settings).
3. Create a remediation task via Azure Portal, CLI, or Terraform (`azurerm_policy_remediation`).
4. Monitor remediation task status — verify all non-compliant resources are remediated.
5. DINE policies automatically remediate newly created resources going forward.

### Modify

Used to add, update, or remove properties on existing resources without replacing them.

| Use Case | Policy Pattern | Remediation Action |
|----------|---------------|-------------------|
| **Tag enforcement** | Check required tags exist with correct values | Auto-add or correct missing/incorrect tags |
| **TLS version upgrade** | Check `minTlsVersion` is `1.2` | Auto-update `minTlsVersion` property |

**Remediation procedure**:
1. Assign the Modify policy with a managed identity.
2. Grant the managed identity the minimum RBAC role required to modify the resource properties (e.g., `Tag Contributor` for tagging).
3. Create a remediation task for existing non-compliant resources.
4. Modify policies automatically correct newly created or updated resources.

**Source**: [Azure Policy remediation](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources) | [DINE effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deploy-if-not-exists) | [Modify effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify)

---

## 4. Versioning Schema

Policy definitions in this project use a semantic versioning schema encoded in the definition file name.

### Naming Convention

```
<effect>-<service-slug>-<control-slug>-v<MAJOR>.json
```

**Examples**:
- `deny-storage-public-access-v1.json`
- `audit-cosmos-db-cmk-v1.json`
- `deploy-storage-diagnostic-settings-v1.json`

### Version Rules

| Version Component | Increment When | Impact |
|-------------------|---------------|--------|
| **MAJOR** (`v1` → `v2`) | Breaking change: new deny condition, removed parameter, changed resource type scope, changed default effect | Requires new policy initiative reference; old version may be deprecated but not deleted (to avoid breaking existing assignments) |
| **MINOR** (tracked in `metadata.version` inside JSON) | Non-breaking: refined description, added metadata, expanded NIST mapping, corrected display name | In-place update; no initiative reference change required |

### Version Metadata

Each policy definition JSON includes a `metadata.version` field:

```json
{
  "properties": {
    "metadata": {
      "version": "1.0",
      "category": "Encryption",
      "nistControls": ["SC-28"],
      "frameworks": ["FedRAMP High"]
    }
  }
}
```

### Deprecation Process

1. Create the new version (`-v2.json`) with updated logic.
2. Update the policy initiative to reference the new version.
3. Add `"deprecated": true` to the old version's metadata.
4. Old version assignments continue to function until manually updated.
5. Remove deprecated versions after all assignments are migrated (minimum 90-day grace period).

**Source**: [Azure Policy definition structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure) | [Built-in policy versioning](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure#version)

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Policy effects overview | https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effects |
| 2 | Azure Policy exemption structure | https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure |
| 3 | Azure Policy remediation | https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources |
| 4 | Azure Policy definition structure | https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure |
| 5 | NIST 800-53 Rev 5 CM Family | https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final |
| 6 | FedRAMP Continuous Monitoring Strategy Guide | https://www.fedramp.gov/assets/resources/documents/CSP_Continuous_Monitoring_Strategy_Guide.pdf |
