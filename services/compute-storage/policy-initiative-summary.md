# Compute & Storage Services — Policy Initiative Summary

> **Version**: 1.0.0 | **Date**: 2026-03-27 | **FR**: FR-007

## Custom Initiatives

| Service | Initiative | Scope | Policy Count |
|---------|-----------|-------|-------------|
| App Service | appservice-fedramp-high | App subscription(s) | 4 |
| Azure Functions | functions-fedramp-high | App subscription(s) | 3 |
| Azure Storage Account | storage-fedramp-high | Root management group | 5 |
| Key Vault | keyvault-fedramp-high | Root management group | 4 |

### Azure Storage Account (Most Restrictive — 5 Deny Policies)

| # | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
|---|--------|---------------|----------------|-------------|
| 1 | deny-storage-public-access | Deny | Deny | SC-7 |
| 2 | deny-storage-shared-key | Deny | Audit | AC-3, IA-2 |
| 3 | deny-storage-http | Deny | Deny | SC-8 |
| 4 | deny-storage-old-tls | Deny | Deny | SC-8, SC-13 |
| 5 | audit-storage-cmk | Audit | Audit | SC-13, SC-28 |

### Key Vault

| # | Policy | Effect (Prod) | Effect (Lower) | NIST Control |
|---|--------|---------------|----------------|-------------|
| 1 | deny-keyvault-soft-delete | Deny | Deny | CP-9 |
| 2 | deny-keyvault-purge-protection | Deny | Deny | CP-9 |
| 3 | deny-keyvault-rbac-auth | Deny | Audit | AC-3, AC-6 |
| 4 | audit-keyvault-key-expiration | Audit | Audit | SC-12 |

## Built-In Policy References

| Service | Built-In Policy | NIST Control |
|---------|----------------|-------------|
| App Service | App Service should use a virtual network service endpoint | SC-7 |
| App Service | App Service should require FTPS only | SC-8 |
| App Service | App Service should use latest TLS version | SC-8, SC-13 |
| Functions | Function apps should use managed identity | IA-2 |
| Storage | Storage accounts should restrict network access | SC-7 |
| Storage | Secure transfer should be enabled | SC-8 |
| Storage | Storage accounts should use CMK | SC-13, SC-28 |
| Key Vault | Key vaults should have purge protection enabled | CP-9 |
| Key Vault | Key vaults should use private link | SC-7 |
| Key Vault | Key Vault keys should have expiration date | SC-12 |

## Assignment Strategy

- **Root Management Group**: Storage Account, Key Vault initiatives (universal services)
- **App Subscriptions**: App Service, Azure Functions initiatives
- **Exemption Process**: Per organizational policy lifecycle governance

---

*Compute & Storage Services — Azure Policy compliance artifacts.*


## Wave 2 (Pending Approval)

_Generated 2026-04-28 by `scripts/wave2/generate.py`. Each row is **** per FedRAMP High compliance baseline._

| Initiative | Service | NIST Families | Path |
|---|---|---|---|
| `fedramp-high-azure-backup-v1` | Azure Backup | CP, AU, SC | [policies/](./azure-backup/policies/) |
| `fedramp-high-azure-batch-v1` | Azure Batch | AC, SC, AU | [policies/](./azure-batch/policies/) |
| `fedramp-high-azure-files-premium-v1` | Azure Files (Premium) | AC, SC, AU | [policies/](./azure-files-premium/policies/) |
| `fedramp-high-compute-gallery-v1` | Azure Compute Gallery | AC, CM | [policies/](./compute-gallery/policies/) |
| `fedramp-high-data-box-v1` | Azure Data Box | MP, SC, AU | [policies/](./data-box/policies/) |
| `fedramp-high-dedicated-host-v1` | Azure Dedicated Host | SC, CM | [policies/](./dedicated-host/policies/) |
| `fedramp-high-hpc-v1` | Azure HPC | AC, SC, AU | [policies/](./hpc/policies/) |
| `fedramp-high-managed-disks-v1` | Azure Managed Disks | SC, CM | [policies/](./managed-disks/policies/) |
| `fedramp-high-netapp-files-v1` | Azure NetApp Files | AC, SC, AU | [policies/](./netapp-files/policies/) |
| `fedramp-high-service-fabric-v1` | Azure Service Fabric | AC, SC, AU | [policies/](./service-fabric/policies/) |
| `fedramp-high-site-recovery-v1` | Azure Site Recovery | CP, AU, SC | [policies/](./site-recovery/policies/) |
| `fedramp-high-spring-apps-v1` | Azure Spring Apps | AC, SC, AU | [policies/](./spring-apps/policies/) |
| `fedramp-high-static-web-apps-v1` | Static Web Apps | SC, IA, AU | [policies/](./static-web-apps/policies/) |
| `fedramp-high-virtual-machine-scale-sets-v1` | Virtual Machine Scale Sets | AC, SC, AU, CM, SI | [policies/](./virtual-machine-scale-sets/policies/) |
| `fedramp-high-virtual-machines-v1` | Virtual Machines | AC, SC, AU, CM, SI | [policies/](./virtual-machines/policies/) |
| `fedramp-high-vmware-solution-v1` | Azure VMware Solution | AC, SC, CM | [policies/](./vmware-solution/policies/) |
