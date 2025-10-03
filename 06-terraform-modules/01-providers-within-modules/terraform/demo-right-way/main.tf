# Demo: The Right Way - Provider in Root Configuration
# This demonstrates the recommended approach with centralized provider management

terraform {
  required_version = ">= 1.0"
}

# Provider configurations in root (RECOMMENDED!)
provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# Modules using providers passed from root
module "bucket_east" {
  source = "./modules/s3-bucket"

  providers = {
    aws = aws.east
  }

  bucket_name = "demo-right-way-bucket-east"
  environment = "demo"
}

module "bucket_west" {
  source = "./modules/s3-bucket"

  providers = {
    aws = aws.west
  }

  bucket_name = "demo-right-way-bucket-west"
  environment = "demo"
}

# Outputs to see what was created
output "bucket_east_name" {
  description = "Name of the S3 bucket created in us-east-1"
  value       = module.bucket_east.bucket_name
}

output "bucket_east_region" {
  description = "Region of the eastern bucket"
  value       = module.bucket_east.bucket_region
}

output "bucket_west_name" {
  description = "Name of the S3 bucket created in us-west-2"
  value       = module.bucket_west.bucket_name
}

output "bucket_west_region" {
  description = "Region of the western bucket"
  value       = module.bucket_west.bucket_region
}
