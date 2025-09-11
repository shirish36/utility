#!/bin/bash

# Comprehensive Container Diagnostics Script
# This script provides detailed information about the running container

echo "=========================================="
echo "    CONTAINER DIAGNOSTICS REPORT"
echo "=========================================="
echo "Report generated at: $(date)"
echo "Container hostname: $(hostname)"
echo ""

echo "=========================================="
echo "1. SYSTEM INFORMATION"
echo "=========================================="
echo "Operating System: $(uname -a)"
echo "Container User: $(whoami)"
echo "Process ID: $$"
echo "Parent Process: $(ps -o ppid= -p $$)"
echo "Working Directory: $(pwd)"
echo ""

echo "=========================================="
echo "2. NETWORK CONFIGURATION"
echo "=========================================="
echo "Network Interfaces:"
ip addr show | grep -E "(^[0-9]|inet|inet6)" | sed 's/^/  /'
echo ""

echo "Routing Table:"
ip route | sed 's/^/  /'
echo ""

echo "DNS Configuration:"
cat /etc/resolv.conf | sed 's/^/  /'
echo ""

echo "Network Statistics:"
echo "  Active Connections:"
netstat -tuln 2>/dev/null | head -10 | sed 's/^/    /'
echo ""

echo "=========================================="
echo "3. CONTAINER IP ADDRESSES"
echo "=========================================="
echo "IPv4 Addresses:"
ip -4 addr show | grep inet | sed 's/^/  /' | sed 's/inet /IP: /'
echo ""

echo "IPv6 Addresses:"
ip -6 addr show | grep inet6 | sed 's/^/  /' | sed 's/inet6 /IP: /'
echo ""

echo "Default Gateway:"
ip route | grep default | sed 's/^/  /'
echo ""

echo "=========================================="
echo "4. ENVIRONMENT VARIABLES"
echo "=========================================="
echo "Container Environment:"
env | grep -E "(TARGET_|GOOGLE_|CLOUD_|KUBERNETES_)" | sed 's/^/  /' || echo "  No cloud-specific env vars found"
echo ""

echo "=========================================="
echo "5. RESOURCE USAGE"
echo "=========================================="
echo "Memory Usage:"
free -h | sed 's/^/  /'
echo ""

echo "Disk Usage:"
df -h | sed 's/^/  /'
echo ""

echo "CPU Information:"
echo "  CPU Cores: $(nproc)"
echo "  CPU Architecture: $(uname -m)"
echo "  Load Average: $(uptime | awk -F'load average:' '{print $2}')"
echo ""

echo "=========================================="
echo "6. PROCESS INFORMATION"
echo "=========================================="
echo "Running Processes:"
ps aux | head -10 | sed 's/^/  /'
echo ""

echo "=========================================="
echo "7. CONTAINER METADATA"
echo "=========================================="
echo "Container Filesystem:"
ls -la / | head -10 | sed 's/^/  /'
echo ""

echo "Available Shells:"
cat /etc/shells 2>/dev/null | sed 's/^/  /' || echo "  /etc/shells not found"
echo ""

echo "=========================================="
echo "8. NETWORK CONNECTIVITY TEST"
echo "=========================================="
echo "Testing connectivity to Google DNS (8.8.8.8):"
ping -c 2 8.8.8.8 2>/dev/null | sed 's/^/  /' || echo "  Ping failed or not available"
echo ""

echo "Testing DNS resolution:"
nslookup google.com 2>/dev/null | head -5 | sed 's/^/  /' || echo "  DNS lookup failed"
echo ""

echo "Testing HTTP connectivity:"
curl -I --connect-timeout 5 https://google.com 2>/dev/null | head -3 | sed 's/^/  /' || echo "  HTTP test failed"
echo ""

echo "=========================================="
echo "    DIAGNOSTICS REPORT COMPLETE"
echo "=========================================="
