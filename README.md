# 🏥 CareGrid E-Commerce

## Production-Style AWS EKS Microservices & DevSecOps Platform

CareGrid is a cloud-native **Blood Test Booking & Diagnostic E-Commerce platform** built to demonstrate a practical production-style DevOps architecture using **AWS, Terraform, Kubernetes, Jenkins, GitOps, Argo CD, security scanning, and observability**.

The project focuses on implementing production engineering practices while keeping the deployed environment **cost-optimized for learning and demonstration**.

---

# 🚀 10-Second Architecture

```text
Developer
   │
   ▼
GitHub
   │
   ▼
Jenkins CI
   │
   ├── Unit Tests
   ├── SonarQube
   ├── OWASP Dependency Check
   ├── Docker Build
   ├── Trivy Scan
   └── SBOM
   │
   ▼
Amazon ECR
   │
   ▼
GitOps Repository
   │
   ▼
Argo CD
   │
   ▼
Argo Rollouts
   │
   ▼
Amazon EKS
   │
   ▼
CareGrid Microservices
   │
   ├── PostgreSQL / Amazon RDS
   └── Redis

Prometheus → Grafana → Alertmanager
```

---

# 🏗️ Platform Architecture

## User Traffic

```text
User
 │
 ▼
Route 53
 │
 ▼
Application Load Balancer
 │
 ▼
AWS Load Balancer Controller
 │
 ▼
Amazon EKS
 │
 ├── Auth Service
 ├── Test Catalog Service
 ├── Cart Service
 ├── Booking Service
 ├── Payment Service
 └── Notification Service
```

EKS worker nodes and databases are placed inside **private subnets**.

Public subnets are used for internet-facing infrastructure such as the Application Load Balancer.

---

# ⚙️ Infrastructure as Code

AWS infrastructure is provisioned using **Terraform**.

The infrastructure layer covers:

- Custom VPC
- Multi-AZ public/private subnets
- NAT Gateway
- Amazon EKS
- Managed Node Groups
- Amazon ECR
- Amazon RDS PostgreSQL
- Redis
- IAM
- IRSA / OIDC
- Security Groups
- AWS Secrets Manager
- Encrypted storage

Terraform code is maintained under:

```text
01-infrastructure-terraform/
```

The currently deployed environment is intentionally cost-optimized.

Production scaling patterns such as stronger multi-AZ redundancy, larger node capacity, and dedicated production environments can be applied without changing the core platform design.

---

# 🐳 Microservices

CareGrid follows a microservices architecture.

```text
02-microservices/
```

Application services:

| Service | Responsibility |
|---|---|
| Auth Service | Authentication and authorization |
| Test Catalog | Diagnostic test management |
| Cart Service | Shopping cart operations |
| Booking Service | Test booking/order processing |
| Payment Service | Payment workflow |
| Notification Service | User notifications |

Services are packaged as **Docker containers** and deployed to Kubernetes.

---

# 🔄 CI — Continuous Integration

**Jenkins is the CI automation server.**

```text
Developer
    ↓
GitHub
    ↓
Jenkins
    ↓
Unit Tests
    ↓
SonarQube
    ↓
OWASP Dependency Check
    ↓
Docker Build
    ↓
Trivy
    ↓
SBOM
    ↓
Amazon ECR
```

## CI Security Gates

### SonarQube

Used for:

- Static code analysis
- Bugs
- Code smells
- Maintainability
- Quality Gate validation

### OWASP Dependency Check

Used to identify known vulnerabilities in application dependencies.

### Trivy

Used to scan container images for:

- OS vulnerabilities
- Package vulnerabilities
- HIGH/CRITICAL CVEs

### SBOM

A Software Bill of Materials is generated for container artifacts to improve dependency visibility and software supply-chain auditing.

---

# 📦 Container Registry

Docker images are stored in **Amazon Elastic Container Registry (ECR)**.

Images use immutable version/commit-based tags instead of relying on:

```text
latest
```

Example:

```text
auth-service:a84f73c
booking-service:be29014
payment-service:f812cd1
```

This provides traceability between:

```text
Git Commit → CI Build → Docker Image → Kubernetes Deployment
```

---

# 🚀 CD — GitOps

Application deployment follows the **GitOps model**.

Jenkins does not directly deploy application workloads using:

```bash
kubectl apply
```

Instead:

```text
Jenkins
   ↓
Update GitOps image tag
   ↓
GitOps Repository
   ↓
Argo CD
   ↓
Amazon EKS
```

The Git repository therefore remains the source of truth for the desired Kubernetes application state.

---

# 🔵🟢 Progressive Delivery

**Argo Rollouts** is used to demonstrate controlled application releases.

Deployment strategy:

```text
New Version
     ↓
Blue / Green Rollout
     ↓
Health Validation
     ↓
┌───────────────┐
│               │
Healthy      Unhealthy
│               │
▼               ▼
Promote       Rollback
```

This reduces deployment risk compared with immediately replacing all running application instances.

---

# ☸️ Kubernetes Production Practices

Application workloads implement Kubernetes reliability practices including:

### Health Checks

```text
Liveness Probe
Readiness Probe
```

### Resource Management

```text
CPU Requests
CPU Limits
Memory Requests
Memory Limits
```

### Autoscaling

```text
Horizontal Pod Autoscaler
```

HPA automatically adjusts application replica counts according to workload metrics.

### Availability

```text
Pod Disruption Budget
```

PDB helps preserve application availability during voluntary disruptions such as node maintenance.

---

# 🔐 Security

Security is implemented across multiple layers.

## AWS

```text
IAM
IRSA
Security Groups
Private Subnets
Encrypted Storage
Secrets Manager
```

## CI

```text
SonarQube
OWASP Dependency Check
Trivy
SBOM
```

## Kubernetes

```text
RBAC
Security Context
Resource Limits
Secrets Integration
Network Policies
```

Application secrets and credentials must **not be stored directly in Git**.

---

# 📊 Observability

The platform uses:

```text
Prometheus
     ↓
Grafana
     ↓
Alertmanager
```

### Prometheus

Collects Kubernetes and application metrics.

### Grafana

Provides dashboards for:

- CPU utilization
- Memory utilization
- Pod health
- Replica counts
- Application metrics
- Infrastructure health

### Alertmanager

Routes operational alerts when configured thresholds or health conditions are triggered.

---

# 💾 Data Layer

## PostgreSQL

Transactional application data is stored in PostgreSQL, with **Amazon RDS PostgreSQL** as the AWS deployment target.

Examples:

```text
Users
Bookings
Orders
Payments
Test Catalog
```

## Redis

Redis provides caching and other short-lived application data where appropriate.

---

# 🌐 AWS Network Design

```text
                    Internet
                       │
                       ▼
                 Route 53 / DNS
                       │
                       ▼
                       ALB
                       │
            ┌──────────┴──────────┐
            │      AWS VPC        │
            │                     │
     Public Subnets         Private Subnets
            │                     │
           ALB                EKS Nodes
                                  │
                         CareGrid Services
                                  │
                           ┌──────┴──────┐
                           │             │
                          RDS          Redis
```

The application and data layers are not intended to be directly exposed to the public internet.

---

# 🛠️ Technology Stack

| Layer | Technology |
|---|---|
| Cloud | AWS |
| IaC | Terraform |
| Containers | Docker |
| Orchestration | Kubernetes / Amazon EKS |
| Package Management | Helm |
| CI | Jenkins |
| Code Quality | SonarQube |
| Dependency Security | OWASP Dependency Check |
| Container Security | Trivy |
| Registry | Amazon ECR |
| CD | Argo CD |
| Progressive Delivery | Argo Rollouts |
| Monitoring | Prometheus |
| Visualization | Grafana |
| Alerting | Alertmanager |
| Database | PostgreSQL / Amazon RDS |
| Cache | Redis |
| Secrets | AWS Secrets Manager |
| Source Control | GitHub |

---

# 📁 Repository Structure

```text
CareGrid-E-Commerce/
│
├── 01-infrastructure-terraform/
│   └── AWS infrastructure using Terraform
│
├── 02-microservices/
│   └── CareGrid application services
│
├── 03-ci-cd-pipelines/
│   └── Jenkins / DevSecOps pipeline configuration
│
├── 04-gitops-manifests/
│   └── Kubernetes / Helm / Argo CD configuration
│
├── 05-observability/
│   └── Prometheus / Grafana / alerting
│
├── 06-Testing/
│   └── Application and infrastructure testing
│
└── README.md
```

---

# 🔁 End-to-End Delivery Flow

```text
CODE
 │
 ▼
GitHub
 │
 ▼
Jenkins
 │
 ├── Test
 ├── SonarQube
 ├── OWASP
 ├── Docker Build
 ├── Trivy
 └── SBOM
 │
 ▼
Amazon ECR
 │
 ▼
GitOps Repository
 │
 ▼
Argo CD
 │
 ▼
Argo Rollouts
 │
 ▼
Amazon EKS
 │
 ▼
CareGrid Microservices
 │
 ├── RDS PostgreSQL
 └── Redis

        │
        ▼
   Prometheus
        │
        ▼
     Grafana
        │
        ▼
   Alertmanager
```

---

# 🎯 Engineering Goals

CareGrid demonstrates practical implementation of:

- Infrastructure as Code
- Containerized microservices
- Kubernetes orchestration
- DevSecOps CI
- Immutable container artifacts
- GitOps continuous delivery
- Progressive deployment
- Automated rollback
- Kubernetes autoscaling
- Secrets management
- Monitoring and alerting
- AWS network isolation
- Cloud-native application delivery

---

# 💰 Cost-Optimized Demonstration Environment

This repository demonstrates **production engineering patterns**, but the live AWS environment can intentionally use smaller and cheaper resources for portfolio/lab purposes.

For example:

```text
Demo / Development
────────────────────
Single NAT Gateway
Small EKS node group
Spot capacity where appropriate
Small RDS instance
Reduced retention
Limited replicas
```

A full production deployment would normally increase redundancy and operational controls, for example:

```text
Production
────────────────────
Multi-AZ architecture
Highly available NAT/egress strategy
On-Demand baseline capacity
Diversified compute capacity
RDS Multi-AZ
Automated backups
Higher replica counts
Stronger monitoring/alerting
Controlled administrative access
Dedicated environment isolation
```

This separation keeps the project affordable while preserving the architectural patterns required to discuss how it would be operated at production scale.

---

# ⚠️ Implementation Status

This repository is being developed incrementally.

Architecture diagrams and documentation may describe the **target state** before every component has been deployed.

A component should only be considered implemented after its configuration exists in the repository and has been validated in the target environment.

---

# 👨‍💻 Author

**Raj More**

DevOps Engineer

**Focus:** AWS • Kubernetes • Terraform • Docker • Jenkins • GitOps • CI/CD • DevSecOps
