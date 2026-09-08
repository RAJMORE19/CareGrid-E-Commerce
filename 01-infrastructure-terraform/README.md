# CareGrid E-Commerce: Cloud Infrastructure Provisioning (Terraform)

An automated, enterprise-grade Infrastructure-as-Code (IaC) implementation to provision the foundational AWS cloud environment for the **CareGrid E-Commerce** distributed microservices platform.

---

## Architectural Highlights

- **VPC Topology**: Multi-AZ networking across 3 Availability Zones with strict Public/Private subnet tier segregation.
- **Cost-Optimized Egress**: Single NAT Gateway deployment for non-production environments, cutting VPC egress baseline costs by ~67%.
- **Resilient Compute**: EKS Managed Node Groups utilizing diversified **AWS Spot Instances** (`t3.medium`, `t3a.medium`, `c5.large`) for up to 70% cost reduction on stateless container workloads.
- **Least-Privilege Security**: IAM Roles for Service Accounts (**IRSA**) via OpenID Connect (OIDC), eliminating long-lived node-level credentials.
- **Modern Authentication**: Native **EKS Access Entries** enabled for API-driven RBAC governance without legacy `aws-auth` ConfigMap coupling.

---

## Provisioned Infrastructure Components

| Layer | AWS Resource | Details / Specification |
|---|---|---|
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
