
#!/bin/bash

echo "=== HOSTNAME ==="
hostname

echo "=== UPTIME ==="
uptime

echo "=== MEMORY ==="
free -h

echo "=== STORAGE ==="
df -h "$HOME"

echo "=== WEB SERVICE ==="
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://127.0.0.1:8080
