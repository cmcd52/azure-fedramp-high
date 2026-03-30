locals {

  # SC-28: Encryption — CMK encryption
  encryption_key_type = "CustomerManaged"

  # AU-11: Retention — 365 days
  retention_days = 365

  # SC-28: Soft-delete retention — 90 days
  soft_delete_days = 90

  # AC-3: Shared key access — disabled (RBAC-only)
  shared_key_enabled = false
}
