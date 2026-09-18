<img width="1535" height="1024" alt="CareGrid-E-Commerce" src="https://github.com/user-attachments/assets/9a6487fe-3a38-449f-a2a6-47e0f3db7b78" />

Aapke GitHub repository ke **README.md** ke liye ekdum crisp, structured aur copy-paste ready documentation neeche diya gaya hai:

---

```markdown
# 🛒 CareGrid E-Commerce: Production-Grade DevSecOps & GitOps Pipeline

An enterprise-grade, cloud-native architecture deployed on **AWS EKS** using **Terraform, Jenkins, SonarQube, Trivy, ArgoCD, and Helm**[cite: 1].

---

## 🏛️ Architecture Overview (4 Core Layers)

* **1. Infrastructure as Code (Terraform)**: Provisions Multi-AZ **Custom VPC** (Public & Private subnets), **AWS EKS Cluster**, **2x `t3.medium` Managed Node Groups**, data stores (**RDS PostgreSQL, ElastiCache Redis, S3**), and **IAM (IRSA)**[cite: 1].
* **2. CI & DevSecOps (Jenkins Master)**: Automates **GitHub** triggers, **SonarQube** code quality gates, **Docker** builds, **Trivy** image scans, and artifact pushes to **AWS ECR**[cite: 1].
* **3. GitOps Continuous Delivery (ArgoCD)**: Runs inside **EKS**, syncs declarative **Helm** manifests from Git, detects image changes, and handles **Blue/Green & Canary Rollouts** with zero drift[cite: 1].
* **4. Secure Ingress Flow**: Traffic enters via **Route 53 -> CloudFront/WAF -> ALB -> EKS Private Microservices -> RDS/Redis**[cite: 1].

---

## 💻 Master Node Hardware Specifications

| Component | Specification | Engineering Purpose |
| :--- | :--- | :--- |
| **Instance Name** | `CareGrid-E-Commerce` | CI/CD & DevSecOps Master Node |
| **Instance Type** | `t3.large` (2 vCPU, 8 GiB RAM) | Stable memory for Jenkins JVM + SonarQube Container |
| **Storage (EBS)** | 50 GiB `gp3` | Docker layers, SonarQube indices, Jenkins workspace |
| **Networking** | Public IPv4 Enabled | External Git webhooks & management access |

---

## 🛠️ Step-by-Step Server Setup Guide

Run all steps sequentially on the **Ubuntu 22.04 / 24.04 LTS** Jenkins Master.

### 1. Base Utilities & AWS CLI v2
* Reference: [AWS CLI Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

```bash
sudo apt update && sudo apt install -y unzip curl wget gnupg software-properties-common ca-certificates apt-transport-https
curl -fsSL [https://awscli.amazonaws.com/v2/install.sh](https://awscli.amazonaws.com/v2/install.sh) | sudo bash -s -- --system
aws --version

```

### 2. HashiCorp Terraform

* Reference: [HashiCorp Install](https://developer.hashicorp.com/terraform/install?utm_source=gemini)

```bash
wget -O - [https://apt.releases.hashicorp.com/gpg](https://apt.releases.hashicorp.com/gpg) | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] [https://apt.releases.hashicorp.com](https://apt.releases.hashicorp.com) $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
terraform -version

```

### 3. Docker Engine & Docker Compose

* Reference: [Docker Install](https://docs.docker.com/engine/install/ubuntu/?utm_source=gemini)

```bash
curl -fsSL [https://get.docker.com](https://get.docker.com) | sudo sh
sudo usermod -aG docker $USER
sudo systemctl enable --now docker
newgrp docker
docker --version && docker compose version

```

### 4. OpenJDK 17 & Jenkins

* Reference: [Jenkins Install](https://www.google.com/search?q=https://www.jenkins.io/doc/book/installing/linux/%2523debianubuntu&utm_source=gemini)

```bash
# Install Java 17
sudo apt update && sudo apt install -y openjdk-17-jre

# Add Jenkins Repo & Install
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc [https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key](https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key)
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] [https://pkg.jenkins.io/debian-stable](https://pkg.jenkins.io/debian-stable) binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update && sudo apt install -y jenkins

# Enable Docker access for Jenkins build user
sudo usermod -aG docker jenkins
sudo systemctl enable --now jenkins

```

### 5. SonarQube (Docker Container)

* Reference: [SonarQube Docker Hub](https://www.google.com/search?q=https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/deploy-on-docker/&utm_source=gemini)

```bash
# Allocate virtual memory for Elasticsearch
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf

# Deploy SonarQube LTS
docker run -d --name sonarqube-server -p 9000:9000 -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true --restart always sonarqube:lts-community
docker ps | grep sonarqube

```

### 6. Trivy Security Scanner

* Reference: [Aqua Trivy Guide](https://www.google.com/search?q=https://aquasecurity.github.io/trivy/latest/getting-started/installation/%2523debianubuntu&utm_source=gemini)

```bash
wget -qO - [https://aquasecurity.github.io/trivy-repo/deb/public.key](https://aquasecurity.github.io/trivy-repo/deb/public.key) | sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] [https://aquasecurity.github.io/trivy-repo/deb](https://aquasecurity.github.io/trivy-repo/deb) $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt update && sudo apt install -y trivy
trivy --version

```

### 7. Kubernetes CLI (`kubectl`)

* Reference: [Kubernetes Docs](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/?utm_source=gemini)

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL [https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key](https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key) | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] [https://pkgs.k8s.io/core:/stable:/v1.30/deb/](https://pkgs.k8s.io/core:/stable:/v1.30/deb/) /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update && sudo apt install -y kubectl
kubectl version --client

```

### 8. Helm v3

* Reference: [Helm Docs](https://helm.sh/docs/intro/install/?utm_source=gemini)

```bash
curl -fsSL [https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3](https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3) | bash
helm version

```

---

## 🚀 Execution Roadmap

1. **Configure AWS Identity**: Run `aws configure` on the master server with proper IAM provisioning access.
2. **Terraform Modules**: Write modular code for `vpc`, `security-groups`, and `eks-cluster`.
3. **Provision Infrastructure**: Run `terraform init`, `terraform plan`, and `terraform apply -auto-approve`.
4. **Connect EKS**: Authenticate local CLI using `aws eks update-kubeconfig --region <REGION> --name <CLUSTER_NAME>`.
5. **GitOps Ingestion**: Deploy **ArgoCD** into the cluster and register deployment repositories.

```

---

Ise aap directly copy karke apne GitHub repo ke `README.md` me paste kar sakte hain. Jab aap ready hon, hum Terraform code directory structure aur `vpc.tf` likhna start karenge.

```
