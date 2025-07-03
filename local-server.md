
# 🌐 Local Web Server with Python

This project demonstrates how to quickly serve static files (HTML, CSS, JS) using Python’s built-in HTTP server — perfect for local testing or file sharing.

---

## 🚀 What It Does

Starts a local web server to serve the contents of a directory over HTTP.

- No installations needed (built into Python)
- Ideal for static websites or demos
- Works on any OS with Python installed

---

## 📦 Requirements

- Python 3.x installed
- Terminal or command prompt access

---

## 🧪 How to Use

### 1. Open your terminal

### 2. Navigate to your project folder

```bash
cd path/to/your-folder
````

### 3. Start the server

```bash
python -m http.server 8000
```

> 🔗 Now visit:
> `http://localhost:8000` in your browser

---

## ⚙️ Custom Options

| Use Case                | Command Example                                     |
| ----------------------- | --------------------------------------------------- |
| Default port (8000)     | `python -m http.server`                             |
| Custom port (e.g. 9000) | `python -m http.server 9000`                        |
| Serve another directory | `python -m http.server --directory /path/to/folder` |

---

## 🛑 Stopping the Server

Press `Ctrl + C` in your terminal.

---

## 📁 Example Structure

```
/my-website
  ├── index.html
  ├── style.css
  └── script.js
```

---

## 🧠 Why Use This?

* Test HTML/CSS/JS locally without deploying
* Share files across your local network
* No need for external packages or servers

---

## 🙌 Author

Made as part of the **Day 11: Pattern Printer + Web Tools** learning challenge.

```
