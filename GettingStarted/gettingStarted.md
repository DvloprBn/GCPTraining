# Getting starting Tutorial GCP



## Terraform

* https://registry.terraform.io/providers/hashicorp/google/latest/docs
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
* https://www.youtube.com/watch?v=5BsueWtVn8I
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
* https://github.com/nicholasjackson/demo-terraform-basics/tree/main




Lo primero que se debe utilizar al trabajar con Terraform y GCP es configurar el: __Provider__

Provider: la interfaz de configuracion para trabajar con el CLI de terraform y la aPI de la nube en este caso GCP.


#### Lógica de Orquestación de Dependencias

Un clúster GKE no es un recurso único; es un conjunto complejo de recursos que deben crearse en un orden específico. Terraform maneja esta complejidad automáticamente.

    Dependencia Implícita: Terraform es inteligente. Cuando defines un google_container_cluster, sabe que no puede existir sin una red (google_compute_network) y una subred (google_compute_subnetwork). Al referenciar estos recursos previos (ej: network = google_compute_network.myvpc.id), Terraform crea un gráfico de dependencias.

    Orden de Ejecución: El gráfico de dependencias garantiza el orden lógico y la solidez del despliegue:

        Crear la VPC (google_compute_network).

        Crear la Subred con los rangos secundarios de IP para GKE.

        Crear el Clúster GKE.

        Crear el Node Pool (Grupo de Nodos), que depende del clúster recién creado.



#### Lógica de Diseño de Red (VPC Nativo)

La lógica más crítica para GKE es el soporte al modelo de VPC Nativo (o IP Aliases), que es el estándar de oro en GCP para Kubernetes.

    Separación de Rangos: Un clúster GKE eficiente necesita que los Pods y los Services de Kubernetes tengan sus propios rangos de IP, separados de las IPs de los nodos.

    Mapeo con Terraform: La lógica de Terraform te fuerza a declarar esta separación antes de crear el clúster, utilizando los bloques secondary_ip_range dentro de la subred (google_compute_subnetwork):        



    Objeto de Terraform	                Mapeo con Kubernetes
    google_compute_subnetwork	        Contiene todos los rangos de IP.
    ip_cidr_range	                    Rango principal para las IPs de los Nodos (VMs).
    secondary_ip_range (Pods)	        Rango para las IPs de los Pods de Kubernetes.
    secondary_ip_range (Services)	    Rango para las IPs de los Services de Kubernetes.


Al declarar estos rangos, Terraform asegura que el clúster GKE se configure correctamente para un escalamiento eficiente y sin solapamiento de IPs.



#### Lógica de Inmutabilidad de la Infraestructura

Cuando modificas un recurso en Terraform, el plan evalúa si esa modificación requiere simplemente actualizar el recurso existente o si necesita destruirlo y volver a crearlo (es decir, hacerlo inmutable).

    Ejemplo de Mutación Simple: Cambiar el número de nodos en un Node Pool. Terraform ejecuta una actualización simple sin interrupción.

    Ejemplo de Inmutabilidad: Cambiar la configuración de red fundamental de un clúster GKE (como el modo VPC Nativo). Terraform detecta que la API de GCP no permite un cambio in situ y propone un plan de: Destruir el clúster viejo → Crear el clúster nuevo.

Esta lógica te protege de cambios de configuración potencialmente peligrosos que podrían dejar tu clúster en un estado inconsistente. Te fuerza a pensar en el impacto de los cambios antes de aplicarlos.







### Data Source
* Read Only Resource






