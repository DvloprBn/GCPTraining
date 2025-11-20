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


### GKE

* ¿Que es un contenedor?

    Empaquetado lógico en el que las aplicaciones se pueden extraer del entorno en el que se ejecutan.


* Que es un Pod?
    Parte mas pequeña que contienen contenedores


* Que es un Nodo?
    Maquinas que ejecutan las aplicaciones.

* Que es GKE?
    Herramienta que provee manejo para despliegue, manejo y escalado de aplicaciones.









### Data Source
* Read Only Resource




#### VPC


¿Qué es una VPC en GCP?
Una VPC (Virtual Private Cloud), o Nube Privada Virtual, es esencialmente la versión virtual de una red física, implementada dentro de la infraestructura global de Google. Puedes pensar en ella como tu propia red privada y aislada dentro de la nube pública de Google.

Propiedades Clave:
Recurso Global: La red de VPC es un recurso global que abarca todas las regiones de Google Cloud.

Conectividad: Proporciona la conectividad de red para tus recursos en la nube, como las instancias de máquinas virtuales (VMs) de Compute Engine.

Subredes (Subnetworks): Cada red de VPC consta de una o más subredes, las cuales sí son recursos regionales con sus propios rangos de direcciones IP.

Control y Seguridad: Te permite controlar el flujo de tráfico mediante reglas de firewall y rutas, garantizando el aislamiento y la seguridad de tus recursos.

🎯 ¿En qué casos se necesita una VPC?
Una VPC es la base de tu arquitectura de red en GCP, y es necesaria para:

Aislamiento y Seguridad de Recursos:

Para separar tus entornos (por ejemplo, Producción, Desarrollo y Pruebas) con diferentes subredes y reglas de firewall, asegurando que los recursos sensibles estén aislados en subredes privadas.

Para ejecutar bases de datos y servicios internos en subredes privadas, inaccesibles directamente desde internet.

Arquitecturas Distribuidas y Escalables:

Alojar aplicaciones web seguras, microservicios y clústeres de contenedores (como Google Kubernetes Engine - GKE) dentro de una red controlada.

Permitir la comunicación eficiente entre recursos que se encuentran en diferentes regiones geográficas de Google Cloud.

Entornos Híbridos (Nube a On-Premise):

Cuando necesitas conectar de forma segura tu red de VPC en GCP con tu centro de datos local (on-premise), utilizando servicios como Cloud VPN o Cloud Interconnect.

Organizaciones Grandes (VPC Compartida):

Organizaciones que requieren una gestión centralizada de la red mientras permiten que múltiples equipos o proyectos utilicen la misma infraestructura de red bajo reglas y políticas comunes.

En resumen, prácticamente cualquier implementación de carga de trabajo en GCP requiere una VPC, ya que es el componente que proporciona la estructura, seguridad y control para todos tus recursos en la nube.


---  


### Task GCP Terraform

1. Create a cluster
2. Within the cluster create a VM
3. a PG instance


* El siguiente código de Terraform realiza estos pasos clave:

    Red: Crea una VPC y una subred.

    GKE: Despliega un clúster GKE en esa subred.

    VM: Crea una VM simple de Compute Engine.

    Cloud SQL (PostgreSQL): Provee una instancia de base de datos Cloud SQL para PostgreSQL, la cual es un servicio gestionado y no una VM. Nota Importante: GKE y las VMs interactúan con Cloud SQL usando su IP privada dentro de la misma VPC.


    terraform state list



### bucket in GCP

+ para que se utiliza






