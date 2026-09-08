output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint URL for Kubernetes API Server access."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to authenticate with the cluster."
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "vpc_id" {
  description = "The ID of the provisioned VPC."
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of private subnet IDs hosting the EKS nodes."
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs hosting Load Balancers."
  value       = module.vpc.public_subnets
}

output "aws_lbc_role_arn" {
  description = "IAM Role ARN configured via IRSA for the AWS Load Balancer Controller."
  value       = module.load_balancer_controller_irsa_role.iam_role_arn
}

output "configure_kubectl" {
  description = "Command line string to register the new cluster credentials locally."
  value       = "aws eks --region ${var.aws_region} update-kubeconfig --name ${module.eks.cluster_name}"
}
