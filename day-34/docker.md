# Dockerize a React App + Serve via NGINX

This guide helps containerize a React application using Docker and NGINX for fast, production-ready static web serving.[1][5][6]

***

## What Is NGINX and What Does It Do?

**NGINX** is a high-performance, open-source web server used to deliver web content efficiently. It can serve static files, act as a reverse proxy, load balancer, cache server, and terminate SSL/TLS connections. Its event-driven architecture makes it ideal for handling a large number of concurrent requests, powering many popular websites for speed and reliability.[9][10][11]

**Why NGINX for React?** It’s lightweight, fast, and optimized for static file delivery—making it perfect for serving React’s production build.[5]

***

## Prerequisites

- Docker installed (Desktop or Engine)[6]
- Node.js and npm (locally for building your app)
- Existing React app (or create with `npx create-react-app <app-name>`)

***

## Step 1: Build Your React App

```sh
npm run build
```
Generates production static files in `/build`.

***

## Step 2: Create .dockerignore File

Add items to ignore during Docker build to reduce image size:
```
node_modules
build
.dockerignore
Dockerfile
.git
.gitignore
*.md
```


***

## Step 3: Create Dockerfile (React + NGINX, Multi-Stage)

```dockerfile
# Stage 1: Build React app
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve with NGINX
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
- Multi-stage keeps your final image slim and clean.[5][1]

***

## Step 4: (Recommended) Create NGINX Configuration

Create `nginx.conf` (optional for custom routing/cache):

```nginx
server {
  listen 80;
  location / {
    root /usr/share/nginx/html;
    index index.html;
    try_files $uri $uri/ /index.html =404;
  }
}
```
Ensures React’s routing works on page reload.[5]

***

## Step 5: Build Docker Image

```sh
docker build -t my-react-app .
```


***

## Step 6: Run Container

```sh
docker run -d -p 80:80 --name react-nginx my-react-app
```
Accessible at `http://localhost`.[6]

***

## Step 7: Docker Compose (Optional)

For easier multi-container orchestration, create `docker-compose.yml`:

```yaml
version: "3"
services:
  react-app:
    build: .
    ports:
      - "80:80"
```
Start with:
```sh
docker compose up -d
```


***

## Useful Docker Commands

- List containers: `docker ps`
- Stop container: `docker stop <container_id>`
- Remove container: `docker rm <container_id>`

***

## References

- How to Dockerize a React App:[6]
- Containerize React.js application (Official):[1]
- Multi-stage Docker + NGINX examples:[5]
- NGINX basics and architecture:[10][11][9]

***

This setup boosts scalability, performance, and portability for React applications in production using **NGINX** with Docker.[1][5][6]

[1](https://docs.docker.com/guides/reactjs/containerize/)
[2](https://blog.devops.dev/devops-docker-series-local-dev-reactjs-nginx-setup-c7b55b8e3c7d)
[3](https://dev.to/sourabpramanik/deploy-your-react-app-using-docker-and-nginx-14lk)
[4](https://rishabh.io/deploying-and-serving-a-react-app-with-docker-and-nginx-85eda5cbbcb4)
[5](https://github.com/bahachammakhi/docker-react-nginx-blog)
[6](https://www.docker.com/blog/how-to-dockerize-react-app/)
[7](https://www.yld.io/blog/deploy-create-react-app-with-docker-and-ngnix)
[8](https://www.digitalocean.com/community/tutorials/deploy-react-application-with-nginx-on-ubuntu)
[9](https://www.papertrail.com/solution/guides/nginx/)
[10](https://kinsta.com/blog/what-is-nginx/)
[11](https://en.wikipedia.org/wiki/Nginx)
