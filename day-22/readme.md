# Build Custom Image from Dockerfile

This README provides a step-by-step guide to **building a custom Docker image using a Dockerfile**. Whether you're running a Python, Node.js, Nginx, or any other application, these instructions help you containerize your application efficiently.

## Table of Contents

- [What is a Dockerfile?](#what-is-a-dockerfile)
- [Steps to Build a Custom Docker Image](#steps-to-build-a-custom-docker-image)
- [Dockerfile Instructions Overview](#dockerfile-instructions-overview)
- [Sample Dockerfile](#sample-dockerfile)
- [Build the Image](#build-the-image)
- [Test and Run Your Image](#test-and-run-your-image)
- [Image Tagging Best Practices](#image-tagging-best-practices)
- [References](#references)

## What is a Dockerfile?

A **Dockerfile** is a plain-text document with instructions to assemble a Docker image. It defines:
- The base operating system/image
- Required dependencies
- Application source code
- Environment variables
- The command to run when the container starts[4][5].

## Steps to Build a Custom Docker Image

1. **Ensure Docker is installed** on your system[1].
2. **Create a Dockerfile** in your application directory (no file extension)[3][5].
3. **Write instructions** in the Dockerfile.
4. **Add your application/config files** as needed.
5. **Build your image** with the `docker build` command.
6. **Run and verify your container** using your new image[3][4][7].

## Dockerfile Instructions Overview

Some of the most commonly used Dockerfile instructions:
- `FROM ` — set a base image (e.g., Ubuntu, Python, Node.js)[2][4][5].
- `WORKDIR ` — set the working directory in the container[4].
- `COPY  ` — copy files from host into the image[4].
- `RUN ` — execute commands/install dependencies[4][5].
- `ENV  ` — set environment variables[4].
- `EXPOSE ` — specify ports to expose[4].
- `USER ` — set the default user in the container[4].
- `CMD ["executable", "param1"]` — default command when a container starts[4].

## Sample Dockerfile

**Python Flask Example**:

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```
This example uses an official lightweight Python image, installs dependencies, copies your code, exposes a port, and sets the default run command[3][4].

## Build the Image

Open your terminal in the directory with your Dockerfile and run:

```sh
docker build -t myapp:1.0 .
```
- `-t myapp:1.0`: Tags your image `myapp` with version `1.0`.
- `.`: Build context is the current directory[7].

You can list your images with:
```sh
docker images
```

## Test and Run Your Image

Start a container from your custom image:

```sh
docker run -p 5000:5000 myapp:1.0
```
- `-p 5000:5000`: Maps host port 5000 to container port 5000.

## Image Tagging Best Practices

- Use **semantic versioning** for production images (e.g., `1.0.0`).
- Unique tags (with date or commit ID) let you track builds and roll back easily[7].

## References

- [Docker Docs: Writing a Dockerfile][4]
- [KodeKloud: Build Docker Images][3]
- [DevOpsCube: Beginner Guide][7]
- [Webdock: Custom Images][5]

**For further details, consult Docker's official documentation and community tutorials.**

[1] https://circleci.com/docs/custom-images/
[2] https://docs.docker.com/build/building/base-images/
[3] https://kodekloud.com/blog/how-to-build-a-docker-image/
[4] https://docs.docker.com/get-started/docker-concepts/building-images/writing-a-dockerfile/
[5] https://webdock.io/en/docs/how-guides/docker-guides/how-create-custom-docker-images
[6] https://www.youtube.com/watch?v=p0YVWeiHGGY
[7] https://devopscube.com/build-docker-image/
[8] https://www.youtube.com/watch?v=EzhfbJpnYJ8
[9] https://linuxconfig.org/how-to-customize-docker-images-with-dockerfiles
[10] https://linuxhandbook.com/create-custom-docker-image/
