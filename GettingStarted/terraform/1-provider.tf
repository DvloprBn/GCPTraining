# The Google Cloud provider is used to configure the Google Cloud Infrastructure.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
provider "google" {
    project = local.project_id    # "my-project-id"
    region  = local.region        # "us-central1"
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 6.0"
    }
  }
}