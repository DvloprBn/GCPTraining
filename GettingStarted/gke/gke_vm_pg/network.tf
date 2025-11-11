# network.tf
# Creamos una red y una subred para alojar todos los recursos.
# Este es el fundamento de la arquitectura, 
# ya que todos los recursos deben residir en una red para comunicarse.

## VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "gke-vm-postgres-vpc"
  auto_create_subnetworks = false # Recomendado para control granular
}

## Subnet
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "gke-vm-subnet"
  ip_cidr_range = "10.0.0.0/20"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}