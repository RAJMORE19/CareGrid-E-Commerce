# CareGrid E-Commerce: Cloud Infrastructure Provisioning (Terraform)

This module implements an automated, enterprise-grade Infrastructure-as-Code (IaC) configuration for the **CareGrid E-Commerce** platform on Amazon Web Services (AWS) using HashiCorp Terraform.

---

## Architectural Highlights

- **VPC Topology**: Multi-AZ networking across 3 Availability Zones with dedicated Public and Private Subnet tiers.
- **Cost-Optimized Egress**: Configured with a single NAT Gateway for non-production environments, cutting baseline VPC egress costs by ~67%.
- **Resilient Compute**: EKS Managed Node Groups utilizing multi-instance **AWS Spot Instances** (`t3.medium`, `t3a.medium`, `c5.large`) for up to 70% cost reduction on stateless workloads.
- **Least-Privilege Security**: Adopts **IAM Roles for Service Accounts (IRSA)** via OpenID Connect (OIDC), eliminating broad node-level IAM credentials.
- **Modern Authentication**: Leverages EKS Access Entries for native Kubernetes RBAC integration.

---

## Provisioned Infrastructure Components

| Component | Resource | Description |
|---|---|---|
| **Network** | AWS VPC | 10.0.0.0/16 VPC across 3 AZs with ingress discovery tags |
| **Orchestration** | Amazon EKS v1.30 | Fully managed Kubernetes control plane |
| **Compute** | EC2 Spot Node Group | Auto-scaling worker fleet (Min: 2, Max: 5, Desired: 2) |
| **Storage Driver** | EBS CSI Driver Add-on | Encrypted persistent volume provisioning via gp3 |
| **Security** | IAM & OIDC | Pod-level IAM federation for ALB Controller and CSI |

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) `>= 1.5.0`
- [AWS CLI](https://aws.amazon.com/cli/) `>= 2.0` authenticated with administrative access
- [kubectl](https://kubernetes.io/docs/tasks/tools/) configured locally

---

## Deployment Lifecycle

### 1. Initialize Backend and Modules
```bash
terraform init
