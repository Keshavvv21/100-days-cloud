# Python Script in Docker

This project demonstrates how to run a Python script inside a Docker container.

## 📂 Project Structure
```

.
├── Dockerfile
├── requirements.txt   # (optional, only if you have dependencies)
├── script.py          # Your main Python script
└── README.md

````

---

## 🚀 Build & Run

### 1. Build the Docker image
```bash
docker build -t python-script .
````

### 2. Run the container

```bash
docker run --rm python-script
```

---

## 📝 Example Dockerfile

```dockerfile
# Use the official lightweight Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy files into the container
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY script.py .

# Default command to run the script
CMD ["python", "script.py"]
```

---

## 🧩 Running with Volumes (Optional)

If you want to mount your local folder so that you don’t need to rebuild on every change:

```bash
docker run --rm -v $(pwd):/app python:3.11-slim python script.py
```

---

## 🐳 Useful Docker Commands

* **List images**

  ```bash
  docker images
  ```
* **List running containers**

  ```bash
  docker ps
  ```
* **Remove all stopped containers**

  ```bash
  docker container prune
  ```
* **Remove all unused images**

  ```bash
  docker image prune -a
  ```

---

## ✅ Notes

* Edit `requirements.txt` if your script needs libraries (`numpy`, `pandas`, etc.).
* For multi-file projects, copy your entire source code into the container (`COPY . .`).

```

---
