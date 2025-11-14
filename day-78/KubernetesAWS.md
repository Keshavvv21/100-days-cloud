# 📘 Kubernetes on AWS — EBS + AMI Snapshot Automation

*Automated Backups for EC2, EKS Worker Nodes & Persistent Volumes*

This guide explains how to configure automated **EBS volume snapshots**, **AMI snapshots**, and **retention policies** for Kubernetes (EKS) clusters running on AWS.

It covers:
✔ EBS PVC snapshot automation
✔ Worker node AMI snapshot automation
✔ Using AWS Backup, Lambda, or CronJobs
✔ Retention policies & lifecycle rules
✔ Restore procedures

---

## 📑 Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Prerequisites](#prerequisites)
4. [Snapshot Types Explained](#snapshot-types-explained)
5. [EBS Snapshot Automation](#ebs-snapshot-automation)
6. [AMI Snapshot Automation](#ami-snapshot-automation)
7. [Retention Policies](#retention-policies)
8. [Kubernetes CronJob for Snapshots](#kubernetes-cronjob-for-snapshots)
9. [Restore Process](#restore-process)
10. [IAM Policies](#iam-policies)
11. [Troubleshooting](#troubleshooting)

---

# 1️⃣ Overview

When running Kubernetes workloads on AWS (EKS or self-managed), it’s important to back up:

* **EBS volumes used by Persistent Volume Claims (PVCs)**
* **AMI images of worker nodes**
* **Critical configuration stored on nodes**

Snapshots protect against accidental deletion, ransomware, corruption, and cluster migration needs.

---

# 2️⃣ Architecture

```
               ┌─────────────────────────┐
               │    Kubernetes Cluster    │
               │        (EKS/EC2)         │
               └───────────┬─────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
   PVC Volumes        Worker Node        Cluster Config
   (EBS)              (EC2 AMI)          (ETCD/EFS/Secrets)
        │                  │                  │
        └──── Snapshot & Backup Automation ───┘
```

Snapshots can be taken via:

* AWS Backup
* Lambda Functions
* Kubernetes CronJobs
* AWS Data Lifecycle Manager (DLM)

---

# 3️⃣ Prerequisites

* AWS Account
* EKS cluster or EC2-based Kubernetes
* kubectl & awscli configured
* IAM role with snapshot permissions
* EBS-backed PVCs

---

# 4️⃣ Snapshot Types Explained

### **EBS Snapshot**

* Backup of block storage used by Kubernetes PVCs.
* Needed for databases: PostgreSQL, MySQL, MongoDB, Elastic, Prometheus, etc.

### **AMI Snapshot**

* Creates an Amazon Machine Image (AMI) from worker node for:

  * Cluster migration
  * Node replacement
  * Disaster recovery

---

# 5️⃣ EBS Snapshot Automation

## **Option A: Using AWS Backup (Recommended)**

Create a backup plan:

```bash
aws backup create-backup-plan --backup-plan file://backup-plan.json
```

Sample **backup-plan.json**:

```json
{
  "BackupPlanName": "eks-ebs-backup",
  "Rules": [
    {
      "RuleName": "daily",
      "TargetBackupVaultName": "default",
      "ScheduleExpression": "cron(0 2 * * ? *)",
      "Lifecycle": {
        "DeleteAfterDays": 7
      }
    }
  ]
}
```

Assign EBS volumes to the plan:

```bash
aws backup create-backup-selection --backup-plan-id <ID> \
--backup-selection file://backup-selection.json
```

**backup-selection.json**:

```json
{
  "SelectionName": "ebs-selection",
  "Resources": ["arn:aws:ec2:*:*:volume/*"]
}
```

---

# 6️⃣ AMI Snapshot Automation

## **Option A: AWS Data Lifecycle Manager (DLM)**

Create a DLM policy:

```bash
aws dlm create-lifecycle-policy --execution-role-arn <role> \
--description "Daily AMI Snapshots" --state ENABLED \
--policy-details file://ami-policy.json
```

Sample **ami-policy.json**:

```json
{
  "ResourceTypes": ["INSTANCE"],
  "TargetTags": [
    {"Key": "Backup", "Value": "true"}
  ],
  "Schedules": [
    {
      "Name": "Daily",
      "CreateRule": {"Interval": 24, "IntervalUnit": "HOURS"},
      "RetainRule": {"Count": 7}
    }
  ]
}
```

Tag your worker nodes:

```bash
aws ec2 create-tags --resources <INSTANCE_ID> \
--tags Key=Backup,Value=true
```

---

# 7️⃣ Retention Policies

Recommended:

| Snapshot Type | Retention |
| ------------- | --------- |
| Daily         | 7 days    |
| Weekly        | 4 weeks   |
| Monthly       | 3 months  |
| Quarterly     | 1 year    |

Automatic deletion is handled by AWS DLM or Backup Lifecycle rules.

---

# 8️⃣ Kubernetes CronJob for Snapshots (Alternative)

Useful when you want snapshot control inside the cluster.

Example CronJob:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: ebs-snapshot-job
spec:
  schedule: "0 3 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: ebs-snapshot
              image: amazon/aws-cli
              command:
                - /bin/sh
                - -c
                - >
                  aws ec2 create-snapshot
                  --volume-id $(VOLUME_ID)
                  --description "Daily PVC Snapshot";
          restartPolicy: OnFailure
```

---

# 9️⃣ Restore Process

### **Restore EBS Snapshot → New Volume**

```bash
aws ec2 create-volume \
  --availability-zone ap-south-1a \
  --snapshot-id snap-123456
```

### **Attach to Node**

```bash
aws ec2 attach-volume --volume-id vol-xxxx --instance-id i-xxxx --device /dev/xvdf
```

### **Restore AMI**

```bash
aws ec2 run-instances --image-id ami-xxxx
```

---

# 🔟 IAM Policies

Attach the policy below to the role used by the cluster or backup system:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateSnapshot",
        "ec2:DeleteSnapshot",
        "ec2:DescribeInstances",
        "ec2:DescribeVolumes",
        "ec2:CreateTags",
        "ec2:CreateImage",
        "ec2:DeregisterImage",
        "ec2:DeleteTags"
      ],
      "Resource": "*"
    }
  ]
}
```

---

# 🔧 Troubleshooting

### ❗ Snapshot stuck in “pending”

* Check EBS “in-use” state
* Ensure correct IAM permissions

### ❗ AMI creation failed

* Root volume encryption issues
* Node role lacks `ec2:CreateImage`

### ❗ CronJob not running

* Check service account IAM
* See logs using:

```bash
kubectl logs job/<job-name>
```

---

# 📌 Summary

This README explains:

* Automated **EBS PVC snapshots**
* Automated **Worker AMI snapshots**
* **AWS Backup**, **DLM**, and **Kubernetes CronJobs**
* IAM + retention + restore processes

You now have a complete backup strategy for **Kubernetes on AWS**.


