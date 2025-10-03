variable "bucket_name" {
  description = "Name for the S3 bucket (will have random suffix appended)"
  type        = string
}

variable "environment" {
  description = "Environment tag for the bucket"
  type        = string
  default     = "demo"
}
