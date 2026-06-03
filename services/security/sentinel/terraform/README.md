# Microsoft Sentinel — Terraform Module



## Compliance Profile

| Control Surface | Status |
|-----------------|--------|
| Private Endpoint | no |
| Managed Identity | n/a |
| Customer-Managed Key encryption-at-rest | service-managed only |
| Diagnostic logging to Log Analytics | yes — `azurerm_monitor_diagnostic_setting` to Log Analytics |

## Inputs

See [`variables.tf`](variables.tf).

## Outputs

See [`outputs.tf`](outputs.tf).

## Usage

```hcl
module "sentinel" {
  source = "./services/security/sentinel/terraform"

  name                       = "..."
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  log_analytics_workspace_id = module.log_analytics.workspace_id



  tags = local.fedramp_tags
}
```

## NIST 800-53 References

This module implements controls in families: **AU, IR, SI**.
See [../controls/baseline.md](../controls/baseline.md) for control-by-control evidence.

## Pending Review Items

- [ ] Verify `azurerm_sentinel_log_analytics_workspace_onboarding` argument schema against current azurerm provider version.
- [ ] Add SKU / tier arguments specific to this service.
- [ ] Add `public_network_access_enabled = false` (or service-specific equivalent) where supported.
- [ ] Add CMK encryption block where applicable.
- [X] ~~Replace `subresource_names = ["TODO_SUBRESOURCE_NAME"]`~~ in the Private Endpoint with the correct subresource name for `Microsoft.OperationsManagement/solutions`.
- [ ] Replace `category_group = "allLogs"` with explicit category list if `allLogs` is not supported by this resource type.
