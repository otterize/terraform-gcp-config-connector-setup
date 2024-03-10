output "config-connector-service-account" {
  value = length(google_service_account.config_connector_sa) > 0 ? google_service_account.config_connector_sa[0].name : data.google_service_account.config_connector_sa[0].name
}