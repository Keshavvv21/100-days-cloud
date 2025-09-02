# ☁️ 140 Days Cloud + DevOps + MLOps Challenge (FAANG & MLOps Ready)

> **Duration:** 15–45 minutes daily
> **Goal:** Master cloud, Kubernetes, DevOps, AWS, GitOps, MLOps, and observability with hands-on labs, blogs, and interview prep.

---

## 🧍‍♂️ Challenge Structure

| Phase   | Days    | Focus                                              |
| ------- | ------- | -------------------------------------------------- |
| Phase 1 | 1–20    | Linux + Networking + Bash                          |
| Phase 2 | 21–40   | Docker + Containers + NGINX                        |
| Phase 3 | 41–75   | Kubernetes + PVCs + Calico + Helm                  |
| Phase 4 | 76–95   | AWS Core Services + EKS + VPC                      |
| Phase 5 | 96–110  | Terraform, Helm, GitOps + ArgoCD                   |
| Phase 6 | 111–125 | Observability, Scaling, Cost, Real-World Debugging |
| Phase 7 | 126–135 | MLOps + SageMaker + ML Pipelines                   |
| Phase 8 | 136–140 | Final Blogs + Interview Readiness                  |

---

## 🛠️ Phase 1: Linux + Networking + Bash (Days 1–20)

| Day | Task                                                  |
| --- | ----------------------------------------------------- |
| 1   | Linux File System & Permissions                       |
| 2   | Common Bash Commands Practice                         |
| 3   | Shell Scripting: Hello World + Variables              |
| 4   | Loops and Functions in Bash                           |
| 5   | Automate File Backup Script                           |
| 6   | Understand TCP/IP, DNS, Ports                         |
| 7   | Netstat, Curl, Ping, Traceroute                       |
| 8   | SSH Key-based Authentication                          |
| 9   | Setup a Local Web Server with `python -m http.server` |
| 10  | Write a health-check bash script                      |
| 11  | Network Namespaces Basics                             |
| 12  | Understand iptables and firewalls                     |
| 13  | rsync for Backup                                      |
| 14  | Cron Jobs: Schedule a cleanup                         |
| 15  | Monitor System Usage (top, ps, vmstat)                |
| 16  | Log Management: journalctl, syslog                    |
| 17  | Linux Process Signals                                 |
| 18  | File Descriptors & Redirects                          |
| 19  | Simulate a Load Test with `ab` or `wrk`               |
| 20  | Blog: What I Learned About Linux Internals            |

---

## 🐳 Phase 2: Docker + Containers + NGINX (Days 21–40)

| Day | Task                                                   |
| --- | ------------------------------------------------------ |
| 21  | Install Docker, Docker CLI Basics                      |
| 22  | Build Custom Dockerfile                                |
| 23  | Docker Daemon, Docker Systemd Unit                     |
| 24  | Docker Volumes + Bind Mounts                           |
| 25  | Multi-Stage Docker Builds                              |
| 26  | Docker Networking Modes (bridge, host, none)           |
| 27  | Docker Compose - Node + Redis Stack                    |
| 28  | Debugging Containers: logs, exec, inspect              |
| 29  | Alpine vs Ubuntu Base Images                           |
| 30  | Docker Health Checks                                   |
| 31  | Node.js App Container                                  |
| 32  | Python Script Container                                |
| 33  | NGINX Reverse Proxy in Docker                          |
| 34  | Dockerize a React App + Serve via NGINX                |
| 35  | Secure Docker Containers (user, seccomp, capabilities) |
| 36  | Docker Secrets & BuildKit                              |
| 37  | Docker Swarm Overview                                  |
| 38  | CI-ready Dockerfile with Metadata Labels               |
| 39  | Docker Registry & Image Tagging  
        add why sodu su is requireed 
        for accessing and creating images                      |
| 40  | Blog: Docker Networking + Daemon Gotchas               |

---

## ☸️ Phase 3: Kubernetes + Advanced (Days 41–75)

| Day | Task                                                |
| --- | --------------------------------------------------- |
| 41  | K8s Architecture: kubelet, etcd, controller-manager |
| 42  | Install: Kind, Minikube or K3d                      |
| 43  | Deploy First Pod + YAML Anatomy                     |
| 44  | Services: ClusterIP, NodePort, LoadBalancer         |
| 45  | Ingress Controller + NGINX + TLS                    |
| 46  | ConfigMaps & Secrets                                |
| 47  | Probes: Liveness, Readiness, Startup                |
| 48  | Deployments, Rollouts, Rollbacks                    |
| 49  | StatefulSets + Headless Service                     |
| 50  | PV, PVC, StorageClass                               |
| 51  | CSI Drivers: AWS EBS, Longhorn, NFS                 |
| 52  | PVC Resize + Retain Policies                        |
| 53  | Taints, Tolerations, Affinity                       |
| 54  | RBAC: Roles, Bindings, SAs                          |
| 55  | Helm Charts + Deploy Redis                          |
| 56  | K8s Network Policies                                |
| 57  | PodDisruptionBudget + Pod Priority                  |
| 58  | Horizontal + Vertical Pod Autoscaler                |
| 59  | Debug CrashLoopBackOff + OOMKilled                  |
| 60  | Metrics Server Setup                                |
| 61  | Canary Deployment via Argo Rollouts                 |
| 62  | Blue-Green vs Rolling Update Strategies             |
| 63  | Custom Resource Definitions (CRDs)                  |
| 64  | Cluster Autoscaler or Karpenter Setup               |
| 65  | Install Calico CNI Plugin (Policy Enforcer)         |
| 66  | K8s Upgrade Plan + Zero Downtime Upgrade            |
| 67  | ExternalDNS + cert-manager                          |
| 68  | IRSA & IAM Roles for K8s on AWS                     |
| 69  | GitOps with ArgoCD: Basics                          |
| 70  | GitOps Sync Policy, Auto Rollback, Notifications    |
| 71  | Multi-Tenant Cluster Design                         |
| 72  | CSI Secret Drivers                                  |
| 73  | Load Testing with k6/Locust                         |
| 74  | TLS Certificates + External Secrets                 |
| 75  | Blog: Kubernetes Networking Debug + Best Practices  |

---

## ☁️ Phase 4: AWS Core + EKS (Days 76–95)

| Day | Task                                        |
| --- | ------------------------------------------- |
| 76  | IAM Users, Groups, Policies                 |
| 77  | Launch EC2 + SSH Key                        |
| 78  | EBS + AMI Snapshots                         |
| 79  | S3 Lifecycle, Glacier, Versioning           |
| 80  | Host Static Site on S3 + CloudFront         |
| 81  | Setup RDS + Connect from EC2                |
| 82  | Create Auto Scaling Group + Launch Template |
| 83  | ALB + Target Group                          |
| 84  | Deploy Lambda + API Gateway                 |
| 85  | VPC, Subnet, Route Tables, NAT Gateway      |
| 86  | CloudWatch Logs, Alarms, Metrics            |
| 87  | SNS, SQS, EventBridge                       |
| 88  | Systems Manager (SSM) & Parameter Store     |
| 89  | EKS Cluster + Worker Nodes                  |
| 90  | EKS + Fargate Deployment                    |
| 91  | EKS Logging + OIDC IAM Integration          |
| 92  | Cost Explorer, Budgets, Trusted Advisor     |
| 93  | Backup + Disaster Recovery                  |
| 94  | Route53 Failover + Health Checks            |
| 95  | Blog: How I Deployed a Scalable App on AWS  |

---

## ⚙️ Phase 5: Terraform + GitOps (Days 96–110)

| Day | Task                                              |
| --- | ------------------------------------------------- |
| 96  | Install Terraform + Providers                     |
| 97  | Define EC2 + S3 + IAM Terraform Modules           |
| 98  | Remote State with S3 + DynamoDB                   |
| 99  | Terraform Variables, Locals, Outputs              |
| 100 | Build VPC using Modules                           |
| 101 | Use Terragrunt for Multi-Environment Setup        |
| 102 | Helm: Install, Template, Upgrade                  |
| 103 | GitHub Actions: Docker Build + Push to ECR        |
| 104 | ArgoCD Install + App Project Setup                |
| 105 | ArgoCD with Helm Charts                           |
| 106 | SOPS + Secrets Encryption                         |
| 107 | ArgoCD Webhooks, Auto Rollback                    |
| 108 | GitOps Anti-Patterns                              |
| 109 | Interview: CI/CD Failure Scenarios                |
| 110 | Blog: Terraform vs CloudFormation + Real Use Case |

---

## 📊 Phase 6: Observability + Real-World Debugging (Days 111–125)

| Day | Task                                                 |
| --- | ---------------------------------------------------- |
| 111 | Prometheus + Node Exporter                           |
| 112 | kube-state-metrics + Grafana Dashboards              |
| 113 | Loki + Promtail for Logs                             |
| 114 | OpenTelemetry Setup + Jaeger Tracing                 |
| 115 | AlertManager + Slack Alerts                          |
| 116 | Horizontal & Vertical Scaling                        |
| 117 | Aurora + RDS + DynamoDB Scaling                      |
| 118 | CPU Throttling, OOMKilled Pod Debug                  |
| 119 | PVC Full, Node Pressure, Eviction Issues             |
| 120 | K8s Node Crash Sim + Draining Strategy               |
| 121 | Cost Optimization Tips (AWS + K8s)                   |
| 122 | Interview: Debugging PVC, DNS, CrashLoopBackOff      |
| 123 | Resource Quotas, Limit Ranges                        |
| 124 | Blog: Real-World Postmortem – What Broke, What Fixed |
| 125 | Interview: Alert Fatigue, Scaling, Dashboard Design  |

---

## 🤖 Phase 7: MLOps Essentials (Days 126–135)

| Day | Task                                              |
| --- | ------------------------------------------------- |
| 126 | Intro to MLOps + Model Lifecycle                  |
| 127 | Build Training Job with SageMaker SDK             |
| 128 | Automate SageMaker Pipelines + Deploy Endpoint    |
| 129 | Register Model + Approve/Reject Workflow          |
| 130 | Lambda for Real-Time Inference                    |
| 131 | Batch Transform Job                               |
| 132 | Monitor Models for Drift & Performance            |
| 133 | MLFlow for Experiment Tracking + Metadata         |
| 134 | KServe Inference with Ingress Routing             |
| 135 | Blog: End-to-End MLOps on AWS with GitHub Actions |

---

## ✍️ Phase 8: Final Blogs + Interview Readiness (Days 136–140)

| Day | Task                                                        |
| --- | ----------------------------------------------------------- |
| 136 | Mock Interview: Infra Design (Multi-AZ, Auto-Scale, GitOps) |
| 137 | Mock Interview: Canary Rollouts, Logs, Metrics              |
| 138 | Final Blog: How This 140-Day Challenge Transformed Me       |
| 139 | Portfolio Upload: GitHub, Dev.to, Medium                    |
| 140 | Celebrate & Share Your Journey 🚀                           |

---

## 📚 Resources

* [Kubernetes Docs](https://kubernetes.io/docs)
* [AWS Docs](https://docs.aws.amazon.com)
* [Terraform Docs](https://developer.hashicorp.com/terraform)
* [ArgoCD](https://argo-cd.readthedocs.io)
* [Longhorn](https://longhorn.io)
* [Calico](https://projectcalico.docs.tigera.io)
* [k6 Load Testing](https://k6.io)
* [SageMaker](https://docs.aws.amazon.com/sagemaker)
* [MLflow](https://mlflow.org)

---

