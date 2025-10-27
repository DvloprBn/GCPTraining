provider "google" {
    project = local.project_id
    region  = local.region
}

terraform {
  required_version = ">= 4.0"

  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 5.0"
    }
  }
}