# 📘 AWS ALB + Target Group Integration with EKS

## Overview

This document explains how **AWS Application Load Balancer (ALB)** integrates with **Amazon EKS** using **Target Groups** to expose Kubernetes services securely and scalably.

The setup leverages the **AWS Load Balancer Controller** to automatically provision and manage ALBs based on Kubernetes Ingress resources.

---

## Architecture Overview

```
User / Client
     ↓
AWS Application Load Balancer (ALB)
     ↓
ALB Target Group (IP Mode)
     ↓
Kubernetes Service
     ↓
Pods (Running in EKS Cluster)
```

---

## Key Components

### 1. Application Load Balancer (ALB)

* Layer 7 (HTTP/HTTPS) load balancer
* Supports path-based and host-based routing
* Managed by AWS
* Integrates natively with Kubernetes via Ingress

---

### 2. Target Group

* Registers **Pod IPs** directly (recommended: `target-type: ip`)
* Performs health checks on Pods
* Dynamically updated as Pods scale up/down

---

### 3. Amazon EKS

* Managed Kubernetes service
* Runs application Pods
* Uses Kubernetes Ingress to define routing rules

---

### 4. AWS Load Balancer Controller

* Kubernetes controller that:

  * Watches Ingress resources
  * Automatically creates ALBs and Target Groups
  * Updates routing rules and health checks

---

## Prerequisites

* Amazon EKS cluster up and running
* `kubectl` configured
* IAM OIDC provider enabled for the cluster
* IAM role with ALB permissions
* Helm installed

---

## Installation Steps

### Step 1: Install AWS Load Balancer Controller

```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=<your-cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

---

### Step 2: Create Kubernetes Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
```

---

### Step 3: Create Ingress Resource

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}]'
spec:
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: app-service
                port:
                  number: 80
```

---

## Traffic Flow (Step-by-Step)

1. Client sends request to ALB DNS
2. ALB evaluates Ingress routing rules
3. Request forwarded to Target Group
4. Target Group routes traffic to Pod IPs
5. Pod processes request and returns response

---

## Health Checks

* Configured at Target Group level
* Default path: `/`
* Unhealthy Pods are automatically removed
* Works seamlessly with Kubernetes readiness probes

---

## Scaling Behavior

* Pod scaling → Target Group updates automatically
* No manual load balancer reconfiguration required
* Works with:

  * Horizontal Pod Autoscaler (HPA)
  * Cluster Autoscaler

---

## Security

* Supports HTTPS with ACM certificates
* Security Groups attached to ALB
* IAM-based access control
* No public exposure of worker nodes required

---

## Best Practices

* Use `target-type: ip` (recommended)
* Use HTTPS + ACM
* Separate Ingress per application
* Enable access logs on ALB
* Use namespaces for isolation

---

## Common Use Cases

* Public APIs
* Web dashboards
* Mobile app backends
* ML / AI inference services
* Microservices architectures

---

## Summary

| Feature            | Benefit              |
| ------------------ | -------------------- |
| Managed ALB        | No infra maintenance |
| Direct Pod Routing | Better performance   |
| Auto Scaling       | Kubernetes-native    |
| Secure             | IAM + SG + TLS       |
| Production Ready   | AWS recommended      |


