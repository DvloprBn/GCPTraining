# main.tf

# Configura el proveedor de Google Cloud
provider "google" {
  project = var.project_id
  region  = var.region
}

# -----------------
# 1. Variables
# -----------------

variable "project_id" {
  description   = "El ID del proyecto de GCP"
  type          = string
  default       = "tutorialgcp001"
}

variable "region" {
  description = "La región de despliegue"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "La zona de despliegue para la VM"
  type        = string
  default     = "us-central1-a"
}