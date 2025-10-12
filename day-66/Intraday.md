# Kubernetes Upgrade Plan — Zero Downtime

## Goals

* Upgrade Kubernetes version (control plane + kubelets) with **zero or minimal downtime**.
* Ensure workloads remain available using Kubernetes primitives (PodDisruptionBudget, readiness probes, rolling updates).
* Provide step-by-step commands, YAML examples, and rollback strategy (etcd snapshot + Git rollback + `kubectl rollout undo`).

---

## High-level architecture flow (Mermaid)

```mermaid
flowchart LR
  A[Prepare & Backup] --> B[Upgrade Control Plane Master-1]
  B --> C[Validate Control Plane]
  C --> D[Upgrade other Control Plane nodes]
  D --> E[Drain & Upgrade Worker Node (1..N)]
  E --> F[Upgrade kubelet & kube-proxy on Node]
  F --> G[Uncordon Node]
  G --> H[Validate Workloads]
  H --> I[Post-upgrade Health Checks & Cleanup]
```

---

## Prerequisites & Safety

* **Back up etcd** (snapshot) *before any control-plane change*.
* Ensure `kubectl` points to the expected cluster (`kubectl config current-context`).
* Ensure control plane nodes & workers have SSH access and package repos configured.
* Check compatibility matrix of kubeadm/kubelet/kubectl with the new Kubernetes version.
* Test upgrade in staging cluster identical to production.
* Communicate scheduled window to stakeholders.

---

## Backup (etcd) — critical

If using static pod etcd (kubeadm default):

```bash
# on a control-plane node
ETCDCTL_API=3 etcdctl snapshot save /tmp/etcd-snapshot-$(date +%F-%T).db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/peer.crt \
  --key=/etc/kubernetes/pki/etcd/peer.key

# copy snapshot to safe storage
scp /tmp/etcd-snapshot-*.db backup-server:/backups/etcd/
```

If using managed etcd (EKS/GKE), use cloud provider snapshot mechanisms.

---

## Prepare Cluster for Zero Downtime

1. Ensure Deployments use `RollingUpdate` strategy and have **readiness probes**.
2. Add **PodDisruptionBudgets (PDB)** for critical apps.
3. Ensure DaemonSets set `updateStrategy: RollingUpdate` if they are safe to roll.
4. Ensure **vertical/horizontal pod autoscaling** is tuned and not triggered unexpectedly.

### Sample PodDisruptionBudget

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: webapp-pdb
spec:
  minAvailable: 80%
  selector:
    matchLabels:
      app: webapp
```

### Sample Deployment (readiness + liveness + rolling update)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  replicas: 6
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
        - name: webapp
          image: myregistry/webapp:1.2.3
          ports:
            - containerPort: 8080
          readinessProbe:
            httpGet:
              path: /healthz
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 5
          livenessProbe:
            httpGet:
              path: /live
              port: 8080
            initialDelaySeconds: 15
            periodSeconds: 10
```

---

## Control Plane (kubeadm) Upgrade — Typical flow (HA and single master)

> **Important**: If your cluster is managed (EKS/GKE/AKS), follow provider-specific upgrade path.

1. **Check current versions**

```bash
kubectl version --short
kubeadm version
```

2. **Plan target version** — pick the next stable minor release (e.g., 1.24 → 1.25). Verify compatibility.

3. **Upgrade kubeadm binary on the first control-plane node**

```bash
# Debian/Ubuntu example
sudo apt-get update
sudo apt-get install -y kubeadm=<target-version>-00
```

4. **Run kubeadm upgrade plan**

```bash
sudo kubeadm upgrade plan
```

5. **Apply control-plane upgrade on the first master**

```bash
sudo kubeadm upgrade apply v1.25.3 --control-plane --yes
```

6. **Upgrade kubelet & kubectl on that control-plane node**

```bash
sudo apt-get install -y kubelet=<target-version>-00 kubectl=<target-version>-00
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

7. **Repeat for other control-plane nodes**

* SSH into each remaining control-plane node and upgrade `kubeadm` → run `kubeadm upgrade node` or follow the kubeadm instructions for HA.

8. **Verify control plane health**

```bash
kubectl get nodes
kubectl get cs
kubectl get pods -n kube-system
```

---

## Worker Node Upgrade — Zero Downtime Pattern

For each worker node (one at a time):

1. **Cordon node**

```bash
kubectl cordon <node>
```

2. **Drain node (respecting daemonsets and local data)**

```bash
kubectl drain <node> --ignore-daemonsets --delete-local-data --grace-period=60 --timeout=10m
```

*Notes:*

* `--ignore-daemonsets` so DaemonSet pods remain.
* `--delete-local-data` only if safe. If not safe, migrate local-data first.
* tune `--grace-period` to let pods terminate gracefully.

3. **Upgrade kubeadm, kubelet & kubectl on the worker**

```bash
# upgrade packages
sudo apt-get update
sudo apt-get install -y kubeadm=<target-version>-00
sudo kubeadm upgrade node
sudo apt-get install -y kubelet=<target-version>-00 kubectl=<target-version>-00
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

Alternatively, on some systems you only need `kubeadm config migrate` and update system packages.

4. **Uncordon node**

```bash
kubectl uncordon <node>
```

5. **Validate node & workloads**

```bash
kubectl get nodes
kubectl get pods -o wide --field-selector spec.nodeName=<node>
kubectl describe node <node>
```

Repeat for all worker nodes **one at a time**.

---

## Kube-Proxy & CNI

* Upgrade `kube-proxy` DaemonSet to the new image matching the cluster version if required.
* Upgrade CNI plugins (calico/weave/flannel) as per vendor instructions — usually by applying manifest updates and rolling DaemonSet pods.

Example upgrade for kube-proxy (kubeadm-managed):

```bash
kubectl -n kube-system set image ds/kube-proxy kube-proxy=k8s.gcr.io/kube-proxy:v1.25.3
```

---

## Zero-Downtime Best Practices (summary)

* Use **PodDisruptionBudgets** to limit simultaneous evictions.
* Keep `maxUnavailable` low (1) and `maxSurge` >= 1 for Deployments.
* Have **readiness probes** so traffic routes only to healthy pods.
* Use **multiple worker nodes** across AZs/racks for redundancy.
* Upgrade workers serially, not in parallel.
* Use **canary** Deployments for critical system components.

---

## Rollback Strategy

1. **If control plane upgrade fails**: restore etcd snapshot (advanced — follow `etcdctl snapshot restore` flow, adjusting static pod manifests and certs). Test restore on a separate cluster before production restore.

2. **If application update / deployment fails**: use `kubectl rollout undo`:

```bash
kubectl rollout undo deployment/my-deploy -n my-ns
```

3. **Git rollback** ("unclone"):

```bash
# clone repo
git clone git@github.com:org/repo.git
cd repo
# tag current production commit
git tag prod-before-upgrade
# if you need to revert changes pushed earlier
git revert <commit-hash>    # creates a new commit that undoes changes
# or reset to tag (force push to branch if necessary)
git reset --hard prod-before-upgrade
git push --force origin main
```

> "Unclone" is not a standard Git op — to undo, you revert, reset, or check out a prior tag/commit and push the corrected state.

---

## Example kubeadm-config (partial)

```yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: v1.25.3
controlPlaneEndpoint: "lb.example.com:6443"
networking:
  podSubnet: "10.244.0.0/16"
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "iptables"
```

Use `kubeadm upgrade apply --config kubeadm-config.yaml` to apply when needed.

---

## Useful commands checklist (compact)

```bash
# pre-upgrade
kubectl version --short
kubectl get nodes -o wide
kubectl get pods -A
kubectl get pdb -A

# backup etcd (static pod)
ETCDCTL_API=3 etcdctl snapshot save /tmp/snap.db --endpoints=https://127.0.0.1:2379 --cacert=... --cert=... --key=...

# control plane
sudo apt-get update && sudo apt-get install -y kubeadm=<ver>-00
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.25.3 --yes
sudo apt-get install -y kubelet=<ver>-00 kubectl=<ver>-00
sudo systemctl daemon-reload && sudo systemctl restart kubelet

# worker rolling upgrade
kubectl cordon node-1
kubectl drain node-1 --ignore-daemonsets --delete-local-data --grace-period=60 --timeout=10m
# upgrade packages on node via SSH
kubectl uncordon node-1

# post checks
kubectl get cs
kubectl get pods -n kube-system
kubectl get nodes
```

---

## Post-upgrade validation & tests

* `kubectl get nodes` (all Ready)
* `kubectl get pods -A` (no CrashLoopBackOff/ErrImagePull)
* Application smoke tests (HTTP health endpoints)
* Monitor metrics (Prometheus), alerts, and logs

---

## Links & Further Reading (offline reminder)

* kubeadm upgrade docs: kubeadm official docs (search `kubeadm upgrade apply`)
* etcd snapshot & restore: etcdctl snapshot documentation
* CNI vendor upgrade docs (Calico/Flannel/Weave)

---

## Appendix — Sample Automation (bash pseudo-script)

> Run on a control-plane node for worker upgrades (or via Ansible)

```bash
#!/usr/bin/env bash
set -euo pipefail
TARGET_VERSION="v1.25.3"
NODES=(node-1 node-2 node-3)
for n in "${NODES[@]}"; do
  echo "Upgrading $n"
  kubectl cordon $n
  kubectl drain $n --ignore-daemonsets --delete-local-data --grace-period=60 --timeout=10m
  ssh ubuntu@$n "sudo apt-get update && sudo apt-get install -y kubeadm=${TARGET_VERSION#v}-00 kubelet=${TARGET_VERSION#v}-00 kubectl=${TARGET_VERSION#v}-00 && sudo systemctl daemon-reload && sudo systemctl restart kubelet"
  kubectl uncordon $n
  # quick validation
  kubectl get nodes | grep $n
done
```

---

