# Azure Resource Graph — Terraform Module

Azure Resource Graph is an API-only query service. It does not have a deployable ARM resource type supported by the azurerm Terraform provider (`azurerm_resource_graph_query` does not exist).

If/when the azurerm provider adds a resource for `Microsoft.ResourceGraph/queries` (saved queries), regenerate this module via `scripts/wave2/generate.py` or author it manually.

ARM resource type: `Microsoft.ResourceGraph/queries` (saved queries — not currently in azurerm)
Service group: management

## Compliance Profile

| Control Surface | Status |
|-----------------|--------|
| Private Endpoint | Not applicable (API-only service) |
| Managed Identity | n/a |
| Customer-Managed Key encryption-at-rest | service-managed only |
| Diagnostic logging to Log Analytics | via Activity Log only |

## NIST 800-53 References

This service addresses controls in families: **AU, CM**.
See [../controls/baseline.md](../controls/baseline.md) for control-by-control evidence.
