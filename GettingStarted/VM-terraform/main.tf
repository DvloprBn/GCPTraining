resource "google_compute_instance" "vm-terraform" {
  # nombre de la VM
  name              = "vm-terraform-name"
  machine_type      = "e2.medium"
  zone              = local.zone
  can_ip_forward    = false

    # configuracion para el disco de booteo
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      # almacenamiento del disco
      size = 30
      # tipo del disco
      type = "pd-ssd"
    }
  }

    # interfaz para trabajar (VPC)
  network_interface {
    network = "vpc"
    # le asignara una ip dentro de la subnet que pertenece a la VPC
    subnetwork = "vpc.private"
  }
}