#!/bin/bash

# === CONFIGURATION ===
SOURCE_DIR="/home/youruser/Documents"   # Local directory to back up
DEST_USER="remoteuser"                  # Remote SSH username
DEST_HOST="192.168.1.50"                # Remote host or IP
DEST_DIR="/mnt/backup/documents"        # Destination directory on remote server
LOG_FILE="/var/log/backup.log"          # Log file path
SSH_KEY="/home/youruser/.ssh/id_rsa"    # SSH key path

# === TIMESTAMP ===
NOW=$(date +"%Y-%m-%d_%H-%M-%S")

# === BACKUP EXECUTION ===
echo "[$NOW] Starting backup..." >> "$LOG_FILE"

rsync -azP -e "ssh -i $SSH_KEY" "$SOURCE_DIR/" "$DEST_USER@$DEST_HOST:$DEST_DIR" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "[$NOW] Backup completed successfully." >> "$LOG_FILE"
else
    echo "[$NOW] Backup FAILED!" >> "$LOG_FILE"
fi
