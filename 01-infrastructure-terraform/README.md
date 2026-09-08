# CareGrid E-Commerce: Cloud Infrastructure Provisioning (Terraform)

An automated, enterprise-grade Infrastructure-as-Code (IaC) implementation to provision the foundational AWS cloud environment for the **CareGrid E-Commerce** distributed microservices platform.

---

## Architectural Highlights

* **VPC Topology**: Multi-AZ networking across 3 Availability Zones with strict Public/Private subnet tier segregation.
* **Cost-Optimized Egress**: Single NAT Gateway deployment for non-production environments, cutting VPC egress baseline costs by ~67%.
* **Resilient Compute**: EKS Managed Node Groups utilizing diversified **AWS Spot Instances** (`t3.medium`, `t3a.medium`, `c5.large`) for up to 70% cost reduction on stateless container workloads.
* **Least-Privilege Security**: IAM Roles for Service Accounts (**IRSA**) via OpenID Connect (OIDC), eliminating long-lived node-level credentials.
* **Modern Authentication**: Native **EKS Access Entries** enabled for API-driven RBAC governance without legacy `aws-auth` ConfigMap coupling.

---

## Provisioned Infrastructure Components

| Layer | AWS Resource | Details / Specification |
| --- | --- | --- |
| **Networking** | AWS VPC | `10.0.0.0/16` CIDR across 3 AZs with ingress discovery tags |
| **Orchestration** | Amazon EKS | Version `1.30` control plane with public/private API endpoints |
| **Compute** | EC2 Spot Node Group | Auto-scaling worker fleet (Min: `2`, Desired: `2`, Max: `5`) |
| **Storage** | EBS CSI Driver Add-on | Dynamically provisions encrypted `gp3` volumes for stateful pods |
| **Identity & Access** | IAM & OIDC | Fine-grained IRSA roles for AWS Load Balancer Controller & EBS CSI |

---

## Repository Structure

```text
01-infrastructure-terraform/
├── versions.tf               # Terraform core & provider constraints
├── variables.tf              # Input variable declarations
├── terraform.tfvars.example  # Sample configuration values
├── vpc.tf                    # VPC, subnets, route tables, and NAT gateway
├── eks.tf                    # EKS cluster, managed spot node groups, addons
├── iam-irsa.tf               # IAM OIDC roles for EBS CSI and ALB controller
├── security-groups.tf        # Intra-cluster and external communication rules
├── outputs.tf                # Cluster endpoints, IDs, and kubeconfig helper
└── README.md                 # Infrastructure operations documentation

```

---

## Prerequisites

Ensure the following tools are installed and configured locally:

* [Terraform](https://developer.hashicorp.com/terraform/downloads) `>= 1.5.0`
* [AWS CLI](https://aws.amazon.com/cli/) `>= 2.0` with administrative credentials configured
* [kubectl](https://kubernetes.io/docs/tasks/tools/) compatible with Kubernetes `1.30`

---

## Step-by-Step Deployment Guide

### 1. Verify AWS Identity

Confirm your active AWS CLI profile has the target permissions:

```bash
aws sts get-caller-identity

```

### 2. Prepare Environment Configuration

Clone the repository, switch to this module, and instantiate your variables:

```bash
cd 01-infrastructure-terraform
cp terraform.tfvars.example terraform.tfvars

```

*(Optional)* Adjust variables in `terraform.tfvars` for your preferred AWS region or instance sizing.

### 3. Initialize Working Directory

Download required providers and external Terraform modules:

```bash
terraform init

```

### 4. Code Formatting & Validation

Enforce Terraform canonical styling and semantic validation:

```bash
terraform fmt -check
terraform validate

```

### 5. Review Execution Plan

Inspect the resources slated for creation before committing changes:

```bash
terraform plan -out=tfplan

```

### 6. Provision Infrastructure

Deploy the plan (typically takes 12–18 minutes):

```bash
terraform apply tfplan

```

---

## Cluster Authentication & Health Verification

### 1. Register Local Kubeconfig

Connect your local `kubectl` client using the generated Terraform output:

```bash
aws eks --region ap-south-1 update-kubeconfig --name caregrid-eks

```

### 2. Verify Worker Nodes

Ensure all Spot worker instances are healthy and in `Ready` status:

```bash
kubectl get nodes -o wide

```

### 3. Inspect System Add-ons

Verify that all core Kubernetes pods (CoreDNS, kube-proxy, VPC CNI, EBS CSI) are running:

```bash
kubectl get pods -n kube-system

```

---

## Operational Notes & Troubleshooting

* **Node Group Spot Interruption**: The node group is configured with multiple instance types (`t3.medium`, `t3a.medium`, `c5.large`) across multiple AZs to mitigate Spot capacity reclamation risks.
* **Unauthorized / RBAC Errors**: If running `kubectl` commands yields authorization failures, verify that the IAM identity running `terraform apply` matches the active identity in your local CLI. This module sets `enable_cluster_creator_admin_permissions = true`.
* **Subnet Discovery Tags**: Public subnets carry `kubernetes.io/role/elb = 1` and private subnets carry `kubernetes.io/role/internal-elb = 1` to allow automated subnet discovery by the AWS Load Balancer Controller.

---

## Teardown Procedure

To avoid unwanted cloud infrastructure billing when testing is complete:

```bash
# Step 1: Remove active Kubernetes services/ingresses provisioning external ALBs
kubectl delete ingress --all --all-namespaces

# Step 2: Destroy all managed infrastructure
terraform destroy -auto-approve

```
