variable "aws_region" {
  description = "Target AWS region for infrastructure provisioning."
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Deployment environment identifier (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Unique identifier for the Amazon EKS cluster."
  type        = string
  default     = "caregrid-eks"
}

variable "cluster_version" {
  description = "Target Kubernetes control plane version."
  type        = string
  default     = "1.30"
}

variable "vpc_cidr" {
  description = "Base IPv4 CIDR block allocated for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR allocations for public tier subnets (ALB / Ingress ingress)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR allocations for private tier subnets (EKS worker nodes and services)."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "spot_instance_types" {
  description = "EC2 instance types for the Spot managed node group to ensure diversification."
  type        = list(string)
  default     = ["t3.medium", "t3a.medium", "c5.large"]
}

variable "node_group_min_size" {
  description = "Minimum capacity threshold for the worker node Auto Scaling Group."
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum burst capacity threshold for the Auto Scaling Group."
  type        = number
  default     = 5
}

variable "node_group_desired_size" {
  description = "Initial target capacity for worker nodes."
  type        = number
  default     = 2
}
