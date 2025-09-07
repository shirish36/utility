#!/bin/bash

echo "=================================================================================="
echo "🔥 QUICK EGRESS FIREWALL TEST"
echo "=================================================================================="
echo "Testing Cloud Storage access through egress firewall"
echo "CIDR: 10.10.0.0/22 → storage.googleapis.com"
echo

# Quick connectivity test
echo "1. Testing HTTPS connectivity to Cloud Storage..."
curl -I https://storage.googleapis.com 2>/dev/null | head -3 || echo "   ❌ HTTPS request failed"
echo

# DNS resolution test
echo "2. Testing DNS resolution..."
nslookup storage.googleapis.com 2>/dev/null | grep "Address" | head -1 || echo "   ❌ DNS resolution failed"
echo

# Network path test
echo "3. Testing network path..."
timeout 5 traceroute -n storage.googleapis.com 2>/dev/null | head -5 || echo "   ❌ Traceroute failed"
echo

# Certificate validation
echo "4. Testing SSL certificate..."
openssl s_client -connect storage.googleapis.com:443 -servername storage.googleapis.com </dev/null 2>/dev/null | \
    openssl x509 -noout -dates 2>/dev/null | head -1 || echo "   ❌ SSL validation failed"
echo

echo "=================================================================================="
echo "🎯 QUICK TEST COMPLETE"
echo "=================================================================================="
echo
echo "If all tests show ✅, egress firewall is working correctly."
echo "If any test shows ❌, run the full analysis:"
echo "  /workspace/scripts/vpc_egress_firewall_analysis.sh"
echo "=================================================================================="
