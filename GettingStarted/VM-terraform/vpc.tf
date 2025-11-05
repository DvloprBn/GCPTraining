# resource "type" "name"
resource "google_compute_network" "vpcVM" {
  name                              = "vpc-vm"
  routing_mode                      = "REGIONAL"  # "REGIONAL | GLOBAL"
  auto_create_subnetworks           = false
  delete_default_routes_on_create   = true

  depends_on = [ google_project_service.api ]
}

# Se debe crear una subnet para que trabajae con esta VPC

# Remove this route to make the VPC fully private
# You need this route for the NAT gateway
resource "google_compute_route" "default_route" {
  name = "default-route"
  dest_range = "0.0.0.0/0"
  network = google_compute_network.vpc.name
  next_hop_gateway = "default-internet-gateway"
}