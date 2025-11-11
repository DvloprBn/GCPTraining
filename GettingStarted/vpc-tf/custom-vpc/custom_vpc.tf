# 1. Definición de la VPC (google_compute_network)
# Creamos la red principal en modo personalizado, sin subredes automáticas.
resource "google_compute_network" "custom_vpc" {
  # Nombre de la VPC
  name                    = "mi-vpc-personalizada"
  # Desactivamos la creación automática de subredes.
  auto_create_subnetworks = false
  # Modo de enrutamiento global (opcional, pero común)
  routing_mode            = "GLOBAL"
}

# ---

# 2. Definición de la Subred (google_compute_subnetwork)
# Creamos una subred regional que pertenece a la VPC anterior.
resource "google_compute_subnetwork" "public_subnet" {
  # Nombre de la subred
  name          = "subnet-publica-us-central1"
  # Región donde se ubicará la subred
  region        = "us-central1"
  # Rango de direcciones IP internas (CIDR) para esta subred
  ip_cidr_range = "10.10.0.0/24"
  # Enlace a la VPC que acabamos de crear
  network       = google_compute_network.custom_vpc.self_link
}

# ---

# 3. Regla de Firewall Básica (google_compute_firewall)
# Permitir tráfico ICMP (ping) e SSH desde cualquier origen (0.0.0.0/0)
resource "google_compute_firewall" "allow_ssh_icmp" {
  # Nombre de la regla
  name    = "allow-ssh-icmp"
  # Enlace a la VPC
  network = google_compute_network.custom_vpc.self_link

  # Permite el tráfico de entrada (INGRESS)
  direction = "INGRESS"

  # Rango de origen (todas las IPs)
  source_ranges = ["0.0.0.0/0"]

  # Regla de permiso para SSH e ICMP
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  allow {
    protocol = "icmp"
  }
}



#  Recurso/Campo	            Descripción
#      google_compute_network	
#                              Es el recurso que define la Red VPC Global.
#  auto_create_subnetworks = false	
#                              Crucial. Indica que estás usando el modo Personalizado y que debes definir las subredes manualmente, 
#                               lo que te da control total sobre los rangos de IP.
#  routing_mode = "GLOBAL"	
#                              Indica que la VPC usará enrutamiento dinámico global, 
#                               permitiendo a los Cloud Routers aprender rutas de subredes en todas las regiones.
#  google_compute_subnetwork	
#                              Es el recurso que define el rango de IP regional dentro de la VPC.
#  ip_cidr_range	
#                              El bloque de IP privadas (ej. 10.10.0.0/24) que usarán los recursos implementados en esta subred.
#  network = ...self_link	
#                              Vincula la subred a la VPC, usando la referencia (self_link) del recurso google_compute_network creado.
#  google_compute_firewall	
#                              Define reglas de seguridad para la red. En este caso, permite el acceso SSH (tcp:22) 
#                               y el ping (icmp) desde internet (0.0.0.0/0).