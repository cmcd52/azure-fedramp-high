# Identity Services — Policy Initiative Summary

> **Version**: 1.0.0 | **Date**: 2026-03-27 | **FR**: FR-007

## Custom Initiatives

### Azure AD B2C Compliance Initiative

- **Initiative**: `b2c-fedramp-high-initiative`
- **Definition**: [policies/initiative.json](azure-ad-b2c/policies/initiative.json)
- **Scope**: Subscription containing B2C tenant
- **Assignment**: `assign-b2c-fedramp-high`
- **Policies Included**:
  | # | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
  |---|--------|---------------|----------------|-------------|
  | 1 | audit-b2c-token-lifetime | Audit | Audit | SC-23, IA-5 |
  | 2 | audit-b2c-custom-domain | Audit | Audit | IA-8 |
  | 3 | audit-b2c-mfa-enabled | Audit | Audit | IA-2(1) |
- **Environment Override**: All B2C policies are Audit-only (compliance reporting layer)

## Built-In Policy References

| Service | Built-In Policy | Policy ID | NIST Control |
|---------|----------------|-----------|-------------|
| B2C | Azure AD B2C should have diagnostic logs enabled | Built-in | AU-2 |
| Managed Identity | — | No built-in policies | — |

## Assignment Strategy

- **B2C Subscription**: B2C initiative (B2C-specific subscription only)
- **Exemption Process**: Per organizational policy lifecycle governance

---

*Identity Services — Azure Policy compliance artifacts.*


## Wave 2 (Pending Approval)

_Generated 2026-04-28 by `scripts/wave2/generate.py`. Each row is **** per FedRAMP High compliance baseline._

| Initiative | Service | NIST Families | Path |
|---|---|---|---|
| `fedramp-high-entra-domain-services-v1` | Microsoft Entra Domain Services | AC, IA, AU | [policies/](./entra-domain-services/policies/) |
