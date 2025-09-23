
# ☸️ Kubernetes CSI Drivers – AWS EBS, Longhorn, NFS

## 📘 Overview
The **Container Storage Interface (CSI)** allows Kubernetes to use different storage systems in a consistent way.  
With CSI drivers, you can dynamically provision persistent volumes for your applications.

In this guide, we cover **3 CSI Drivers**:
- **AWS EBS CSI Driver** – Block storage on AWS.
- **Longhorn** – Cloud-native distributed block storage.
- **NFS CSI Driver** – Network File System for shared storage.

---

## 🖼️ Architecture (CSI in Kubernetes)

```mermaid
flowchart LR
    subgraph Kubernetes
        A[Pod] --> B[Persistent Volume Claim]
        B --> C[Persistent Volume]
    end

    C --> D[CSI Driver]
    D -->|Provision/Delete| E[Storage Backend]
````

👉 The CSI Driver acts as a **bridge** between Kubernetes and your **storage backend**.

---

## 🔹 AWS EBS CSI Driver

```mermaid
flowchart TD
    Pod --> PVC --> PV --> "AWS EBS CSI Driver" --> "AWS Elastic Block Store"
```

### Install

```sh
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.36"
```

### Example StorageClass

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
```

---

## 🔹 Longhorn CSI Driver

```mermaid
flowchart TD
    Pod --> PVC --> PV --> "Longhorn CSI Driver" --> "Longhorn Distributed Storage"
```

### Install

```sh
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/master/deploy/longhorn.yaml
```

### Example StorageClass

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: longhorn-sc
provisioner: driver.longhorn.io
reclaimPolicy: Delete
allowVolumeExpansion: true
```

---

## 🔹 NFS CSI Driver

```mermaid
flowchart TD
    Pod --> PVC --> PV --> "NFS CSI Driver" --> "NFS Server"
```

### Install

```sh
kubectl apply -k "github.com/kubernetes-csi/csi-driver-nfs/deploy/kubernetes/overlays/stable"
```

### Example StorageClass

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-sc
provisioner: nfs.csi.k8s.io
parameters:
  server: <NFS_SERVER_IP>
  share: /exported/path
```

---

## 💡 Did You Know?

* Kubernetes CSI was introduced in **v1.9** and became stable in **v1.13**.
* **EBS volumes** are **AZ-bound** → a Pod using an EBS volume must run in the same AZ.
* **Longhorn** supports **replication across nodes** for high availability.
* **NFS** is the oldest shared file system protocol, widely supported across OSes.

---

## 🚀 Instructions – Using a CSI Driver

1. **Install the CSI driver** (AWS EBS, Longhorn, or NFS).
2. **Create a StorageClass** for that driver.
3. **Create a PersistentVolumeClaim (PVC)** referencing the StorageClass.
4. **Mount the PVC inside a Pod** as storage.

Example PVC:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ebs-sc
  resources:
    requests:
      storage: 5Gi
```

---

## 🔗 Useful Links

* [Kubernetes CSI Docs](https://kubernetes-csi.github.io/docs/)
* [AWS EBS CSI Driver](https://github.com/kubernetes-sigs/aws-ebs-csi-driver)
* [Longhorn Docs](https://longhorn.io/docs/)
* [NFS CSI Driver](https://github.com/kubernetes-csi/csi-driver-nfs)

---


## 📊 Comparison – AWS EBS vs Longhorn vs NFS

| Feature              | AWS EBS CSI Driver                  | Longhorn CSI Driver                         | NFS CSI Driver                          |
|----------------------|-------------------------------------|---------------------------------------------|-----------------------------------------|
| **Type**             | Block storage (per AZ)              | Distributed block storage (replicated)       | Shared file system                      |
| **High Availability**| ❌ Single-AZ only                   | ✅ Multi-node replication                   | ✅ Shared across multiple Pods/Nodes    |
| **Performance**      | High (per-volume IOPS)              | Medium (depends on replication)             | Lower (network latency)                 |
| **Scalability**      | Scales with AWS infra               | Scales across Kubernetes nodes              | Scales with NFS server backend          |
| **Use Case**         | Databases, stateful apps per AZ     | Cloud-native HA storage for K8s             | Shared data, configs, ML datasets       |
| **Cloud Dependence** | AWS-only                            | Cloud agnostic (works on any infra)         | Cloud agnostic                          |
| **Volume Expansion** | ✅ Supported                        | ✅ Supported                                | ✅ Supported                            |

---

✅ **Summary**:  
- Use **EBS** when running in AWS and need **fast block storage** (but bound to AZ).  
- Use **Longhorn** when you need **HA + replication in Kubernetes**.  
- Use **NFS** for **shared storage** across multiple Pods.  

---

