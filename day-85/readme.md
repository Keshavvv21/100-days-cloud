# 🌐 AWS Networking Basics – VPC, Subnet, Route Tables & NAT Gateway

This document explains the core AWS networking components and how they work together to securely host applications in the cloud.

---

## 📌 Overview

An **Amazon Virtual Private Cloud (VPC)** is an isolated virtual network where you deploy AWS resources. Inside a VPC, you organize resources using **subnets**, control traffic using **route tables**, and enable secure internet access using components like **Internet Gateway (IGW)** and **NAT Gateway**.

---

## 🧱 Components Explained

### 1️⃣ VPC (Virtual Private Cloud)

* A logically isolated network in AWS.
* You define an IP range using **CIDR** (e.g., `10.0.0.0/16`).
* Acts as the boundary for all networking components.

**Purpose:**
Provide full control over networking, security, and routing.

---

### 2️⃣ Subnets

A subnet is a smaller IP range inside a VPC.

#### Types:

* **Public Subnet**

  * Has a route to the Internet Gateway.
  * Used for ALBs, Bastion Hosts, NAT Gateway.

* **Private Subnet**

  * No direct internet access.
  * Used for application servers, databases.

**Example:**

* Public Subnet: `10.0.1.0/24`
* Private Subnet: `10.0.2.0/24`

---

### 3️⃣ Route Tables

* Define **where network traffic is directed**.
* Each subnet is associated with a route table.

#### Common Routes:

* `0.0.0.0/0 → Internet Gateway` (Public Subnet)
* `0.0.0.0/0 → NAT Gateway` (Private Subnet)

---

### 4️⃣ NAT Gateway (Network Address Translation)

* Allows **private subnet resources to access the internet**.
* Prevents inbound internet traffic to private instances.
* Deployed **only in a public subnet**.

**Use case:**
Private EC2 instances downloading updates, calling APIs, pushing logs.

---

## 🔁 Traffic Flow Summary

* **Inbound Internet Traffic**

  * Internet → IGW → Public Subnet → Load Balancer / EC2

* **Outbound Traffic from Private Subnet**

  * Private EC2 → NAT Gateway → IGW → Internet

---

## 🧭 Architecture Diagram (ASCII)

```
                   🌍 Internet
                        |
                 +----------------+
                 | Internet Gateway|
                 +----------------+
                        |
        -------------------------------------
        |                                   |
+--------------------+            +---------------------+
|  Public Subnet     |            |  Private Subnet     |
|  (10.0.1.0/24)     |            |  (10.0.2.0/24)     |
|                    |            |                     |
|  - Load Balancer   |            |  - App Server       |
|  - NAT Gateway     |<-----------|  - Database         |
|                    |   Outbound |                     |
+--------------------+            +---------------------+
```

---

## 🔐 Security Best Practices

* Keep databases and backend services in **private subnets**
* Allow inbound access only via **Load Balancers**
* Use **Security Groups** (stateful) and **NACLs** (stateless)
* Use **NAT Gateway** instead of exposing private instances

---

## ✅ Typical Use Case

* **Frontend / Load Balancer** → Public Subnet
* **Backend Services** → Private Subnet
* **Database** → Private Subnet (no internet)
* **Updates & API calls** → Via NAT Gateway

---

## 📦 Summary Table

| Component   | Purpose                         |
| ----------- | ------------------------------- |
| VPC         | Isolated network                |
| Subnet      | Segment VPC into public/private |
| Route Table | Control traffic flow            |
| NAT Gateway | Secure outbound internet access |

---

If you want, I can also:

* Convert this into **Markdown for GitHub**
* Create a **draw.io / PPT diagram**
* Add **Terraform or CloudFormation examples**
* Tailor it for **EKS, ECS, or On-Prem hybrid**

Just tell me 👍
