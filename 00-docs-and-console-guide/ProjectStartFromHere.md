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
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
  sudo apt update && sudo apt install -y unzip
  curl -fsSL https://awscli.amazonaws.com/v2/install.sh | sudo bash -s -- --system
  aws --version
  
* **Terraform:** This is the primary Infrastructure as Code (IaC) tool used to provision and automate the entire cloud infrastructure, including the EKS cluster, VPC, and worker nodes.
https://developer.hashicorp.com/terraform/install
sudo apt update && sudo apt install -y wget gpg
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
terraform -version

* **Docker & Docker Compose:** This tool is vital for building container images for your microservices and for locally testing the containerization setup.

### DevSecOps & Kubernetes Orchestration (Pipeline Prerequisites):

* **Java (OpenJDK):** Jenkins has a core dependency on Java; it cannot run without it.
* **SonarQube (as Container):** This is for implementing static code analysis, maintaining code quality, and enforcing secure coding standards in your application code.
* **Trivy:** This is a standard prerequisite tool for dynamically scanning container images and repositories to detect CVE (Common Vulnerabilities and Exposures).
* **Helm & kubectl:** These are essential tools for Kubernetes orchestration. Use Helm to manage Kubernetes charts and `kubectl` for direct cluster configuration and debugging from the command line.
