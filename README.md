<img width="1535" height="1024" alt="CareGrid-E-Commerce" src="https://github.com/user-attachments/assets/9a6487fe-3a38-449f-a2a6-47e0f3db7b78" />

# CAREGRID-E-COMMERCE

## Production-Grade • Cloud-Native • Secure • Scalable

# 10-SECOND PROJECT OVERVIEW

**GitHub → Jenkins → SonarQube + Trivy → Docker Build → ECR → GitOps Repository → ArgoCD → EKS → CareGrid Microservices**

**Terraform** provisions the AWS infrastructure.

**Jenkins** performs CI, code-quality checks, security scans, Docker image builds, and pushes images to **Amazon ECR**.

**ArgoCD** monitors the **GitOps repository** and deploys the required application version to **Amazon EKS**.

**EKS** runs the CareGrid microservices.

**User Traffic:** **Route 53 → CloudFront/WAF → ALB → EKS Private Worker Nodes → Microservices**

The detailed implementation of each component will be covered separately in dedicated folders such as **Terraform**, **Jenkins**, **Kubernetes**, **ArgoCD**, and other project folders.

---

# STEP 1 — EC2 MASTER SERVER SETUP

## EC2 Master Server Specifications

### CI/CD & DevSecOps

**Name:** CareGrid-E-Commerce

**Instance Family:** General Purpose (Burstable)

**Instance Type:** **t3.large (Minimum Required)**

**Compute:** **2 vCPUs**

**Memory:** **8 GiB RAM**

**Note:** This specification is required to simultaneously run the **Jenkins Master server** and the **SonarQube container** without memory exhaustion.

**Storage (EBS):** **50 GiB gp3**

**Note:** This provides sufficient space for:

* Operating system
* Jenkins home directory
* Local Docker image cache
* SonarQube data

**Networking:** **Public IPv4 enabled (Auto-assign)**

---

# STEP 1.1 — INSTALL REQUIRED TOOLS

To begin the project, install the following tools on the **Jenkins Master EC2 server**.

## Installation Order

1. **AWS CLI v2**
2. **Terraform**
3. **Docker & Docker Compose**
4. **Java**
5. **Jenkins**
6. **SonarQube**
7. **Trivy**
8. **kubectl**
9. **Helm**

---

## 1. AWS CLI v2

**AWS CLI v2** is essential for:

* Setting up the EKS cluster
* Managing permissions
* Creating artifacts within the CI/CD pipeline

Documentation:

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

```bash
sudo apt update && sudo apt install -y unzip
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | sudo bash -s -- --system
aws --version
```

---

## 2. Terraform

**Terraform** is the primary Infrastructure as Code (IaC) tool used to provision and automate the entire cloud infrastructure, including:

* EKS cluster
* VPC
* Worker nodes

Documentation:

https://developer.hashicorp.com/terraform/install

```bash
sudo apt update && sudo apt install -y wget gpg
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
terraform -version
```

---

## 3. Docker & Docker Compose

**Docker & Docker Compose** are used for:

* Building container images for microservices
* Locally testing the containerization setup

Documentation:

https://docs.docker.com/engine/install/ubuntu/

```bash
curl -fsSL https://get.docker.com | sudo sh && sudo usermod -aG docker $USER
newgrp docker
docker --version && docker compose version
```

---

# STEP 1.2 — DEVSECOPS & KUBERNETES ORCHESTRATION

## 4. Java — Jenkins Prerequisite

Java is required as a prerequisite for **Jenkins**.

```bash
sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version
```

---

## 5. Jenkins

**Jenkins** is the core CI/CD orchestration engine used to run:

* Build
* Security scans
* GitOps sync trigger

Documentation:

https://www.jenkins.io/doc/book/installing/linux/

### Install Jenkins

```bash
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install jenkins
```

Now, access **Jenkins Master on the browser on port 8080** and configure it.

---

## 6. SonarQube

**SonarQube** runs as a container and is used for code quality scanning.

```bash
sudo sysctl -w vm.max_map_count=262144

docker run -d --name sonarqube-server -p 9000:9000 sonarqube:lts-community
```

---

## 7. Trivy

**Trivy** is used for security scanning of:

* Images
* Dependencies

```bash
sudo apt-get install wget apt-transport-https gnupg lsb-release -y

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -

echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list

sudo apt-get update -y

sudo apt-get install trivy -y
```

---

## 8. kubectl

**kubectl** is used to interact with Kubernetes.

```bash
sudo mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update

sudo apt install -y kubectl
```

---

## 9. Helm

**Helm** is the package manager for Kubernetes and is used to deploy:

* Charts
* Ingress controllers
* Monitoring stacks
* ArgoCD resources

```bash
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm version
```

---

# STEP 2 — TERRAFORM INFRASTRUCTURE PROVISIONING

Terraform creates **Box 3 — AWS Cloud Fabric**.

## Custom VPC

* **Public Subnets** — Load Balancer
* **Private Subnets** — EKS Nodes and Databases

## EKS Cluster

* **AWS-managed Control Plane**
* **HA mode**
* **Managed Node Groups**
* **2 × t3.medium worker nodes**
* **Multi-AZ private subnets**

## Data Fabric

* **RDS PostgreSQL**
* **ElastiCache Redis**
* **S3**

## Networking & Security

* **IAM Roles**
* **Security Groups**
* **EKS OIDC Provider**

The detailed Terraform implementation will be maintained separately in the **Terraform folder**.

---

# STEP 3 — AMAZON ECR

**Amazon ECR** is the container image registry.

Jenkins builds the microservice Docker images and pushes them to **ECR**.

**Jenkins → Docker Build → Security Scan → ECR**

---

# STEP 4 — JENKINS CI PIPELINE

Jenkins handles **CI — Build & Security Scan**.

Pipeline flow:

**GitHub → Code Checkout → SonarQube → Docker Build → Trivy Scan → ECR**

Jenkins then updates the **GitOps repository** with the new:

* **Helm values**
* **Image tag**

---

# STEP 5 — GITOPS REPOSITORY

The **GitOps repository** contains the desired Kubernetes deployment configuration.

It contains the required:

* **Helm**
* **Manifests**
* **Image tags**

Jenkins updates the required image tag after a successful CI pipeline.

---

# STEP 6 — ARGOCD

**ArgoCD** is installed inside the **EKS cluster**.

ArgoCD monitors the **GitOps repository**.

Jenkins does **not** directly run `kubectl apply` for application deployment.

Deployment flow:

**Jenkins → GitOps Repository → ArgoCD → EKS**

When Jenkins updates the image tag, **ArgoCD detects the change and rolls out the new application version** on the EKS worker nodes.

The detailed ArgoCD implementation will be maintained separately in the **ArgoCD folder**.

---

# STEP 7 — EKS MICROSERVICES DEPLOYMENT

The EKS worker nodes run the CareGrid microservices:

* **Auth**
* **Catalog**
* **Cart**
* **Booking**
* **Payment**
* **Notification**

The microservices consume the required AWS data services such as:

* **RDS PostgreSQL**
* **ElastiCache Redis**
* **S3**

---

# STEP 8 — APPLICATION TRAFFIC FLOW

User requests follow this flow:

**User → Route 53 → CloudFront / WAF → Application Load Balancer (ALB) → EKS Private Worker Nodes → CareGrid Microservices**

---

# COMPLETE PROJECT FLOW

```text
                         GITHUB
                           |
                           v
                       JENKINS
                           |
              +------------+------------+
              |                         |
              v                         v
          SONARQUBE                   TRIVY
        Code Quality              Security Scan
              |                         |
              +------------+------------+
                           |
                           v
                    DOCKER BUILD
                           |
                           v
                         ECR
                           |
                           v
                  GITOPS REPOSITORY
                           |
                           v
                        ARGOCD
                           |
                           v
                         EKS
                           |
        +----------+-------+-------+----------+
        |          |       |       |          |
       AUTH     CATALOG   CART   BOOKING   PAYMENT
                                             |
                                      NOTIFICATION
                           |
                           v
                  RDS / REDIS / S3
```

## Infrastructure Flow

```text
                      TERRAFORM
                          |
                          v
                         AWS
                          |
          +---------------+---------------+
          |               |               |
         VPC             EKS             DATA
          |               |               |
     Subnets        Node Groups      RDS / Redis / S3
          |
   IAM / Security Groups
   / OIDC Provider
```

## User Traffic Flow

```text
USER
  |
  v
ROUTE 53
  |
  v
CLOUDFRONT / WAF
  |
  v
ALB
  |
  v
EKS PRIVATE WORKER NODES
  |
  v
CAREGRID MICROSERVICES
```

