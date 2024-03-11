# Create a service account for Config Connector
resource "google_service_account" "config_connector_sa" {
  count        = var.create_config_connector_sa ? 1 : 0
  account_id   = var.config_connector_sa_name
  display_name = "Config Connector Service Account"
}

# If the service account was not created, retrieve the name and email of the existing service account
locals {
  config_connector_sa_name = length(google_service_account.config_connector_sa) > 0 ? one(google_service_account.config_connector_sa[*].name) : one(data.google_service_account.config_connector_sa[*].name)
  config_connector_sa_email = length(google_service_account.config_connector_sa) > 0 ? one(google_service_account.config_connector_sa[*].email) : one(data.google_service_account.config_connector_sa[*].email)
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
  member  = "serviceAccount:${local.config_connector_sa_email}"
}

# Enable the required APIs for the project
resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project = var.gcp_project_id
  service = each.key
}

# Add the 'roles/iam.workloadIdentityUser' role to the service account for workload identity
resource "google_service_account_iam_member" "workload_identity_binding" {
  count = var.create_config_connector_sa ? 1 : 0
  service_account_id = local.config_connector_sa_name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.gcp_project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
}

resource "kubectl_manifest" "config_connector_manifest" {
  count = var.create_config_connector_sa ? 1 : 0
  yaml_body = <<-EOT
    apiVersion: core.cnrm.cloud.google.com/v1beta1
    kind: ConfigConnector
    metadata:
      name: configconnector.core.cnrm.cloud.google.com
    spec:
      mode: cluster
      googleServiceAccount: "${local.config_connector_sa_email}"
  EOT

  depends_on = [data.google_container_cluster.existing_cluster]
}