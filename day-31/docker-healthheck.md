# Docker Health Checks

## Overview

Docker Health Checks are a feature that periodically tests whether a containerized application is running and functioning correctly. Properly configured health checks enable Docker to manage container lifecycles and ensure reliability.

***

## Why Use Health Checks?

- **Detect Failed Containers:** Health checks help identify containers that are running, but not functioning as expected.[3][7]
- **Automated Recovery:** Docker and orchestration platforms can automatically restart or replace unhealthy containers.[3]
- **Enhanced Monitoring:** Containers report their health status: `starting`, `healthy`, or `unhealthy`.[7]

***

## How to Add Health Checks

### Dockerfile Example

Add a `HEALTHCHECK` instruction to your Dockerfile:

```dockerfile
FROM nginx:latest

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
```

**Explanation of Options:**
- `--interval=30s`: Run the check every 30 seconds.
- `--timeout=3s`: Checks must finish within 3 seconds.
- `--start-period=5s`: Grace period before checks begin.
- `--retries=3`: If check fails 3 times, mark unhealthy.[5][7][3]

### Docker Compose Example

```yaml
services:
  web:
    image: nginx:latest
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 5s
```
*You can use environment variables for flexibility:*
```yaml
test: ["CMD", "curl", "-f", "http://${HOST:-localhost}:${PORT:-80}/health"]
```

***

## Best Practices

- **Keep Checks Lightweight:** Use simple commands (`curl`, basic scripts). Heavy or resource-intensive checks degrade container performance.[1][7]
- **Meaningful Checks:** Test critical service functionality, not just process existence. For APIs/web servers, check relevant endpoints.[1][7]
- **Set Sensible Intervals:** Most services use 30s–2min for intervals. Do not set too frequent (can overload system).[7][1]
- **Graceful Error Handling:** In case of network issues, handle errors and log warnings. Don’t fail immediately unless necessary.[1]
- **Custom Scripts:** For complex scenarios, use scripts that exit with status 0 when healthy and 1 when unhealthy. Place scripts inside the container and reference in `HEALTHCHECK`.[7]

***

## Monitoring Health Status

You can view container health status with:
```shell
docker ps
docker inspect 
```
States are:
- `starting`
- `healthy`
- `unhealthy`[7]

***

## Troubleshooting and Adjustments

- **Network Issues:** Build resilient checks that handle short network interruptions.
- **Latch Retries/Timeouts:** Tweak `retries`, `timeout`, and `start-period` as needed.[1]
- **Graceful Shutdowns:** Handle `SIGTERM` in your app for proper cleanup when Docker stops a container.[1]

***

## References

- See official Docker documentation and best practice guides for more advanced usage.[5][3][7][1]

***

## Example Healthcheck Script

For advanced checks, use a custom shell script:

```bash
#!/bin/sh
if curl -f http://localhost/health; then
  exit 0
else
  echo "Healthcheck warning: Network issue detected" >> /var/log/healthcheck.log
  exit 1
fi
```
Reference in Dockerfile:

```dockerfile
COPY healthcheck.sh /usr/local/bin/
HEALTHCHECK CMD /usr/local/bin/healthcheck.sh
```

***

## Summary

Docker Health Checks are critical for robust container management. Define lightweight, meaningful checks, and tune parameters to match your app’s startup and runtime behavior for best results.[3][5][7][1]

[1] https://signoz.io/guides/how-to-view-docker-compose-healthcheck-logs/
[2] https://www.youtube.com/watch?v=1nxxlkxqktU
[3] https://www.bobby.sh/5-docker-best-practices-i-wish-i-knew-when-i-started
[4] https://github.com/healthchecks/healthchecks/blob/master/README.md
[5] https://supportfly.io/docker-healthcheck/
[6] https://github.com/peter-evans/docker-compose-healthcheck
[7] https://lumigo.io/container-monitoring/docker-health-check-a-practical-guide/
[8] https://forums.docker.com/t/creating-a-health-check/136595
[9] https://dev.to/idsulik/a-beginners-guide-to-docker-health-checks-and-container-monitoring-3kh6
[10] https://docs.linuxserver.io/images/docker-healthchecks/
