variable "project_id" {
  description = "El ID del proyecto de Google Cloud."
  type        = string
}

variable "region" {
  description = "La región de Google Cloud donde se creará el recurso."
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "El nombre deseado para el clúster GKE."
  type        = string
  default     = "mi-cluster-gke"
}

variable "machine_type" {
  description = "El tipo de máquina para los nodos del clúster (por ejemplo, e2-medium)."
  type        = string
  default     = "e2-medium"
}