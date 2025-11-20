# The Google Cloud provider is used to configure the Google Cloud Infrastructure.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference

terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 6.0"
    }
  }
}

provider "google" {
    project = var.project_id    # "my-project-id"
    region  = var.region        # "us-central1"
    zone  = var.zone        # "us-central1-a"
    # credentials = "./keys.json"

}

