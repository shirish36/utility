#!/bin/bash

echo "=================================================================================="
echo "📊 Cloud Run Jobs Logging & Monitoring Guide"
echo "=================================================================================="
echo "Where to find all diagnostic information in Google Cloud logs"
echo

# Function to show Cloud Run Jobs logs
show_cloud_run_logs() {
    echo "=================================================================================="
    echo "🚀 CLOUD RUN JOBS LOGS"
    echo "=================================================================================="

    echo "1. Cloud Run Jobs Execution Logs:"
    echo "   Location: Cloud Logging → Logs Explorer"
    echo "   Resource Type: cloud_run_job"
    echo "   Log Name: run.googleapis.com/stdout, run.googleapis.com/stderr"
    echo

    echo "2. Query Examples:"
    echo "   # All Cloud Run Jobs logs"
    echo "   resource.type=\"cloud_run_job\""
    echo
    echo "   # Specific job logs"
    echo "   resource.type=\"cloud_run_job\""
    echo "   resource.labels.job_name=\"utility-job\""
    echo
    echo "   # Logs with errors"
    echo "   resource.type=\"cloud_run_job\""
    echo "   severity>=ERROR"
    echo

    echo "3. Via gcloud CLI:"
    echo "   # View recent logs"
    echo "   gcloud logging read \"resource.type=cloud_run_job\" --limit=50"
    echo
    echo "   # Logs for specific execution"
    echo "   gcloud run jobs executions logs read EXECUTION_ID --region=us-central1"
    echo

    echo "4. What You'll See:"
    echo "   ✓ Volume mount test results"
    echo "   ✓ NAT analysis output"
    echo "   ✓ Network connectivity tests"
    echo "   ✓ Firewall test results"
    echo "   ✓ Error messages and stack traces"
    echo
}

# Function to show VPC Flow Logs
show_vpc_flow_logs() {
    echo "=================================================================================="
    echo "🌐 VPC FLOW LOGS"
    echo "=================================================================================="

    echo "1. VPC Flow Logs Location:"
    echo "   Location: Cloud Logging → Logs Explorer"
    echo "   Resource Type: gce_subnetwork"
    echo "   Log Name: compute.googleapis.com/vpc_flows"
    echo

    echo "2. Enable VPC Flow Logs:"
    echo "   # Enable for your subnet"
    echo "   gcloud compute networks subnets update app-dev \\
     --region=us-central1 \\
     --enable-flow-logs"
    echo

    echo "3. Query Examples:"
    echo "   # All VPC flow logs for your subnet"
    echo "   resource.type=\"gce_subnetwork\""
    echo "   resource.labels.subnetwork_name=\"app-dev\""
    echo "   logName=\"projects/YOUR_PROJECT/logs/compute.googleapis.com%2Fvpc_flows\""
    echo
    echo "   # Traffic to Cloud Storage"
    echo "   resource.type=\"gce_subnetwork\""
    echo "   jsonPayload.connection.dest_ip=\"142.250.190.0/24\""
    echo

    echo "4. What You'll See:"
    echo "   ✓ Source IP (10.10.2.x - NAT'd from 169.254.x.x)"
    echo "   ✓ Destination IP (storage.googleapis.com IPs)"
    echo "   ✓ Port numbers (443 for HTTPS)"
    echo "   ✓ Traffic direction (EGRESS)"
    echo "   ✓ Packet/byte counts"
    echo "   ✓ Connection status"
    echo
}

# Function to show Firewall logs
show_firewall_logs() {
    echo "=================================================================================="
    echo "🔥 FIREWALL LOGS"
    echo "=================================================================================="

    echo "1. Firewall Logs Location:"
    echo "   Location: Cloud Logging → Logs Explorer"
    echo "   Resource Type: gce_firewall_rule"
    echo "   Log Name: compute.googleapis.com/firewall"
    echo

    echo "2. Enable Firewall Logging:"
    echo "   # Enable logging for your egress rule"
    echo "   gcloud compute firewall-rules update ALLOW_EGRESS_TO_STORAGE \\
     --enable-logging"
    echo

    echo "3. Query Examples:"
    echo "   # Firewall rule evaluations"
    echo "   resource.type=\"gce_firewall_rule\""
    echo "   jsonPayload.rule_details.reference=\"ALLOW_EGRESS_TO_STORAGE\""
    echo
    echo "   # Denied traffic (if any)"
    echo "   resource.type=\"gce_firewall_rule\""
    echo "   jsonPayload.disposition=\"DENIED\""
    echo

    echo "4. What You'll See:"
    echo "   ✓ Source IP (10.10.2.x - VPC subnet)"
    echo "   ✓ Destination (storage.googleapis.com)"
    echo "   ✓ Rule name and action (ALLOW/DENY)"
    echo "   ✓ Protocol and ports"
    echo "   ✓ Instance details"
    echo
}

# Function to show Cloud NAT logs (if applicable)
show_cloud_nat_logs() {
    echo "=================================================================================="
    echo "🔄 CLOUD NAT LOGS (Not Applicable for Cloud Run)"
    echo "=================================================================================="

    echo "1. Important Note:"
    echo "   ❌ Cloud Run Jobs do NOT use Cloud NAT service"
    echo "   ✓ They use VPC NAT (automatic, no logs)"
    echo

    echo "2. If You Had Cloud NAT:"
    echo "   Location: Cloud Logging → Logs Explorer"
    echo "   Resource Type: nat_gateway"
    echo "   Log Name: compute.googleapis.com/nat_flows"
    echo

    echo "3. Cloud Run NAT Visibility:"
    echo "   • VPC Flow Logs show NAT'd traffic"
    echo "   • Firewall logs show post-NAT source IPs"
    echo "   • No separate Cloud NAT logs needed"
    echo
}

# Function to show log aggregation and monitoring
show_log_aggregation() {
    echo "=================================================================================="
    echo "📈 LOG AGGREGATION & MONITORING"
    echo "=================================================================================="

    echo "1. Cloud Monitoring Dashboards:"
    echo "   • VPC Network Dashboard"
    echo "   • Firewall Insights Dashboard"
    echo "   • Cloud Run Monitoring Dashboard"
    echo

    echo "2. Custom Metrics:"
    echo "   • Firewall rule hits"
    echo "   • VPC traffic volume"
    echo "   • Cloud Run job success/failure rates"
    echo

    echo "3. Log-based Metrics:"
    echo "   # Create metric for firewall denies"
    echo "   gcloud logging metrics create firewall-denies \\
     --description=\"Firewall deny events\" \\
     --filter=\"resource.type=gce_firewall_rule jsonPayload.disposition=DENIED\""
    echo
}

# Function to show troubleshooting with logs
show_troubleshooting_guide() {
    echo "=================================================================================="
    echo "🛠 TROUBLESHOOTING WITH LOGS"
    echo "=================================================================================="

    echo "1. Connectivity Issues:"
    echo "   Check VPC Flow Logs:"
    echo "   • Look for REJECTED connections"
    echo "   • Verify source IPs are in allowed CIDR"
    echo "   • Check destination IPs match expected services"
    echo

    echo "2. Firewall Issues:"
    echo "   Check Firewall Logs:"
    echo "   • Look for DENIED dispositions"
    echo "   • Verify rule priority and matching"
    echo "   • Check source/destination criteria"
    echo

    echo "3. NAT Issues:"
    echo "   Check VPC Flow Logs:"
    echo "   • Verify source IP translation (169.254.x.x → 10.10.2.x)"
    echo "   • Look for asymmetric routing"
    echo "   • Check connection state consistency"
    echo

    echo "4. Application Issues:"
    echo "   Check Cloud Run Logs:"
    echo "   • Look for error messages in stdout/stderr"
    echo "   • Check execution status and duration"
    echo "   • Verify environment variables and mounts"
    echo
}

# Function to show log retention and export
show_log_retention() {
    echo "=================================================================================="
    echo "⏰ LOG RETENTION & EXPORT"
    echo "=================================================================================="

    echo "1. Default Retention:"
    echo "   • Cloud Logging: 30 days (can be extended)"
    echo "   • VPC Flow Logs: 30 days"
    echo "   • Firewall Logs: 30 days"
    echo

    echo "2. Export Options:"
    echo "   • BigQuery: For long-term storage and analysis"
    echo "   • Cloud Storage: For archival"
    echo "   • Pub/Sub: For real-time processing"
    echo

    echo "3. Export Setup:"
    echo "   # Export to BigQuery"
    echo "   gcloud logging sinks create my-sink \\
     bigquery.googleapis.com/projects/PROJECT/datasets/DATASET \\
     --log-filter=\"resource.type=cloud_run_job\""
    echo
}

# Main execution
echo "🎯 Starting Cloud Logging Guide..."
echo

# Run all logging functions
show_cloud_run_logs
show_vpc_flow_logs
show_firewall_logs
show_cloud_nat_logs
show_log_aggregation
show_troubleshooting_guide
show_log_retention

# Final summary
echo "=================================================================================="
echo "🎉 CLOUD LOGGING GUIDE COMPLETE"
echo "=================================================================================="
echo
echo "📋 SUMMARY:"
echo "• Cloud Run Logs: run.googleapis.com/stdout, run.googleapis.com/stderr"
echo "• VPC Flow Logs: compute.googleapis.com/vpc_flows"
echo "• Firewall Logs: compute.googleapis.com/firewall"
echo "• Cloud NAT Logs: Not applicable for Cloud Run Jobs"
echo "• Location: Cloud Logging → Logs Explorer"
echo
echo "🔍 Quick Access:"
echo "1. Go to https://console.cloud.google.com/logs/query"
echo "2. Use the query examples above"
echo "3. Filter by resource type and time range"
echo
echo "🛠 Enable logging where needed:"
echo "• VPC Flow Logs: gcloud compute networks subnets update SUBNET --enable-flow-logs"
echo "• Firewall Logs: gcloud compute firewall-rules update RULE --enable-logging"
echo
echo "📊 For advanced analysis, consider exporting logs to BigQuery."
echo "=================================================================================="
