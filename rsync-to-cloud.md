# 🔁 Backup with `rsync` to Cloud

## 📋 What is `rsync`?

`rsync` is a powerful command-line tool used for fast, incremental backups and file synchronization. It copies only the differences between the source and the destination, saving time and bandwidth.

---

## 🌐 Use Case: Backing up to a Cloud Server

You can use `rsync` to backup your local files to a remote server (cloud VM) over SSH.

---

## 🛠️ Basic Command

```bash
rsync -avz ~/my-project/ username@cloud-server-ip:/path/to/backup/
