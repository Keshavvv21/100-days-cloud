
# ☸️ Kubernetes Services – ClusterIP, NodePort, LoadBalancer, Ingress

## 🔹 Introduction

In Kubernetes, a **Service** is an abstraction that defines a logical set of Pods and a stable way to access them.
Since Pods are ephemeral and IPs change, Services provide consistent networking.

There are four main ways to expose applications:

1. **ClusterIP** – Internal access only (default).
2. **NodePort** – Exposes a port on each node.
3. **LoadBalancer** – Uses a cloud provider load balancer.
4. **Ingress** – Smart HTTP/HTTPS routing with domains & TLS.

---

## 🔹 1. ClusterIP (Default)

* Exposes service **only inside** the cluster.
* Used for **Pod-to-Pod** or **Pod-to-Service** communication.
* Default type if not specified.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: ClusterIP
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
```

### Diagram

```mermaid
flowchart TD
    A[Pod 1] -->|8080| S[ClusterIP Service]
    B[Pod 2] -->|8080| S
    C[Pod 3] -->|8080| S
    S -->|80| App[Internal Consumers]
```

---

## 🔹 2. NodePort

* Opens a port **(30000–32767)** on each node.
* Access via `<NodeIP>:<NodePort>`.
* Good for testing; not ideal for production.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30080
```

### Diagram

```mermaid
flowchart TD
    Client[External Client] -->|NodeIP:30080| N1[Node 1]
    Client -->|NodeIP:30080| N2[Node 2]
    Client -->|NodeIP:30080| N3[Node 3]
    N1 --> PodA[Pod A]
    N2 --> PodB[Pod B]
    N3 --> PodC[Pod C]
```

---

## 🔹 3. LoadBalancer

* Integrates with **cloud providers** (AWS ELB, Azure LB, GCP LB, etc.).
* Automatically provisions an external load balancer with a **public IP**.
* Best for production single-service apps.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
```

### Diagram

```mermaid
flowchart TD
    C[External Clients] --> LB[Cloud Load Balancer]
    LB --> N1[Node 1]
    LB --> N2[Node 2]
    LB --> N3[Node 3]
    N1 --> P1[Pod A]
    N2 --> P2[Pod B]
    N3 --> P3[Pod C]
```

---

## 🔹 4. Ingress

* **Not a Service**, but works alongside them.
* Provides **L7 routing (HTTP/HTTPS)**:

  * Path-based (`/api` → backend1, `/app` → backend2).
  * Host-based (`api.example.com` → backend1).
* Supports **TLS/HTTPS** termination.
* Requires an **Ingress Controller** (NGINX, Traefik, HAProxy, etc.).

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              number: 80
```

### Diagram

```mermaid
flowchart TD
    User[User: myapp.example.com] --> Ingress[Ingress Controller]
    Ingress -->|/api| S1[Service A]
    Ingress -->|/app| S2[Service B]
    S1 --> P1[Pod A]
    S2 --> P2[Pod B]
```

---

## 🔹 Combined Diagram – All Service Types

```mermaid
flowchart TB
    subgraph Cluster["Kubernetes Cluster"]
        subgraph Node1["Node 1"]
            P1[Pod A]
        end
        subgraph Node2["Node 2"]
            P2[Pod B]
        end
        subgraph Node3["Node 3"]
            P3[Pod C]
        end

        CI[ClusterIP Service] --> P1
        CI --> P2
        CI --> P3
    end

    DevClient[Dev Client] -->|NodeIP:30080| Node1
    DevClient -->|NodeIP:30080| Node2
    DevClient -->|NodeIP:30080| Node3

    LB[Cloud LoadBalancer] --> Node1
    LB --> Node2
    LB --> Node3

    User[User: myapp.example.com] --> Ingress[Ingress Controller]
    Ingress --> CI
```

---

## 🔹 Summary

| Type             | Scope          | Accessible From      | Use Case                         |
| ---------------- | -------------- | -------------------- | -------------------------------- |
| **ClusterIP**    | Internal only  | Inside cluster       | Pod-to-Pod communication         |
| **NodePort**     | Node IP + Port | External (manual)    | Dev/testing                      |
| **LoadBalancer** | Cloud Provider | External (public IP) | Production, simple apps          |
| **Ingress**      | L7 HTTP/HTTPS  | External (Domain)    | Routing, TLS, multi-service apps |

---

## 🔹 References

* [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)
* [Ingress Overview](https://kubernetes.io/docs/concepts/services-networking/ingress/)
* [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

---

✨ **In short:**

* **ClusterIP** → internal only.
* **NodePort** → basic external access.
* **LoadBalancer** → external access with cloud LB.
* **Ingress** → smart HTTP/HTTPS routing with TLS & domains.

---

