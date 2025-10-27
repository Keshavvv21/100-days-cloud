# ☸️ Kube GitOps — Sync Policy, Auto Rollback & Notifications

### 📘 Overview

This project demonstrates a **GitOps workflow** for Kubernetes clusters using **ArgoCD**, focusing on:

* **Declarative deployments** synced from Git
* **Automated rollback** on failed deployments
* **Real-time notifications** via Slack / Email / Webhook

The goal is to ensure **continuous delivery** with **self-healing**, **auditability**, and **zero manual drift** between Git and cluster state.

---

## 🧭 Core Features

| Feature                | Description                                                                    |
| ---------------------- | ------------------------------------------------------------------------------ |
| **GitOps Sync Policy** | Automatically applies changes from Git to the cluster.                         |
| **Auto Rollback**      | Reverts to last healthy version if a sync or rollout fails.                    |
| **Notifications**      | Sends status alerts (Success, Failure, Rollback) via Slack, Email, or Webhook. |
| **Declarative Config** | All manifests and policies are stored in Git.                                  |
| **Observability**      | Integrates with ArgoCD UI, Prometheus, and Grafana dashboards.                 |

---

## 🏗️ Architecture Flow

```mermaid
flowchart TD

A[Developer Commit to Git Repo] --> B[Git Repository (Manifests, Helm Charts)]
B --> C[ArgoCD Controller Watches Git]
C --> D[Kubernetes Cluster]
D --> E[Application Pods & Services]

C -->|Sync Policy| D
D -->|Health Check Failed| F[Auto Rollback]
C -->|Status Events| G[Notifications System (Slack / Email / Webhook)]

subgraph GitOps Flow
A --> B --> C --> D
end
```

---

## ⚙️ Tech Stack

* **Kubernetes** – Orchestration platform
* **ArgoCD** – GitOps controller
* **Helm / Kustomize** – Manifest templating
* **Prometheus / Grafana** – Monitoring and metrics
* **Slack Webhook** – Notifications
* **GitHub / GitLab** – Source of Truth

---

## 🧩 Setup Steps

### 1️⃣ Prerequisites

* Kubernetes cluster (Minikube, EKS, GKE, or AKS)
* `kubectl` and `argocd` CLI installed
* Git repo containing your Kubernetes manifests

---

### 2️⃣ Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f \
  https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Access UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

👉 Visit [https://localhost:8080](https://localhost:8080)

---

### 3️⃣ Connect ArgoCD to Git Repo

```bash
argocd repo add https://github.com/<your-org>/<your-repo>.git
```

Create Application:

```bash
argocd app create my-app \
  --repo https://github.com/<your-org>/<your-repo>.git \
  --path manifests \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default
```

---

### 4️⃣ Enable Auto-Sync & Rollback

```yaml
spec:
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
      allowEmpty: false
    retry:
      limit: 3
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 2m
```

This ensures:

* **Auto-Sync** on every Git commit
* **Rollback** to last successful revision if sync fails

---

### 5️⃣ Configure Notifications

Install ArgoCD Notifications:

```bash
kubectl apply -n argocd -f \
  https://raw.githubusercontent.com/argoproj-labs/argocd-notifications/master/manifests/install.yaml
```

Example Slack Config (`argocd-notifications-cm`):

```yaml
context:
  slackToken: $SLACK_BOT_TOKEN

subscriptions:
- recipients:
  - slack:#devops-alerts
  triggers:
  - on-sync-failed
  - on-sync-succeeded
```

---

## 🧠 Workflow Summary

1. Developer commits code → Git updated
2. ArgoCD detects the change → triggers Sync
3. Deployment applied → health check performed
4. If failure → rollback auto-triggered
5. Notification sent → Slack/Webhook update

---

## 🔗 Reference Links

* [ArgoCD Official Docs](https://argo-cd.readthedocs.io/en/stable/)
* [Argo Rollouts](https://argoproj.github.io/argo-rollouts/)
* [ArgoCD Notifications](https://argocd-notifications.readthedocs.io/en/stable/)
* [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)
* [GitOps Principles](https://www.weave.works/technologies/gitops/)

---

## 🚀 Next Steps

* Integrate **Argo Rollouts** for canary or blue-green deploys
* Add **Prometheus alerts** for rollback triggers
* Implement **SOPS / Sealed Secrets** for secure credentials

---

## 🧩 Folder Structure

```
kube-gitops/
├── manifests/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
├── argocd/
│   ├── app.yaml
│   └── notifications.yaml
├── README.md
└── .github/workflows/ci-cd.yaml
```

---

## 🧘 Summary

This setup brings together the essence of **GitOps automation**:

* **Git = Source of Truth**
* **Kubernetes = Runtime environment**
* **ArgoCD = Bridge**
* **Notifications = Observability layer**

