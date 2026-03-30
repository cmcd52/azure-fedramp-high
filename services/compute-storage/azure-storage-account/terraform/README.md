# Terraform Module: Azure Storage Account

## Overview

Deploys an Azure Storage Account with FedRAMP High compliant defaults including CMK encryption, no public access, RBAC-only access, and comprehensive diagnostic logging across all sub-services.

## Usage

```hcl
module "storage_account" {
  source = "./services/compute-storage/azure-storage-account/terraform"

  environment                = "production"
  location                   = "usgovvirginia"
  resource_group_name        = "rg-storage-prod"
  log_analytics_workspace_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.OperationalInsights/workspaces/law-shared"
  storage_account_name       = "stmyappprod001"
  key_vault_key_id           = "https://kv-shared.vault.azure.net/keys/storage-cmk/..."
  cmk_identity_id            = "/subscriptions/.../resourceGroups/.../providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-storage-cmk"
  subnet_id                  = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/virtualNetworks/.../subnets/pe-subnet"
  private_dns_zone_id        = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  tags = {
    environment          = "production"
    compliance-framework = "FedRAMP-High"
    owner                = "platform-team"
  }
}
```

## Required Inputs

| Variable | Type | Description |
|----------|------|-------------|
| `environment` | string | `production` or `lower` |
| `location` | string | Azure region (US only) |
| `resource_group_name` | string | Target resource group |
| `log_analytics_workspace_id` | string | Log Analytics workspace ID |
| `storage_account_name` | string | Storage Account name (3-24 chars, lowercase + numbers) |

## Optional Inputs

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | map(string) | `{}` | Resource tags |
| `subnet_id` | string | `null` | PE subnet ID |
| `private_dns_zone_id` | string | `null` | PE DNS zone ID |
| `key_vault_key_id` | string | `null` | CMK key ID (required in production) |
| `account_tier` | string | `Standard` | Storage tier |
| `account_replication` | string | `GRS` | Replication type |
| `cmk_identity_id` | string | `null` | User-assigned identity for CMK |

## Outputs

| Output | Description |
|--------|-------------|
| `resource_id` | Storage Account resource ID |
| `resource_name` | Storage Account name |
| `private_endpoint_id` | Blob PE resource ID |
| `diagnostic_setting_id` | Diagnostic setting ID |
| `primary_blob_endpoint` | Blob endpoint URL |
| `primary_access_key` | Access key (sensitive) |

## NIST 800-53 Control Coverage

| Control | Implementation |
|---------|----------------|
| SC-7 | Private Endpoint + network rules deny all |
| SC-8 | HTTPS-only, TLS 1.2 |
| SC-13 | FIPS 140-2 validated encryption (CMK via Key Vault HSM) |
| SC-28 | CMK encryption, blob versioning, soft-delete |
| AC-3 | Shared key disabled, RBAC-only access |
| AU-12 | Diagnostic settings for all 4 sub-services |
