
## NGINX Reverse Proxy in Docker

### Introduction

This guide explains how to set up NGINX as a **reverse proxy** using Docker. A reverse proxy forwards client requests to backend services, improving security, scalability, and centralizing routing logic.[1]

***

### Prerequisites

- Docker installed
- Basic knowledge of containers and web services

***

### Project Structure

```
project-root/
├── nginx/
│   └── default.conf
├── docker-compose.yml
```

***

### Step 1: Create an NGINX Configuration

Inside `nginx/default.conf`, define the reverse proxy routes. Example configuration routes `/api` requests to a backend service:

```nginx
server {
    listen 80;

    server_name localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    location /api/ {
        proxy_pass http://backend:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```


***

### Step 2: Docker Compose File

In `docker-compose.yml` define NGINX (reverse proxy) and your backend service:

```yaml
version: "3.8"
services:
  backend:
    image: your-backend-image
    container_name: backend
    ports:
      - "8080:8080"

  nginx:
    image: nginx:latest
    container_name: nginx_proxy
    ports:
      - "80:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - backend
```


***

### Step 3: Build and Launch

Run the following command from the project root:

```bash
docker compose up
```

- Access NGINX at `http://localhost`
- Requests to `/api` are forwarded to the backend service on port 8080

***

### Step 4: Verify and Test

- Open a browser and navigate to `http://localhost/api` to confirm your backend service is being proxied through NGINX.[1]

***

### Customization

- Update `default.conf` for additional routes/services
- Secure with SSL by generating keys/certificates and updating the NGINX config[4]
- Scale services by adding more backend containers

***

### Troubleshooting

- Check container logs with `docker logs nginx_proxy` and `docker logs backend`
- Reload NGINX config if changes are made:
  ```
  docker exec nginx_proxy nginx -s reload
  ```

***

**References:**  
- Example setup steps and configs[2][3][1]
- Further SSL setup details[4]

***

**This guide helps deploy an NGINX reverse proxy in Docker for efficient routing to backend services, enabling scalable and maintainable application infrastructure**.[3][2][1]

[1](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/Docker-Nginx-reverse-proxy-setup-example)
[2](https://geshan.com.np/blog/2024/03/nginx-docker-compose/)
[3](https://gcore.com/learning/reverse-proxy-with-docker-compose)
[4](https://phoenixnap.com/kb/docker-nginx-reverse-proxy)
[5](https://www.docker.com/blog/how-to-use-the-official-nginx-docker-image/)
[6](https://nginxproxymanager.com/setup/)
[7](https://blog.devops.dev/devops-setting-up-a-docker-reverse-proxy-nginx-multiple-local-apps-21b6f03eefa0)
[8](https://github.com/joelgarciajr84/nginx-docker-reverse-proxy)
[9](https://www.youtube.com/watch?v=ZmH1L1QeNHk)
[10](https://secf00tprint.github.io/blog/devops/docker/nginx/reverseproxy/en)
