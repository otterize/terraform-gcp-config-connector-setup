output "config-connector-service-account" {
  value = google_service_account.config_connector_sa.name
}