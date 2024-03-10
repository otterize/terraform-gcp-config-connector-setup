# load pre-existing cluster
data "google_container_cluster" "existing_cluster" {
  name     = var.gcp_gke_name
  location = var.gcp_region
}

# load pre-existing service account
data "google_service_account" "config_connector_sa" {
  count = var.create_config_connector_sa ? 0 : 1
  account_id   = var.config_connector_sa_name
}