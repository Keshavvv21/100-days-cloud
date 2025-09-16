
# ConfigMaps & Secrets in Kubernetes (Cloud)

***

## Overview

**ConfigMaps** and **Secrets** let Kubernetes applications manage external configuration and sensitive data securely, without hardcoding values into images. This separation enhances portability, security, and automation for cloud-native workloads.[5][7][9][1]

***

## Table of Contents

- What are ConfigMaps?
- What are Secrets?
- Key Differences
- Creating ConfigMaps & Secrets
- Usage in Pods
- Immutability
- Best Practices

***

## What are ConfigMaps?

ConfigMaps store **non-sensitive configuration** as key-value pairs—environment variables, configuration files, command-line arguments, etc. Data is injected into pods at runtime.[3][1][5]

Example:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  LOG_LEVEL: "INFO"
  SERVICE_URL: "http://example.com"
```

***

## What are Secrets?

Secrets store **sensitive data** (passwords, tokens, keys) encoded as base64 to provide a basic level of protection. Do not use ConfigMaps for sensitive content.[2][8][3][5]

Example:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  username: YWRtaW4=          # base64 for "admin"
  password: MWYyZDFlMmU2N2Rm  # base64 for "1f2d1e2e67df"
```

***

## Key Differences

| Aspect       | ConfigMap                        | Secret                     |
|--------------|----------------------------------|----------------------------|
| Usage        | Non-sensitive config             | Sensitive data             |
| Storage      | Plain text                       | Base64 encoded             |
| Example Data | App URLs, feature flags          | DB passwords, API tokens   |
| Security     | Not encrypted by default         | More secure, RBAC support  |

[7][3][5]

***

## Creating ConfigMaps & Secrets

- **From YAML manifest**  
  Use `kubectl apply -f configmap.yaml` or `kubectl apply -f secret.yaml`

- **Direct from CLI**  
  ```
  kubectl create configmap app-config --from-literal=LOG_LEVEL=INFO
  kubectl create secret generic app-secret --from-literal=password=s3cr3t
  ```

- **From files**  
  ```
  kubectl create configmap app-config --from-file=config.txt
  kubectl create secret generic app-secret --from-file=creds.txt
  ```


***

## Usage in Pods

Inject values via environment variables or as files:

```yaml
envFrom:
  - configMapRef:
      name: app-config
  - secretRef:
      name: app-secret
```
or as mounted volumes.

[1][5]

***

## Immutability

You can make ConfigMaps/Secrets immutable (Kubernetes v1.21+) for **performance and safety**—useful in clouds at scale :[7][1]

```yaml
immutable: true
```

***

## Best Practices

- Use ConfigMaps for non-sensitive settings only.
- Store passwords, tokens, and keys in Secrets—never in ConfigMaps.
- Limit access to Secrets via RBAC.
- Consider enabling encryption at rest for Secrets in cloud providers.
- Make infrequently changing ConfigMaps/Secrets immutable for performance.
- Do not commit Secrets files to version control.

***

## References

- Kubernetes Docs: ConfigMap , Secret[2][1]
- Devtron Blog[3]
- Groundcover Blog[5]
- Aditya Samant Blog[7]
- Kubernetes Tasks: Managing Secrets[8]

***

This template can be tailored for particular cloud providers or workloads by expanding usage examples and RBAC setup as needed.

[1](https://kubernetes.io/docs/concepts/configuration/configmap/)
[2](https://kubernetes.io/docs/concepts/configuration/secret/)
[3](https://devtron.ai/blog/kubernetes-configmaps-secrets/)
[4](https://www.gravitee.io/blog/kubernetes-configurations-secrets-configmaps)
[5](https://www.groundcover.com/blog/kubernetes-configmap)
[6](https://cloud.theodo.com/en/blog/helm-kubernetes-configmap-secret)
[7](https://www.adityasamant.dev/post/immutable-configmaps-and-secrets-in-kubernetes-a-complete-guide)
[8](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-config-file/)
[9](https://learning.sap.com/learning-journeys/developing-applications-in-sap-btp-kyma-runtime/explaining-configmaps-and-secrets_f39f9cc6-2576-4c9f-bab8-8b81aebf3c5a)
