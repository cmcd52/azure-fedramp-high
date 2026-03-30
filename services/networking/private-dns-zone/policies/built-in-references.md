# Built-in Policy References: Private DNS Zone

**Service**: Private DNS Zone
**Last Updated**: 2026-03-27

---

## Built-in Policy References

### Azure Private DNS Zone Built-in Policies

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Azure Private DNS zones should use virtual network links | `e0a4b6c0-39a0-4795-bc98-a3ebaf1fd528` | Audit | SC-7 | VNet link enforcement |

### Related Built-in Policies (Private Link DNS Integration)

| Built-in Policy | Policy ID | Effect | NIST Controls | Applicability |
|----------------|-----------|--------|---------------|---------------|
| Configure Azure Storage to use private DNS zones | `75973700-529f-4de2-b658-751351e3f7b6` | DeployIfNotExists | SC-7 | Automates DNS zone group for Storage PE |
| Configure Azure Key Vault to use private DNS zones | `ac673a9a-f77d-4846-b2d8-a57f8e1c01d4` | DeployIfNotExists | SC-7 | Automates DNS zone group for Key Vault PE |

> **Note**: Many service-specific "Configure {service} to use private DNS zones" built-in policies exist. These are referenced in each service's own `policies/built-in-references.md`. The policies above are representative examples.

---

## Custom Policy Requirement (per R-001)

Custom policy definitions supplement built-in policies for comprehensive FedRAMP High coverage:

| Custom Policy | Effect | NIST Controls | Purpose |
|--------------|--------|---------------|---------|
| `audit-privatednszones-vnet-link-v1` | Audit | SC-7 | Private DNS Zone must have VNet link to hub |
| `deny-privatednszones-public-records-v1` | Deny/Audit | SC-7 | No A records pointing to public IP addresses |

---

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | Azure Private DNS Zone documentation | https://learn.microsoft.com/en-us/azure/dns/private-dns-overview |
| 2 | Private DNS Zone virtual network links | https://learn.microsoft.com/en-us/azure/dns/private-dns-virtual-network-links |
| 3 | Private Endpoint DNS integration | https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns |
| 4 | Azure Policy built-in definitions for Network | https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies#network |
