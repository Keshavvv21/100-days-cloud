
# 📘 Kubernetes: StatefulSets + Headless Service

## Introduction

StatefulSets manage stateful applications in Kubernetes.  
Unlike Deployments, StatefulSets give each Pod a **stable identity** (name & network).  
A **Headless Service** (`ClusterIP: None`) is usually combined with StatefulSets to provide **stable DNS records** for each Pod.

---

## 🔑 Key Concepts

- **StatefulSet**:
  - Ensures Pods have predictable names (`pod-0`, `pod-1`, etc.)
  - Supports ordered creation, scaling, and deletion.
  - Useful for databases (MySQL, MongoDB, Cassandra, etc.).

- **Headless Service**:
  - No cluster IP (`clusterIP: None`).
  - Provides DNS entries for each Pod.
  - Example: `pod-0.service.namespace.svc.cluster.local`.

---

## 🛠 Example: StatefulSet with Headless Service

### Headless Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  clusterIP: None   # Headless Service
  selector:
    app: mysql
  ports:
    - port: 3306
      name: mysql
````

### StatefulSet

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: "mysql"   # Matches headless service
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql:8.0
          ports:
            - containerPort: 3306
              name: mysql
          volumeMounts:
            - name: mysql-persistent-storage
              mountPath: /var/lib/mysql
  volumeClaimTemplates:
    - metadata:
        name: mysql-persistent-storage
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 1Gi
```

---

## 📊 How It Works (Diagram)

```mermaid
flowchart TD
    U[Client] -->|DNS Lookup| HS[Headless Service (ClusterIP=None)]
    HS --> P0[pod-0.mysql.default.svc]
    HS --> P1[pod-1.mysql.default.svc]
    HS --> P2[pod-2.mysql.default.svc]

    style HS fill:#f9f,stroke:#333,stroke-width:2px
    style P0 fill:#bbf,stroke:#333
    style P1 fill:#bbf,stroke:#333
    style P2 fill:#bbf,stroke:#333
```

* Clients use the **Headless Service** for DNS.
* Each Pod gets a **stable DNS record** (`pod-x.service.namespace.svc`).
* Storage volumes are persistent across restarts.

---

## ✅ Summary

* **StatefulSets**: manage stateful apps with stable IDs.
* **Headless Service**: enables DNS-based discovery of individual Pods.
* Perfect for **databases, distributed systems, and clustered apps**.

```

```
