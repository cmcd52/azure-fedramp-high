# Microsoft Defender for Cloud — Terraform Module



## Compliance Profile

| Control Surface | Status |
|-----------------|--------|
| Private Endpoint | no |
| Managed Identity | n/a |
| Customer-Managed Key encryption-at-rest | service-managed only |
| Diagnostic logging to Log Analytics | via Activity Log only |

## Inputs

See [`variables.tf`](variables.tf).

## Outputs

See [`outputs.tf`](outputs.tf).

## Usage

```hcl
module "defender_for_cloud" {
  source = "./services/security/defender-for-cloud/terraform"

  name                       = "..."
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  log_analytics_workspace_id = module.log_analytics.workspace_id



  tags = local.fedramp_tags
}
```

## NIST 800-53 References

This module implements controls in families: **RA, SI, AU, CA**.
See [../controls/baseline.md](../controls/baseline.md) for control-by-control evidence.

## Pending Review Items

- [ ] Verify `azurerm_security_center_subscription_pricing` argument schema against current azurerm provider version.
- [ ] Add SKU / tier arguments specific to this service.
- [ ] Add `public_network_access_enabled = false` (or service-specific equivalent) where supported.
- [ ] Add CMK encryption block where applicable.
- [X] ~~Replace `subresource_names = ["TODO_SUBRESOURCE_NAME"]`~~ in the Private Endpoint with the correct subresource name for `Microsoft.Security/pricings`.
- [ ] Replace `category_group = "allLogs"` with explicit category list if `allLogs` is not supported by this resource type.
