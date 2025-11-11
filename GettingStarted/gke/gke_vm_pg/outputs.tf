# outputs.tf

output "gke_cluster_endpoint" {
  description = "El endpoint público del plano de control de GKE"
  value       = google_container_cluster.primary_gke_cluster.endpoint
}

output "vm_internal_ip" {
  description = "La IP interna de la VM de Compute Engine"
  value       = google_compute_instance.example_vm.network_interface[0].network_ip
}

output "postgres_private_ip" {
  description = "La IP privada de la instancia de PostgreSQL"
  value       = google_sql_database_instance.postgres_instance.private_ip_address
}