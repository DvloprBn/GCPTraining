# postgres.tf
# Despliegue de la base de datos gestionada. Esto no es una VM, sino un servicio gestionado que se conecta a tu VPC a través de Private Service Access.

## Habilitar el API para Cloud SQL y el servicio de Private Access
resource "google_project_service" "cloudsql_api" {
  project = var.project_id
  service = "sqladmin.googleapis.com"
}

resource "google_project_service" "vps_api" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
}

## 5.1. Rango de IP para Private Service Access
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
resource "google_compute_global_address" "private_ip_alloc" {
  provider      = google-beta # Puede requerir el proveedor beta
  name          = "google-managed-services-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

## 5.2. Conexión de Peering entre tu VPC y la Red de Servicios de Google
resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
  depends_on              = [google_project_service.vps_api]
}

## 5.3. La Instancia de Cloud SQL PostgreSQL
resource "google_sql_database_instance" "postgres_instance" {
  database_version = "POSTGRES_14"
  name             = "app-postgres-db"
  region           = var.region
  project          = var.project_id
  settings {
    tier = "db-f1-micro" # Nivel más pequeño para el ejemplo
    # Configuración de red para usar la IP privada
    ip_configuration {
      ipv4_enabled    = false # Deshabilita la IP pública
      private_network = google_compute_network.vpc_network.id
    }
  }

  deletion_protection  = false
  depends_on           = [google_service_networking_connection.private_vpc_connection]
}