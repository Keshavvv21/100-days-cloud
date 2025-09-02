# Secure Docker Containers (user, seccomp, capabilities)

This guide outlines key methods to secure Docker containers using non-root users, seccomp profiles, and Linux capabilities. These techniques help harden your workloads against privilege escalation and runtime exploits.

## Run Containers as Non-Root User

Running containers as a non-root user prevents many attacks that rely on root privileges.

- **Create a user in your Dockerfile**:
  ```Dockerfile
  FROM alpine:latest
  RUN addgroup -S appgroup && adduser -S appuser -G appgroup
  USER appuser
  ```
  This ensures the main process in the container does not execute as root.[4][5]

- **Avoid privileged and root execution**:
  ```sh
  docker run --user 1001:1001 myimage
  ```
  Explicitly set UID/GID to nonzero values or use named users.[5][6]

## Apply Seccomp Profiles

Seccomp restricts syscall access to the Linux kernel. Use the default or custom seccomp profiles to limit dangerous syscalls.

- **Run with the Docker default seccomp profile** (recommended):
  ```sh
  docker run --security-opt seccomp=default.json myimage
  ```
  By default, Docker applies a secure profile unless you override it. Never disable seccomp unless necessary.[3]

- **Custom seccomp profiles**:
  Store your tailored profile and reference it with:
  ```sh
  docker run --security-opt seccomp=/path/to/profile.json myimage
  ```
  Customize for strict environments needing only limited kernel interaction.[3]

## Drop Unnecessary Linux Capabilities

Docker containers run with several Linux capabilities enabled by default. Drop everything not explicitly needed.

- **Drop all capabilities except those required**:
  ```sh
  docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE myimage
  ```
  Here, only port binding is permitted—ideal for web servers and APIs.[4][5]

- **Common options**:
  - `--cap-drop=ALL`: Removes all capabilities by default.
  - `--cap-add=<CAPABILITY>`: Restores only those required (e.g., `NET_BIND_SERVICE` for binding to privileged ports).[4]

## Additional Best Practices

- **No privilege escalation:**  
  Forbid acquiring new privileges even for process exec:
  ```sh
  docker run --security-opt=no-new-privileges:true myimage
  ```
  This blocks all attempts to escalate beyond initial rights.[5][4]

- **Use a read-only filesystem**:
  ```sh
  docker run --read-only myimage
  ```
  Prevent runtime tampering unless explicitly required.[3]

***

Implementing **non-root users**, strong **seccomp** restrictions, and tightly scoped **capabilities** makes your Docker containers significantly more secure against common attacks and misconfigurations.[6][5][4][3]

[1](https://www.tigera.io/learn/guides/container-security-best-practices/docker-security/)
[2](https://docs.docker.com/engine/security/)
[3](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
[4](https://spacelift.io/blog/docker-security)
[5](https://blog.gitguardian.com/how-to-improve-your-docker-containers-security-cheat-sheet/)
[6](https://www.aquasec.com/cloud-native-academy/container-security/container-security-best-practices/)
[7](https://snyk.io/blog/10-docker-image-security-best-practices/)
[8](https://docs.docker.com/build/building/best-practices/)
[9](https://www.sysdig.com/learn-cloud-native/container-security-best-practices)
[10](https://orca.security/resources/blog/container-security-best-practices/)

## Fixing Docker Overlay Issues

### 1. Clean Up Unused Containers, Images, and Volumes

- Remove stopped containers:
  ```sh
  docker rm -v $(docker ps -a -q -f status=exited)
  ```
- Remove dangling and unused images:
  ```sh
  docker rmi -f $(docker images -f "dangling=true" -q)
  ```
- Remove unused or dangling volumes:
  ```sh
  docker volume ls -qf dangling=true | xargs -r docker volume rm
  ```
- Run a complete prune (images, containers, networks, build cache):
  ```sh
  docker system prune -a -f
  docker builder prune -af
  ```
  This frees space and removes artifacts not tracked by current deployments.[2][3]

### 2. Stop Docker and Manually Remove Overlay Data (if necessary)

> Only if space is **still not reclaimed** and overlay files persist after prune.

- Stop Docker:
  ```sh
  sudo systemctl stop docker
  ```
- Remove overlay directories safely (this deletes ALL Docker state, including images and volumes):
  ```sh
  sudo rm -rf /var/lib/docker/overlay2/*
  # Or for legacy systems:
  sudo rm -rf /var/lib/docker/overlay/*
  ```
- Restart Docker:
  ```sh
  sudo systemctl start docker
  ```
  **Warning:** This workflow clears all Docker data. Back up anything critical first.[3][1][2]

### 3. Change/Validate Storage Driver and Filesystem Compatibility

- Some overlay issues are kernel or filesystem-specific. For example, XFS and older kernels may not support all overlay features.
- Check storage config with:
  ```sh
  docker info | grep "Storage Driver"
  ```
- To set or change storage driver (e.g., overlay2), update `/etc/docker/daemon.json`:
  ```json
  { "storage-driver": "overlay2" }
  ```
  Then restart Docker for changes to take effect.[4][5]

***

Addressing overlay issues combines **systematic cleanup** commands, **manual intervention** (when needed), and **storage driver compatibility checks**. Always validate kernel and Docker compatibility to prevent overlay problems from recurring.[5][2][4]

[1](https://forums.docker.com/t/some-way-to-clean-up-identify-contents-of-var-lib-docker-overlay/30604)
[2](https://stackoverflow.com/questions/31712266/how-to-clean-up-docker-overlay-directory)
[3](https://www.reddit.com/r/docker/comments/15r3xhb/huge_overlay2_any_way_to_prevent/)
[4](https://docs.docker.com/engine/storage/drivers/overlayfs-driver/)
[5](https://documentation.tricentis.com/qtest/10500/en/content/onpremise/installation/installation_guides/docker/change_docker_storage_driver_to_avoid_overlay_issue.htm)
[6](https://docs.docker.com/engine/network/drivers/overlay/)
[7](https://www.badcasserole.com/fixing-error-creating-overlay-mount-in-docker-on-windows/)
[8](https://github.com/moby/moby/issues/37338)
[9](https://discuss.airbyte.io/t/having-problem-with-docker-overlay-storage-driver/3888)
