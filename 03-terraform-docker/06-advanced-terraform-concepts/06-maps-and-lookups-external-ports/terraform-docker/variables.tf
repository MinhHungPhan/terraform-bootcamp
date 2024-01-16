# Variables

variable "env" {
  type = string
  description = "Environment to deploy to"
  default = "dev"
}

variable "int_port" {
  type        = number
  default     = 1880
  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

variable "image" {
  type = map
  description = "Image for container"
  default = {
      dev = "nodered/node-red:latest"
      prod = "nodered/node-red:latest-minimal"
  }
}

variable "ext_port" {
  type = map

  validation {
    condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 1980
    error_message = "The external port for dev must be in the range 1980 - 65535."
  }

  validation {
    condition     = max(var.ext_port["prod"]...) < 1980 && min(var.ext_port["prod"]...) >= 1880
    error_message = "The external port for prod must be in the range 1880 - 1979."
  }
}

locals {
  container_count = length(lookup(var.ext_port, var.env))
}
