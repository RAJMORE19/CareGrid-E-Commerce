=============================================================================================

EC2 Master Server Specifications (CI/CD & DevSecOps):
**Name** : CareGrid-E-Commerce
**Instance Family:** General Purpose (Burstable)
**Instance Type**: t3.large (Minimum Required)
**Compute**: 2 vCPUs
**Memory**: 8 GiB RAM
**Note**: This specification is required to simultaneously run the Jenkins Master server and the SonarQube container without memory exhaustion.
**Storage (EBS)**: 50 GiB gp3
**Note**: This provides sufficient space for the operating system, Jenkins home directory, local Docker image cache, and SonarQube data.
**Networking**: Public IPv4 enabled (Auto-assign)

=================================================================================================

To begin the project, you must first install these tools on the **Jenkins Master EC2** server:

### Top Priority Base Installations:

* **AWS CLI v2:** This tool is essential for setting up the EKS cluster, managing permissions, and creating artifacts within your CI/CD pipeline.
[https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
```bash
sudo apt update && sudo apt install -y unzip
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | sudo bash -s -- --system
aws --version

```


* **Terraform:** This is the primary Infrastructure as Code (IaC) tool used to provision and automate the entire cloud infrastructure, including the EKS cluster, VPC, and worker nodes.
[https://developer.hashicorp.com/terraform/install](https://developer.hashicorp.com/terraform/install)
```bash
sudo apt update && sudo apt install -y wget gpg
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
terraform -version

```


* **Docker & Docker Compose:** This tool is vital for building container images for your microservices and for locally testing the containerization setup.
[https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)
```bash
curl -fsSL https://get.docker.com | sudo sh && sudo usermod -aG docker $USER
newgrp docker
docker --version && docker compose version

```



### DevSecOps & Kubernetes Orchestration (Pipeline Prerequisites):


```


* **Jenkins:** The core CI/CD orchestration engine to run build, security scans, and trigger GitOps sync.
https://www.jenkins.io/doc/book/installing/linux/

# install java as prerequvist for jenkins 
sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins

```


* **SonarQube (as Container):** This is for implementing static code analysis, maintaining code quality, and enforcing secure coding standards in your application code.
[https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/deploy-on-docker/](https://www.google.com/search?q=https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/deploy-on-docker/)
```bash
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
docker run -d --name sonarqube -p 9000:9000 -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true --restart always sonarqube:lts-community
docker ps | grep sonarqube

```


* **Trivy:** This is a standard prerequisite tool for dynamically scanning container images and repositories to detect CVE (Common Vulnerabilities and Exposures).
[https://aquasecurity.github.io/trivy/latest/getting-started/installation/#debianubuntu](https://www.google.com/search?q=https://aquasecurity.github.io/trivy/latest/getting-started/installation/%23debianubuntu)
```bash
sudo apt install -y wget apt-transport-https gnupg
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt update && sudo apt install -y trivy
trivy --version

```


* **kubectl:** The primary Kubernetes command-line tool required to communicate with and control the AWS EKS cluster.
[https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update && sudo apt install -y kubectl
kubectl version --client

```


* **Helm:** The package manager for Kubernetes to deploy charts, ingress controllers, monitoring stacks, and ArgoCD resources.
[https://helm.sh/docs/intro/install/](https://helm.sh/docs/intro/install/)
```bash
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version

```
