## 🧭  CSI Secret Drivers**

```markdown
# 🔐 CSI Secret Drivers – Secure Secrets Management in Kubernetes

## 📘 Overview

The **Container Storage Interface (CSI) Secret Drivers** enable Kubernetes workloads to securely access secrets, keys, and certificates stored in external secret managers (such as **AWS Secrets Manager**, **Azure Key Vault**, **Google Secret Manager**, or **HashiCorp Vault**) — without embedding them directly in Kubernetes Secrets.

This approach ensures **stronger security**, **auditability**, and **dynamic secret rotation**.

---

## 🧩 Why Use CSI Secret Drivers?

### 🔑 Traditional Method:
- Secrets are stored in Kubernetes Secrets (Base64 encoded, not encrypted).
- Rotation is manual and prone to leaks.

### 🚀 CSI Driver Method:
- Secrets are fetched directly from external secret managers at runtime.
- No plaintext secrets are stored in Kubernetes.
- Supports auto-refresh of secrets and certificates.
- Enforces **least privilege** access with IAM or RBAC.

---

## ⚙️ Architecture

```

+---------------------------+
|   External Secret Store   |
|  (AWS / Azure / Vault)    |
+-----------+---------------+
|
| Secret Provider Class (mapping)
v
+---------------------------+
|   CSI Secret Driver Pod   |
|  - Fetches secrets        |
|  - Mounts to Pod volume   |
+-----------+---------------+
|
v
+---------------------------+
|     Application Pod       |
|  - Reads secret as file   |
+---------------------------+

````

---

## 🧰 Prerequisites

- Kubernetes cluster (v1.20+)
- kubectl configured
- Helm (for installation)
- Access to an external secret manager  
  (e.g., AWS, Azure, GCP, or Vault)

---

## 🏗️ Installation

### Option 1: Using Helm (Recommended)

```bash
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system
````

Verify installation:

```bash
kubectl get pods -n kube-system | grep csi
```

---

## 🔧 Create a SecretProviderClass

This object defines **which external secrets** to mount and **how**.

### Example (Azure Key Vault)

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-keyvault-secrets
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    keyvaultName: "my-keyvault"
    tenantId: "<tenant-id>"
    objects: |
      array:
        - |
          objectName: app-secret
          objectType: secret
          objectVersion: ""
```

---

## 📦 Mounting Secrets in Pods

Attach the `SecretProviderClass` to your Pod spec:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sample-app
spec:
  containers:
    - name: app
      image: nginx
      volumeMounts:
        - name: secrets-store
          mountPath: "/mnt/secrets"
          readOnly: true
  volumes:
    - name: secrets-store
      csi:
        driver: secrets-store.csi.k8s.io
        readOnly: true
        volumeAttributes:
          secretProviderClass: "azure-keyvault-secrets"
```

Now the secret will appear in your container under `/mnt/secrets/app-secret`.

---

## 🔁 Optional: Sync to Kubernetes Secret

To also create a Kubernetes Secret automatically:

```yaml
secretObjects:
  - secretName: app-secret-sync
    type: Opaque
    data:
      - objectName: app-secret
        key: password
```

This allows legacy apps or controllers (that expect Kubernetes Secrets) to still function.

---

## 🧠 Supported Providers

| Provider                                  | CSI Driver Repo                           | Documentation                                                                        |
| ----------------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------------ |
| **Azure Key Vault**                       | `secrets-store-csi-driver-provider-azure` | [Docs](https://github.com/Azure/secrets-store-csi-driver-provider-azure)             |
| **AWS Secrets Manager / Parameter Store** | `secrets-store-csi-driver-provider-aws`   | [Docs](https://github.com/aws/secrets-store-csi-driver-provider-aws)                 |
| **Google Secret Manager**                 | `secrets-store-csi-driver-provider-gcp`   | [Docs](https://github.com/GoogleCloudPlatform/secrets-store-csi-driver-provider-gcp) |
| **HashiCorp Vault**                       | `secrets-store-csi-driver-provider-vault` | [Docs](https://github.com/hashicorp/secrets-store-csi-driver-provider-vault)         |

---

## 🧪 Validate

After deploying your Pod:

```bash
kubectl exec -it sample-app -- cat /mnt/secrets/app-secret
```

You should see the secret value fetched from your external secret store.

---

## 🧼 Cleanup

```bash
kubectl delete pod sample-app
kubectl delete secretproviderclass azure-keyvault-secrets
helm uninstall csi-secrets-store -n kube-system
```

---

## ✅ Benefits Recap

* 🔐 Secrets never stored in etcd or ConfigMaps.
* 🔄 Automatic secret rotation.
* ⚙️ Multi-cloud compatible.
* 🧭 Works with Kubernetes RBAC and IAM roles.
* 🧱 Supports file-based mounts and synced K8s Secrets.

---

## 📅 Project Context

**Day 93 of 100 Days of DevOps**
**Topic:** CSI Secret Drivers – External Secrets Integration
**Author:** Keshav Velhal
**Date:** November 2025

> “Security is not about locking things away — it’s about controlling who holds the key.” 🔑

---

```

---

```
