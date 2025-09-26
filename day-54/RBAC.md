
# 🔐 RBAC in Kubernetes

## 📖 What is RBAC?

**Role-Based Access Control (RBAC)** in Kubernetes is a mechanism to regulate who can access what in a cluster.
It defines **permissions** using:

1. **Roles / ClusterRoles** → Define a set of permissions.
2. **RoleBindings / ClusterRoleBindings** → Assign those permissions to users, groups, or ServiceAccounts.
3. **ServiceAccounts (SAs)** → Special Kubernetes accounts used by pods, controllers, and applications to interact with the API server.

---

## 🗂️ Core Components

### 1. **Role / ClusterRole**

* **Role** → Defines permissions *within a namespace*.
* **ClusterRole** → Defines permissions *cluster-wide*.

👉 Example: A Role might allow listing Pods in a namespace, while a ClusterRole might allow listing Nodes cluster-wide.

---

### 2. **RoleBinding / ClusterRoleBinding**

* **RoleBinding** → Assigns a Role to a user, group, or ServiceAccount *within a namespace*.
* **ClusterRoleBinding** → Assigns a ClusterRole *across all namespaces*.

👉 Think: *Roles define “what,” Bindings define “who.”*

---

### 3. **ServiceAccount (SA)**

* Default account for workloads (Pods, Deployments, etc.).
* Often bound with Roles so apps can talk to the Kubernetes API securely.
* Example: A pod may use a ServiceAccount with a Role allowing it to read ConfigMaps.

---

## 🔁 RBAC Flow Diagram

```mermaid
flowchart TD
    A[User / Pod / ServiceAccount] --> B[RoleBinding / ClusterRoleBinding]
    B --> C[Role / ClusterRole]
    C --> D[Permissions <br/> (verbs: get • list • create • delete)]
    D --> E[Resources <br/> (pods • secrets • configmaps)]
```

---

## 📄 Example YAML Snippet

```yaml
# Role: allows reading pods
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: dev
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]

---
# RoleBinding: binds the Role to a ServiceAccount
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods-binding
  namespace: dev
subjects:
- kind: ServiceAccount
  name: dev-sa
  namespace: dev
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

---

## 📝 Notes

* Always follow the **principle of least privilege** → give only required permissions.
* Use **ClusterRoleBindings cautiously** (too broad = risky).
* Combine RBAC with **Network Policies** for stronger security.
* Debugging tip: Use `kubectl auth can-i <verb> <resource> --as <user>` to check permissions.

---

## 🔗 Useful Links

* [Kubernetes RBAC Docs](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
* [Service Accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
* [RBAC Authorization Guide](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#rbac)


