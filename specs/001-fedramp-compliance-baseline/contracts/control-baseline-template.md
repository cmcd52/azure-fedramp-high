# Contract: Security Control Baseline Template

**Applies to**: All security control baselines under `services/{group}/{service}/controls/`

---

## Document Structure

Every security control baseline MUST follow this template structure. Sections may be marked "Not Applicable" with justification but MUST NOT be omitted.

```markdown
# Security Control Baseline: {Service Name}

**Service**: {Service name from azure-services-reference.md}
**Category**: {Identity | Networking | Compute | Storage | Data/AI}
**Last Updated**: {Date}
**Environment**: Production (lower environment deltas noted inline)

## Service Overview

{Brief description of the service, its role in the architecture, 
and its place within the project scope.}

## Identity & Access Controls

### RBAC Assignments
| Role | Assignment Scope | Justification | NIST Control |
|------|-----------------|---------------|--------------|
| {role} | {scope} | {why} | AC-2, AC-3, AC-6 |

### Managed Identity
- Type: System-assigned / User-assigned
- Usage: {what service-to-service auth flows}
- NIST: IA-2, IA-5

### MFA / Conditional Access
- {Applicable Conditional Access policies}
- AAL level achieved: {AAL2/AAL3 per NIST SP 800-63-4}
- NIST: IA-2(1), IA-2(2)

## Network Security Controls

### Private Endpoint
- Status: {Required / Not Supported}
- Private DNS Zone: {zone name}
- NIST: SC-7

### Firewall / NSG Rules
| Rule | Direction | Source | Destination | Port | Action | NIST Control |
|------|-----------|--------|-------------|------|--------|--------------|
| {rule} | {in/out} | {src} | {dst} | {port} | {allow/deny} | SC-7 |

### Public Endpoint
- Status: {Disabled / Justified Exception}
- If exception: {justification and compensating control}

## Encryption Controls

### Encryption at Rest
- Algorithm: AES-256
- Key Type: {Customer-Managed Key (CMK) / Platform-Managed Key}
- Key Vault: {reference to shared Key Vault}
- FIPS 140-2 Certificate: {certificate number or platform module reference}
- NIST: SC-13, SC-28
- Lower environment: {Platform-Managed Key — justification}

### Encryption in Transit
- Protocol: TLS 1.2+
- FIPS 140-2 Certificate: {certificate number}
- Cipher suites: {FIPS-approved only}
- NIST: SC-8, SC-13
- NIST SP 800-52 Rev 2: {compliance note}

## Logging & Monitoring Controls

- Diagnostic categories: {list}
- Destination: Centralized Log Analytics workspace
- Retention: 365 days online / 548 days archived (production)
- OMB M-21-31 tier: {EL1/EL2/EL3}
- Alert rules: {list of critical event alerts}
- NIST: AU-2, AU-3, AU-6, AU-12
- NIST SP 800-137: {continuous monitoring note}

## NIST 800-53 Rev 5 Control Mapping

| Control ID | Control Name | Implementation | Evidence |
|------------|-------------|----------------|----------|
| {e.g., SC-8} | Transmission Confidentiality | {how implemented} | {policy/terraform/config ref} |

## DISA STIG Mapping

| Finding ID | Title | Status | Implementation | Source |
|------------|-------|--------|----------------|--------|
| {V-xxxxx} | {title} | {Implemented/Not Applicable} | {how} | {STIG URL} |

*If no STIG exists: "No published DISA STIG for this service. Compensating controls: NIST 800-53 + CIS Benchmark."*

## Additional Framework Mappings

### DFARS 252.204-7012 / NIST 800-171 Rev 3 (CUI)
| CUI Control | Implementation | CMMC Practice |
|-------------|----------------|---------------|
| {3.x.x} | {how} | {CMMC practice ID} |

### EO 14028 / OMB M-22-09 (Zero Trust)
- {Zero trust alignment notes}
- NIST SP 800-207 tenet: {which tenet}

### OMB M-21-31 (Logging Maturity)
- Target tier: {EL level}
- Achieved tier: {EL level with justification if gap}

## Environment Deltas (Production vs. Lower)

| Setting | Production Value | Lower Value | Justification | Min Baseline Met? |
|---------|-----------------|-------------|---------------|-------------------|
| {setting} | {prod} | {lower} | {why} | Yes/No |

## Source References

| # | Reference | URL |
|---|-----------|-----|
| 1 | {title} | {URL} |
```

## Mandatory Sections Checklist

- [ ] Service Overview
- [ ] Identity & Access Controls (RBAC, Managed Identity, MFA)
- [ ] Network Security Controls (Private Endpoint, Firewall, Public Endpoint)
- [ ] Encryption Controls (At Rest with FIPS cert, In Transit with FIPS cert)
- [ ] Logging & Monitoring Controls (Categories, Retention, Alerts, M-21-31 tier)
- [ ] NIST 800-53 Rev 5 Control Mapping (at least: AC, AU, IA, SC families)
- [ ] DISA STIG Mapping (or "No STIG available" with compensating controls)
- [ ] Additional Framework Mappings (DFARS/CUI, EO 14028, OMB M-22-09, M-21-31)
- [ ] Environment Deltas
- [ ] Source References (every claim has a URL)
