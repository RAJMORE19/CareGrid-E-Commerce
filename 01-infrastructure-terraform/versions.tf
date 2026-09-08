terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # For remote state management with state locking (Production Best Practice)
  # backend "s3" {
  #   bucket         = "caregrid-terraform-state-backend"
  #   key            = "environments/dev/terraform.tfstate"
  #   region         = "ap-south-1"
  #   dynamodb_table = "caregrid-terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "CareGrid-E-Commerce"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Repository  = "https://github.com/RAJMORE19/CareGrid-E-Commerce"
    }
  }
}
