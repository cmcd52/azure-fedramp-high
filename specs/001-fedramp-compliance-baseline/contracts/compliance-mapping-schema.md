# Contract: Compliance Mapping Index Schema

**Applies to**: Root-level `compliance-mapping-index.md` and its machine-readable companion.

---

## Purpose

The compliance mapping index is the consolidated, navigable reference that maps every configuration decision across all services and artifact types to its authoritative source. An auditor MUST be able to trace any configuration setting to its justification within 2 minutes using this index (SC-009).

## Index Entry Schema

Each row in the compliance mapping index MUST contain these fields:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `service` | string | Yes | Service name from azure-services-reference.md |
| `serviceGroup` | enum | Yes | `identity`, `networking`, `compute-storage`, `data-ai` |
| `configurationSetting` | string | Yes | Specific setting (e.g., "Encryption at rest with CMK") |
| `artifactType` | enum | Yes | `policy`, `terraform`, `control-baseline`, `logging` |
| `artifactPath` | string | Yes | Relative path from repo root to the artifact file |
| `nist80053Controls` | string[] | Yes | NIST 800-53 Rev 5 control IDs (e.g., `SC-8, SC-13`) |
| `controlFamily` | string | Yes | NIST 800-53 family code (e.g., `SC`, `AC`, `AU`) |
| `frameworks` | string[] | Yes | All applicable: FedRAMP, FISMA, FIPS 140, STIG, DFARS/CUI, CMMC, EO 14028, etc. |
| `stigFindingId` | string | Conditional | DISA STIG finding ID. Required if STIG exists for the service. `N/A` otherwise. |
| `fips140CertRef` | string | Conditional | FIPS 140-2/3 certificate. Required for encryption entries. `N/A` otherwise. |
| `nist800171Control` | string | Conditional | NIST 800-171 Rev 3 control ID. Required for CUI-relevant entries. |
| `cmmcPractice` | string | Conditional | CMMC 2.0 practice ID. Required where CMMC mapping exists. |
| `sourceUrl` | string | Yes | Authoritative documentation URL |
| `environment` | enum | Yes | `all`, `production`, `lower` |
| `severity` | enum | Yes | `High`, `Medium`, `Low` |

## Index File Format

### Markdown (Human-Readable)

The primary `compliance-mapping-index.md` at the repo root is organized by service group, then by service, with entries sorted by NIST control family.

```markdown
# Compliance Mapping Index

## Identity Services

### Entra ID

| Setting | Artifact | NIST 800-53 | Frameworks | STIG | Source |
|---------|----------|-------------|------------|------|--------|
| MFA enforcement | [controls/identity.md](path) | IA-2(1) | FedRAMP, CMMC L2 | V-xxxxx | [URL](url) |
```

### CSV (Machine-Readable) — Optional Companion

A `compliance-mapping-index.csv` may be generated alongside the Markdown for programmatic consumption (audit tool integration, filtering, pivot tables).

## Filtering Requirements

The index MUST support filtering by:
1. **Service** — all entries for a given service
2. **NIST 800-53 control ID** — all entries satisfying a specific control
3. **Framework** — all entries mapped to a specific compliance framework
4. **Artifact type** — all policies, or all Terraform configs, etc.
5. **Service group** — all entries within identity, networking, etc.
6. **Severity** — all High entries across all services

## Completeness Validation

The index is complete when:
- Every service in azure-services-reference.md has at least one entry per applicable artifact type
- Every NIST 800-53 Rev 5 High baseline control (per NIST SP 800-53B) maps to at least one service configuration
- Every framework listed in the constitution's regulatory hierarchy has at least one index entry
- Every encryption entry has a `fips140CertRef` value
- No entry has an empty `sourceUrl`

## Cross-Reference Integrity

- Every `artifactPath` MUST point to an existing file in the repository
- Every `service` value MUST match an entry in azure-services-reference.md
- Every `nist80053Controls` value MUST be a valid NIST 800-53 Rev 5 control identifier
- Every `sourceUrl` MUST be a working URL to authoritative documentation (Microsoft Learn, NIST, DISA, etc.)
