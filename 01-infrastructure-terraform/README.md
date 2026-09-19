
<img width="1536" height="1024" alt="Terraform" src="https://github.com/user-attachments/assets/79eabc0c-3b29-4c1c-8bdb-c1e4b532836d" />


# 🏗️ CareGrid — AWS Infrastructure with Terraform

Terraform Infrastructure as Code for the **CareGrid E-Commerce** platform, providing the AWS networking, Kubernetes compute, identity, storage integration, and security foundation required by the application.

> **Region:** `ap-south-1` (Mumbai)  
> **Environment:** `dev`  
> **IaC:** Terraform  
> **Platform:** Amazon EKS

---

## Architecture

```text
                         Internet
                            │
                     Application Traffic
                            │
             ┌──────── AWS VPC ────────┐
             │       10.0.0.0/16       │
             │                         │
             │   Public Subnets        │
             │   ├── 10.0.1.0/24       │
             │   ├── 10.0.2.0/24       │
             │   └── 10.0.3.0/24       │
             │           │             │
             │      NAT Gateway        │
             │           │             │
             │   Private Subnets       │
             │   ├── 10.0.11.0/24      │
             │   ├── 10.0.12.0/24      │
             │   └── 10.0.13.0/24      │
             │           │             │
             │      Amazon EKS         │
             │           │             │
             │   Managed Node Group    │
             │     Spot Instances      │
             │           │             │
             │   Kubernetes Workloads  │
             │                         │
             └─────────────────────────┘
```

The VPC spans **three Availability Zones**. Kubernetes workers run in private subnets while public subnets provide internet-facing load-balancer discovery and outbound connectivity through a single NAT Gateway.

---

## Infrastructure

| Component | Implementation |
|---|---|
| Networking | VPC `10.0.0.0/16`, 3 public + 3 private subnets |
| Egress | Single NAT Gateway for lower lab cost |
| Kubernetes | Amazon EKS managed control plane |
| Compute | Managed Spot Node Group |
| Scaling | Min `2` • Desired `2` • Max `5` |
| Instances | `t3.medium`, `t3a.medium`, `c5.large` |
| Storage Driver | Amazon EBS CSI |
| Identity | OIDC + IAM Roles for Service Accounts |
| Load Balancing IAM | IRSA role for AWS Load Balancer Controller |
| Cluster Access | EKS Access Entries |
| Node Storage | Encrypted `gp3`, 20 GiB |
| DNS | VPC DNS support + hostnames |

### Kubernetes Add-ons

```text
CoreDNS
kube-proxy
Amazon VPC CNI
Amazon EBS CSI Driver
```

The EBS CSI driver receives AWS permissions through its dedicated service account role rather than broad worker-node credentials.

---

## Network Layout

```text
VPC: 10.0.0.0/16

Public
├── 10.0.1.0/24
├── 10.0.2.0/24
└── 10.0.3.0/24

Private
├── 10.0.11.0/24
├── 10.0.12.0/24
└── 10.0.13.0/24
```

Subnet discovery tags prepare the network for Kubernetes load balancers:

```text
Public  → kubernetes.io/role/elb
Private → kubernetes.io/role/internal-elb
```

---

## Security

The infrastructure currently applies these controls:

- Worker nodes remain inside private subnets.
- EBS volumes are encrypted.
- OIDC enables pod-level AWS authorization through IRSA.
- Separate roles exist for the EBS CSI driver and AWS Load Balancer Controller.
- Cluster creator administration uses native EKS access management.
- Additional node security-group rules permit internal cluster communication.
- AWS provider default tags identify environment, project, repository, and Terraform ownership.

> The Kubernetes API currently supports both public and private endpoints. Public-access restriction is a future hardening step.

---

## Cost Strategy

This repository uses a **cost-optimized demonstration environment**, not production-scale capacity.

```text
Single NAT Gateway
        +
Spot Worker Nodes
        +
Small Initial Capacity
        ↓
Lower AWS Lab Cost
```

Spot capacity is diversified across multiple EC2 instance families to reduce dependency on a single Spot pool.

For a real production environment, the same design can be extended with an On-Demand baseline, stronger NAT/egress redundancy, additional availability controls, backups, and stricter administrative access.

---

## Project Structure

```text
01-infrastructure-terraform/
│
├── versions.tf
├── variables.tf
├── terraform.tfvars.example
│
├── vpc.tf
├── eks.tf
├── iam-irsa.tf
├── security-groups.tf
│
├── outputs.tf
└── README.md
```

| File | Purpose |
|---|---|
| `versions.tf` | Terraform/provider requirements and AWS configuration |
| `variables.tf` | Configurable infrastructure values |
| `terraform.tfvars.example` | Example environment configuration |
| `vpc.tf` | Network topology, routing and NAT |
| `eks.tf` | Cluster, worker capacity and core add-ons |
| `iam-irsa.tf` | Kubernetes service-account AWS permissions |
| `security-groups.tf` | Additional worker-node network controls |
| `outputs.tf` | IDs, endpoints and connection information |

---

## Deployment

### Prerequisites

```text
Terraform >= 1.5
AWS CLI >= 2
kubectl
AWS credentials with required permissions
```

### Configure

```bash
cd 01-infrastructure-terraform
cp terraform.tfvars.example terraform.tfvars

aws sts get-caller-identity
```

### Validate

```bash
terraform init
terraform fmt -check
terraform validate
```

### Review

```bash
terraform plan -out=tfplan
```

### Provision

```bash
terraform apply tfplan
```

Always review the execution plan before applying infrastructure changes.

---

## Connect to EKS

```bash
aws eks \
  --region ap-south-1 \
  update-kubeconfig \
  --name caregrid-eks
```

Validate the platform:

```bash
kubectl get nodes -o wide
kubectl get pods -n kube-system
```

Expected core services include:

```text
CoreDNS
kube-proxy
VPC CNI
EBS CSI
```

---

## Terraform Outputs

After provisioning:

```bash
terraform output
```

The configuration exposes:

```text
cluster_id
cluster_endpoint
cluster_certificate_authority_data
vpc_id
private_subnets
public_subnets
aws_lbc_role_arn
configure_kubectl
```

These values are consumed by later Kubernetes and platform configuration.

---

## Planned Infrastructure

The following resources belong to the CareGrid target architecture but are **not yet provisioned by the current Terraform code**:

```text
Amazon ECR
Amazon RDS PostgreSQL
Amazon ElastiCache Redis
Amazon S3
AWS Secrets Manager
Remote Terraform State
```

They will be added incrementally before this infrastructure layer is considered complete.

---

## Cleanup

Remove Kubernetes resources that created external AWS infrastructure before destroying the environment:

```bash
kubectl delete ingress --all --all-namespaces
terraform destroy
```

Review the destroy plan before confirmation to avoid deleting resources you intend to keep.

---

## Infrastructure Flow

```text
Terraform Configuration
        ↓
terraform init
        ↓
terraform validate
        ↓
terraform plan
        ↓
terraform apply
        ↓
AWS Infrastructure
        ↓
Amazon EKS
        ↓
Kubernetes Platform
```

**Current status:** VPC + EKS foundation implemented. Data, registry, secrets, and remote-state layers are the next infrastructure milestones.
