terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "kite-terraform-tf-state"
    key            = "kite-state-setup"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "kite-tf-lock"
  }
}