# Right Way: Provider-agnostic module
# This module doesn't define any provider configuration - it uses whatever is passed to it

# NO provider block here! (GOOD!)
# The provider will be passed from the root configuration

# Random suffix to make bucket names unique
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# S3 bucket resource - uses whatever AWS provider was passed to this module
resource "aws_s3_bucket" "main" {
  bucket = "${var.bucket_name}-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Demo        = "providers-in-modules-right-way"
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
