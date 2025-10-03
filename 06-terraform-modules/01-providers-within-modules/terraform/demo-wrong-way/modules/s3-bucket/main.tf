# Wrong Way: Module with embedded provider configuration
# This is the problematic approach - DON'T DO THIS!

# Provider configuration inside the module (PROBLEM!)
provider "aws" {
  region = "us-east-1" # Hardcoded region in module
}

# Random suffix to make bucket names unique
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# S3 bucket resource
resource "aws_s3_bucket" "main" {
  bucket = "${var.bucket_name}-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Demo        = "providers-in-modules-wrong-way"
  }
}

# Block public access (security best practice)
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}
