# Docker Secrets & BuildKit

## Overview
**Docker BuildKit** allows developers to securely use secrets (passwords, API keys, tokens) in the image build process without baking them into the final image.[6][7]

## Why Use BuildKit Secrets?
- Traditional environment variables or build args are insecure: secrets can leak into the final image or source control.[2][1]
- BuildKit provides ephemeral, mount-only access for secrets—used only in the relevant `RUN` commands and discarded after the build.[3][1]

## Prerequisites
- Docker 18.09+ (recommended: Docker 23.0 or newer).[4][6]
- Enable BuildKit either per build:
  ```
  DOCKER_BUILDKIT=1 docker build .
  ```
  Or permanently:
  - Add `"buildkit": true` to your `~/.docker/config.json`.[3]

## Handling Secret Files

### 1. Create Your Secret File
Store your sensitive data in a file (e.g., `mydb-password.txt`):
```
echo "super-secret-value" > mydb-password.txt
```


### 2. Reference Secrets in Dockerfile
Add the following syntax directive atop your Dockerfile:
```dockerfile
# syntax=docker/dockerfile:1.4
FROM ubuntu:20.04

RUN --mount=type=secret,id=mydb_password cat /run/secrets/mydb_password > /tmp/secret_output
CMD ["bash"]
```


- Each secret is mounted at `/run/secrets/<id>` for its build step only.
- Use unique `id=` for each secret.

### 3. Build Image with Secrets
Build using BuildKit, passing secrets:
```
DOCKER_BUILDKIT=1 docker build \
  --secret id=mydb_password,src=mydb-password.txt \
  -t my_image .
```

You can pass multiple secrets with extra `--secret` arguments.

## Passing Secrets from Environment Variables

- Export your secret as an environment variable:
  ```
  export MY_SECRET="super-secret-value"
  ```
- Update Dockerfile:
  ```dockerfile
  RUN --mount=type=secret,id=my_secret cat /run/secrets/my_secret > /tmp/secret_output
  ```
- Build:
  ```
  DOCKER_BUILDKIT=1 docker build \
    --secret id=my_secret,env=MY_SECRET \
    -t my_image .
  ```


## Security Notes

- Secrets are **not saved** in the final image.
- They are only mounted during the specific build step.
- Never add secrets as ENV or ARG in the Dockerfile.

## Reference Code Snippet

```dockerfile
# syntax=docker/dockerfile:1.4
FROM alpine
RUN --mount=type=secret,id=my_api_key cat /run/secrets/my_api_key
```
Build command:
```
DOCKER_BUILDKIT=1 docker build \
  --secret id=my_api_key,src=api-key.txt \
  -t secure-app .
```


## References
- [Docker Build Secrets](https://docs.docker.com/build/building/secrets/)[1]
- [BuildKit Documentation](https://docs.docker.com/build/buildkit/)[6]
- [Secret Environment Variables](https://www.baeldung.com/ops/docker-build-add-secret-environment-variable)[4]
- [Practical Secret Mount Example](https://earthly.dev/blog/buildkit-secrets/)[2]

This README.md empowers the secure use of secrets in modern Docker workflows.

[1](https://docs.docker.com/build/building/secrets/)
[2](https://earthly.dev/blog/buildkit-secrets/)
[3](https://www.hostinger.com/in/tutorials/docker-build-secrets)
[4](https://www.baeldung.com/ops/docker-build-add-secret-environment-variable)
[5](https://render.com/docs/docker-secrets)
[6](https://docs.docker.com/build/buildkit/)
[7](https://github.com/moby/buildkit)
[8](https://damienaicheh.github.io/azure/devops/2022/08/15/docker-secrets-azure-devops-en.html)
[9](https://docs.docker.com/engine/swarm/secrets/)
[10](https://stackoverflow.com/questions/75668905/adding-secret-to-docker-build-from-environment-variable-rather-than-a-file)
[11](https://docs.docker.com/build/ci/github-actions/secrets/)
