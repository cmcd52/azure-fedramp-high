# Azure Spring Apps — Built-in Azure Policy References

**AUTHORING TEMPLATE** — supplement custom policies above with applicable Azure built-in policies. Verify current `policyDefinitionId` GUIDs at <https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high>.

## Recommended Built-in Initiatives

- **FedRAMP High** (built-in initiative `d5264498-16f4-418a-b659-fa7ef418175f`) — assign at the management group scope as a foundational baseline.
- **NIST SP 800-53 Rev 5** (built-in initiative `179d1daa-458f-4e47-8086-2a68d0d6c38f`) — overlay for full Rev 5 control coverage.

## Service-Specific Built-ins

This section is a starting point. Confirm each ID against the current Azure Policy catalog before assignment.

| Policy Display Name | Definition ID (verify) | Effect | NIST Control |
|---------------------|------------------------|--------|--------------|
| _Pending review of built-in catalog for `Microsoft.AppPlatform/Spring`_ | — | — | — |

## References

- Azure Policy built-in for `Microsoft.AppPlatform/Spring`: <https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies>
- FedRAMP High catalog: <https://learn.microsoft.com/en-us/azure/governance/policy/samples/fedramp-high>
- NIST 800-53 Rev 5 catalog: <https://learn.microsoft.com/en-us/azure/governance/policy/samples/nist-sp-800-53-r5>
