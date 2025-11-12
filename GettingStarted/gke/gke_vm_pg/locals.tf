locals {
    project_id    = "tutorialgcp001"
    region        = "us-central1"
    zone        = "us-central1-a"
    apis = [
        "compute.googleapis.com",
        "container.googleapis.com",
        "logging.googleapis.com",
        "secretmanager.googleapis.com"
    ]
}