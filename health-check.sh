#!/bin/bash

# Health Check Script

echo "===== System Health Check ====="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo

# CPU Load
echo "----- CPU Load -----"
uptime
echo

# Memory Usage
echo "----- Memory Usage -----"
free -h
echo

# Disk Usage
echo "----- Disk Usage -----"
df -h /
echo

# Network Connectivity
echo "----- Network Check -----"
ping -c 2 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Network is up"
else
    echo "Network is down"
fi
echo

# Optional: Check a service (uncomment and replace 'nginx' if needed)
# echo "----- Service Status: nginx -----"
# systemctl is-active --quiet nginx && echo "nginx is running" || echo "nginx is NOT running"
# echo

echo "===== Health Check Complete ====="
