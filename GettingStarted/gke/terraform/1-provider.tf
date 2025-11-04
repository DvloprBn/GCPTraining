provider "google" {
  project = "tutorialgcp001"
  region = "us-central1"
}

terraform {
  backend "gcs" {
    bucket = "ben-tf-sate-staging"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 5.0"
    }
  }
}