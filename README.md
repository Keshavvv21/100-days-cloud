## ☁️ **122 Days Cloud + DevOps Challenge (15–30 Minutes a Day)**

### 🧩 **Structure**

| Phase   | Days    | Focus                                      |
| ------- | ------- | ------------------------------------------ |
| Phase 1 | 1–20    | Linux + Networking + Bash                  |
| Phase 2 | 21–40   | Docker + Containers                        |
| Phase 3 | 41–65   | Kubernetes Deep Dive                       |
| Phase 4 | 66–80   | AWS Core Services                          |
| Phase 5 | 81–95   | Infrastructure as Code (Terraform + CI/CD) |
| Phase 6 | 96–105  | Go for Cloud Engineering                   |
| Phase 7 | 106–115 | Read Scale + Observability                 |
| Phase 8 | 116–122 | Blog Writing + Real-World Scenarios        |

---

## 🛠️ **Phase 1: Linux + Networking + Bash (Days 1–20)**

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

## 🐳 **Phase 2: Docker + Containers (Days 21–40)**

| Day | Task                                        |
| --- | ------------------------------------------- |
| 21  | Install Docker & Hello World                |
| 22  | Build Custom Image from Dockerfile          |
| 23  | Understand Docker Volumes                   |
| 24  | Multi-Stage Builds                          |
| 25  | Docker Compose: Multi-container App         |
| 26  | Networking in Docker                        |
| 27  | Docker Healthchecks                         |
| 28  | Image Tagging and Publishing to DockerHub   |
| 29  | Debugging Containers (exec, logs, inspect)  |
| 30  | Alpine vs Ubuntu Base Images                |
| 31  | Create a Node.js Containerized App          |
| 32  | Containerize a Python Script                |
| 33  | Implement Docker Swarm (intro only)         |
| 34  | Dockerize Nginx Reverse Proxy               |
| 35  | Create a CI/CD-ready Dockerfile             |
| 36  | Secure Containers (rootless, non-root user) |
| 37  | Docker Secrets                              |
| 38  | Run Redis + Postgres with Compose           |
| 39  | Troubleshoot Docker Volume Issues           |
| 40  | Blog: How Docker Simplifies DevOps          |

---

## ☸️ **Phase 3: Kubernetes (Days 41–65)**

| Day | Task                                                 |
| --- | ---------------------------------------------------- |
| 41  | Kubernetes Architecture (kube-apiserver, etcd, etc.) |
| 42  | Minikube Setup                                       |
| 43  | Deploy First Pod (YAML)                              |
| 44  | Services: ClusterIP vs NodePort                      |
| 45  | Deployments + Rollouts                               |
| 46  | ConfigMaps + Secrets                                 |
| 47  | Health Probes: Liveness & Readiness                  |
| 48  | Horizontal Pod Autoscaler                            |
| 49  | Create a StatefulSet (e.g., MongoDB)                 |
| 50  | PersistentVolume (PV) + PersistentVolumeClaim (PVC)  |
| 51  | StorageClass Basics                                  |
| 52  | Network Policies                                     |
| 53  | Use Helm to Deploy Redis                             |
| 54  | RBAC in Kubernetes                                   |
| 55  | Custom Resource Definitions (CRDs)                   |
| 56  | Pod Affinity / Taints & Tolerations                  |
| 57  | Kube Proxy & CNI Deep Dive                           |
| 58  | Install Metrics Server + View Resource Usage         |
| 59  | Troubleshoot CrashLoopBackOff                        |
| 60  | CI/CD: Auto Deploy to Minikube                       |
| 61  | Blog: Kubernetes PVC & StatefulSets Explained        |
| 62  | K8s Upgrade Process                                  |
| 63  | Create & Mount EBS Volume in EKS                     |
| 64  | PodDisruptionBudget                                  |
| 65  | Blog: K8s Networking Gotchas                         |

---

## ☁️ **Phase 4: AWS Core (Days 66–80)**

| Day | Task                                          |
| --- | --------------------------------------------- |
| 66  | AWS CLI Setup + IAM Users/Roles               |
| 67  | Launch EC2 + SSH into Instance                |
| 68  | Understand S3: Buckets, Lifecycle Rules       |
| 69  | S3 Static Website Hosting                     |
| 70  | Use AWS CloudWatch Alarms                     |
| 71  | Setup RDS + Connect via EC2                   |
| 72  | Create an Auto Scaling Group                  |
| 73  | Launch Load Balancer + Target Group           |
| 74  | Deploy Lambda with API Gateway                |
| 75  | AWS VPC Overview: Subnet, Route Tables        |
| 76  | Create Private/Public Subnets                 |
| 77  | NAT Gateway + Bastion Host                    |
| 78  | AWS SNS + SQS Overview                        |
| 79  | Use AWS CloudFormation to Launch EC2          |
| 80  | Blog: How I Used AWS to Deploy a Scalable App |

---

## ⚙️ **Phase 5: Infrastructure as Code + CI/CD (Days 81–95)**

| Day | Task                                     |
| --- | ---------------------------------------- |
| 81  | Install Terraform + HCL Syntax           |
| 82  | Terraform AWS EC2 Resource               |
| 83  | Manage S3 with Terraform                 |
| 84  | Terraform Variables & Outputs            |
| 85  | Create VPC with Terraform                |
| 86  | Terraform Remote Backend (S3 + DynamoDB) |
| 87  | Use Terragrunt for Environments          |
| 88  | Setup GitHub Actions for Docker Build    |
| 89  | CI/CD with GitHub → DockerHub → EC2      |
| 90  | Build a Terraform Module                 |
| 91  | Terraform with EKS                       |
| 92  | CI Pipeline for Helm Charts              |
| 93  | Secure Terraform Secrets                 |
| 94  | ArgoCD Setup with Kubernetes             |
| 95  | Blog: Terraform vs CloudFormation        |

---

## 🐹 **Phase 6: Go for Cloud Engineers (Days 96–105)**

| Day | Task                                           |
| --- | ---------------------------------------------- |
| 96  | Hello World + Go Modules                       |
| 97  | Build HTTP Server in Go                        |
| 98  | JSON Encode/Decode API                         |
| 99  | Connect to Redis with Go                       |
| 100 | Use Go to Interact with AWS SDK                |
| 101 | Goroutines + Channels                          |
| 102 | Create CLI Tool in Go                          |
| 103 | Implement Custom Logger                        |
| 104 | Containerize Go App                            |
| 105 | Blog: Why Go is Great for Cloud Infrastructure |

---

## 🧪 **Phase 7: Read Scale + Observability (Days 106–115)**

| Day | Task                                      |
| --- | ----------------------------------------- |
| 106 | Difference: Read Scaling vs Write Scaling |
| 107 | Read Replicas with PostgreSQL             |
| 108 | DNS Load Balancing + Route53              |
| 109 | Prometheus Setup + Exporters              |
| 110 | Grafana Dashboards                        |
| 111 | Logs: ELK vs Loki Stack                   |
| 112 | OpenTelemetry Tracing Basics              |
| 113 | Alerting with AlertManager                |
| 114 | Simulate Scale Test with Locust           |
| 115 | Blog: Read-Scale Issues I Faced and Fixed |

---

## ✍️ **Phase 8: Blogging + Real World (Days 116–122)**

| Day | Task                                             |
| --- | ------------------------------------------------ |
| 116 | Write: “How I Built a Scalable Dockerized App”   |
| 117 | Blog: CI/CD in Kubernetes with ArgoCD            |
| 118 | Write: From Terraform Plan to Production         |
| 119 | Blog: Storage Classes in Kubernetes              |
| 120 | Real World: Reproduce K8s Node Crash and Recover |
| 121 | Real World: Container Disk Fill Issue            |
| 122 | Final Blog: My 122-Day Cloud Journey 🚀          |

---

## 📚 Resources

* Kubernetes Docs: [https://kubernetes.io/docs](https://kubernetes.io/docs)
* AWS Docs: [https://docs.aws.amazon.com](https://docs.aws.amazon.com)
* Terraform: [https://developer.hashicorp.com/terraform](https://developer.hashicorp.com/terraform)
* Docker: [https://docs.docker.com](https://docs.docker.com)
* Prometheus & Grafana: [https://prometheus.io](https://prometheus.io)
* Go: [https://go.dev/doc](https://go.dev/doc)

