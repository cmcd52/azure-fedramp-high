# Azure IoT Hub — Policy Definitions



## Definitions

- **`audit-iot-hub-diagnostic-settings-v1`** — [FedRAMP High] Azure IoT Hub: Diagnostic Settings Enabled
  - NIST 800-53: AU-12, AU-2
- **`deny-iot-hub-public-network-access-v1`** — [FedRAMP High] Azure IoT Hub: Public Network Access Disabled
  - NIST 800-53: SC-7, AC-3
- **`deny-iot-hub-minimum-tls-v1`** — [FedRAMP High] Azure IoT Hub: Minimum TLS 1.2
  - NIST 800-53: SC-8, SC-13
- **`audit-iot-hub-managed-identity-v1`** — [FedRAMP High] Azure IoT Hub: Managed Identity Required
  - NIST 800-53: IA-2, AC-3
- **`audit-iot-hub-cmk-v1`** — [FedRAMP High] Azure IoT Hub: Customer-Managed Key Encryption
  - NIST 800-53: SC-12, SC-13, SC-28

## Initiative — `fedramp-high-iot-hub-v1`

Policy initiative for Azure IoT Hub FedRAMP High compliance. Bundles transmission confidentiality (SC-8/SC-13), boundary protection (SC-7), authentication (IA-2), encryption-at-rest (SC-28), and audit generation (AU-12) policies. Workloads hosting federal data MUST enforce all bundled controls.

NIST 800-53 controls: AU-12, AU-2, SC-7, AC-3, SC-8, SC-13, IA-2, SC-12, SC-28

## See Also

- [Built-in policy references](built-in-references.md)
- [Service control baseline](../controls/baseline.md)
- [Diagnostic logging configuration](../logging/config.md)
- ARM resource type: `Microsoft.Devices/IotHubs`
