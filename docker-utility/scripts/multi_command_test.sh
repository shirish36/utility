#!/bin/bash

# Multi-Command Test Script
# This script demonstrates running multiple commands in sequence

echo "=== Starting Multi-Command Test ==="
echo "Current date: $(date)"
echo "Container hostname: $(hostname)"
echo ""

echo "1. Testing network connectivity to Google..."
curl -I https://google.com | head -3
echo ""

echo "2. Testing DNS resolution..."
nslookup google.com | head -5
echo ""

echo "3. Checking available disk space..."
df -h | head -5
echo ""

echo "4. Testing ping connectivity..."
ping -c 3 google.com | head -5
echo ""

echo "5. Checking system information..."
echo "OS: $(uname -a)"
echo "Uptime: $(uptime)"
echo ""

echo "=== Multi-Command Test Completed Successfully ==="
