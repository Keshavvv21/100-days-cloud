# Kubernetes Probes — Liveness, Readiness, Startup

A concise but practical README covering Kubernetes probes (Liveness, Readiness, Startup). Includes examples, recommended settings, troubleshooting, and diagrams.

---

## Table of Contents

1. Overview
2. Probe types & differences
3. Fields & recommended defaults
4. Examples (HTTP, TCP, Exec)
5. Deployment examples (with probes)
6. Probe lifecycle diagram (Mermaid)
7. Debugging & troubleshooting
8. Best practices
9. References / further reading

---

## 1. Overview

Kubernetes probes are health checks that the kubelet uses to determine the status of containers. They help ensure traffic is only routed to healthy pods and that unhealthy containers are restarted.

Three standard probe types:

* **Liveness**: If this fails, the kubelet kills the container and restarts it. Use this to detect deadlocks or unrecoverable states.
* **Readiness**: If this fails, the pod is removed from service endpoints (won't receive requests) but the container is not killed.
* **Startup**: Used to determine if a container has successfully started. When defined, startup probe disables liveness/readiness until it succeeds.

## 2. Probe Types & Differences

* **LivenessProbe**: Ensures container is alive. Failures cause a restart.
* **ReadinessProbe**: Ensures container is ready to accept traffic. Failures cause the pod to be removed from Service endpoints.
* **StartupProbe**: Detects slow starting containers. If present, kubelet waits for it to succeed before running liveness/readiness probes.

Example behaviours:

* Use **startup** for apps that take long to initialize (e.g., JVM warm-up, migrations).
* Use **liveness** to recover from deadlocks or infinite loops.
* Use **readiness** for temporary unavailability (e.g., connection to DB lost until reconnected).

## 3. Probe fields & recommended defaults

Common fields (all probes):

* `initialDelaySeconds`: time to wait before the first probe (seconds)
* `periodSeconds`: how often to perform the probe (seconds)
* `timeoutSeconds`: time allowed for the probe to respond
* `successThreshold`: minimum consecutive successes for the probe to be considered successful after having failed
* `failureThreshold`: minimum consecutive failures for the probe to be considered failed

Defaults (Kubernetes defaults if unspecified):

* `periodSeconds`: 10
* `timeoutSeconds`: 1
* `failureThreshold`: 3
* `successThreshold`: 1

Recommended starting values (tune per app):

* `readiness` — `initialDelaySeconds: 5`, `periodSeconds: 10`, `timeoutSeconds: 1`, `failureThreshold: 3`
* `liveness` — `initialDelaySeconds: 30`, `periodSeconds: 20`, `timeoutSeconds: 2`, `failureThreshold: 3`
* `startup` — `initialDelaySeconds: 0`, `periodSeconds: 10`, `timeoutSeconds: 2`, `failureThreshold: 60` (gives \~10 minutes to start if failureThreshold=60 & periodSeconds=10 — tune as needed)

> Tip: err on the side of longer timeouts and higher failureThresholds for JVM/.NET apps or apps doing heavy initialization.

## 4. Probe types: HTTP, TCP, Exec — Examples

### HTTP GET probe (common for web apps)

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
    httpHeaders:
      - name: X-Health-Check
        value: kube
  initialDelaySeconds: 30
  periodSeconds: 20
  timeoutSeconds: 3
  failureThreshold: 3
```

### TCP Socket probe (checks port open)

```yaml
readinessProbe:
  tcpSocket:
    port: 6379
  initialDelaySeconds: 5
  periodSeconds: 10
  timeoutSeconds: 1
  failureThreshold: 3
```

### Exec probe (run a command inside container)

```yaml
startupProbe:
  exec:
    command:
      - /bin/sh
      - -c
      - test -f /tmp/ready && echo ready
  initialDelaySeconds: 5
  periodSeconds: 10
  timeoutSeconds: 2
  failureThreshold: 30
```

### Using gRPC

Kubernetes doesn't provide a first-class `grpc` probe type. Use an HTTP/HTTP2 endpoint if you expose a gRPC health check over HTTP/HTTP2, or use an exec probe that calls a gRPC health-check client.

## 5. Full Deployment Example (Deployment + Service)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: example-app
  template:
    metadata:
      labels:
        app: example-app
    spec:
      containers:
        - name: web
          image: myregistry/example-app:1.2.3
          ports:
            - containerPort: 8080
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 10
            timeoutSeconds: 2
            failureThreshold: 3
          livenessProbe:
            httpGet:
              path: /healthz
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 20
            timeoutSeconds: 3
            failureThreshold: 3
---
apiVersion: v1
kind: Service
metadata:
  name: example-app
spec:
  selector:
    app: example-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: ClusterIP
```

### Example with startupProbe to avoid early restarts during long boot

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 20
  timeoutSeconds: 3
  failureThreshold: 3
startupProbe:
  exec:
    command:
      - /bin/sh
      - -c
      - curl -fsS http://localhost:8080/health/startup || exit 1
  periodSeconds: 10
  failureThreshold: 30
```

With `startupProbe` defined, liveness/readiness are disabled until the startup probe succeeds.

## 6. Probe lifecycle diagram (Mermaid)

## 6. Probe lifecycle diagram (Mermaid)

```mermaid
flowchart TD
  A[Container starts] --> B{StartupProbe defined?}
  B -->|Yes| C[Run StartupProbe]
  B -->|No| D[Run Liveness & Readiness]
  C -->|Startup success| D
  C -->|Startup failure threshold| E[Container restart]
  D --> F{Readiness success?}
  F -->|Yes| G[Pod in Service endpoints]
  F -->|No| H[Pod removed from Service]
  D --> I{Liveness success?}
  I -->|No| E
  I -->|Yes| D

## 7. Debugging & Troubleshooting

Useful commands:

```bash
# Show pod details and probe events
kubectl describe pod <pod-name>

# View pod logs
kubectl logs <pod-name> -c <container-name>

# Exec into pod and run probe target checks
kubectl exec -it <pod-name> -- /bin/sh
# e.g., curl localhost:8080/healthz

# Watch pod restart counts
kubectl get pods -w

# Show events (including why container was killed):
kubectl get events --sort-by=.metadata.creationTimestamp
```

Common troubleshooting steps:

* If liveness fails but the endpoint works via `kubectl exec` -> check networking (localhost vs 0.0.0.0), ports, path, or if health endpoint requires auth.
* If readiness keeps failing -> investigate startup order (DB connection), or whether the probe is too strict.
* Check timeouts — long response times (GC pauses, slow DB) may need larger `timeoutSeconds` and `failureThreshold`.

## 8. Best Practices

* Expose lightweight, idempotent health endpoints (e.g., `/healthz`, `/ready`) that return quickly.
* Keep probes simple: ideally check only what is necessary (for readiness, that app can serve requests; for liveness, app not deadlocked).
* Use `startupProbe` for slow-starting apps to prevent premature restarts.
* Prefer HTTP GET for web services, exec for complex checks, and tcpSocket for simple port checks.
* Avoid heavy-weight checks (e.g., large DB queries) in probes — these can overload dependencies.
* Monitor restartCount and events — they often highlight probe misconfiguration.

## 9. Quick Cheatsheet

* Use `kubectl describe pod <pod>` to see probe failures and reasons.
* `kubectl exec` + `curl` to manually test endpoints.
* If using `startupProbe`, liveness/readiness will wait until success.
* Tune `initialDelaySeconds` and `failureThreshold` for app-specific startup times.

---

## Appendix: Example health endpoints (Node.js & Python)

### Node.js minimal express health endpoints

```js
const express = require('express')
const app = express()

app.get('/healthz', (req, res) => res.send('ok'))
app.get('/ready', (req, res) => {
  // e.g. check DB connection cached state
  res.send('ready')
})

app.listen(8080)
```

### Python FastAPI simple health endpoints

```py
from fastapi import FastAPI
app = FastAPI()

@app.get('/healthz')
async def healthz():
    return {'status': 'ok'}

@app.get('/ready')
async def ready():
    # perform lightweight checks
    return {'status': 'ready'}
```

---

*End of document.*
