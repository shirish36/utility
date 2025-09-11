#!/bin/bash

# VPC Connectivity Test Script
# Tests connectivity to VPC resources and internal services

echo "=========================================="
echo "    VPC CONNECTIVITY TEST"
echo "=========================================="
echo "Testing connectivity to VPC resources..."
echo "Timestamp: $(date)"
echo ""

echo "=========================================="
echo "1. VPC NETWORK INFORMATION"
echo "=========================================="
echo "Container Internal IPs:"
ip addr show | grep -E "inet.*global" | sed 's/^/  /'
echo ""

echo "Routing Table (VPC Routes):"
ip route | grep -v "169.254" | sed 's/^/  /'
echo ""

echo "=========================================="
echo "2. VPC RESOURCE ACCESSIBILITY"
echo "=========================================="
echo "Testing access to common VPC services:"
echo ""

# Test access to VPC metadata
echo "VPC Metadata Service:"
curl -s --connect-timeout 5 http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip 2>/dev/null || echo "  External IP metadata not accessible"
echo ""

# Test DNS resolution for internal services
echo "Internal DNS Resolution:"
nslookup app-dev.us-central1.internal 2>/dev/null | head -3 | sed 's/^/  /' || echo "  Internal DNS not configured"
echo ""

# Test connectivity to subnet gateway
echo "Subnet Gateway Connectivity:"
ping -c 2 10.10.2.1 2>/dev/null | tail -1 | sed 's/^/  /' || echo "  Gateway ping failed (expected in Cloud Run)"
echo ""

echo "=========================================="
echo "3. NETWORK CONNECTIVITY TESTS"
echo "=========================================="
echo "Testing external connectivity:"
curl -I --connect-timeout 5 https://www.google.com 2>/dev/null | head -2 | sed 's/^/  /' || echo "  External connectivity failed"
echo ""

echo "Testing DNS resolution:"
nslookup google.com 2>/dev/null | grep "Address" | head -2 | sed 's/^/  /' || echo "  DNS resolution failed"
echo ""

echo "=========================================="
echo "4. VPC CONFIGURATION SUMMARY"
echo "=========================================="
echo "VPC Network: vpc-core-dev"
echo "Subnet: app-dev (10.10.2.0/24)"
echo "Region: us-central1"
echo ""
echo "Container Internal Networking:"
echo "  - Cloud Run assigns 169.254.x.x addresses"
echo "  - VPC attachment enables access to internal resources"
echo "  - External traffic routed through Cloud Run NAT"
echo ""

echo "=========================================="
echo "    VPC TEST COMPLETE"
echo "=========================================="
