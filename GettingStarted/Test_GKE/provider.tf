terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Versión sugerida, verifica la más reciente si es necesario
    }
  }
}

provider "google" {
  project = var.project_id # ID del proyecto GCP
  region  = var.region     # Región de GCP
}