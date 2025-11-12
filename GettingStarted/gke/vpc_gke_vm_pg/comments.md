

main.tf        → recursos principales (infraestructura)
provider.tf    → configuración del proveedor (Google Cloud)
variables.tf   → definición de variables (parámetros de entrada)
outputs.tf     → salida de información útil





🔍 Qué hace:

Declara el proveedor: hashicorp/google — es el plugin que permite a Terraform interactuar con los servicios de Google Cloud.

Versión requerida: ~> 6.0 significa “usa la versión 6.x más reciente”.

Configura el proveedor con las variables:

project: ID del proyecto en GCP (por ejemplo, mi-proyecto-gcp-12345)

region: donde se crearán los recursos (por ejemplo, us-central1)

zone: zona específica (por ejemplo, us-central1-a)


---


google_compute_network.vpc crea una VPC personalizada llamada demo-vpc.

auto_create_subnetworks = false significa que no se crean subredes automáticas (como ocurre con la VPC “default”).

google_compute_subnetwork.subnet crea una subred dentro de esa VPC:

ip_cidr_range = rango de IPs (aquí 10.0.0.0/24, o sea 256 IPs).

region = región donde estará disponible.

network = se vincula a la VPC creada anteriormente.


---


google_container_cluster.gke_cluster crea el cluster Kubernetes principal.

Usa la VPC y subred definidos antes.

remove_default_node_pool = true: elimina el “node pool” automático para que puedas crear el tuyo propio con configuraciones personalizadas.

google_container_node_pool.primary_nodes define el grupo de nodos (VMs) que ejecutan los pods:

machine_type: tipo de instancia (e2-medium = 2 vCPU, 4 GB RAM)

oauth_scopes: permisos que se dan a las VMs del cluster.

initial_node_count: número de nodos.

💡 Resultado: un cluster GKE con 2 nodos en tu VPC.



---


Explicación:

Crea una máquina virtual llamada demo-vm.

machine_type: define tamaño y capacidad de la VM.

boot_disk: indica que use Debian 12 como imagen base.

network_interface: conecta la VM a la VPC y subred.

access_config {} agrega una IP pública (sin esto, solo tendría IP interna).

metadata_startup_script: script que se ejecuta al arrancar la VM.
En este caso, instala NGINX automáticamente.

💡 Resultado: una VM accesible por IP pública, con Nginx corriendo.



---


Explicación:

Crea una instancia de Cloud SQL con PostgreSQL 15.

tier = "db-f1-micro" → instancia pequeña (barata, ideal para pruebas).

ip_configuration:

ipv4_enabled = true: habilita una IP pública.

authorized_networks: define quién puede conectarse.
Aquí se usa 0.0.0.0/0, que significa acceso abierto (solo para pruebas, no en producción).

Luego se crean:

google_sql_database.app_db → base de datos vacía llamada appdb.

google_sql_user.db_user → usuario appuser con contraseña.

💡 Resultado: una base de datos PostgreSQL accesible externamente, lista para conectar desde la VM o GKE.



---


Muestra información útil después del despliegue:

La URL del cluster GKE.

La IP pública de la VM.

El nombre de conexión de la base de datos (para conectarse desde aplicaciones o GKE).











