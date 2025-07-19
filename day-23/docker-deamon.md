# Docker Daemon and Docker Systemd Unit

This README explains the concepts of the Docker Daemon and Docker Systemd Unit, and shows how to create and manage Docker as a service using systemd on Linux systems.

## What is the Docker Daemon?

The **Docker Daemon** (`dockerd`) is the server-side component of Docker. It runs as a background process on your machine and is responsible for managing Docker containers, images, networks, volumes, and the entire container lifecycle. The Docker Daemon listens for Docker API requests coming from clients, such as the Docker CLI (`docker` command), and handles all container-related operations.

- **Daemon name:** `dockerd`
- **Role:** Core service that creates, runs, and manages containers

> The Docker daemon listens for Docker API requests and manages Docker objects such as images, containers, networks, and volumes.

Learn more:  
- [What is Docker Daemon (dockerd)? - Docker Docs]

## What is a Docker Systemd Unit?

A **Systemd Unit** is a configuration file used by the `systemd` init system on Linux to manage and control system services. A Docker Systemd Unit file (commonly named `docker.service`) defines how the Docker Daemon should start, stop, restart, and be monitored as a background service.

- **Location:** `/etc/systemd/system/docker.service`
- **Purpose:** Makes Docker start automatically at boot, easily controllable via `systemctl`

Learn more:  
- [Systemd Service Unit Documentation]

## Example: Creating a Docker Systemd Unit

Below is a typical `docker.service` unit file. You can create/modify this file to manage Docker with systemd.

```ini
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service containerd.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always

# Limits
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
```

## Steps to Set Up the Docker Systemd Unit

1. **Create the Unit File**
   - Save the above contents as `/etc/systemd/system/docker.service`.

2. **Reload systemd:**
   ```sh
   sudo systemctl daemon-reload
   ```

3. **Start and Enable Docker Daemon Service:**
   ```sh
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

4. **Check the Service Status:**
   ```sh
   sudo systemctl status docker
   ```

5. **View Logs:**
   ```sh
   sudo journalctl -u docker
   ```

## Additional Resources

- [Docker Daemon Reference]
- [Systemd Service Unit Documentation]
- [Control Docker with systemd - Docker Docs]

## Useful Links

- Docker Daemon official documentation: https://docs.docker.com/engine/reference/commandline/dockerd/
- Systemd Service Unit overview: https://www.freedesktop.org/software/systemd/man/systemd.service.html
- Setting up Docker with systemd: https://docs.docker.com/config/daemon/systemd/

: https://docs.docker.com/engine/reference/commandline/dockerd/
: https://www.freedesktop.org/software/systemd/man/systemd.service.html
: https://docs.docker.com/config/daemon/systemd/
