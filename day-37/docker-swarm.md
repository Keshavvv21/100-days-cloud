

# 🐳 Docker Swarm – Detailed Guide

## 🔹 What is Docker Swarm?

Docker Swarm is **Docker’s native clustering and orchestration tool**. It allows you to:

* Combine multiple Docker nodes (machines running Docker) into a **single cluster**.
* Deploy services with **replicas** across those nodes.
* Achieve **high availability, scaling, and load balancing** without external tools.

👉 Think of it as Kubernetes’ lightweight cousin — built directly into Docker.

---

## 🔹 Why Use Swarm?

* Simple to set up (no extra installation).
* Works directly with Docker CLI (`docker service`, `docker stack`).
* Provides **load balancing, service discovery, rolling updates, fault tolerance**.
* Good for **small-to-medium scale microservices deployments**.

---

## 🔹 Swarm Components

### 1. **Nodes**

* **Manager Node**:

  * Controls the cluster.
  * Handles scheduling, orchestration, and API requests.
  * Stores cluster state using **Raft consensus**.
* **Worker Node**:

  * Executes the containers (tasks).
  * Reports status back to managers.

⚡ Production clusters typically have **3–7 managers** for fault tolerance.

---

### 2. **Services & Tasks**

* **Service** = A definition of how to run containers (image, replicas, networks).
* **Task** = A running container instance of a service, placed on a worker.
* **Replicated Service** = Multiple instances across workers (e.g., 5 web replicas).
* **Global Service** = One instance per node (e.g., monitoring agents).

---

## 🔹 Step-by-Step Workflow

### 1. Initialize a Swarm

On the first node (manager):

```bash
docker swarm init
```

This outputs a join command for workers, e.g.:

```bash
docker swarm join --token <token> <manager-ip>:2377
```

### 2. Join Worker Nodes

On other machines (workers):

```bash
docker swarm join --token <token> <manager-ip>:2377
```

### 3. Create a Service

Run 5 replicas of Nginx:

```bash
docker service create --name web --replicas 5 -p 80:80 nginx
```

### 4. Inspect the Cluster

```bash
docker node ls        # List nodes in the swarm
docker service ls     # List running services
docker service ps web # Show tasks/replicas of 'web'
```

### 5. Scale Services

Increase replicas from 5 → 10:

```bash
docker service scale web=10
```

### 6. Rolling Updates

Update the service to a new version:

```bash
docker service update --image nginx:latest web
```

If something goes wrong, Swarm rolls back automatically.

---

## 🔹 Example Multi-Service Deployment (Stack YAML)

```yaml
version: "3.9"

services:
  frontend:
    image: myorg/frontend:latest
    ports:
      - "80:80"
    deploy:
      replicas: 3
    networks:
      - app-net

  backend:
    image: myorg/backend:latest
    deploy:
      replicas: 2
    networks:
      - app-net

  database:
    image: postgres:14
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secret
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - app-net

volumes:
  db-data:

networks:
  app-net:
    driver: overlay
```

Deploy it with:

```bash
docker stack deploy -c stack.yml mystack
```

---

## 🔹 Key Features of Docker Swarm

| Feature               | Description                                                     |
| --------------------- | --------------------------------------------------------------- |
| **High Availability** | Replicated managers + auto-failover.                            |
| **Load Balancing**    | Routes requests across service replicas using **routing mesh**. |
| **Scaling**           | Easily scale up/down services (`docker service scale`).         |
| **Rolling Updates**   | Gradual updates with rollback support.                          |
| **Service Discovery** | Built-in DNS lets services find each other by name.             |
| **Secure by Default** | Node-to-node communication via **mutual TLS**.                  |

---

## 🔹 Diagram – Swarm in Action

```
                +----------------------+
                |   Manager Node       |
                |  - Orchestration     |
                |  - Raft Consensus    |
                +----------------------+
                          |
        --------------------------------------------
        |                   |                     |
+---------------+   +---------------+     +---------------+
|  Worker 1     |   |  Worker 2     |     |  Worker 3     |
|  web:80       |   |  web:80       |     |  redis        |
+---------------+   +---------------+     +---------------+
```

---

✅ **Summary**

* Docker Swarm is Docker’s built-in orchestration tool.
* Provides **easy scaling, HA, and service discovery** out of the box.
* Great for microservices and smaller production environments.
* Works natively with **Docker CLI** — no extra installation needed.

---

