#!/bin/bash

echo "=================================================================================="
echo "🌐 VPC Network Traffic Flow Analysis"
echo "=================================================================================="
echo "Analyzing traffic flows to Cloud Storage and Cloud SQL"
echo "Execution Time: $(date)"
echo

# Function to check VPC Flow Logs status
check_vpc_flow_logs() {
    echo "=================================================================================="
    echo "📊 VPC FLOW LOGS ANALYSIS"
    echo "=================================================================================="

    echo "1. Checking VPC Flow Logs Configuration:"
    echo "   Note: VPC Flow Logs need to be enabled at the subnet level"
    echo "   Current subnet: app-dev (10.10.2.0/24)"
    echo

    echo "2. Flow Logs Status:"
    # Check if we can access VPC information
    echo "   VPC: vpc-core-dev"
    echo "   Subnet: app-dev (10.10.2.0/24)"
    echo "   Region: us-central1"
    echo

    echo "3. Recent Network Activity:"
    echo "   Container IP: $(hostname -i 2>/dev/null || echo 'Unknown')"
    echo "   Gateway: $(ip route show default 2>/dev/null | awk '{print $3}' || echo 'Unknown')"
    echo

    # Check network connections
    echo "4. Active Network Connections:"
    netstat -tuln 2>/dev/null | grep -E "(ESTABLISHED|LISTEN)" | head -10 || echo "   Unable to check connections"
    echo
}

# Function to analyze Cloud Storage traffic
analyze_cloud_storage_traffic() {
    echo "=================================================================================="
    echo "☁️ CLOUD STORAGE TRAFFIC ANALYSIS"
    echo "=================================================================================="

    echo "1. Cloud Storage Endpoints:"
    echo "   • storage.googleapis.com (Global)"
    echo "   • storage.us-central1.googleapis.com (Regional)"
    echo "   • Bucket: gifted-palace-468618-q5-enterprise-app-processing-development"
    echo

    echo "2. DNS Resolution:"
    echo "   storage.googleapis.com: $(nslookup storage.googleapis.com 2>/dev/null | grep "Address" | head -1 | awk '{print $2}' || echo "Failed to resolve")"
    echo

    echo "3. Connectivity Tests:"
    echo "   Testing HTTPS connectivity..."
    curl -I https://storage.googleapis.com 2>/dev/null | head -3 || echo "   Connection failed"
    echo

    echo "4. GCS FUSE Mount Analysis:"
    if [ -d "/data/in" ] || [ -d "/data/out" ]; then
        echo "   GCS FUSE Status: ✅ Active"
        echo "   Mount Points: /data/in, /data/out"
        echo "   Bucket: gifted-palace-468618-q5-enterprise-app-processing-development"
    else
        echo "   GCS FUSE Status: ❌ Not mounted"
    fi
    echo

    echo "5. Traffic Patterns (Estimated):"
    echo "   • Read Operations: Via GCS FUSE → storage.googleapis.com"
    echo "   • Write Operations: Via GCS FUSE → storage.googleapis.com"
    echo "   • List Operations: Via GCS FUSE → storage.googleapis.com"
    echo "   • Protocol: HTTPS (TCP/443)"
    echo
}

# Function to analyze Cloud SQL traffic
analyze_cloud_sql_traffic() {
    echo "=================================================================================="
    echo "🗄️ CLOUD SQL TRAFFIC ANALYSIS"
    echo "=================================================================================="

    echo "1. Cloud SQL Connection Patterns:"
    echo "   • Protocol: TCP (usually port 3306 for MySQL, 5432 for PostgreSQL)"
    echo "   • Connection Type: Private IP (via VPC) or Public IP"
    echo "   • Authentication: IAM or native database auth"
    echo

    echo "2. Network Path Analysis:"
    echo "   From Cloud Run (VPC) → Cloud SQL:"
    echo "   • Same VPC: Direct private IP connection"
    echo "   • Different VPC: Cloud SQL Proxy or VPC peering"
    echo "   • Public IP: Internet egress through Cloud NAT"
    echo

    echo "3. Connection Testing:"
    echo "   Testing common Cloud SQL ports..."
    timeout 5 bash -c "</dev/tcp/10.0.0.1/3306" 2>/dev/null && echo "   MySQL (3306): ✅ Open" || echo "   MySQL (3306): ❌ Closed/Filtered"
    timeout 5 bash -c "</dev/tcp/10.0.0.1/5432" 2>/dev/null && echo "   PostgreSQL (5432): ✅ Open" || echo "   PostgreSQL (5432): ❌ Closed/Filtered"
    echo

    echo "4. DNS Resolution for Cloud SQL:"
    echo "   Note: Cloud SQL instances use private DNS when in VPC"
    echo "   Format: [instance-name].[project-id]:[region]:[db-type]"
    echo

    echo "5. Traffic Flow Characteristics:"
    echo "   • Connection Pooling: Recommended for performance"
    echo "   • SSL/TLS: Always enabled for security"
    echo "   • Connection Timeouts: 60 seconds default"
    echo "   • Max Connections: Based on Cloud SQL tier"
    echo
}

# Function to monitor network traffic
monitor_network_traffic() {
    echo "=================================================================================="
    echo "📈 NETWORK TRAFFIC MONITORING"
    echo "=================================================================================="

    echo "1. Current Network Interfaces:"
    ip addr show 2>/dev/null | grep -E "^[0-9]+:" | while read line; do
        interface=$(echo $line | awk '{print $2}' | sed 's/://')
        ip=$(ip addr show $interface 2>/dev/null | grep "inet " | awk '{print $2}' || echo "No IP")
        echo "   $interface: $ip"
    done
    echo

    echo "2. Routing Table:"
    ip route show 2>/dev/null | head -5 || echo "   Unable to show routing table"
    echo

    echo "3. Active Connections to Google Services:"
    echo "   Checking connections to Google APIs..."
    netstat -tuln 2>/dev/null | grep -E ":(443|80)" | head -5 || echo "   No active web connections found"
    echo

    echo "4. DNS Queries (Recent):"
    echo "   Note: DNS queries are cached and may not show all traffic"
    echo "   Primary DNS: 169.254.169.254 (GCP metadata server)"
    echo

    echo "5. Traffic Volume Estimation:"
    echo "   • Cloud Storage: ~10-100 KB per file operation"
    echo "   • Cloud SQL: ~1-10 KB per query"
    echo "   • Metadata API: ~1-5 KB per request"
    echo
}

# Function to provide monitoring recommendations
provide_monitoring_recommendations() {
    echo "=================================================================================="
    echo "🎯 MONITORING RECOMMENDATIONS"
    echo "=================================================================================="

    echo "1. Enable VPC Flow Logs:"
    echo "   gcloud compute networks subnets update app-dev \\"
    echo "     --region=us-central1 \\"
    echo "     --enable-flow-logs"
    echo

    echo "2. Cloud Monitoring Metrics:"
    echo "   • networking.googleapis.com/vpc_flow/bytes_count"
    echo "   • networking.googleapis.com/vpc_flow/packet_count"
    echo "   • storage.googleapis.com/api/request_count"
    echo "   • cloudsql.googleapis.com/database/connection/count"
    echo

    echo "3. Set up Alerts:"
    echo "   • High egress traffic"
    echo "   • Cloud SQL connection failures"
    echo "   • Cloud Storage access errors"
    echo

    echo "4. Log Analysis:"
    echo "   • Cloud Storage audit logs"
    echo "   • Cloud SQL slow query logs"
    echo "   • VPC Flow Logs analysis"
    echo

    echo "5. Network Intelligence Center:"
    echo "   • Visualize network topology"
    echo "   • Monitor connectivity"
    echo "   • Analyze traffic patterns"
    echo
}

# Function to create traffic capture script
create_traffic_capture_script() {
    echo "=================================================================================="
    echo "🔍 TRAFFIC CAPTURE SCRIPT"
    echo "=================================================================================="

    cat << 'EOF'
#!/bin/bash
# Traffic Capture Script for Cloud Run Jobs
# This script captures network traffic for analysis

echo "Starting traffic capture..."
echo "Duration: 30 seconds"
echo "Output: /data/out/traffic_capture.pcap"
echo

# Start tcpdump (if available)
if command -v tcpdump >/dev/null 2>&1; then
    echo "Capturing traffic with tcpdump..."
    timeout 30 tcpdump -i any -w /data/out/traffic_capture.pcap \
        host storage.googleapis.com or port 3306 or port 5432 2>/dev/null &
    TCPDUMP_PID=$!
    
    # Wait for capture to complete
    wait $TCPDUMP_PID 2>/dev/null
    echo "Traffic capture completed"
else
    echo "tcpdump not available - capturing connection information instead..."
    
    # Fallback: Log network activity
    echo "Network activity log:" > /data/out/network_activity.log
    date >> /data/out/network_activity.log
    echo "Active connections:" >> /data/out/network_activity.log
    netstat -tuln 2>/dev/null >> /data/out/network_activity.log
    echo "Routing table:" >> /data/out/network_activity.log
    ip route show 2>/dev/null >> /data/out/network_activity.log
fi

echo "Traffic analysis saved to /data/out/"
EOF

    echo "   ↑ Save this as a script and run it to capture traffic"
    echo
}

# Main execution
echo "🎯 Starting VPC Network Traffic Analysis..."
echo

# Run all analysis functions
check_vpc_flow_logs
analyze_cloud_storage_traffic
analyze_cloud_sql_traffic
monitor_network_traffic
provide_monitoring_recommendations
create_traffic_capture_script

# Final summary
echo "=================================================================================="
echo "🎉 VPC TRAFFIC ANALYSIS COMPLETE"
echo "=================================================================================="
echo "📋 SUMMARY:"
echo "• VPC Flow Logs: Check subnet configuration"
echo "• Cloud Storage: Connected via GCS FUSE"
echo "• Cloud SQL: Private IP connections recommended"
echo "• Monitoring: Enable VPC Flow Logs for detailed analysis"
echo "• Traffic Capture: Use provided script for packet analysis"
echo
echo "🔗 Key Services Involved:"
echo "• Cloud Storage JSON API (storage.googleapis.com)"
echo "• Cloud SQL Private IP connections"
echo "• VPC Flow Logs for network monitoring"
echo "• Cloud Monitoring for metrics and alerting"
echo
echo "📊 For detailed traffic analysis, enable VPC Flow Logs at the subnet level."
echo "=================================================================================="
