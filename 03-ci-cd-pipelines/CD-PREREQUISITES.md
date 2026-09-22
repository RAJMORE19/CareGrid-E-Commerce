# CareGrid CD Pipeline - Prerequisites & Architecture

## Overview
This Continuous Deployment (CD) pipeline operates on GitOps principles:
Jenkins CD job updates the image version inside Kubernetes manifests (`04-gitops-manifests/02-microservices/apps.yaml`) and commits back to GitHub. ArgoCD continuously monitors this Git repository and triggers rolling updates to the AWS EKS cluster without manual intervention.

---

## Prerequisites Setup

### 1. GitHub Personal Access Token (PAT)
- GitHub Settings -> Developer Settings -> Personal access tokens (Classic or Fine-grained).
- Required Permissions:
  - `repo` (Full control of private repositories / public write access).

### 2. Jenkins Global Credentials
- Jenkins Dashboard -> **Manage Jenkins** -> **Credentials** -> **System** -> **Global credentials (unrestricted)**.
- Click **+ Add Credentials**:
  - **Kind:** `Username with password`
  - **Username:** `RAJMORE19`
  - **Password:** `<GitHub Personal Access Token>`
  - **ID:** `github-credentials` (Strict requirement for Jenkinsfile reference)

### 3. Jenkins Plugins Required
- Pipeline (`workflow-aggregator`)
- Git plugin
- Credentials Binding Plugin
- Workspace Cleanup Plugin (`ws-cleanup`)

### 4. GitOps Manifest Reference
- Target File: `04-gitops-manifests/02-microservices/apps.yaml`
- Service Target: `caregrid-booking-service` container image tag.

---

## Execution Flow
1. **Workspace cleanup:** Deletes previous workspace artifacts.
2. **Git Checkout:** Pulls target repo `main` branch.
3. **Verify Tag:** Validates build parameter `DOCKER_IMAGE_TAG`.
4. **Update Manifest:** Uses atomic sed replacement and pushes authenticated commit using GitHub Token.
5. **ArgoCD Sync:** ArgoCD detects commit diff and applies zero-downtime rolling update on EKS.
