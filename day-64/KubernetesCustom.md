# 📘 Kubernetes Custom Resource Definitions (CRDs)

---

## 1. Overview

Kubernetes provides **Custom Resource Definitions (CRDs)** to extend the API and allow users to define **custom objects** beyond built-in resources like Pods, Services, and Deployments.

CRDs enable:

* **Custom APIs** for your applications
* **Automation & controllers** via custom operators
* **Declarative infrastructure** for application-specific resources

> Essentially, CRDs allow you to teach Kubernetes **new types of objects**, which can then be managed like native resources.

---

## 2. What is a Custom Resource Definition (CRD)?

A **CRD** defines a **new API resource** in the Kubernetes cluster. Once defined:

* You can create instances of your custom resource (CRs).
* Kubernetes treats them like built-in objects (you can `kubectl get`, `kubectl describe`, etc.).
* Controllers/operators can watch CRs and automate actions.

**Example analogy:**

* Built-in resource → Pod, Service
* Custom resource → Database, Queue, Cache, etc.

---

## 3. CRD Components

| Component                | Description                                           |
| ------------------------ | ----------------------------------------------------- |
| **CRD**                  | Defines the schema & API for your custom object       |
| **Custom Resource (CR)** | Instance of a CRD                                     |
| **Controller/Operator**  | Watches CRs and performs actions based on their state |
| **API Group/Version**    | Namespacing and versioning for your custom API        |

---

## 4. CRD Example

**CRD YAML: `database-crd.yaml`**

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: databases.example.com
spec:
  group: example.com
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                engine:
                  type: string
                  description: Type of database engine (mysql/postgres)
                version:
                  type: string
                  description: Database version
                replicas:
                  type: integer
                  description: Number of replicas
  scope: Namespaced
  names:
    plural: databases
    singular: database
    kind: Database
    shortNames:
      - db
```

---

**Custom Resource YAML: `my-database.yaml`**

```yaml
apiVersion: example.com/v1
kind: Database
metadata:
  name: mydb
spec:
  engine: postgres
  version: "14"
  replicas: 3
```

**Commands:**

```bash
# Create the CRD
kubectl apply -f database-crd.yaml

# Create a CR instance
kubectl apply -f my-database.yaml

# View all custom resources
kubectl get databases
kubectl describe database mydb
```

---

## 5. CRD Architecture & Flow Diagram

```mermaid
flowchart LR
    A[User] -->|kubectl apply| B[Custom Resource Definition (CRD)]
    B --> C[Kubernetes API Server]
    C --> D[Custom Resource (CR) Instances]
    D --> E[Controller / Operator]
    E --> F[Underlying Infrastructure]
    F --> G[Status Updates]
    G --> E
```

**Explanation:**

1. User defines a **CRD** to extend Kubernetes.
2. Kubernetes API server registers the CRD.
3. Users create **custom resources (CRs)**.
4. Controllers/operators watch CRs and perform actions.
5. Controllers update the CR’s **status**.
6. Users can observe the state via `kubectl`.

---

## 6. Key Learnings

1. **CRDs are declarative**: You define “what” you want; controllers decide “how.”
2. **Controllers automate actions**: CRDs alone do not manage anything; you need a controller/operator.
3. **Versioning is important**: Use `spec.versions` to support upgrades.
4. **Validation schemas**: OpenAPI v3 schema ensures CR correctness.
5. **Namespacing**: CRDs can be **Namespaced** or **ClusterScoped**.

---

## 7. CRD Best Practices

* Always include **OpenAPI validation** for spec fields.
* Use **status subresource** to separate **desired spec** and **observed state**.
* Version your CRDs properly (v1, v1beta1 deprecated).
* Use **short names** for easier `kubectl` access.
* Combine CRDs with **operators** to automate lifecycle management.

---

## 8. Real-World Use Cases

| Use Case          | Example                                                 |
| ----------------- | ------------------------------------------------------- |
| Database Operator | MySQL/Postgres CRD with controller managing pods & PVCs |
| Kafka Operator    | KafkaCluster CRD for deploying Kafka clusters           |
| Custom Scheduler  | Job CRD with custom logic to schedule workloads         |
| AI/ML Pipelines   | MLModel CRD to define model deployment & training       |

---

## 9. Learnings for AI & UI Agents

* CRDs allow **AI agents** to define custom objects like `AIJob` or `DataPipeline`.
* **Controllers** can let AI agents **observe state** and **trigger actions** automatically.
* UI dashboards can display **CRD status** to provide **real-time feedback** on AI agent operations.

---

## 10. Useful Commands

```bash
# View CRDs
kubectl get crd

# View custom resources for a CRD
kubectl get <crd-name>

# Describe a CRD
kubectl describe crd <crd-name>

# Delete CRD
kubectl delete crd <crd-name>
```

---

## 11. References & Papers

* Kubernetes Official Docs: [Custom Resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
* Kubernetes Operator Pattern: [Operator Framework](https://operatorframework.io/)
* Paper: “Extending Kubernetes with Custom Resources” (Cloud Native Computing Foundation)
* Anthropic / AI Insights: Using CRDs for declarative AI pipeline orchestration

---

This README contains:

* Detailed **CRD definition and CR examples**
* **Flow diagrams** for CRD lifecycle
* **Key learnings & best practices**
* Commands for managing CRDs
* Insights for **AI & UI integration**

---

If you want, I can also create a **full working demo folder structure** with:

* `database-crd.yaml`
* `my-database.yaml`
* Optional **controller/operator Python example**

Do you want me to do that?
