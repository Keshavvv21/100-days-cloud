# Deployment Strategies in Kubernetes — Rolling Update vs Blue-Green

This document explains and demonstrates two common deployment strategies in Kubernetes:

* **Rolling Update** — Gradual replacement of old pods with new pods (built into `Deployment`).
* **Blue-Green** — Run two parallel environments (`blue` and `green`) and switch traffic from one to the other (commonly done by switching a `Service` selector).

---

## Quick definitions

**Rolling Update**
A Kubernetes `Deployment` updates pods incrementally: new replicas are created and old ones terminated according to the `strategy.rollingUpdate` parameters (`maxUnavailable`, `maxSurge`). It aims for zero downtime while ensuring a controlled ramp-up and roll-back via `kubectl rollout`.

**Blue-Green**
Two separate environments (deployments) run concurrently — e.g. `app-blue` (current) and `app-green` (new). A Service routes traffic to one of these by label selector. When the green environment is verified, you switch the Service to green — immediate traffic switch and simple rollback by switching back.

---

## High-level comparison

| Aspect          |                                                       Rolling Update | Blue-Green                                                           |
| --------------- | -------------------------------------------------------------------: | -------------------------------------------------------------------- |
| Downtime        |                                Usually zero (if readiness probes OK) | Zero if switch is atomic                                             |
| Traffic control | Gradual, can't easily split by percentage without additional tooling | All-or-nothing (unless combined with load balancer/ingress features) |
| Resource usage  |             Uses same resources (only brief spike if `maxSurge` > 0) | Requires double resources during cutover                             |
| Rollback        |                   `kubectl rollout undo`, automatic revision history | Switch service selector back (very fast)                             |
| Complexity      |                                                       Simple, native | Slightly more operational overhead but safer for big changes         |
| Best for        |                                      Minor changes, frequent deploys | Major releases, schema changes, validated staging                    |

---

## Architecture diagrams

### Rolling Update — Flowchart (Mermaid)

```mermaid
flowchart TB
  A[User triggers new image / manifest] --> B[Deployment controller sees new ReplicaSet]
  B --> C[Create new Pods (up to maxSurge)]
  C --> D[New Pods pass readinessProbe?]
  D -- yes --> E[Traffic routed to new Pods; old Pods terminated (respect maxUnavailable)]
  D -- no --> F[Wait or pause rollout; mark failing]
  E --> G[Rollout finishes -> new ReplicaSet becomes active]
  F --> H[Rollback or fix and re-apply]
```

### Blue-Green — Flowchart (Mermaid)

```mermaid
flowchart TB
  A[User triggers new image / green manifest] --> B[Create app-green Deployment & ReplicaSet]
  B --> C[app-green pods start and pass readinessProbe?]
  C -- yes --> D[Run tests / smoke tests against app-green (staging endpoint)]
  D -- success --> E[Switch Service selector from blue -> green (atomic)]
  E --> F[Traffic now to app-green; app-blue retained as backup]
  D -- fail --> G[Destroy app-green or fix & redeploy]
  F --> H[If issue -> switch selector back to blue (rollback)]
```

### Component architecture (text)

* `Deployment` (rolling update): 1 `Deployment` → `ReplicaSet` → Pods → `Service` → Clients
* `Blue-Green`: `Deployment` `app-blue` + `Deployment` `app-green`; one `Service` whose `selector` points to either blue or green labels; optional Ingress/LoadBalancer in front.

---

## Example YAMLs

### 1) Rolling Update Deployment (recommended default)

`deployment-rolling.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  labels:
    app: myapp
spec:
  replicas: 4
  selector:
    matchLabels:
      app: myapp
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1    # at most 1 pod unavailable during update
      maxSurge: 1          # create at most 1 extra pod during update
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myregistry/myapp:1.2.0
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /healthz
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /livez
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 10
```

`service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-svc
spec:
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

**Commands:**

```bash
kubectl apply -f deployment-rolling.yaml
kubectl apply -f service.yaml

# Update image (start rolling update)
kubectl set image deployment/myapp myapp=myregistry/myapp:1.2.1

# Watch rollout
kubectl rollout status deployment/myapp

# Check rollout history
kubectl rollout history deployment/myapp

# Rollback (if needed)
kubectl rollout undo deployment/myapp
```

**Notes:** `maxSurge` and `maxUnavailable` control speed & resource spike.

---

### 2) Blue-Green (Service selector switching)

`deployment-blue.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-blue
  labels:
    app: myapp
    env: blue
spec:
  replicas: 4
  selector:
    matchLabels:
      app: myapp
      env: blue
  template:
    metadata:
      labels:
        app: myapp
        env: blue
    spec:
      containers:
      - name: myapp
        image: myregistry/myapp:1.2.0
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /healthz
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
```

`deployment-green.yaml` *(new release)*

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-green
  labels:
    app: myapp
    env: green
spec:
  replicas: 4
  selector:
    matchLabels:
      app: myapp
      env: green
  template:
    metadata:
      labels:
        app: myapp
        env: green
    spec:
      containers:
      - name: myapp
        image: myregistry/myapp:1.3.0   # new version
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /healthz
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
```

`service-blue.yaml` (single service that points to blue initially)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-svc
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: myapp
    env: blue
```

**Commands / Workflow:**

```bash
# 1. Deploy the blue environment (current)
kubectl apply -f deployment-blue.yaml
kubectl apply -f service-blue.yaml

# 2. Deploy the green environment (new version)
kubectl apply -f deployment-green.yaml

# 3. Verify green readiness, run smoke tests against green pods:
# (Either port-forward to a green pod or use a temporary service/Ingress that points to env=green)
kubectl get pods -l app=myapp,env=green
kubectl exec -it <one-green-pod> -- curl -fsS http://localhost:80/healthz

# 4. If green is OK, atomically switch Service selector to green:
kubectl patch service myapp-svc -p '{"spec": {"selector": {"app":"myapp", "env":"green"}}}'

# 5. Confirm traffic now goes to green:
kubectl get endpoints myapp-svc
# Optionally monitor application logs/metrics for traffic distribution

# 6. Keep blue as backup: if issues -> switch back
kubectl patch service myapp-svc -p '{"spec": {"selector": {"app":"myapp", "env":"blue"}}}'

# 7. Cleanup (once green is validated for long enough)
kubectl delete deployment myapp-blue
```

**Alternative safe switch**: replace Service manifest and `kubectl apply -f service-green.yaml` where `service-green.yaml` has selector `env: green` — `kubectl apply` does an atomic change too.

---

## Advanced notes & best practices

### Readiness & Liveness

* **readinessProbe** must reflect when the app can accept real traffic. Without readiness, the Service may route user requests to an unready pod causing errors.
* Use readiness probes for rolling updates and blue-green staging checks.
* Liveness restarts unhealthy pods.

### Database migrations & schema changes

* Blue-Green is safer if you need to:

  * run DB migrations that are not backward-compatible (use feature flags or multi-version-safe migrations).
  * keep the old version online during DB transition.
* For rolling updates, ensure DB changes are **backward compatible**.

### Zero-downtime caveats

* External load balancers or Ingress controllers may cache endpoints — ensure they honor endpoint changes quickly.
* Warm caches and connection draining matter: configure `terminationGracePeriodSeconds` and `preStop` hook if you need connection draining.

### Canary & traffic splitting

* For percentage-based gradual traffic shifting, use advanced tools:

  * Service mesh (Istio, Linkerd), Ingress with traffic-splitting features, or external LB capabilities.
  * Blue-Green + traffic splitting can be implemented by changing weights in a Gateway.

### Rollback

* Rolling Update: `kubectl rollout undo deployment/<name>`
* Blue-Green: switch `Service` selector back to old deployment or reapply previous service manifest.

---

## Handy `kubectl` commands (summary)

```bash
# Apply manifests
kubectl apply -f deployment-rolling.yaml
kubectl apply -f service.yaml

# Update container image (rolling)
kubectl set image deployment/myapp myapp=myregistry/myapp:1.2.1
kubectl rollout status deployment/myapp
kubectl rollout history deployment/myapp
kubectl rollout undo deployment/myapp

# Blue-Green operations
kubectl apply -f deployment-blue.yaml
kubectl apply -f deployment-green.yaml
# Switch service from blue -> green
kubectl patch service myapp-svc -p '{"spec": {"selector": {"app":"myapp", "env":"green"}}}'
# Rollback to blue
kubectl patch service myapp-svc -p '{"spec": {"selector": {"app":"myapp", "env":"blue"}}}'

# Check pod readiness & endpoints
kubectl get pods -l app=myapp,env=green
kubectl get endpoints myapp-svc
kubectl logs -f deployment/myapp-green
```

---

## When to choose which

* **Choose Rolling Update**:

  * Frequent deployments, small changes.
  * Limited cluster resources.
  * Backward-compatible changes only.

* **Choose Blue-Green**:

  * Big releases requiring full verification (smoke/integration tests).
  * Risky database or API contract changes (when you need quick rollback).
  * You can afford temporary doubled resources.

---

## Useful links

* Kubernetes official docs — Deployments & rolling updates:
  [https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment)
* Blue-Green Deployment (concept explanation) — Martin Fowler:
  [https://martinfowler.com/bliki/BlueGreenDeployment.html](https://martinfowler.com/bliki/BlueGreenDeployment.html)
* Kubernetes Services and Endpoints:
  [https://kubernetes.io/docs/concepts/services-networking/service/](https://kubernetes.io/docs/concepts/services-networking/service/)
* Canary & traffic shifting with Istio (if you need percentage split):
  [https://istio.io/latest/docs/tasks/traffic-management/traffic-shifting/](https://istio.io/latest/docs/tasks/traffic-management/traffic-shifting/)

---

## Troubleshooting checklist

1. If pods never become `Ready`:

   * Inspect `kubectl describe pod <pod>` for events.
   * Check readiness path, environment variables, configmaps and secrets.

2. If rolling update seems stuck:

   * `kubectl rollout status deployment/<name>` shows progress.
   * Inspect pod logs, readiness probe failures, or insufficient resources.

3. If blue-green switch doesn't route traffic:

   * Check `kubectl get endpoints <service>` if endpoints are present.
   * Check network policies, Ingress/LoadBalancer caching.

---


