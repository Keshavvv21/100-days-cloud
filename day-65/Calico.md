
# 🐱 Calico CNI Plugin for Kubernetes

**Project**: Calico – Kubernetes CNI Plugin & Network Policy Enforcer

Calico provides **network connectivity and security enforcement** for Kubernetes clusters. It acts as a **CNI (Container Network Interface) plugin**, enabling pods to communicate securely, with optional network policies to enforce isolation.

---

## 🔹 What Calico Does

* Provides **pod-to-pod networking** across nodes.
* Implements **Network Policies** (ingress/egress control).
* Optional **IPAM (IP Address Management)** for pod IP assignment.
* Supports **BGP routing** for high-performance networking.
* Can enforce **security policies** across clusters (e.g., deny all traffic by default).

**Key Components**:

| Component                 | Function                                                     |
| ------------------------- | ------------------------------------------------------------ |
| `calico-node`             | Agent running on each node; programs routes and policies     |
| `calicoctl`               | CLI for managing Calico resources                            |
| `calico-kube-controllers` | Integrates Calico with Kubernetes APIs for policy management |
| `Felix`                   | Calico agent for packet processing and policy enforcement    |

---

## 🏗️ Installation Flow for Kubernetes

### 1️⃣ Prerequisites

* Kubernetes cluster (v1.24+ recommended)
* `kubectl` configured
* `etcd` or Kubernetes datastore (Calico can use Kubernetes API directly)

---

### 2️⃣ Installation Steps

**Option 1: Using Manifest (Recommended)**

```bash
# Download and apply Calico manifest
kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico.yaml
```

**Option 2: Using Helm Chart**

```bash
helm repo add projectcalico https://docs.projectcalico.io/charts
helm repo update
helm install calico projectcalico/tigera-operator
```

**Check Installation**

```bash
kubectl get pods -n calico-system
kubectl get nodes -o wide
```

---

### 3️⃣ Verify Network Policy Enforcement

* Create a test namespace:

```bash
kubectl create ns test
```

* Apply a network policy:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: test
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

* Test pod connectivity across namespaces – traffic should be blocked by default.

---

## 🧩 Flow Diagram

Here’s a conceptual **Calico Networking Flow** in Kubernetes:

```
+-------------------+         +-------------------+
| Pod A (Node 1)    | <-----> | Pod B (Node 2)    |
+-------------------+         +-------------------+
         |                             |
         |  veth + CNI                 |  veth + CNI
         |                             |
   +------------------+         +------------------+
   | calico-node(Felix)|         | calico-node(Felix)|
   +------------------+         +------------------+
            \                         /
             \ BGP / Routing / Policies \
              \                       /
               +---------------------+
               |  Kubernetes API     |
               +---------------------+
```

**Flow Description**:

1. **Pods communicate** via virtual ethernet interfaces (`veth`) managed by Calico.
2. **Felix agent** programs routes and enforces network policies.
3. **Kubernetes API** stores policy definitions.
4. Traffic flows across nodes via **BGP routes** or overlay encapsulation (VXLAN, IP-in-IP).
5. Policies control ingress/egress for pod isolation.

---

## 🔗 Useful Links

* Official Calico Docs: [https://projectcalico.docs.tigera.io](https://projectcalico.docs.tigera.io)
* Network Policy Reference: [https://kubernetes.io/docs/concepts/services-networking/network-policies/](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
* GitHub Repository: [https://github.com/projectcalico/calico](https://github.com/projectcalico/calico)
* Blog/Guide for CNI Plugins: [https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/)

---

## ✅ Key Takeaways

* Calico = **Networking + Security** for Kubernetes
* Supports both **overlay (VXLAN)** and **BGP-based routing**
* Enables **fine-grained network policies** for pods
* Easy installation via **manifest or Helm**
* Provides visibility and debugging tools via `calicoctl`


