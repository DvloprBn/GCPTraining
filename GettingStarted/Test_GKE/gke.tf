resource "google_container_cluster" "primary" {
  # Propiedades básicas del clúster
  name                     = var.cluster_name
  location                 = var.region
  initial_node_count       = 1 # Se requiere un valor, aunque se remueva el pool por defecto
  remove_default_node_pool = true
  deletion_protection      = false

  # Configuración del control plane
        # Bloque de autenticación vacío, GKE utiliza cuentas de servicio y credenciales por defecto
  # master_auth {}

  # Configuración de la red (se asume que se usa la red por defecto)
  networking_mode = "VPC_NATIVE"

  # Configuración del mantenimiento (ventana de mantenimiento)
  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00" # Mantenimiento a las 3 AM UTC
    }
  }

  # Opcional: Habilitar Autoescalado
  # vertical_pod_autoscaling {
  #   enabled = true
  # }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-nodepool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 2 # Número deseado de nodos

  node_config {
    machine_type = var.machine_type
    disk_size_gb = 50
    disk_type    = "pd-standard"

    # Scopes OAuth necesarios para que los nodos interactúen con otros servicios de GCP
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    # Imagen del SO del nodo
    image_type = "COS_CONTAINERD"
  }

  # Opcional: Configuración de Autoescalado de nodos
  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }
}

output "cluster_name" {
  description = "El nombre del clúster GKE."
  value       = google_container_cluster.primary.name
}

output "endpoint" {
  description = "El endpoint del maestro del clúster GKE."
  value       = google_container_cluster.primary.endpoint
}