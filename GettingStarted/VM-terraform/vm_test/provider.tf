terraform {
  required_providers {
    google = {
        source  = "hashicorp/google"
        version = "~> 6.0"
    }
  }
}

provider "google" {
    project = local.project_id      # "my-project-id"
    region  = local.region          # "us-central1"
    zone    = local.zone            # "us-central1-a"
}