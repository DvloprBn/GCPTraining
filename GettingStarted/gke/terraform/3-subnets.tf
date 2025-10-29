resource "google_compute_subnetwork" "private" {
    name                        = "private"
    ip_cidr_range               = "10.0.0.0/18"  # main CIDR range 
    region                      = "us-central1"
    network                     = google_compute_network.main.id
    private_ip_google_access    = true


    # Kubernetes nodes will use IPs from the main CIDR range 
    # Kubernetes pods will useIPs from the secondary
    # In case It is needed to open a firewall to access other VMs in the VPC from Kubernetes,
    # it will be necessary to use this secondary ip range as a source and optionally service account of the Kubernetes nodes.
    # Each secondary IP range has a name associated with it, which it will be use in the GKE configuration.
    secondary_ip_range {
        range_name      = "k8s-pod-range"
        ip_cidr_range   = "10.48.0.0/14"
    }


    # This secondary range will be used to assign IP addresses for the clusterIPs in Kubernetes
    secondary_ip_range {
        range_name      = "k8s-service-range"
        ip_cidr_range   = "10.52.0.0/20"
    }
}