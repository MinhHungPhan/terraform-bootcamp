terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.15.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest

  ports {
    internal = 1880
    # external = 1880
  }
}

output "Container-name" {
  value       = docker_container.nodered_container[*].name
  description = "The name of the container"
}

output "IP-Address" {
  value       = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
  description = "The IP address and external port of the container"
}
