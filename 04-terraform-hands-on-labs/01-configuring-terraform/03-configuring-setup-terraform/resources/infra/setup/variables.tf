variable "kite-terraform-tf-state" {
  description = "The name of the S3 bucket for the backend"
  type        = string
  default     = "kite-terraform-tf-state"
}

variable "kite-tf-lock" {
  description = "The name of the DynamoDB table for state locking"
  type        = string
  default     = "kite-tf-lock"
}

variable "key" {
  description = "The path to the state file inside the bucket"
  type        = string
  default     = "kite-state-setup"
}

variable "project" {
  description = "The name of the project"
  type        = string
  default     = "kientree-terraform-project"
}

variable "contact" {
  description = "The contact person for the project"
  type        = string
  default     = "your-email@example.com"
}