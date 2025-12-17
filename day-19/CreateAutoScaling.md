# 📘 README

## Create Auto Scaling Group using Launch Template (AWS Core + EKS)

---

## 1. Overview

This document explains how to create an **AWS Auto Scaling Group (ASG)** using a **Launch Template**, designed to work for:

* **AWS Core EC2 workloads**
* **Amazon EKS worker nodes (self-managed node groups)**

The setup enables:

* Automatic scaling of EC2 instances
* High availability across multiple Availability Zones
* Seamless integration with EKS clusters (optional)

---

## 2. Architecture Flow

```
Launch Template
      ↓
Auto Scaling Group
      ↓
EC2 Instances
      ↓
(Optional) Join EKS Cluster
```

---

## 3. Prerequisites

* AWS Account with required permissions
* IAM User / Role with:

  * EC2
  * Auto Scaling
  * IAM
  * (Optional) EKS permissions
* Existing:

  * VPC
  * Subnets (at least 2 AZs recommended)
* AWS CLI configured (optional but recommended)

---

## 4. Create Launch Template

### Key Configuration

| Parameter            | Description                        |
| -------------------- | ---------------------------------- |
| AMI ID               | Amazon Linux 2 / EKS Optimized AMI |
| Instance Type        | `t3.medium`, `m5.large`, etc.      |
| Key Pair             | For SSH access                     |
| Security Groups      | Allow required inbound/outbound    |
| IAM Instance Profile | Required for EKS nodes             |
| User Data            | Bootstrap script                   |

### Example (EKS Worker Node User Data)

```bash
#!/bin/bash
/etc/eks/bootstrap.sh <EKS_CLUSTER_NAME>
```

> For **non-EKS workloads**, user data can be omitted or replaced with app bootstrap logic.

---

## 5. Create Auto Scaling Group

### Configuration Steps

1. Select **Launch Template**
2. Choose:

   * VPC
   * Subnets (multiple AZs recommended)
3. Set capacity:

   * Desired: `2`
   * Min: `1`
   * Max: `5`
4. Health Checks:

   * EC2 (or ELB if using Load Balancer)
5. Scaling Policies (Optional):

   * CPU Utilization
   * Memory / Custom CloudWatch metrics

---

## 6. IAM Requirements (Important)

### Required IAM Policies for EKS Nodes

Attach to the **EC2 Instance Role**:

* `AmazonEKSWorkerNodePolicy`
* `AmazonEKS_CNI_Policy`
* `AmazonEC2ContainerRegistryReadOnly`

---

## 7. Tagging (Recommended)

Ensure these tags are added at **ASG level**:

| Key               | Value                |
| ----------------- | -------------------- |
| Name              | eks-worker-node      |
| Environment       | dev / staging / prod |
| KubernetesCluster | `<cluster-name>`     |

> Tags should be set to **propagate to instances**

---

## 8. Verify Setup

### For AWS Core EC2

* Instances launch automatically
* Scale in/out based on policy
* Health checks working

### For EKS

Run:

```bash
kubectl get nodes
```

Expected:

* EC2 instances appear as **Ready nodes**

---

## 9. Scaling Example

| Event              | Result                 |
| ------------------ | ---------------------- |
| CPU > 70%          | ASG scales out         |
| CPU < 30%          | ASG scales in          |
| Instance unhealthy | Automatically replaced |

---

## 10. Cleanup (Optional)

To delete resources safely:

1. Scale ASG desired capacity to `0`
2. Delete Auto Scaling Group
3. Delete Launch Template
4. Remove IAM roles (if unused)

---

## 11. Best Practices

* Use **Launch Templates** instead of Launch Configurations
* Spread instances across **multiple AZs**
* Enable **CloudWatch Alarms**
* Use **EKS Optimized AMIs** for Kubernetes workloads
* Avoid hard-coding values in user data

---

## 12. Summary

This setup provides:

* Automated scaling
* Fault tolerance
* EKS-ready infrastructure
* Production-grade AWS architecture

---

If you want, I can also provide:

* Terraform version
* CloudFormation template
* EKS-specific diagram
* Production vs Dev configuration split
