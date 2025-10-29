# it will be used with the NAT gateway to allow VMs without public IP addresses to access the Internet
resource "google_compute_router" "router" {
  # name for the router
  name = "router"
  # The same region where the subnet was created
  region = "us-central1"
  # The reference to the VPC, Where it is wanted to place this router
  network = google_compute_network.main.id
}