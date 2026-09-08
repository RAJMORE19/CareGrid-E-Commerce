terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Production me S3 bucket aur DynamoDB state locking ke liye use karein:
  # backend "s3" {
  #   bucket         = "caregrid-terraform-state"
  #   key            = "dev/terraform.tfstate"
  #   region         = "ap-south-1"
  #   dynamodb_table = "terraform-locks"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "CareGrid-E-Commerce"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
