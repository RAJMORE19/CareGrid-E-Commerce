# 🏥 CareGrid E-Commerce

### Production-Style • AWS • Kubernetes • DevSecOps • GitOps

CareGrid is a cloud-native **Blood Test Booking & Diagnostic E-Commerce platform** built to demonstrate production engineering practices using **AWS, Terraform, Docker, Kubernetes/EKS, Jenkins, Argo CD, DevSecOps, and observability**.

The deployed environment is intentionally **cost-optimized for portfolio/lab use**, while the architecture follows patterns that can be extended for production.

---

## 🏗️ Architecture

```text
                           USERS
                             │
                         Route 53
                             │
                            ALB
                             │
                    ┌──── Amazon EKS ────┐
                    │                    │
               Microservices         HPA / PDB
                    │
             ┌──────┴──────┐
             │             │
       RDS PostgreSQL     Redis


══════════════════════ CI ══════════════════════

Developer → GitHub → Jenkins
                        │
              ┌─────────┼──────────┐
              │         │          │
             Test    SonarQube    OWASP
              │
         Docker Build
              │
            Trivy
              │
             SBOM
              │
         Amazon ECR


══════════════════════ CD ══════════════════════

Jenkins → GitOps Repository
                 │
              Argo CD
                 │
           Argo Rollouts
                 │
             Amazon EKS
                 │
          Health Validation
             ┌───┴───┐
          Promote   Rollback


════════════════ OBSERVABILITY ════════════════

Prometheus → Grafana → Alertmanager
```

---

## 🧩 Microservices

| Service | Responsibility |
|---|---|
| **Auth** | Authentication & authorization |
| **Test Catalog** | Diagnostic test management |
| **Cart** | Shopping cart operations |
| **Booking** | Test booking/order processing |
| **Payment** | Payment workflow |
| **Notification** | User notifications |

All services are containerized with **Docker** and deployed on **Amazon EKS**.

---

## ⚙️ Infrastructure — Terraform

Terraform provisions the AWS foundation:

**VPC → Multi-AZ Public/Private Subnets → NAT → EKS → Managed Node Groups → ECR → RDS PostgreSQL → Redis → IAM/IRSA → Security Groups → Secrets Manager**

### Network Design

```text
Internet
   │
Route 53
   │
  ALB                         Public Subnets
   │
  EKS ── Microservices        Private Subnets
             │
        ┌────┴────┐
       RDS      Redis          Private Data Layer
```

EKS workloads and databases remain private; only required ingress is exposed through the load balancer.

---

## 🔄 CI/CD & GitOps

### CI — Jenkins

```text
GitHub
   ↓
Jenkins
   ↓
Unit Tests
   ↓
SonarQube Quality Gate
   ↓
OWASP Dependency Check
   ↓
Docker Build
   ↓
Trivy Vulnerability Scan
   ↓
SBOM
   ↓
Amazon ECR
```

Images use **immutable commit/version tags** for traceability:

```text
Git Commit → CI Build → Docker Image → Kubernetes Deployment
```

### CD — Argo CD

```text
Jenkins
   ↓
Update GitOps Image Tag
   ↓
GitOps Repository
   ↓
Argo CD
   ↓
Argo Rollouts
   ↓
Amazon EKS
```

Jenkins handles **CI** but does not directly deploy application workloads with `kubectl apply`.

**Git remains the desired-state source of truth**, while Argo CD performs continuous delivery.

Argo Rollouts provides **Blue/Green progressive delivery** with health validation and controlled promotion/rollback.

---

## ☸️ Kubernetes Production Practices

Application workloads implement:

- **Liveness & Readiness Probes**
- **CPU/Memory Requests & Limits**
- **Horizontal Pod Autoscaler (HPA)**
- **Pod Disruption Budget (PDB)**
- **RBAC & Security Contexts**
- **Network Policies**
- **Helm-based configuration**
- **Controlled Blue/Green releases**

---

## 🔐 DevSecOps & Security

Security is applied across the delivery stack:

| Layer | Controls |
|---|---|
| **AWS** | IAM, IRSA/OIDC, Security Groups, Private Subnets, Encryption |
| **Secrets** | AWS Secrets Manager — no credentials stored in Git |
| **Code** | SonarQube Quality Gates |
| **Dependencies** | OWASP Dependency Check |
| **Containers** | Trivy vulnerability scanning |
| **Supply Chain** | SBOM + immutable image tags |
| **Kubernetes** | RBAC, NetworkPolicy, Security Contexts, Resource Limits |

---

## 📊 Observability

```text
EKS + Applications
        ↓
    Prometheus
        ↓
     Grafana
        ↓
   Alertmanager
        ↓
      Alerts
```

Monitoring covers **CPU, memory, pod health, replicas, application metrics, and infrastructure health**.

---

## 🛠️ Technology Stack

| Area | Technology |
|---|---|
| Cloud | AWS |
| IaC | Terraform |
| Containers | Docker |
| Kubernetes | Amazon EKS |
| Packaging | Helm |
| CI | Jenkins |
| Code Quality | SonarQube |
| Security | Trivy + OWASP Dependency Check |
| Registry | Amazon ECR |
| GitOps CD | Argo CD |
| Progressive Delivery | Argo Rollouts |
| Database | Amazon RDS PostgreSQL |
| Cache | Redis |
| Secrets | AWS Secrets Manager |
| Monitoring | Prometheus + Grafana + Alertmanager |
| Source Control | GitHub |

---

## 📁 Repository Structure

```text
CareGrid-E-Commerce/
│
├── 01-infrastructure-terraform/   # AWS Infrastructure as Code
├── 02-microservices/              # Application microservices
├── 03-ci-cd-pipelines/            # Jenkins DevSecOps CI
├── 04-gitops-manifests/           # Helm + Argo CD + Rollouts
├── 05-observability/              # Prometheus + Grafana + Alerts
├── 06-Testing/                    # Application/platform testing
└── README.md
```

---

## 💰 Production Design vs Lab Cost

The live environment is deliberately smaller to control AWS cost.

| Portfolio / Lab | Production Extension |
|---|---|
| Single NAT Gateway | HA egress/NAT strategy |
| Small EKS capacity | Multi-AZ scalable capacity |
| Spot where appropriate | On-Demand baseline + Spot |
| Small RDS | RDS Multi-AZ + backups |
| Limited replicas | HA replicas + autoscaling |
| Single environment | Isolated dev/staging/prod |

This allows the project to demonstrate **production engineering patterns without requiring production-scale AWS spending**.

---

## ⚠️ Implementation Status

CareGrid is being implemented incrementally.

Architecture documentation may represent the **target state**. A component is considered implemented only when its configuration exists in the repository and has been successfully validated.

---

## 👨‍💻 Author

**Raj More — DevOps Engineer**

AWS • Kubernetes • Terraform • Docker • Jenkins • GitOps • CI/CD • DevSecOps
