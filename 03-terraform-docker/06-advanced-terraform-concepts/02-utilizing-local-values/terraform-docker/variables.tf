# Variables
variable "int_port" {
  type        = number
  default     = 1880
  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

variable "ext_port" {
  type        = list
  sensitive  = true
  default     = 76423
  # validation {
  #  condition     = var.ext_port <= 65535 && var.ext_port > 0
  #  error_message = "The external port must be in the valid range 0 - 65535."
  # }
}

locals {
  container_count = length(var.ext_port)
}
