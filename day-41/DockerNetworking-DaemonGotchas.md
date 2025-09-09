# Docker Networking + Daemon Gotchas

This guide provides a hands-on example of resolving common Docker networking and daemon pitfalls you might encounter during local development and production deployment.[1][5][7]

## Overview

Docker networking enables containers to communicate with each other, the Docker host, and external services. Misconfiguration at the daemon layer or within user networks often triggers hard-to-diagnose issues.[5][7]

## Example Problem: DNS Resolution Failure in Containers

Sometimes, containers fail to resolve domain names, blocking access to external resources (like pulling packages or images). This is often caused by DNS misconfiguration in the Docker daemon.[2][1]

### Steps to Reproduce

1. Start a basic container:
    ```sh
    docker run --rm -it alpine sh
    ```
2. Try resolving an external domain:
    ```sh
    nslookup google.com
    ```
3. If you see `DNS request timed out`, it indicates a container DNS failure.

### Cause

By default, Docker uses Google’s DNS servers or, sometimes, the host’s `/etc/resolv.conf`. In corporate or restricted environments, external DNS may be blocked, requiring manual configuration.[1]

## Solution: Configure Daemon DNS

1. Open (or create) the daemon configuration file:
    ```sh
    sudo nano /etc/docker/daemon.json
    ```

2. Set the DNS servers:
    ```json
    {
      "dns": ["8.8.8.8", "8.8.4.4"]
    }
    ```

3. Restart the Docker daemon to apply changes:
    ```sh
    sudo service docker restart
    ```

4. Test DNS inside a new container:
    ```sh
    docker run --rm -it alpine nslookup google.com
    ```

## Other Daemon Networking Gotchas

- Too many containers (>1,000) on a single network can cause failures and hard-to-trace connectivity issues.[4]
- Host networking mode may expose containers to host network conflicts or security risks.[15][5]
- Container-to-container communication requires explicit network attachment; containers in different networks cannot talk to each other unless bridged.[7]

## Tips for Debugging Networking

- Inspect container and network state:
    ```sh
    docker network ls
    docker network inspect <network>
    docker inspect <container>
    ```
- Use diagnostic containers:
    ```sh
    docker run --rm -it --network=my-net busybox sh
    ```
    Then use ping/nslookup tools for connectivity checks.

## References

- [Docker Daemon Troubleshooting Docs][1]
- [Docker Networking Guide][5]
- [Networking Basics and Examples][7]

***

This README template covers a canonical example and outlines key debugging steps for Docker networking and daemon configuration issues, making it useful for both blog posts and developer onboarding.[5][7][1]

[1](https://docs.docker.com/engine/daemon/troubleshoot/)
[2](https://www.reddit.com/r/docker/comments/13mfc7f/docker_networking_seems_to_have_completely_broken/)
[3](https://forums.docker.com/t/docker-breaks-network-after-short-period/139889)
[4](https://github.com/moby/moby/issues/44973)
[5](https://docs.docker.com/engine/network/)
[6](https://blog.atulr.com/docker-local-environment/)
[7](https://spacelift.io/blog/docker-networking)
[8](https://www.paigeniedringhaus.com/blog/docker-102-docker-compose/)
[9](https://stackoverflow.com/questions/53347951/docker-network-not-found)
[10](https://faun.pub/a-deep-dive-into-docker-container-3b6cb4c8d7d1)
[11](https://forums.docker.com/t/host-networking-drops-when-starting-up-more-than-x-containers/144694)
[12](https://docker-curriculum.com)
[13](https://earthly.dev/blog/docker-networking/)
[14](https://stackoverflow.com/questions/47854463/docker-got-permission-denied-while-trying-to-connect-to-the-docker-daemon-socke)
[15](https://forums.docker.com/t/problems-with-host-networking-on-containers/18679)
[16](https://octopus.com/devops/ci-cd/ci-cd-with-docker/)
[17](https://docs.docker.com/compose/how-tos/networking/)
[18](https://testdriven.io/blog/docker-best-practices/)
