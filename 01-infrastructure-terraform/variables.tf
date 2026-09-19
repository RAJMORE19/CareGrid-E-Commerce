variable "aws_region" {
  type        = string
  description = "AWS deployment region."
  default     = "ap-south-1"
}

variable "project_name" {
  type        = string
  description = "Project identifier."
  default     = "caregrid"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "dev"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
  default     = "caregrid-eks"
}

variable "cluster_version" {
  type        = string
  description = "Supported EKS Kubernetes version."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC IPv4 CIDR."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs."
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs."
  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

variable "spot_instance_types" {
  type        = list(string)
  description = "Diversified EC2 types for Spot workers."
  default = [
    "t3.medium",
    "t3a.medium"
  ]
}

variable "node_group_min_size" {
  type    = number
  default = 2
}

variable "node_group_desired_size" {
  type    = number
  default = 2
}

variable "node_group_max_size" {
  type    = number
  default = 4
}

variable "db_name" {
  type    = string
  default = "caregrid"
}

variable "db_username" {
  type    = string
  default = "caregridadmin"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "redis_node_type" {
  type    = string
  default = "cache.t3.micro"
}

variable "ecr_repositories" {
  type = set(string)

  default = [
    "auth-service",
    "catalog-service",
    "cart-service",
    "booking-service",
    "payment-service",
    "notification-service"
  ]
}
