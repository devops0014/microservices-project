# Microservices Deployment to Amazon EKS using Jenkins

This project deploys Kubernetes resources to an **Amazon EKS** cluster through a **Jenkins Pipeline**.

---

## Deployment Flow

```text
Git Branch -> Jenkins Pipeline -> kubectl apply -> Amazon EKS (namespace: webapps)
```

---

## What This Repository Contains

- `Jenkinsfile` - Jenkins pipeline for deployment and verification.
- `deployment-service.yml` - Kubernetes Deployment/Service manifest applied to EKS.

---

## Prerequisites

Before running deployment, make sure the following are ready:

1. **AWS / EKS**
   - EKS cluster is created and accessible.
   - API server endpoint is reachable from Jenkins.
2. **Jenkins**
   - Jenkins server is running.
   - Kubernetes CLI (`kubectl`) is installed on Jenkins agent.
   - Required Jenkins plugin is installed for `withKubeCredentials`.
3. **Kubernetes Access**
   - Jenkins credential exists with ID: `k8-token`.
   - Target namespace exists: `webapps`.
4. **Repository**
   - `deployment-service.yml` is present and valid.
   - `Jenkinsfile` is in repository root.

---

## Jenkins Pipeline Stages in This Project

The current pipeline has two deployment stages:

### 1) Deploy to Kubernetes

- Uses `withKubeCredentials` to authenticate to EKS.
- Runs:

```bash
kubectl apply -f deployment-service.yml
```

### 2) Verify Deployment

- Validates service visibility in namespace `webapps`.
- Runs:

```bash
kubectl get svc -n webapps
```

---

## Jenkins Job Setup (Recommended)

### Option A: Pipeline Job

1. Create a **Pipeline** job in Jenkins.
2. Connect your Git repository.
3. Set pipeline source to **Pipeline script from SCM**.
4. Keep script path as `Jenkinsfile`.
5. Save and run **Build Now**.

### Option B: Multibranch Pipeline (Best for Multiple Branches)

If you work with multiple branches, use a **Multibranch Pipeline**:

1. Create **Multibranch Pipeline** job.
2. Configure Git repository URL and credentials.
3. Add branch discovery behavior.
4. Set build triggers (webhook or periodic scan).
5. Jenkins automatically builds branches that contain a `Jenkinsfile`.

---

## How to Deploy (Step-by-Step)

1. Push latest code to your target branch.
2. Open Jenkins job for that branch.
3. Run pipeline build.
4. Wait for:
   - `Deploy To Kubernetes` stage success
   - `verify Deployment` stage success
5. Confirm resources in cluster:

```bash
kubectl get pods -n webapps
kubectl get svc -n webapps
```

---

## Troubleshooting

- **Credential error (`k8-token`)**
  - Recheck Jenkins credential ID and token validity.
- **Namespace not found**
  - Create namespace:
    ```bash
    kubectl create namespace webapps
    ```
- **Cannot connect to EKS API server**
  - Verify EKS endpoint/network access from Jenkins.
- **Manifest apply failed**
  - Validate YAML syntax:
    ```bash
    kubectl apply --dry-run=client -f deployment-service.yml
    ```

---

## Good Practices for Multi-Branch Deployments

- Use separate environments per branch (`dev`, `qa`, `prod`).
- Keep branch naming consistent (`feature/*`, `release/*`, `main`).
- Add approvals for production branch deployments.
- Version container images with branch + commit SHA.

---

## Next Improvements (Optional)

- Add build and test stages before deployment.
- Add Docker image build/push stage (ECR).
- Add Helm/Kustomize for environment-specific configuration.
- Add Slack/Email notifications for pipeline status.

