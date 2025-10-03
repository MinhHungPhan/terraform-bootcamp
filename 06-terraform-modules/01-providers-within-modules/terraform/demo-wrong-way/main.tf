# Demo: The Wrong Way - Provider Inside Module
# This demonstrates the problematic approach where modules define their own providers

terraform {
  required_version = ">= 1.0"
}

# Notice: NO provider configuration here!
# The provider is defined inside the module (which is problematic)

module "demo_bucket" {
  source      = "./modules/s3-bucket"
  bucket_name = "demo-wrong-way-bucket"
  environment = "demo"
}

# Outputs to see what was created
output "bucket_name" {
  description = "Name of the S3 bucket created"
  value       = module.demo_bucket.bucket_name
}

output "bucket_region" {
  description = "Region where the bucket was created"
  value       = module.demo_bucket.bucket_region
}
