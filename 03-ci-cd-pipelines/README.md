# CI/CD IMPLEMENTATION

## 1. CI (Continuous Integration) Pipeline Setup

### Trigger & Build (Tier A)

* **Developer ke GitHub repo me push karte hi Jenkins ya GitHub Actions pipeline trigger hoga aur Docker build run karega.**

### Security & Quality Scan (Tier B)

* Code quality ke liye **SonarQube**
* Vulnerabilities ke liye **Trivy**
* Dependency scanning ke liye **OWASP Dependency Check**

### Artifact Push (Tier C)

* Scans pass hote hi **SBOM generate** hoga.
* Docker image **version tag** ke sath **AWS ECR** me push hogi.

---

## 2. CD (Continuous Delivery via GitOps) Setup

### GitOps Repo

* **Kubernetes manifests ya Helm charts ko ek alag Git repository me maintain karna hoga.**

### Argo CD Deployment

* EKS cluster ke andar **Argo CD** aur **Argo CD Image Updater** deploy karna hoga.

### Automated Sync & Rollout

* Jaise hi **ECR me nayi image aayegi**, **Argo CD Image Updater** manifests ko update karega.
* **Argo CD** changes ko pull karega.
* **Argo Rollouts (Blue/Green)** ke through **zero-downtime microservices deployment** hoga.
