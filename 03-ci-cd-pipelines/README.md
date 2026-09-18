<img width="1672" height="940" alt="CICD" src="https://github.com/user-attachments/assets/310ec4c0-d171-4265-b642-6bca647deddc" />


# CI/CD IMPLEMENTATION

## 1. CI (Continuous Integration) Pipeline Setup

### Trigger & Build (Tier A)

* **As soon as the developer pushes code to the GitHub repository, the Jenkins or GitHub Actions pipeline will be triggered and the Docker build will run.**

### Security & Quality Scan (Tier B)

* **SonarQube** for code quality
* **Trivy** for vulnerability scanning
* **OWASP Dependency Check** for dependency scanning

### Artifact Push (Tier C)

* After all scans pass, an **SBOM will be generated**.
* The Docker image will be pushed to **AWS ECR** with a **version tag**.

---

## 2. CD (Continuous Delivery via GitOps) Setup

### GitOps Repo

* **Kubernetes manifests or Helm charts will be maintained in a separate Git repository.**

### Argo CD Deployment

* **Argo CD** and **Argo CD Image Updater** will be deployed inside the **EKS cluster**.

### Automated Sync & Rollout

* As soon as a **new image is available in ECR**, **Argo CD Image Updater** will update the manifests.
* **Argo CD** will pull the changes.
* **Argo Rollouts (Blue/Green)** will deploy the microservices with **zero downtime**.
