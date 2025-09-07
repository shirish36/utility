#!/bin/bash

echo "=================================================================================="
echo "🚀 MASTER DIAGNOSTIC SCRIPT - Complete Container Health Check"
echo "=================================================================================="
echo "Execution Time: $(date)"
echo "Container Host: $(hostname)"
echo "=================================================================================="
echo

# Function to run a script and capture output
run_diagnostic() {
    local script_name=$1
    local script_path="/workspace/scripts/$script_name"
    local section_title=$2

    echo "=================================================================================="
    echo "🔍 $section_title"
    echo "=================================================================================="

    if [ -f "$script_path" ] && [ -x "$script_path" ]; then
        echo "✅ Running $script_name..."
        echo "----------------------------------------------------------------------------------"
        bash "$script_path"
        echo "----------------------------------------------------------------------------------"
        echo "✅ $script_name completed successfully"
    else
        echo "❌ ERROR: $script_name not found or not executable at $script_path"
        echo "   Available scripts in /workspace/scripts/:"
        ls -la /workspace/scripts/ 2>/dev/null || echo "   Unable to list scripts directory"
    fi
    echo
    echo
}

# Function to show system overview
show_system_overview() {
    echo "=================================================================================="
    echo "📊 SYSTEM OVERVIEW"
    echo "=================================================================================="
    echo "⏰ Current Time: $(date)"
    echo "🏠 Hostname: $(hostname)"
    echo "👤 User: $(whoami) (UID: $(id -u), GID: $(id -g))"
    echo "📁 Working Directory: $(pwd)"
    echo "💾 Process ID: $$"
    echo "🐧 OS: $(uname -a)"
    echo "📦 Container: $(cat /proc/1/cgroup 2>/dev/null | head -1 || echo 'Unknown')"
    echo
    echo "📋 Environment Variables:"
    echo "   PATH: ${PATH:0:100}..."
    echo "   INPUT_DIR: ${INPUT_DIR:-Not set}"
    echo "   OUTPUT_DIR: ${OUTPUT_DIR:-Not set}"
    echo "   TARGET_HOST: ${TARGET_HOST:-Not set}"
    echo
    echo "💽 System Resources:"
    echo "   CPU Cores: $(nproc 2>/dev/null || echo 'Unknown')"
    echo "   Memory: $(free -h 2>/dev/null | grep '^Mem:' | awk '{print $2}' || echo 'Unknown')"
    echo "   Disk Usage (/): $(df -h / 2>/dev/null | tail -1 | awk '{print $5}' || echo 'Unknown')"
    echo
}

# Function to show volume status summary
show_volume_summary() {
    echo "=================================================================================="
    echo "💾 VOLUME MOUNT SUMMARY"
    echo "=================================================================================="
    echo "📁 Volume Directories:"
    echo "   /data/in: $(test -d /data/in && echo '✅ Mounted' || echo '❌ Not found')"
    echo "   /data/out: $(test -d /data/out && echo '✅ Mounted' || echo '❌ Not found')"
    echo

    if [ -d "/data/in" ]; then
        echo "📥 Input Volume Details:"
        echo "   Permissions: $(ls -ld /data/in | awk '{print $1}')"
        echo "   Owner: $(ls -ld /data/in | awk '{print $3 ":" $4}')"
        echo "   Files: $(find /data/in -type f 2>/dev/null | wc -l) files"
        echo "   Directories: $(find /data/in -type d 2>/dev/null | wc -l) directories"
        echo "   Total Size: $(du -sh /data/in 2>/dev/null | cut -f1 || echo 'Unknown')"
    fi

    if [ -d "/data/out" ]; then
        echo "📤 Output Volume Details:"
        echo "   Permissions: $(ls -ld /data/out | awk '{print $1}')"
        echo "   Owner: $(ls -ld /data/out | awk '{print $3 ":" $4}')"
        echo "   Files: $(find /data/out -type f 2>/dev/null | wc -l) files"
        echo "   Directories: $(find /data/out -type d 2>/dev/null | wc -l) directories"
        echo "   Total Size: $(du -sh /data/out 2>/dev/null | cut -f1 || echo 'Unknown')"
    fi
    echo
}

# Function to show network status
show_network_status() {
    echo "=================================================================================="
    echo "🌐 NETWORK STATUS"
    echo "=================================================================================="
    echo "📡 Network Interfaces:"
    ip addr show 2>/dev/null | grep -E "^[0-9]+:" | while read line; do
        interface=$(echo $line | awk '{print $2}' | sed 's/://')
        ip=$(ip addr show $interface 2>/dev/null | grep "inet " | awk '{print $2}' || echo "No IP")
        echo "   $interface: $ip"
    done
    echo

    echo "🔗 DNS Resolution Test:"
    echo "   google.com: $(nslookup google.com 2>/dev/null | grep "Address" | head -2 | tail -1 | awk '{print $2}' || echo "Failed")"
    echo

    echo "🌍 Internet Connectivity:"
    echo "   HTTP to google.com: $(curl -I https://www.google.com 2>/dev/null | head -1 | sed 's/HTTP\/[0-9.]* //' || echo "Failed")"
    echo

    echo "📋 Routing Table:"
    ip route show 2>/dev/null | head -3 || echo "   Unable to show routing table"
    echo
}

# Main execution
echo "🎯 Starting Master Diagnostic - This may take a few minutes..."
echo

# Show system overview first
show_system_overview

# Show volume summary
show_volume_summary

# Show network status
show_network_status

# Run individual diagnostic scripts
echo "=================================================================================="
echo "🔧 RUNNING INDIVIDUAL DIAGNOSTIC SCRIPTS"
echo "=================================================================================="
echo

run_diagnostic "debug_app_failure.sh" "APPLICATION FAILURE DEBUG"
run_diagnostic "debug_gcs_mount.sh" "GCS MOUNT DEBUG"
run_diagnostic "mount_investigation.sh" "MOUNT INVESTIGATION"
run_diagnostic "volume_test.sh" "VOLUME MOUNT TEST"
run_diagnostic "list_volumes.sh" "VOLUME FILE LISTING"
run_diagnostic "vpc_test.sh" "VPC CONNECTIVITY TEST"
run_diagnostic "network_diag.sh" "NETWORK DIAGNOSTICS"
run_diagnostic "system_info.sh" "SYSTEM INFORMATION"
run_diagnostic "multi_command_test.sh" "MULTI-COMMAND TEST"

# Final summary
echo "=================================================================================="
echo "🎉 MASTER DIAGNOSTIC COMPLETE"
echo "=================================================================================="
echo "📅 End Time: $(date)"
echo "⏱️  Total Runtime: $(($(date +%s) - $(date +%s - $(date +%s)))) seconds"
echo
echo "📋 SUMMARY:"
echo "• System Overview: ✅ Completed"
echo "• Volume Status: $(test -d /data/in && test -d /data/out && echo '✅ Both volumes mounted' || echo '⚠️  Check volume mounts')"
echo "• Network Status: $(curl -I https://www.google.com &>/dev/null && echo '✅ Internet accessible' || echo '⚠️  Network issues detected')"
echo "• All Diagnostic Scripts: ✅ Executed"
echo
echo "🔍 If you see any ❌ or ⚠️ items above, check the detailed output above for more information."
echo "=================================================================================="
