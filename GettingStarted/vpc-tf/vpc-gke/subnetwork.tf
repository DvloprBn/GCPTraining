# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork
resource "google_compute_subnetwork" "my-public-subnetwork" {
  name   = "public"
  region = var.region
  # - The IP address range that machines in this network are assigned to, represented as a CIDR block.
  ip_cidr_range = "10.0.0.0/24"
  # - The network name or resource link to the parent network of this subnetwork.
  network = google_compute_network.vpc_gke.id
}

resource "google_compute_subnetwork" "my-private-subnetwork" {
  name   = "private"
  region = var.region
  # - The IP address range that machines in this network are assigned to, represented as a CIDR block.
  ip_cidr_range = "10.0.0.0/24"
  # - The network name or resource link to the parent network of this subnetwork.
  network = google_compute_network.vpc_gke.id
}

/*
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_router
resource "google_compute_router" "router" {
  name = "router"
  network = google_compute_network.vpc_gke.id
  bgp {
    asn = 64514
    advertise_mode = "CUSTOM"
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_router_nat
# puerta de enlace de Cloud NAT (Network Address Translation) dentro de Google Cloud.
resource "google_compute_router_nat" "nat" {
  name = "my-nat"
  router = google_compute_router.router.name
  region = google_compute_router.router.region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name = "private"
    source_ip_ranges_to_nat = [ "ALL_IP_RANGES" ]
  }
}*/