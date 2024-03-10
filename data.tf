
# load pre-existing cluster
data "google_container_cluster" "existing_cluster" {
  name     = var.gcp_gke_name
  location = var.gcp_region
}