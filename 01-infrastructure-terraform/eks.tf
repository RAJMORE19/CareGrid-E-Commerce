module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_public_access  = true
  endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  enable_cluster_creator_admin_permissions = true

  addons = {
    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      most_recent    = true
      before_compute = true
    }

    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa_role.arn
    }
  }

  eks_managed_node_groups = {
    application = {
      name = "${var.project_name}-${var.environment}-spot"

      ami_type      = "AL2023_x86_64_STANDARD"
      capacity_type = "SPOT"

      instance_types = var.spot_instance_types

      min_size     = var.node_group_min_size
      desired_size = var.node_group_desired_size
      max_size     = var.node_group_max_size

      disk_size = 20

      labels = {
        workload = "microservices"
      }
    }
  }
}
