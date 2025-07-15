# 🐳 Docker Setup & Hello World

This guide will help you install Docker and run your first containerized application — the classic **Hello World**.

---

## 📦 Step 1: Install Docker

### 🔗 Download Docker
- Go to the official Docker website: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

### 💻 Installation by OS

#### Windows / macOS:
1. Download **Docker Desktop** for your OS.
2. Follow the installer instructions.
3. After installation, restart your system (if prompted).

#### Linux (Ubuntu example):

```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce
