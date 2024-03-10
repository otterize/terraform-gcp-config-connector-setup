# Create a service account for Config Connector
resource "google_service_account" "config_connector_sa" {
  account_id   = var.config_connector_sa_name
  display_name = "Config Connector Service Account"
}

# Add the required roles to the service account at the project level
resource "google_project_iam_member" "role_bindings" {
  for_each = toset([
    "roles/iam.roleAdmin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.workloadIdentityUser",
  ])
  project = var.gcp_project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.config_connector_sa.email}"
}

# Add the 'roles/iam.workloadIdentityUser' role to the service account for workload identity
resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = google_service_account.config_connector_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.gcp_project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
}

resource "kubectl_manifest" "config_connector_manifest" {
  yaml_body = <<-EOT
    apiVersion: core.cnrm.cloud.google.com/v1beta1
    kind: ConfigConnector
    metadata:
      name: configconnector.core.cnrm.cloud.google.com
    spec:
      mode: cluster
      googleServiceAccount: "${google_service_account.config_connector_sa.email}"
  EOT

  depends_on = [data.google_container_cluster.existing_cluster]
}