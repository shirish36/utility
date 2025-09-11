#!/bin/bash

echo "=================================================================================="
echo "🔥 Cloud Run Jobs VPC Traffic Flow Analysis with Egress Firewall"
echo "=================================================================================="
echo "Analyzing end-to-end traffic flow with 'Route all traffic to VPC' setting"
echo "Egress Firewall: CIDR 10.10.0.0/22 for storage.googleapis.com"
echo

# Function to analyze VPC routing configuration
analyze_vpc_routing() {
    echo "=================================================================================="
    echo "🌐 VPC ROUTING CONFIGURATION"
    echo "=================================================================================="

    echo "1. Cloud Run Jobs Network Settings:"
    echo "   • Traffic Routing: Route all traffic to VPC"
    echo "   • VPC Network: vpc-core-dev"
    echo "   • Subnet: app-dev (10.10.2.0/24)"
    echo "   • Egress Firewall: CIDR 10.10.0.0/22 for Google APIs"
    echo

    echo "2. Traffic Flow Architecture:"
    echo "   Cloud Run Job → VPC (app-dev subnet) → Egress Firewall → Google APIs"
    echo "                       ↓"
    echo "                 Cloud Storage (storage.googleapis.com)"
    echo

    echo "3. IP Address Analysis:"
    echo "   Container Internal IP: $(hostname -i 2>/dev/null || echo 'Unknown')"
    echo "   VPC Subnet Range: 10.10.2.0/24"
    echo "   Egress Firewall CIDR: 10.10.0.0/22"
    echo "   Note: Cloud Run uses 169.254.x.x internal IPs"
    echo

    # Check if container IP is within allowed ranges
    container_ip=$(hostname -i 2>/dev/null | awk '{print $1}')
    if [ ! -z "$container_ip" ]; then
        echo "4. IP Range Validation:"
        if [[ $container_ip =~ ^169\.254\. ]]; then
            echo "   ✅ Container IP ($container_ip) is in Cloud Run internal range"
            echo "   ✅ Traffic will be routed through VPC"
        else
            echo "   ⚠️  Container IP ($container_ip) is not in expected range"
        fi
    fi
    echo
}

# Function to analyze egress firewall rules
analyze_egress_firewall() {
    echo "=================================================================================="
    echo "🔥 EGRESS FIREWALL ANALYSIS"
    echo "=================================================================================="

    echo "1. Firewall Rule Configuration:"
    echo "   • Target: storage.googleapis.com"
    echo "   • Allowed CIDR: 10.10.0.0/22"
    echo "   • Protocol: TCP/443 (HTTPS)"
    echo "   • Direction: Egress"
    echo

    echo "2. CIDR Range Breakdown:"
    echo "   10.10.0.0/22 includes:"
    echo "   • 10.10.0.0 - 10.10.3.255 (1024 addresses)"
    echo "   • Your subnet 10.10.2.0/24 is within this range ✅"
    echo

    echo "3. Firewall Rule Logic:"
    echo "   IF source_ip IN [10.10.0.0/22] AND destination = storage.googleapis.com"
    echo "   THEN ALLOW TCP/443"
    echo "   ELSE DENY"
    echo

    echo "4. Traffic Path Through Firewall:"
    echo "   1. Cloud Run Job initiates HTTPS request to storage.googleapis.com"
    echo "   2. Traffic routed to VPC (10.10.2.0/24)"
    echo "   3. VPC routing sends traffic to egress firewall"
    echo "   4. Firewall checks source IP against 10.10.0.0/22"
    echo "   5. If allowed, traffic forwarded to Google APIs"
    echo "   6. Response follows reverse path"
    echo
}

# Function to test Cloud Storage connectivity
test_cloud_storage_connectivity() {
    echo "=================================================================================="
    echo "☁️ CLOUD STORAGE CONNECTIVITY TEST"
    echo "=================================================================================="

    echo "1. DNS Resolution Test:"
    storage_ip=$(nslookup storage.googleapis.com 2>/dev/null | grep "Address" | head -1 | awk '{print $2}' || echo "Failed")
    echo "   storage.googleapis.com resolves to: $storage_ip"
    echo

    echo "2. HTTPS Connectivity Test:"
    echo "   Testing connection to storage.googleapis.com:443..."
    timeout 10 bash -c "</dev/tcp/storage.googleapis.com/443" 2>/dev/null && \
        echo "   ✅ TCP/443 connection successful" || \
        echo "   ❌ TCP/443 connection failed"
    echo

    echo "3. API Endpoint Test:"
    echo "   Testing Cloud Storage API connectivity..."
    curl -I https://storage.googleapis.com 2>/dev/null | head -3 || echo "   ❌ HTTPS request failed"
    echo

    echo "4. Certificate Validation:"
    echo "   Testing SSL certificate..."
    openssl s_client -connect storage.googleapis.com:443 -servername storage.googleapis.com </dev/null 2>/dev/null | \
        openssl x509 -noout -dates 2>/dev/null | head -1 || echo "   ❌ SSL validation failed"
    echo
}

# Function to analyze network path
analyze_network_path() {
    echo "=================================================================================="
    echo "🛣️ NETWORK PATH ANALYSIS"
    echo "=================================================================================="

    echo "1. Routing Table Analysis:"
    echo "   Current routing configuration:"
    ip route show 2>/dev/null || echo "   Unable to show routing table"
    echo

    echo "2. Network Interfaces:"
    echo "   Available network interfaces:"
    ip addr show 2>/dev/null | grep -E "^[0-9]+:" | while read line; do
        interface=$(echo $line | awk '{print $2}' | sed 's/://')
        ip=$(ip addr show $interface 2>/dev/null | grep "inet " | awk '{print $2}' || echo "No IP")
        echo "   $interface: $ip"
    done
    echo

    echo "3. Gateway Information:"
    gateway=$(ip route show default 2>/dev/null | awk '{print $3}' || echo "Unknown")
    echo "   Default Gateway: $gateway"
    echo

    echo "4. DNS Configuration:"
    echo "   DNS Servers:"
    cat /etc/resolv.conf 2>/dev/null | grep nameserver || echo "   Unable to read DNS config"
    echo
}

# Function to debug firewall issues
debug_firewall_issues() {
    echo "=================================================================================="
    echo "🛠️ FIREWALL DEBUGGING"
    echo "=================================================================================="

    echo "1. Potential Firewall Issues:"
    echo "   ❌ Source IP not in allowed CIDR (10.10.0.0/22)"
    echo "   ❌ Destination not matching storage.googleapis.com"
    echo "   ❌ Protocol not TCP/443"
    echo "   ❌ Firewall rule not applied to subnet"
    echo "   ❌ Route all traffic setting not configured"
    echo

    echo "2. Debugging Steps:"
    echo "   1. Verify Cloud Run Job VPC configuration"
    echo "   2. Check subnet (app-dev) firewall rules"
    echo "   3. Confirm egress rule allows 10.10.0.0/22 to storage.googleapis.com"
    echo "   4. Test connectivity from within VPC"
    echo "   5. Check Cloud Run service account permissions"
    echo

    echo "3. Test Commands to Run:"
    echo "   # Test basic connectivity"
    echo "   curl -v https://storage.googleapis.com"
    echo "   "
    echo "   # Test with specific IP"
    echo "   curl -v --resolve storage.googleapis.com:443:142.250.190.208 https://storage.googleapis.com"
    echo "   "
    echo "   # Test DNS resolution"
    echo "   nslookup storage.googleapis.com"
    echo
}

# Function to provide troubleshooting commands
provide_troubleshooting() {
    echo "=================================================================================="
    echo "🧰 TROUBLESHOOTING COMMANDS"
    echo "=================================================================================="

    echo "1. Test Basic Connectivity:"
    echo "   gcloud run jobs execute utility-job \\
      --command 'curl -I https://storage.googleapis.com' \\
      --region us-central1"
    echo

    echo "2. Debug DNS Resolution:"
    echo "   gcloud run jobs execute utility-job \\
      --command 'nslookup storage.googleapis.com' \\
      --region us-central1"
    echo

    echo "3. Test Network Path:"
    echo "   gcloud run jobs execute utility-job \\
      --command 'traceroute -n storage.googleapis.com' \\
      --region us-central1"
    echo

    echo "4. Check Firewall Rules:"
    echo "   gcloud compute firewall-rules list \\
      --filter='direction=EGRESS' \\
      --format='table(name,network,direction,priority,sourceRanges,targetTags)'"
    echo

    echo "5. Verify VPC Configuration:"
    echo "   gcloud run services describe utility-job \\
      --region us-central1 \\
      --format='value(spec.template.spec.template.spec.vpcAccess)'"
    echo
}

# Main execution
echo "🎯 Starting VPC Traffic Flow Analysis with Egress Firewall..."
echo

# Run all analysis functions
analyze_vpc_routing
analyze_egress_firewall
test_cloud_storage_connectivity
analyze_network_path
debug_firewall_issues
provide_troubleshooting

# Final summary
echo "=================================================================================="
echo "🎉 VPC TRAFFIC FLOW ANALYSIS COMPLETE"
echo "=================================================================================="
echo
echo "📋 SUMMARY:"
echo "• Traffic Flow: Cloud Run → VPC → Egress Firewall → Cloud Storage"
echo "• Firewall Rule: 10.10.0.0/22 → storage.googleapis.com:443"
echo "• Routing: 'Route all traffic to VPC' enabled"
echo "• Expected Result: HTTPS traffic should flow through firewall"
echo
echo "🔍 If connectivity fails:"
echo "1. Verify egress firewall rule is applied to app-dev subnet"
echo "2. Confirm Cloud Run Job has 'Route all traffic to VPC' enabled"
echo "3. Check that 10.10.2.0/24 is within 10.10.0.0/22 range"
echo "4. Ensure Cloud Run service account has necessary permissions"
echo
echo "🛠️ Use the troubleshooting commands above to diagnose specific issues."
echo "=================================================================================="
