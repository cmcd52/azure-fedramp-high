# Contract: Azure Policy Definition Schema

**Applies to**: All custom Azure Policy definitions under `services/{group}/{service}/policies/`

---

## JSON Schema

Every custom policy definition MUST conform to this schema. Built-in policies are referenced by ID only, not redefined.

```json
{
  "name": "{effect}-{service}-{control}-v{version-number}",
  "properties": {
    "displayName": "[FedRAMP High] {Service}: {Control Description}",
    "description": "{Detailed description of what this policy enforces and why}",
    "mode": "All | Indexed",
    "policyType": "Custom",
    "metadata": {
      "version": "1.0.0",
      "category": "FedRAMP High",
      "service": "{GA Azure Commercial service name; must be covered or recorded in docs/azure-service-exclusions.md}",
      "nistControls": ["SC-8", "SC-13"],
      "frameworks": ["FedRAMP High", "DFARS/CUI", "CMMC 2.0 L2"],
      "severity": "High | Medium | Low",
      "fipsApplicable": true,
      "fips140CertRef": "{Certificate number or 'Platform module'}",
      "stigFindingId": "{STIG finding ID or 'No STIG available'}",
      "environment": "all | production | lower"
    },
    "parameters": {
      "effect": {
        "type": "String",
        "defaultValue": "Deny",
        "allowedValues": ["Audit", "Deny", "Disabled"],
        "metadata": {
          "displayName": "Effect",
          "description": "Production default: Deny for critical controls, Audit for advisory. Lower environment: Audit for all."
        }
      }
    },
    "policyRule": {
      "if": {
        "allOf": [
          { "field": "type", "equals": "{resource-provider/type}" },
          { "...condition...": "...value..." }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
    }
  }
}
```

## Naming Convention

| Component | Pattern | Example |
|-----------|---------|---------|
| Policy definition name | `{effect}-{service}-{control}-v{N}` | `deny-storageaccount-public-access-v1` |
| Display name | `[FedRAMP High] {Service}: {Description}` | `[FedRAMP High] Storage Account: Deny public blob access` |
| Initiative name | `fedramp-high-{service-group}-v{N}` | `fedramp-high-compute-storage-v1` |
| Initiative display name | `[FedRAMP High] {Service Group} Controls` | `[FedRAMP High] Compute & Storage Controls` |

## Effect Parameter Strategy

| Control Criticality | Production Default | Lower Default |
|--------------------|-------------------|---------------|
| Critical (encryption, network isolation, identity) | `Deny` | `Audit` |
| Advisory (tagging, naming, diagnostics) | `Audit` | `Audit` |

## Versioning

- Semver: `MAJOR.MINOR.PATCH`
- MAJOR: Breaking change to policy rule (new denials, scope change)
- MINOR: New conditions, metadata updates
- PATCH: Description, references

## File Structure

```text
services/{group}/{service}/policies/
├── definitions/
│   ├── {effect}-{service}-{control}-v1.json    # Individual policy definitions
│   └── ...
├── initiatives/
│   └── fedramp-high-{service}-v1.json          # Policy initiative referencing definitions
├── built-in-references.md                       # List of referenced built-in policy IDs
└── README.md                                    # Policy coverage summary for this service
```

## Required Metadata Fields

Every custom policy definition MUST include ALL of these metadata fields:

- `nistControls` — at least one NIST 800-53 Rev 5 control ID
- `frameworks` — at least one compliance framework
- `severity` — High, Medium, or Low
- `service` — must identify a GA Azure Commercial service that is either covered by deliverables or recorded in `docs/azure-service-exclusions.md`
- `fipsApplicable` — boolean (required for any encryption-related policy)
- `environment` — scope applicability
