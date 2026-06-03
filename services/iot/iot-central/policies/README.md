# Azure IoT Central — Policy Definitions



## Definitions

- **`audit-iot-central-diagnostic-settings-v1`** — [FedRAMP High] Azure IoT Central: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-iot-central-public-network-access-v1`** — [FedRAMP High] Azure IoT Central: Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3
- **`audit-iot-central-managed-identity-v1`** — [FedRAMP High] Azure IoT Central: Managed Identity Required
  - NIST 800-53: IA-2, AC-3

## Initiative — `fedramp-high-iot-central-v1`

Policy initiative for Azure IoT Central FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3, IA-2

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.IoTCentral/IoTApps`
