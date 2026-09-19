FOR CI PREREQUISITES
---

# CareGrid DevSecOps CI Setup & Troubleshooting Runbook

This guide covers all pre-requisites, permissions, IAM roles, security configurations, and troubleshooting fixes required to run the enterprise CI pipeline successfully.

---

### Step 1: Jenkins Plugins Installation

Navigate to **Jenkins Dashboard** -> **Manage Jenkins** -> **Plugins** -> **Available plugins** and install:

* **Docker Pipeline** (enables Docker commands inside Jenkinsfile steps)
* **Pipeline: Stage View** (provides UI execution tracking across stages)
* **Workspace Cleanup Plugin** (required for automated `cleanWs()` cleanup)

Restart Jenkins if prompted after installation.

---

### Step 2: Docker Socket & Jenkins Host Permissions

Fixes daemon connection and permission denied errors when Jenkins executes container commands.

SSH into your **Jenkins EC2 Host** and run:

```bash
# 1. Add jenkins user to docker group
sudo usermod -aG docker jenkins

# 2. Set strict permissions on docker daemon socket
sudo chown root:docker /var/run/docker.sock
sudo chmod 660 /var/run/docker.sock

# 3. Restart Docker and Jenkins to apply group changes
sudo systemctl restart docker
sudo systemctl restart jenkins

# 4. Verify jenkins user can run docker without sudo
sudo su - jenkins -s /bin/bash -c "docker ps"

```

---

### Step 3: AWS IAM Role Setup (Instance Profile)

Eliminates static AWS access keys by granting the EC2 instance direct permissions to authenticate against AWS services.

1. Go to **AWS Console** -> **IAM** -> **Roles** -> **Create role**.
2. **Trusted entity type:** Select **AWS service** -> **Use case:** Choose **EC2**.
3. **Attach Permission Policies:**
* **`AmazonEC2ContainerRegistryPowerUser`** (allows ECR authentication, token generation, push, and pull)
* **`AmazonECS_FullAccess`** (allows updating container service deployments)


4. **Role Name:** Name it **`Jenkins-ECR-ECS-Role`** and save.
5. **Attach Role to EC2:**
* Go to **EC2 Dashboard** -> select your Jenkins instance.
* Click **Actions** -> **Security** -> **Modify IAM role**.
* Select **`Jenkins-ECR-ECS-Role`** and click **Update IAM role**.



---

### Step 4: SonarQube Server Setup (SAST Engine)

Runs SonarQube as a persistent service on the EC2 host.

```bash
# 1. Start SonarQube LTS container
docker run -d --name sonarqube-server -p 9000:9000 -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true sonarqube:lts-community

# 2. Verify container health
docker ps | grep sonarqube-server

```

* **AWS Security Group Requirement:** Add Inbound Rule allowing **Custom TCP Port 9000** for your IP or VPC CIDR.
* **Dashboard Access:** Open `http://<YOUR_EC2_STATIC_IP>:9000` (Default: **`admin`** / **`admin`**). Update to a secure password on initial login.

---

### Step 5: SonarQube Token Generation & Jenkins Credential Mapping

Enables Jenkins to authenticate against SonarQube scans without exposing credentials.

#### 1. Generate Token in SonarQube

1. In SonarQube UI, click your **User Profile Icon (Top Right)** -> **My Account** -> **Security** tab.
2. Under **Generate Token**:
* **Name:** `jenkins-token`
* **Type:** `User Token`
* **Expires in:** `No expiration` (or 30 days based on policy)


3. Click **Generate** and **Copy the token value immediately**.

#### 2. Store in Jenkins Credentials

1. Go to **Jenkins Dashboard** -> **Manage Jenkins** -> **Credentials** -> **System** -> **Global credentials (unrestricted)**.
2. Click **+ Add Credentials** and configure:
* **Kind:** `Secret text`
* **Scope:** `Global`
* **Secret:** *(Paste the copied SonarQube token)*
* **ID:** **`sonar-token`** *(Must match the variable defined in Jenkinsfile)*
* **Description:** `SonarQube User Token`


3. Click **Create**.

---

### Step 6: AWS Target Infrastructure Verification

Ensure these cloud resources exist in AWS prior to triggering builds:

* **ECR Repository:** **`caregrid/booking-service`** (Region: **`ap-south-1`**, Account ID: **`466124992944`**)
* **ECS Cluster:** **`caregrid-cluster`**
* **ECS Service:** **`booking-service`**

---

### Step 7: Critical Troubleshooting Fixes Applied

* **EC2 Memory Sizing:** Upgraded from `t3.large` (8GB RAM) to **`t3.xlarge` (16GB RAM)** to prevent out-of-memory (OOM) kernel crashes when running Jenkins, SonarQube, and container scans concurrently.
* **SCA Scan Optimization:** Replaced slow unauthenticated OWASP Dependency-Check (which hangs due to NVD API rate-limiting) with native **`pip-audit`** to scan `requirements.txt` instantly without external API throttling.
* **SonarQube Property Alignment:** Used **`-Dsonar.login`** instead of `-Dsonar.token` for compatibility with SonarQube 9.9 LTS Community Edition.

  ====================================================================================================================================================================================================================
