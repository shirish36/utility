#!/bin/bash

# Network Test Script
# Usage: ./network_test.sh [hostname]
# If no hostname provided, uses TARGET_HOST environment variable

HOST=${1:-$TARGET_HOST}

if [ -z "$HOST" ]; then
    echo "Usage: $0 <hostname> or set TARGET_HOST environment variable"
    exit 1
fi

echo "=== Network Test for $HOST ==="
echo

echo "1. Ping test:"
ping -c 4 $HOST
echo

echo "2. DNS lookup:"
nslookup $HOST
echo

echo "3. HTTP HEAD request:"
curl -I $HOST
echo

echo "4. Traceroute:"
traceroute $HOST
