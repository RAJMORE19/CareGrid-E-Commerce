---

# CareGrid CI/CD Pipeline Prerequisites

CI pipeline trigger karne se pehle ye configurations complete hona **compulsory** hai:

---

### 1. Jenkins Required Plugins

Jenkins Dashboard -> **Manage Jenkins** -> **Plugins** -> **Available plugins** me jakar ye plugins install karein:

* **Docker Pipeline** (Jenkinsfile me docker syntax aur build support ke liye)
* **Pipeline: Stage View** (Pipeline execution ko visually track karne ke liye)
* **Workspace Cleanup Plugin** (`cleanWs()` step ke liye)

---

### 2. Jenkins Server / Docker Permissions (EC2 Host)

Jenkins server par **SSH** karke ye commands run karein:

```bash
# 1. Jenkins user ko docker group me add karein
sudo usermod -aG docker jenkins

# 2. Docker socket permissions verify karein
sudo chown root:docker /var/run/docker.sock
sudo chmod 660 /var/run/docker.sock

# 3. Services restart karein
sudo systemctl restart docker
sudo systemctl restart jenkins

# 4. Verify karein ki bina sudo docker chal raha hai
sudo su - jenkins -s /bin/bash -c "docker ps"

```

---

### 3. AWS IAM Role (Instance Profile)

Jenkins EC2 instance par bina static keys ke AWS access dene ke liye **IAM Role** attach karein:

1. **IAM -> Roles -> Create role**:
* **Trusted entity:** AWS service
* **Use case:** EC2


2. **Attach Policies:**
* **`AmazonEC2ContainerRegistryPowerUser`** (ECR login, image push aur pull ke liye)
* **`AmazonECS_FullAccess`** (ECS service deployment update ke liye)


3. **Role Name:** **`Jenkins-ECS-CI-Role`**
4. **Attach to Jenkins EC2:**
* EC2 Dashboard -> Select Jenkins Instance -> **Actions** -> **Security** -> **Modify IAM role**
* **`Jenkins-ECS-CI-Role`** choose karke **Update IAM role** karein.



---

### 4. AWS Cloud Infrastructure Pre-requisites

Pipeline run hone se pehle AWS console me ye resources **already exist** hone chahiye:

* **ECR Repository:** **`caregrid/booking-service`** (Region: **`ap-south-1`**)
* **ECS Cluster:** **`caregrid-cluster`**
* **ECS Service:** **`booking-service`**
