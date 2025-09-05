# README.md: Docker Swarm Overview

## What is Docker Swarm?

**Docker Swarm** is Docker’s native container orchestration solution, which allows users to create, deploy, and manage clusters of Docker engines as a single logical unit. Swarm enables high-availability, load balancing, scaling, and self-healing for containerized applications—directly through the Docker CLI, with no separate installation required.[2][5]

***

## Swarm Architecture

### Nodes
- **Node:** Any instance of the Docker engine participating in the swarm; can be on a physical, virtual, or cloud host.
- **Manager Node:**  
  - Maintains cluster state using a distributed key-value store (Raft consensus).
  - Schedules and orchestrates containers, processes API requests, and elects a leader if multiple managers.
- **Worker Node:**  
  - Runs containers (tasks) as directed by managers, and reports back status.

A production swarm contains multiple manager and worker nodes for redundancy and scaling. Minimum for functional Swarm: 1 manager. Typical setups use 3–7 managers for fault tolerance.[5][6][2]

***

## Services and Tasks

- **Service:** A declarative definition of what containers run, which images to use, network/volume configuration, and the number of replicas.
- **Task:** An atomic unit managed by the scheduler—running a container with specified parameters on a worker node.
- **Replicated Service:** Manager distributes desired number of replicas over worker nodes.  
  Example:  
  Running 10 replicas of a web app across a 4-node cluster for high availability.[2][5]
- **Global Service:** One instance runs on every node; good for monitoring or logging agents.

### Declarative Service Example

```yaml
version: "3.8"
services:
  web:
    image: "my-webapp:latest"
    ports:
      - "80:80"
    deploy:
      replicas: 3
  redis:
    image: "redis:alpine"
    deploy:
      replicas: 2
```
Deploy with:
```
docker stack deploy -c stack.yml mystack
```
Changes are tracked and can be rolled back if errors occur.[2]

***

## Cluster Management & Features

- **Simplified Setup:**  
  - Initialize cluster: `docker swarm init`  
  - Join worker: `docker swarm join --token …`  
  - Promote/demote manager: `docker node promote <name>`
- **Scalability:**  
  - Easily scale up/down services: `docker service scale web=10`
- **Load Balancing:**  
  - Incoming requests are routed across service containers via Swarm’s built-in load balancer and routing mesh.[1][2]
- **Self-Healing:**  
  - Swarm monitors desired service state—if a container dies or a node drops, it reassigns tasks for continuity.[5]
- **Rolling Updates:**  
  - Update service images/version using:  
    ```
    docker service update --image webapp:v2 web
    ```
    Old containers are replaced with new ones, with automatic rollback capability.
- **Secure Networking:**  
  - All node communication uses mutual TLS; overlay networks provide secure, isolated multi-host connectivity.
- **Service Discovery:**  
  - Built-in DNS service lets containers reference others by service name.

***

## Real-World Example Workflow

1. Initialize Swarm:
    ```
    docker swarm init
    ```
2. Add Worker Node:
    ```
    docker swarm join --token <token> <manager-ip>:2377
    ```
3. Deploy and Scale a Web Service:
    ```
    docker service create --name web --replicas 5 -p 80:80 nginx
    docker service scale web=10
    ```
4. Rolling Update:
    ```
    docker service update --image nginx:latest web
    ```
5. Monitor Cluster:
    ```
    docker node ls
    docker service ls
    docker service ps web
    ```
Swarm ensures desired state: if a node fails, containers/tasks are moved to healthy nodes automatically.[5][2]

***

## Summary Table

| Component       | Role                                                   | Example Command                |
|-----------------|--------------------------------------------------------|-------------------------------|
| Manager Node    | Cluster orchestration, API, scheduling                 | `docker node promote`          |
| Worker Node     | Runs tasks, reports status                             | `docker node demote`           |
| Service         | Declarative application definition, scaling            | `docker service create`        |
| Task            | Unit of container scheduling, execution                | `docker service ps <service>`  |
| Overlay Network | Secure inter-node communication                        | Specified in stack YAML        |

***

This README.md gives DevOps, engineers, and learners a comprehensive reference and practical starting point for deploying **Docker Swarm** clusters and orchestrating containers in production environments.[3][1][2][5]

[1](https://www.geeksforgeeks.org/devops/introduction-to-docker-swarm-mode/)
[2](https://notes.kodekloud.com/docs/Docker-Certified-Associate-Exam-Course/Docker-Swarm/Swarm-Architecture)
[3](https://k21academy.com/docker-kubernetes/docker-swarm/)
[4](https://www.almabetter.com/bytes/tutorials/docker/docker-architecture)
[5](https://docs.docker.com/engine/swarm/key-concepts/)
[6](https://dccn-docker-swarm.readthedocs.io/en/latest/tutorial/swarm.html)
[7](https://www.c-sharpcorner.com/article/docker-swarm-architecture/)
[8](https://docs.docker.com/engine/swarm/swarm-tutorial/)
