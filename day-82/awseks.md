# 🚀 AWS EKS Auto Scaling

## Auto Scaling Group (ASG) + Launch Template (LT)

### Production-Ready Architecture & Deep Flow Explanation

---

## 📘 Overview

This README explains **how worker nodes in Amazon EKS scale automatically** using:

* **Launch Templates** – define *how EC2 worker nodes are created*
* **Auto Scaling Groups (ASG)** – control *how many nodes run*
* **Kubernetes Cluster Autoscaler** – decides *when to scale*
* **AWS APIs** – perform the actual scale up/down

This setup ensures:

* High availability
* Cost efficiency
* Self-healing infrastructure
* Seamless pod scheduling

---

## 🧱 Core Components

| Component              | Responsibility                                  |
| ---------------------- | ----------------------------------------------- |
| **EKS Control Plane**  | Manages Kubernetes API, scheduling decisions    |
| **Launch Template**    | EC2 config (AMI, instance type, IAM, bootstrap) |
| **Auto Scaling Group** | Maintains desired number of worker nodes        |
| **Cluster Autoscaler** | Watches pending pods & unused nodes             |
| **EC2 Nodes**          | Join EKS cluster and run workloads              |
| **AWS CloudWatch**     | Metrics & scaling signals                       |

---

## 🏗️ Architecture (High Level)

```
Developer / CI
     |
     v
kubectl apply / helm
     |
     v
Kubernetes Scheduler
     |
     v
Pending Pods?
     |
     v
Cluster Autoscaler
     |
     v
AWS Auto Scaling Group
     |
     v
Launch Template
     |
     v
New EC2 Worker Node
     |
     v
Node joins EKS cluster
     |
     v
Pods Scheduled & Running
```

---

## 🔁 Detailed Flow Diagram (Step-by-Step)

```
┌───────────────┐
│ Application   │
│ Deployment    │
└───────┬───────┘
        │
        ▼
┌────────────────────┐
│ Kubernetes         │
│ Scheduler          │
└───────┬────────────┘
        │
        │ Pods cannot be scheduled
        ▼
┌────────────────────┐
│ Cluster Autoscaler │
│ (in kube-system)  │
└───────┬────────────┘
        │
        │ Calls AWS APIs
        ▼
┌────────────────────┐
│ Auto Scaling Group │
│ Desired Capacity ↑ │
└───────┬────────────┘
        │
        │ Uses
        ▼
┌────────────────────┐
│ Launch Template    │
│ (AMI, IAM, SG)    │
└───────┬────────────┘
        │
        ▼
┌────────────────────┐
│ EC2 Worker Node    │
│ Boots + Bootstrap  │
└───────┬────────────┘
        │
        ▼
┌────────────────────┐
│ Node joins EKS     │
│ kubelet registers │
└───────┬────────────┘
        │
        ▼
┌────────────────────┐
│ Pods Scheduled     │
│ Application Live   │
└────────────────────┘
```

---

## 🧠 What is a Launch Template?

A **Launch Template** defines *how a worker node is created*.

### Contains:

* AMI ID (EKS-optimized AMI)
* Instance type(s)
* Security Groups
* IAM Instance Profile
* Disk size & type
* User data (bootstrap.sh)
* Spot / On-Demand config

### Why Launch Template (not Launch Config)?

✅ Versioning
✅ Multiple instance types
✅ Spot + On-Demand mixed
✅ Future-proof (required by EKS Managed Node Groups)

---

## 🧠 What is an Auto Scaling Group?

An **ASG** maintains EC2 capacity.

### ASG Controls:

* `minSize`
* `maxSize`
* `desiredCapacity`
* Health checks
* Node replacement
* AZ distribution

ASG **does not understand Kubernetes** — it only manages EC2.

Kubernetes intelligence comes from **Cluster Autoscaler**.

---

## 🔍 Scale-Up Flow (Deep Dive)

1. Pod is created (`replicas > available capacity`)
2. Scheduler cannot place pod
3. Pod enters `Pending` state
4. Cluster Autoscaler detects:

   * Insufficient CPU / memory / GPU
5. Autoscaler:

   * Maps pod → node group
   * Increases ASG desired capacity
6. ASG launches EC2 via Launch Template
7. EC2:

   * Runs `/etc/eks/bootstrap.sh`
   * Joins cluster
8. Scheduler assigns pod
9. Pod becomes `Running`

⏱ Typical scale-up time: **1–3 minutes**

---

## 🔻 Scale-Down Flow (Deep Dive)

```
Low Utilization?
     |
     v
Cluster Autoscaler
     |
     v
Finds empty / underutilized nodes
     |
     v
Cordon node (no new pods)
     |
     v
Drain node (move pods)
     |
     v
Terminate EC2 instance
     |
     v
ASG desired capacity decreases
```

### Safety Rules:

* Respects PodDisruptionBudgets
* Does NOT evict system pods
* Graceful shutdown

---

## ⚙️ Example: Launch Template (Key Parameters)

```text
AMI: eks-optimized-ami
Instance Types: t3.large / m5.large
Disk: gp3 – 50GB
IAM Role: AmazonEKSWorkerNodePolicy
User Data:
  /etc/eks/bootstrap.sh <cluster-name>
```

---

## ⚙️ Example: Auto Scaling Group

```text
Min Size: 2
Desired: 3
Max Size: 10
Availability Zones: 3
Health Check: EC2
Cooldown: 300s
```

---

## 📈 Scaling Signals

| Source            | Used For      |
| ----------------- | ------------- |
| Pending Pods      | Scale Up      |
| CPU / Memory Idle | Scale Down    |
| Node Utilization  | Consolidation |
| PDBs              | Safety        |

---

## 🔐 IAM Requirements

Cluster Autoscaler IAM permissions:

* autoscaling:SetDesiredCapacity
* autoscaling:TerminateInstanceInAutoScalingGroup
* autoscaling:DescribeAutoScalingGroups
* ec2:DescribeInstances
* eks:DescribeNodegroup

🔒 **Always use IAM Roles for Service Accounts (IRSA)**

---

## 🧪 Failure & Self-Healing

| Failure       | Result                   |
| ------------- | ------------------------ |
| EC2 crash     | ASG replaces node        |
| Node NotReady | Pod rescheduled          |
| AZ failure    | ASG launches in other AZ |
| High traffic  | Automatic scale-up       |

---

## 🏆 Best Practices

✅ Use **Managed Node Groups** unless custom AMIs needed
✅ Use **mixed instance policies** (Spot + On-Demand)
✅ Set **PodDisruptionBudgets**
✅ Enable **Cluster Autoscaler logs**
✅ Separate node groups per workload
✅ Tag ASGs properly for autoscaler discovery

---

## 🏁 Summary

**Launch Template** = *How nodes are created*
**Auto Scaling Group** = *How many nodes exist*
**Cluster Autoscaler** = *When to scale*
**EKS** = *Where workloads run*

Together they provide:

* Elastic compute
* Cost optimization
* Zero-touch scaling
* Production reliability

---
