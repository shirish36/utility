#!/bin/bash

# System Information Script
# Comprehensive system diagnostics

echo "=========================================="
echo "    SYSTEM INFORMATION REPORT"
echo "=========================================="
echo "Generated: $(date)"
echo ""

echo "CONTAINER INFO:"
echo "  Hostname: $(hostname)"
echo "  User: $(whoami)"
echo "  PID: $$"
echo "  Working Dir: $(pwd)"
echo "  Uptime: $(uptime -p 2>/dev/null || uptime)"
echo ""

echo "SYSTEM RESOURCES:"
echo "  CPU Cores: $(nproc)"
echo "  CPU Architecture: $(uname -m)"
echo "  OS: $(uname -s) $(uname -r)"
echo "  Kernel: $(uname -v)"
echo ""

echo "MEMORY:"
free -h | sed 's/^/  /'
echo ""

echo "DISK:"
df -h | sed 's/^/  /'
echo ""

echo "NETWORK INTERFACES:"
ip addr show | grep -E "(^[0-9]|inet )" | sed 's/^/  /'
echo ""

echo "ENVIRONMENT:"
echo "  PATH: $PATH"
echo "  SHELL: $SHELL"
echo "  HOME: $HOME"
env | grep -E "(TARGET_|GOOGLE_|CLOUD_)" | sed 's/^/  /' || echo "  No cloud env vars found"
echo ""

echo "=========================================="
