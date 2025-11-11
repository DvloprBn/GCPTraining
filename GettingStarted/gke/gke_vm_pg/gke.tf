# gke.tf
# Cluster de Kubernetes
# Despliegue de un clúster GKE usando la subred definida.
# Define la plataforma de orquestación de contenedores.


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "primary_gke_cluster" {
  name               = "gke-example-cluster"
  location           = var.region
  initial_node_count = 1
  network            = google_compute_network.vpc_network.name
  subnetwork         = google_compute_subnetwork.gke_subnet.name

  # Necesario para el acceso a servicios gestionados (como Cloud SQL)
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
resource "google_container_node_pool" "primary_gke_pool" {
  name       = "default-pool"
  location   = var.region
  cluster    = google_container_cluster.primary_gke_cluster.name
  node_count = 1
  
  

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    # error
    # subnetwork = google_compute_subnetwork.gke_subnet.name
  }
  
}