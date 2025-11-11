provider "google" {
  project = "tutorialgcp001"
  region = "us-east1"
  zone = "us-east1-a"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpc_basic" {
  name = "vpc-basic"
  # TRUE: the network is created in "auto subnet mode" 
  # and it will create a subnet for each region automatically 
  # across the 10.128.0.0/9 address range. 
  # FALSE: the network is created in "custom subnet mode" 
  # so the user can explicitly connect subnetwork resources.
  auto_create_subnetworks = true
  # Maximum Transmission Unit in bytes. 
  mtu                     = 1460
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork
resource "google_compute_subnetwork" "my-public-subnetwork" {
  name   = "public"
  region = "us-east1"
  # - The IP address range that machines in this network are assigned to, represented as a CIDR block.
  ip_cidr_range = "10.0.0.0/24"
  # - The network name or resource link to the parent network of this subnetwork.
  network = google_compute_network.vpc_basic.id
}

resource "google_compute_subnetwork" "my-private-subnetwork" {
  name   = "private"
  region = "us-east1"
  # - The IP address range that machines in this network are assigned to, represented as a CIDR block.
  ip_cidr_range = "10.0.0.0/24"
  # - The network name or resource link to the parent network of this subnetwork.
  network = google_compute_network.vpc_basic.id
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_router
resource "google_compute_router" "router" {
  name = "router"
  network = google_compute_network.vpc_basic.id
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
}