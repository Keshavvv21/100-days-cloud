# Docker Registry & Image Tagging

## Overview

Docker registry is a storage and content delivery system for Docker images, supporting both public and private repositories. Tagging is the process of assigning human-readable names and version labels to images, allowing effective image management and deployment workflows.[1][2][3]

***

## Image Tagging

A **Docker image tag** gives a specific name and optional version (or label) to an image, making it easy to identify, share, and deploy.

- **Tag Syntax:**  
  ```
  [HOST[:PORT]/]NAMESPACE/REPOSITORY:TAG
  ```
  - If `HOST` and `PORT` are omitted, defaults to Docker Hub.[2][1]
  - If no `TAG` is specified, defaults to `latest`.

**Examples:**
- Tag an image by ID:
  ```
  docker tag 0e5574283393 myuser/myapp:version1.0
  ```
- Tag and push to a private registry:
  ```
  docker tag myapp myregistryhost:5000/myuser/myapp:prod
  docker push myregistryhost:5000/myuser/myapp:prod
  ```
- Tag during build:
  ```
  docker build -t myuser/myapp:1.2 .
  ```


***

## Accessing and Creating Images: Why is `sudo`/`su` Required?

Docker manipulates system resources, networking, and storage at a low level. Therefore:

- **Root Privileges:**  
  Interacting with the Docker daemon (which manages images, containers, and registries) requires elevated permissions. By default, only users in the `docker` group or the `root` user can run Docker commands.
- **Security Defaults:**  
  On most systems, for security reasons, regular users cannot access Docker's socket, making `sudo` necessary for commands like `docker build`, `docker push`, or when pulling images from/to restricted directories.[1][2]
- **Typical Usage Pattern:**  
  ```
  sudo docker build -t myuser/myimage:latest .
  sudo docker push myuser/myimage:latest
  ```
  Or, gain a subshell with `su` to operate as root or a privileged user for repeated commands.

**Note:**  
If regular, add your user to the `docker` group with:
```
sudo usermod -aG docker $USER
```
Then log out/in to avoid needing `sudo` each time. However, this gives broad system access to Docker, so consider organizational policy.[2][1]

***

## Best Practices

- Always use meaningful tags (not just `latest`) for reproducibility.
- Use registry namespaces and version tags to clearly identify environments (e.g., `staging`, `prod`).
- Secure access to private registries and avoid running Docker with root unless necessary.[8][5][2]

***

## References

- Docker Official Documentation on Tagging[1][2]
- Tagging and Publishing Images, Registry Concepts[3][5]
- Security implications of Docker group membership[2][1]

[1](https://docs.docker.com/reference/cli/docker/image/tag/)
[2](https://docs.docker.com/get-started/docker-concepts/building-images/build-tag-and-publish-an-image/)
[3](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-registry/)
[4](https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
[5](https://cloud.google.com/artifact-registry/docs/docker/pushing-and-pulling)
[6](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-retag.html)
[7](https://dokku.com/docs~v0.19.13/deployment/methods/images/)
[8](https://www.docker.com/blog/docker-best-practices-using-tags-and-labels-to-manage-docker-image-sprawl/)
[9](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-image-tag-version)
[10](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli)
