# Identity Services — Azure Commercial vs Azure Government (Virginia) Feature Parity

**Services Covered**: Azure AD B2C, Managed Identity

---

## 1. Azure AD B2C

### Commercial Features
- Customer Identity and Access Management (CIAM)
- Custom sign-up/sign-in flows with user flows and custom policies
- Social identity provider federation (Google, Facebook, Apple, etc.)
- Multi-factor authentication
- Identity Experience Framework for complex identity journeys
- API connectors for integration with external systems
- Custom domains
- Conditional Access integration
- Token customization
- Available in all commercial regions

### Azure Government (Virginia) Features
- **NOT AVAILABLE**

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Entire service** | Generally Available | **NOT AVAILABLE** | Azure Active Directory B2C is not available in Azure Government — confirmed explicitly in Microsoft documentation |

### Impact Assessment
This is a **showstopper gap** for any architecture that depends on Azure AD B2C for customer-facing identity. Organizations deploying to Azure Government must use alternative approaches:

- **Entra ID External ID** (if available in Gov — verify separately)
- **Custom identity solution** built on top of Entra ID with application-level sign-up/sign-in flows
- **Third-party CIAM products** deployed within the Gov environment
- **Hybrid architecture** where B2C runs in commercial Azure with cross-cloud trust (introduces compliance complexity)

### Source References
- [Compare Azure Government and global Azure — Azure Active Directory B2C](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#azure-active-directory-b2c): "Azure Active Directory B2C is not available in Azure Government."

---

## 2. Managed Identity

### Commercial Features
- System-assigned managed identities
- User-assigned managed identities
- Automatic credential rotation (no secrets to manage)
- Integration with Azure RBAC for resource access
- Token acquisition via Azure Instance Metadata Service (IMDS)
- Support across all Azure services that accept Entra ID tokens
- Available in all commercial regions

### Azure Government (Virginia) Features
- **Available** in US Gov Virginia
- Managed identities function through the Azure Government Entra ID endpoint: `login.microsoftonline.us`
- Token audience URIs differ for some services (e.g., IoT Hub uses `https://iothubs.azure.us`)

### Parity Gaps

| Feature | Commercial | Gov Virginia | Gap Details |
|---------|-----------|--------------|-------------|
| **Entra ID endpoint** | `login.microsoftonline.com` | `login.microsoftonline.us` | Configuration change only |
| **Certificate auth endpoint** | `certauth.login.microsoftonline.com` | `certauth.login.microsoftonline.us` | Configuration change only |
| **Password reset** | `passwordreset.microsoftonline.com` | `passwordreset.microsoftonline.us` | Configuration change only |
| **Feature set** | Full | **Full** | No managed identity feature limitations documented for Gov |

### Entra ID Dependency Context (Applicable to All Services)

While Managed Identity itself has full parity, the broader Entra ID platform (which all Azure services depend on) has the following limitations in Gov that affect access control patterns:

| Entra ID Feature | Commercial | Gov Virginia | Gap Details |
|-----------------|-----------|--------------|-------------|
| **B2B Collaboration** | Full | **Limited** | Limitations exist in Gov tenants; not all B2B features available. See [Microsoft Entra B2B in government and national clouds](https://learn.microsoft.com/en-us/azure/active-directory/external-identities/b2b-government-national-clouds) |
| **MFA Trusted IPs** | Available | **Not supported** | Must use Conditional Access named locations instead of Trusted IPs |
| **Privileged Identity Management (PIM)** | Full (including Azure Lighthouse JIT) | **Partial** | PIM is available in Gov for Entra ID roles, but Azure Lighthouse JIT/eligible authorization capability is not enabled |

### Source References
- [Compare Azure Government and global Azure — Identity](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#identity)
- [Compare Azure Government and global Azure — Microsoft Entra ID P1 and P2](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure#microsoft-entra-id-p1-and-p2)
- [Cloud feature availability](https://learn.microsoft.com/en-us/azure/active-directory/authentication/feature-availability)
