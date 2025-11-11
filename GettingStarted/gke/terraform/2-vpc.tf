resource "google_project_service" "compute" {
    service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
    service = "container.googleapis.com"
}

# VPC Configuration
resource "google_compute_network" "vpc_main" {
    name                            = "vpc_main"
    routing_mode                    = "REGIONAL" # REGIONAL or GLOBAL
    auto_create_subnetworks         = false
    mtu                             = 1460
    # MTU: Maximum Transmission Unit in Bytes
    # the minimim value for this field is 1460
    delete_default_routes_on_create = false 
    # False: the network is created in custom subnet mode and let us define our own subnets

    depends_on = [ 
        google_project_service.compute, 
        google_project_service.container 
    ]
}