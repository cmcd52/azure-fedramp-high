locals {
  # FR-030, AU-11: 365-day retention (FedRAMP High)
  retention_days = 365

  # SC-7: Disable internet ingestion/query to enforce
  # network boundary protection via AMPLS only.
  internet_ingestion_enabled = false
  internet_query_enabled     = false
}
