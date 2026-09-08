```markdown
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

Ensure the following tools are installed and configured locally before deployment:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) `>= 1.5.0`
- [AWS CLI](https://aws.amazon.com/cli/) `>= 2.0`
- [kubectl](https://kubernetes.io/docs/tasks/tools/) compatible with Kubernetes `1.30`

---

## Step-by-Step Deployment Guide

### 1. Configure AWS Credentials
Ensure your terminal has administrative access to your AWS account:
```bash
aws configure

```

Verify identity and active account:

```bash
aws sts get-caller-identity

```

### 2. Prepare Environment Variables

Navigate to the Terraform directory and create your variable configuration from the sample:

```bash
cd 01-infrastructure-terraform
cp terraform.tfvars.example terraform.tfvars

```

*(Optional)* Edit `terraform.tfvars` if you need to override the target region, cluster name, or instance configurations.

### 3. Initialize Terraform Working Directory

Download necessary provider plugins and external modules:

```bash
terraform init

```

### 4. Validate and Format Configuration

Check syntax integrity and formatting across all `.tf` files:

```bash
terraform fmt -check
terraform validate

```

### 5. Review Execution Plan

Generate and inspect an execution plan to verify planned infrastructure changes:

```bash
terraform plan -out=tfplan

```

### 6. Provision Cloud Infrastructure

Apply the generated execution plan to provision the VPC, EKS cluster, and IAM resources (typically takes 12–18 minutes):

```bash
terraform apply tfplan

```

---

## Post-Deployment & Cluster Verification

### 1. Update Local Kubeconfig

Register the newly created EKS cluster with your local `kubectl` context:

```bash
aws eks --region ap-south-1 update-kubeconfig --name caregrid-eks

```

### 2. Verify Node Pool Status

Confirm that all EC2 spot worker nodes are in the `Ready` status:

```bash
kubectl get nodes -o wide

```

### 3. Verify Core Cluster Services

Verify that the core EKS add-ons (CoreDNS, kube-proxy, VPC CNI, and EBS CSI) are running properly:

```bash
kubectl get pods -n kube-system

```

---

## Teardown Procedure

To cleanly destroy all provisioned cloud resources and prevent ongoing billing:

```bash
# 1. Ensure any external Kubernetes Services/Ingresses (ALBs) are deleted first:
# kubectl delete ingress --all --all-namespaces

# 2. Destroy the underlying AWS infrastructure:
terraform destroy -auto-approve

```

```

```
