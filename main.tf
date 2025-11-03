# main.tf (A VERSÃO FINAL E CORRETA)

# 1. terraform e provider
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# 2. redes
resource "docker_network" "rede_interna" {
  name = "rede-interna" # Backend <-> DB
}

resource "docker_network" "rede_externa" {
  name = "rede-externa" # Proxy <-> Backend
}

# 3. Define o volume
resource "docker_volume" "db_data" {
  name = "postgres-data"
}

# 4. imagem docker do backend
resource "docker_image" "backend_image" {
  name = "backend-app:latest"
  build {
    context = "./backend" # Pasta onde está o Dockerfile
  }
}

# 5. define os containers

# -- BANCO DE DADOS --
resource "docker_container" "db" {
  name  = "postgres-db"
  image = "postgres:15.8"
  networks_advanced {
    name = docker_network.rede_interna.name
  }
  env = [
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=mysecretpassword",
    "POSTGRES_DB=desafiodb"
  ]

  # 1: dados persistentes
  volumes {
    volume_name    = docker_volume.db_data.name
    container_path = "/var/lib/postgresql/data"
  }

  # 2: inicialização
  volumes {
    host_path      = abspath("./db") # Monta a PASTA 'db'
    container_path = "/docker-entrypoint-initdb.d" # Na PASTA 'initdb.d'
    read_only      = true
  }

  restart = "unless-stopped"
}

# -- BACKEND --
resource "docker_container" "backend" {
  name  = "backend"
  image = docker_image.backend_image.image_id
  networks_advanced {
    name = docker_network.rede_interna.name
  }
  networks_advanced {
    name = docker_network.rede_externa.name
  }
  env = [
    "PORT=3000",
    "POSTGRES_HOST=postgres-db",
    "POSTGRES_PORT=5432",
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=mysecretpassword",
    "POSTGRES_DB=desafiodb"
  ]
  depends_on = [docker_container.db]
  restart    = "unless-stopped"
}

# -- PROXY REVERSO (NGINX) --
resource "docker_container" "proxy" {
  name  = "proxy"
  image = "nginx:alpine"
  networks_advanced {
    name = docker_network.rede_externa.name
  }
  ports {
    internal = 80
    external = 8080
  }
  
  volumes {
    host_path      = abspath("./proxy/default.conf")
    container_path = "/etc/nginx/conf.d/default.conf"
    read_only      = true
  }

  volumes {
    host_path      = abspath("./frontend/index.html")
    container_path = "/usr/share/nginx/html/index.html"
    read_only      = true
  }

  depends_on = [docker_container.backend]
  restart    = "unless-stopped"
}