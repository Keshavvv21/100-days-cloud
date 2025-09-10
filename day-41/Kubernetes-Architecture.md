
# 📘 Kubernetes Architecture – Control Plane (Master), Nodes & Workers

This document explains the **core Kubernetes architecture**, focusing on:

* **Control Plane (Master)**
* **Worker Nodes**
* **Key Components** (kubelet, etcd, controller-manager, scheduler, API server)

---

## 🌐 High-Level Overview

* **Control Plane (Master):**
  The “brain” of the cluster. It makes global decisions about the cluster (e.g., scheduling), and detects/responds to cluster events.

* **Worker Nodes:**
  The “muscles” of the cluster. They run the actual applications inside Pods. Each worker node is managed by the Control Plane.

* **Node:**
  A **single machine (VM or physical)** in the cluster.

  * **Master Node (Control Plane):** Runs the control components.
  * **Worker Node:** Runs application Pods, managed by kubelet.

---

## 📊 Arrow Flow Diagram (Cluster Workflow)

```text
 [ User / kubectl ]
         |
         v
 [ kube-apiserver ] <-------> [ etcd (DB) ]
         |
         v
 [ Controller Manager ] ----> watches desired vs actual
         |
         v
 [ Scheduler ] ----> decides "which worker node runs this Pod?"
         |
         v
 [ Worker Node ] ---> [ kubelet ] ---> [ Container Runtime ] ---> [ Pods / Containers ]
```

---

## 📦 Block Diagram (Cluster Components)

```text
                   ┌───────────────────────────┐
                   │       Control Plane        │
                   │  (Master Node Components) │
                   │                           │
                   │  +---------------------+  │
                   │  | kube-apiserver      |  │
                   │  +---------------------+  │
                   │  | etcd (DB)           |  │
                   │  +---------------------+  │
                   │  | Controller Manager  |  │
                   │  +---------------------+  │
                   │  | Scheduler           |  │
                   │  +---------------------+  │
                   └───────────▲──────────────┘
                               │
                               │
       ┌───────────────────────┴─────────────────────────┐
       │                                                 │
┌──────┴──────┐                                   ┌──────┴──────┐
│ Worker Node │                                   │ Worker Node │
│             │                                   │             │
│ +---------+ │                                   │ +---------+ │
│ | kubelet | │                                   │ | kubelet | │
│ +----▲----+ │                                   │ +----▲----+ │
│      |      │                                   │      |      │
│ +----┴----+ │                                   │ +----┴----+ │
│ | Runtime | │                                   │ | Runtime | │
│ |(Docker) | │                                   │ |(containerd)│
│ +----▲----+ │                                   │ +----▲----+ │
│      |      │                                   │      |      │
│   +--┴---+  │                                   │   +--┴---+  │
│   | Pods |  │                                   │   | Pods |  │
│   +------+  │                                   │   +------+  │
└─────────────┘                                   └─────────────┘
```

---

## 🔑 Components Explained

### 🧠 Control Plane (Master Node)

Runs cluster management processes:

1. **kube-apiserver**

   * Front door of the cluster
   * All components & users talk through it
     📖 [API Server Docs](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)

2. **etcd (DB)**

   * Distributed, consistent key-value store
   * Source of truth for cluster state
     📖 [etcd in Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)

3. **Controller Manager**

   * Reconciles desired vs actual state
   * Runs controllers like Deployment, Node, Job controllers
     📖 [Controller Manager Docs](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/)

4. **Scheduler**

   * Decides which worker node a Pod should run on
   * Considers resource availability, policies, taints/tolerations
     📖 [Scheduler Docs](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/)

---

### ⚙️ Worker Nodes

Run your actual applications (Pods):

1. **kubelet**

   * Node agent
   * Talks to API server
   * Ensures Pods are running
     📖 [Kubelet Docs](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)

2. **Container Runtime**

   * Runs containers (Docker, containerd, CRI-O)
   * Pulls images, starts/stops containers
     📖 [Container Runtime Interface](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)

3. **Pods**

   * Smallest deployable unit
   * Contains one or more containers (app, sidecars, init containers)
     📖 [Pods in Kubernetes](https://kubernetes.io/docs/concepts/workloads/pods/)

---

## 🔁 Step-by-Step Flow

1. User runs `kubectl apply -f pod.yaml`.
2. **API server** accepts request, stores desired state in **etcd**.
3. **Controller Manager** notices new object → ensures resources exist.
4. **Scheduler** decides which Worker Node should host the Pod.
5. **kubelet** on that node pulls container image & runs it via runtime.
6. **etcd** updates actual state → cluster now reconciles desired = actual.

---

## 🧩 Summary

* **Control Plane (Master Node):** Brain of cluster (API, etcd, controllers, scheduler).
* **Worker Nodes:** Machines that run apps (kubelet, runtime, Pods).
* **Node:** Any machine in cluster (can be Master or Worker).

Together, these make Kubernetes a **self-healing, declarative orchestration system**.

---

## 📚 References

* [Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/)
* [Nodes in Kubernetes](https://kubernetes.io/docs/concepts/architecture/nodes/)
* [Control Plane Components](https://kubernetes.io/docs/concepts/overview/components/#control-plane-components)
* [Worker Node Components](https://kubernetes.io/docs/concepts/overview/components/#node-components)

```

---
