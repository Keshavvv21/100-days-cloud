# Debugging Containers: Logs, Exec, Inspect (Docker)

## Overview
Debugging Docker containers is crucial to identify issues with containerized applications quickly. The main tools for container debugging include:

- **docker logs** – View output/error logs from containers
- **docker exec** – Run commands inside a running container to inspect or troubleshoot
- **docker inspect** – Get detailed metadata and configuration about containers

This README explains how these commands work and links to detailed official documentation.

***

## 1. Viewing Logs: `docker logs`

- Use `docker logs ` to see the standard output (stdout) and error (stderr) streams of a container.
- Helpful for diagnosing application-level errors, crashes, or startup problems.
- Options:
  - `-f` or `--follow`: Continuously stream logs (like `tail -f`).
  - `--tail N`: Show the last N lines for focused inspection.

**Link:** [Docker Logs Documentation](https://docs.docker.com/engine/reference/commandline/logs/)

***

## 2. Running Commands Inside Containers: `docker exec`

- `docker exec -it  ` lets you run commands interactively inside a running container (e.g., `bash`, `sh`).
- Useful for exploring the container’s file system, checking configuration files, running diagnostic utilities, or troubleshooting the environment.
- Example:
  ```
  docker exec -it my_container bash
  ```
- If the container lacks `bash`, try `sh` or install debugging tools temporarily in the container.

**Link:** [Docker Exec Documentation](https://docs.docker.com/engine/reference/commandline/exec/)

***

## 3. Inspecting Container Details: `docker inspect`

- `docker inspect ` provides detailed JSON output about container configuration, including network settings, volumes, environment variables, mounts, state, and more.
- Useful for configuration verification and troubleshooting issues like networking or volume mounts.
- You can filter output with `--format` for specific info.

Example:
```
docker inspect my_container
```

**Link:** [Docker Inspect Documentation](https://docs.docker.com/engine/reference/commandline/inspect/)

***

## Additional Debugging Tips and Best Practices

- **Keep containers lightweight:** Minimize services per container for easier debugging.
- **Enable verbose logging:** Use environment variables or app settings for detailed logs during development.
- **Monitor resources:** Use `docker stats` to check CPU, memory, and I/O usage that might cause issues.
- **Use `docker attach` for live output:** Attach to a container’s stdout/stderr in real time.
- **Check Docker daemon logs:** Sometimes issues are at the Docker host or daemon level.
- **Use `docker debug` (Docker Desktop):** Inject debugging tools on the fly into minimal containers.
- **Clean up after debugging:** Remove temporary containers and images (`docker rm`, `docker rmi`) to avoid clutter.

***

## Useful Resources

- [How to Debug Docker Containers Locally (GetAmbassador)](https://www.getambassador.io/blog/how-to-debug-docker-containers-locally) — Comprehensive guide with best practices and advanced tools
- [Effective Strategies to Debug Docker Containers (CloudThat)](https://www.cloudthat.com/resources/blog/effective-strategies-to-debug-docker-containers) — Common techniques and debugging workflow
- [Docker Debugging Common Scenarios and Tips (Lumigo)](https://lumigo.io/container-monitoring/docker-debugging-common-scenarios-and-7-practical-tips/)
- [Official Docker Reference for Exec, Logs, Inspect](https://docs.docker.com/engine/reference/commandline/)

***

This README offers a practical start for debugging Docker containers effectively using native Docker commands and strategies. If you want, I can help you create sample commands with explanations or scripts for common debugging scenarios.

[1] https://www.getambassador.io/blog/how-to-debug-docker-containers-locally
[2] https://www.cloudthat.com/resources/blog/effective-strategies-to-debug-docker-containers
[3] https://lumigo.io/container-monitoring/docker-debugging-common-scenarios-and-7-practical-tips/
[4] https://www.docker.com/blog/how-to-fix-and-debug-docker-containers-like-a-superhero/
[5] https://spacelift.io/blog/docker-keep-container-running
[6] https://docs.docker.com/reference/cli/docker/debug/
[7] https://docs.docker.com/build/building/best-practices/
[8] https://www.xcubelabs.com/blog/product-engineering-blog/debugging-and-troubleshooting-docker-containers/
[9] https://earthly.dev/blog/debugging-docker-containers/
