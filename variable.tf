variable "gcp_region" {
  description = "Google Cloud Region"
  type        = string
}

variable "gcp_project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "gcp_gke_name" {
  description = "Google Cloud GKE cluster name"
  type        = string
}

variable "config_connector_sa_name" {
  description = "The name of the service account to be created for Config Connector in the GCP project"
  type        = string
  default     = "config-connector-sa"
}