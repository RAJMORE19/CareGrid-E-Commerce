resource "aws_security_group" "additional_node_sg" {
  name        = "${var.cluster_name}-additional-node-sg"
  description = "Additional network controls for CareGrid EKS worker nodes."
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Intra-cluster communication for cross-pod container networking"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Outbound egress rule to allow image pulls, updates, and external API requests"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-node-sg"
  }
}
