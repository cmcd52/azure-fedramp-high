# Quickstart: FedRAMP High Compliance Baseline Repository

**Branch**: `001-fedramp-compliance-baseline`

---

## What This Repository Produces

This is a **compliance artifact repository**, not a compiled application. It produces:

| Artifact Type | Format | Location |
|---------------|--------|----------|
| Azure Policy definitions | JSON | `services/{group}/{service}/policies/` |
| Terraform modules | HCL | `services/{group}/{service}/terraform/` |
| Security control baselines | Markdown | `services/{group}/{service}/controls/` |
| Logging configurations | Markdown + HCL | `services/{group}/{service}/logging/` |
| Compliance mapping index | Markdown (+ CSV) | `compliance-mapping-index.md` |
| Centralized logging strategy | Markdown | `shared/logging-strategy.md` |

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Terraform | 1.x (latest stable) | `terraform validate`, `terraform plan` |
| Azure CLI | Latest | Authentication for Terraform |
| Git | Any | Version control |

**No build system, package manager, or runtime required.**

## Repository Layout

```
services/           # Per-service compliance artifacts (23 services)
├── identity/       # B2C, Managed Identity
├── networking/     # ExpressRoute, Front Door, Bastion, DNS, VMs, Monitor
├── compute-storage/# App Service, Functions, Storage, Key Vault
└── data-ai/        # OpenAI, AI Search, Purview, Event Hubs, etc.

shared/             # Shared infrastructure Terraform modules
├── terraform/      # Log Analytics, Key Vault, VNet, DNS, State Backend
└── logging-strategy.md

compliance-mapping-index.md  # Root-level consolidated index
```

## How to Validate Terraform Modules

```bash
# Validate a single service module
cd services/compute-storage/azure-storage-account/terraform
terraform init
terraform validate

# Dry-run against lower environment
terraform plan -var="environment=lower" -var="location=eastus" ...

# Validate all modules
find services -name "main.tf" -execdir terraform init \; -execdir terraform validate \;
```

## How to Use Policy Definitions

1. Review custom definitions in `services/{group}/{service}/policies/definitions/`
2. Review the initiative in `services/{group}/{service}/policies/initiatives/`
3. Deploy to Azure:
   ```bash
   az policy definition create --name "{name}" --rules @{file}.json --params @{params}.json
   az policy set-definition create --name "{initiative}" --definitions @{initiative}.json
   az policy assignment create --policy-set-definition "{initiative}" --scope "{management-group-id}"
   ```
4. Verify compliance in Azure Policy → Compliance dashboard

## How to Navigate the Compliance Mapping Index

The `compliance-mapping-index.md` at the repository root is the fastest way to find:
- All controls for a specific Azure service
- All services satisfying a specific NIST 800-53 control
- All DISA STIG mappings
- All FIPS 140-2 encryption references
- All configuration differences between production and lower environments

## Service Group Implementation Order

Work follows this dependency order:

1. **Identity** (B2C, Managed Identity) — foundation
2. **Networking** (ExpressRoute, Front Door, Bastion, DNS, Monitor) — perimeter
3. **Compute, Storage & Data/AI** (App Service, Functions, Storage, Key Vault, OpenAI, etc.) — workloads

## Key References

- Feature spec: [spec.md](specs/001-fedramp-compliance-baseline/spec.md)
- Constitution: `.specify/memory/constitution.md`
- Services reference: `.specify/memory/azure-services-reference.md`
- Research: [research.md](specs/001-fedramp-compliance-baseline/research.md)
- Data model: [data-model.md](specs/001-fedramp-compliance-baseline/data-model.md)
