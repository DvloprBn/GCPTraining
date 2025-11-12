output "gke_cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "vm_external_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "postgres_connection_name" {
  value = google_sql_database_instance.postgres_instance.connection_name
}
