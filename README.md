# Setup
This repository houses a Terraform module required for setting up Otterize in your infrastructure using Terraform, on GCP IAM.

To use this Terraform module, see the Terraform Registry: https://registry.terraform.io/modules/otterize/config-connector-setup/gcp/latest

## Usage
1. Allow the terraform script to access gcloud credentials: [Terraform Authentication](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication)
2. Point the default kubeconfig to the cluster you want to manage: `gcloud container clusters get-credentials <cluster-name>`
3. Add the following code to your Terraform script:
    ```hcl
    module "otterize-gcp-iam" {
      source  = "otterize/otterize-gcp-iam/gcp"
      version = "0.1.0"
      # insert the 5 required variables here
    }
    ```

## Local Development
1. Clone the repository
2. Run `terraform init`
3. On changing files run `terraform fmt` + `terraform validate`
4. To test the changes run `terraform apply -var-file=terraform.tfvars`
5. To destroy the changes run `terraform destroy -var-file=terraform.tfvars`