locals {
  # Core privatelink DNS zones required for all in-scope FedRAMP High services
  dns_zones = {
    storage = {
      zone_name = "privatelink.blob.core.windows.net"
      service   = "Azure Storage"
    }
    keyvault = {
      zone_name = "privatelink.vaultcore.azure.net"
      service   = "Key Vault"
    }
    monitor = {
      zone_name = "privatelink.monitor.azure.com"
      service   = "Azure Monitor"
    }
    log_analytics_oms = {
      zone_name = "privatelink.oms.opinsights.azure.com"
      service   = "Log Analytics (OMS)"
    }
    log_analytics_ods = {
      zone_name = "privatelink.ods.opinsights.azure.com"
      service   = "Log Analytics (ODS)"
    }
    log_analytics_agent = {
      zone_name = "privatelink.agentsvc.azure-automation.net"
      service   = "Log Analytics (Agent)"
    }
    app_service = {
      zone_name = "privatelink.azurewebsites.net"
      service   = "App Service / Functions"
    }
    ai_search = {
      zone_name = "privatelink.search.windows.net"
      service   = "Azure AI Search"
    }
    openai = {
      zone_name = "privatelink.openai.azure.com"
      service   = "Azure OpenAI"
    }
    cognitive_services = {
      zone_name = "privatelink.cognitiveservices.azure.com"
      service   = "Document Intelligence / Speech"
    }
    purview = {
      zone_name = "privatelink.purview.azure.com"
      service   = "Azure Purview"
    }
    purview_studio = {
      zone_name = "privatelink.purviewstudio.azure.com"
      service   = "Purview Studio"
    }
    event_hubs = {
      zone_name = "privatelink.servicebus.windows.net"
      service   = "Event Hubs"
    }
    container_registry = {
      zone_name = "privatelink.azurecr.io"
      service   = "Azure Container Registry"
    }
  }

  # Merge core zones with any additional zones provided by the caller
  all_dns_zones = merge(local.dns_zones, var.additional_zones)
}
