# vm.tf
# Despliegue de una VM simple que se ubica en la misma subred.

resource "google_compute_instance" "example_vm" {
  name         = "example-app-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.gke_subnet.name
    # Usamos access_config para permitir acceso a Internet (para actualizaciones, etc.)
    # Se puede omitir para una VM completamente privada.
    access_config {} 
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo "VM iniciada y lista."
    EOF
}