# Built-in Policy References: Azure Maps

**Service**: Azure Maps
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Azure Maps Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Azure Maps accounts should disable local authentication | `(check Azure Policy catalog)` | Audit | IA-2 | Shared key disablement |

> **Note**: Azure Maps has LIMITED built-in policy coverage. Unlike Cognitive Services or Machine Learning, Azure Maps has few Azure Policy built-in definitions. Most governance is achieved through application-level controls and compensating mechanisms.

### Azure Maps–Specific Considerations

| Consideration | Status | Notes |
|--------------|--------|-------|
| Private Endpoint support | **NOT SUPPORTED** | Azure Maps does not support Private Endpoint. Documented as exception with compensating controls. |
| Public network access policy | No built-in policy | Azure Maps is inherently a public-facing API. Compensating controls: managed identity auth, CORS restrictions, IP restrictions, Front Door WAF. |
| CORS enforcement | No built-in policy | Custom policy required (`audit-maps-cors-restrictions-v1`) |
| Managed identity auth | Limited built-in | Custom policy provides explicit managed identity enforcement |

> **EXCEPTION**: Azure Maps does NOT support Private Endpoint (SC-7 exception). Compensating controls per FedRAMP POA&M:
> 1. Managed identity authentication (disable shared key auth in production)
> 2. CORS origin restrictions (authorized domains only)
> 3. Azure Front Door WAF in front of map tile requests
> 4. IP address restrictions at the application/infrastructure level
> 5. No sensitive data in map queries (tile requests only)

---

## Custom Policy Requirement (per R-001)

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `audit-maps-managed-identity-v1` | Audit | IA-2 | Managed Identity preferred over shared key |
| `audit-maps-cors-restrictions-v1` | Audit | AC-4 | CORS restrictions configured |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Maps documentation | https://learn.microsoft.com/en-us/azure/azure-maps/about-azure-maps |
| 2 | Azure Maps authentication | https://learn.microsoft.com/en-us/azure/azure-maps/azure-maps-authentication |
| 3 | Azure Maps managed identity | https://learn.microsoft.com/en-us/azure/azure-maps/how-to-manage-authentication |
| 4 | Azure Maps security baseline | https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/azure-maps-security-baseline |
| 5 | Azure Policy built-in definitions | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies |
| 6 | FedRAMP High built-in policy initiative | https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high |
