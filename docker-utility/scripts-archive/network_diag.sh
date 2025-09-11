#!/bin/bash

# Quick Network Diagnostics
# Usage: ./network_diag.sh [target_host]

TARGET=${1:-$TARGET_HOST}
TARGET=${TARGET:-google.com}

echo "=========================================="
echo "    QUICK NETWORK DIAGNOSTICS"
echo "=========================================="
echo "Target: $TARGET"
echo "Timestamp: $(date)"
echo ""

echo "1. IP Address & Interface Info:"
ip addr show | grep -E "inet.*global" | sed 's/^/  /'
echo ""

echo "2. Routing Information:"
ip route | grep default | sed 's/^/  /'
echo ""

echo "3. DNS Resolution:"
nslookup $TARGET 2>/dev/null | grep -E "(Name|Address)" | sed 's/^/  /' || echo "  DNS lookup failed"
echo ""

echo "4. Connectivity Test:"
ping -c 3 $TARGET 2>/dev/null | tail -3 | sed 's/^/  /' || echo "  Ping failed"
echo ""

echo "5. HTTP Test:"
curl -I --max-time 10 https://$TARGET 2>/dev/null | head -3 | sed 's/^/  /' || echo "  HTTP test failed"
echo ""

echo "=========================================="
