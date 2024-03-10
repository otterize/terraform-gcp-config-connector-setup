# General GCP variables
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

# Config Connector service account variables
variable "create_config_connector_sa" {
  description = "Create a new Config Connector service account - set to false if you already have a service account to use"
  type        = bool
}

variable "config_connector_sa_name" {
  description = "The name of the service account to be created for Config Connector in the GCP project"
  type        = string
}
