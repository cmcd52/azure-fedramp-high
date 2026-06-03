# Azure IoT Device Provisioning Service — Security Control Baseline



**Service**: Azure IoT Device Provisioning Service
**ARM Resource Type**: `Microsoft.Devices/provisioningServices`
**Service Group**: iot
**Compliance Baseline**: FedRAMP High (NIST SP 800-53 Rev 5 High baseline)
**Target Cloud**: Azure Commercial

---

## NIST 800-53 Control Coverage Summary

This service primarily addresses control families: **AC, IA, AU**.

Mapping to specific controls is documented in each section below.

---

## Identity and Access Control (AC, IA)

- **RBAC**: Use Azure RBAC built-in roles scoped to the resource and resource group. Avoid Owner; prefer least-privilege Contributor or service-specific roles. (NIST AC-2, AC-3, AC-6)
- **Managed Identity**: REQUIRED — service-assigned or user-assigned managed identity for outbound auth (NIST IA-2, IA-5).
- **Conditional Access**: Apply tenant-level Conditional Access (MFA, device compliance, named locations) to all administrators that manage the resource (NIST IA-2(1), IA-2(2)).
- **Privileged Identity Management (PIM)**: Eligible-only role assignments for production access; just-in-time elevation with approval (NIST AC-2(7), AC-6(2)).

## Network Security (SC, AC)

- **Private Endpoint**: REQUIRED — disable public network access; access only via private endpoint in the project VNet (NIST SC-7, SC-7(3)).
- **Public Network Access**: MUST be set to `Disabled` (NIST SC-7).
- **Service-tier-aware boundary**: Document boundary controls per environment (production vs lower) per the [environment delta document](../../../../docs/environment-delta.md).

## Encryption (SC-8, SC-12, SC-13, SC-28)

- **In transit**: TLS 1.2 minimum with FIPS 140-2 validated cipher suites. Service uses platform-default FIPS-validated TLS endpoints; no per-resource TLS configuration required. (NIST SC-8, SC-13)
- **At rest**: Service-managed keys with FIPS 140-2 validated modules (NIST SC-13, SC-28). Re-evaluate when Microsoft adds CMK support.
- **FIPS 140-2 validated modules**: <https://csrc.nist.gov/Projects/Cryptographic-Module-Validation-Program/Validated-Modules>

## Audit and Monitoring (AU, CA)

- **Diagnostic settings**: REQUIRED — forward all available log categories to the central Log Analytics workspace via `Microsoft.Insights/diagnosticSettings`.
- **Activity Log**: All control-plane operations forwarded to Log Analytics via the subscription-level diagnostic setting (NIST AU-2).
- **Microsoft Defender for Cloud**: Enable applicable Defender plan; review recommendations weekly (NIST CA-7, RA-5).
- **Sentinel**: Onboard logs to Microsoft Sentinel for detection rules and incident workflow (NIST IR-4, IR-5, IR-6).

## Configuration Management (CM)

- **Azure Policy**: Assign the [`fedramp-high-iot-dps-v1`](../policies/initiatives/fedramp-high-iot-dps-v1.json) initiative at the management-group or subscription scope (NIST CM-2, CM-6).
- **Resource locks**: Apply `CanNotDelete` to production resources (NIST CM-5).
- **Tagging**: Apply `compliance-framework=FedRAMP-High` and `service=iot-dps` tags via the Terraform module's `tags` variable (NIST CM-8).

## Incident Response and Contingency (IR, CP)

- **Backup**: Configure backup or replication consistent with the Recovery Time Objective documented for the workload (NIST CP-9, CP-10).
- **Incident detection**: Sentinel analytics rules + Defender for Cloud alerts route to the SOC (NIST IR-4, IR-5, IR-6).

## Source References

- Azure IoT Device Provisioning Service documentation: <https://learn.microsoft.com/en-us/azure/iot-dps/>
- FedRAMP High Microsoft offering page: <https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-fedramp>
- NIST SP 800-53 Rev 5 catalog: <https://csrc.nist.gov/projects/risk-management/sp800-53-controls/release-search#!/800-53>
- FIPS 140-2 validation list: <https://csrc.nist.gov/Projects/Cryptographic-Module-Validation-Program/Validated-Modules>
- Service-specific Azure Policy built-ins: <https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies>

---

**Version**: 0.1.0 (template) | **Generated**: 2026-04-28
