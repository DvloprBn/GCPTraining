resource "google_project_service" "compute" {
    service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
    service = "container.googleapis.com"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpc_gke" {
    name = "vpc-gke"
    # TRUE: the network is created in "auto subnet mode" 
    # and it will create a subnet for each region automatically 
    # across the 10.128.0.0/9 address range. 
    # FALSE: the network is created in "custom subnet mode" 
    # so the user can explicitly connect subnetwork resources.
    auto_create_subnetworks = true
    # Maximum Transmission Unit in bytes. 
    mtu                     = 1460

    depends_on = [ 
        google_project_service.compute, 
        google_project_service.container 
    ]
}

