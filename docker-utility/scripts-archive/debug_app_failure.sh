#!/bin/bash

echo "=== Application Failure Debug Script ==="
echo "Systematic debugging of Cloud Run application failures"
echo

# Step 1: Basic container health check
echo "1. Container Health Check:"
echo "   Container ID: $(hostname)"
echo "   Current user: $(whoami)"
echo "   Working directory: $(pwd)"
echo "   Process ID: $$"
echo

# Step 2: Environment check
echo "2. Environment Variables:"
echo "   PATH: $PATH"
echo "   INPUT_DIR: ${INPUT_DIR:-Not set}"
echo "   OUTPUT_DIR: ${OUTPUT_DIR:-Not set}"
echo "   TARGET_HOST: ${TARGET_HOST:-Not set}"
echo "   HOME: ${HOME:-Not set}"
echo

# Step 3: Volume mount verification
echo "3. Volume Mount Status:"
echo "   /data/in exists: $(test -d /data/in && echo "YES" || echo "NO")"
echo "   /data/out exists: $(test -d /data/out && echo "YES" || echo "NO")"

if [ -d "/data/in" ]; then
    echo "   /data/in permissions: $(ls -ld /data/in | awk '{print $1}')"
    echo "   /data/in contents: $(ls -la /data/in 2>/dev/null | wc -l) items"
fi

if [ -d "/data/out" ]; then
    echo "   /data/out permissions: $(ls -ld /data/out | awk '{print $1}')"
    echo "   /data/out contents: $(ls -la /data/out 2>/dev/null | wc -l) items"
fi
echo

# Step 4: Script availability check
echo "4. Available Scripts:"
echo "   /workspace/scripts/ directory exists: $(test -d /workspace/scripts && echo "YES" || echo "NO")"

if [ -d "/workspace/scripts" ]; then
    echo "   Executable scripts:"
    find /workspace/scripts -name "*.sh" -executable 2>/dev/null | while read script; do
        echo "   ✓ $(basename "$script")"
    done
fi
echo

# Step 5: Test basic commands
echo "5. Basic Command Tests:"
echo "   Testing 'echo': $(echo "SUCCESS" 2>&1 || echo "FAILED")"
echo "   Testing 'ls': $(ls /workspace 2>&1 | head -1 || echo "FAILED")"
echo "   Testing 'pwd': $(pwd 2>&1 || echo "FAILED")"
echo "   Testing 'date': $(date 2>&1 || echo "FAILED")"
echo

# Step 6: Network connectivity
echo "6. Network Tests:"
echo "   DNS resolution: $(nslookup google.com 2>&1 | head -2 | tail -1 || echo "FAILED")"
echo "   HTTP connectivity: $(curl -I https://www.google.com 2>&1 | head -1 || echo "FAILED")"
echo

# Step 7: Resource availability
echo "7. System Resources:"
echo "   Memory: $(free -h 2>/dev/null | head -2 | tail -1 || echo "free command not available")"
echo "   Disk space: $(df -h / 2>/dev/null | tail -1 || echo "df command not available")"
echo "   CPU info: $(nproc 2>/dev/null || echo "nproc not available") cores"
echo

echo "=== Debug Complete ==="
echo
echo "📋 SUMMARY:"
echo "If all basic tests show SUCCESS, the issue is likely with:"
echo "• Your specific application command"
echo "• Missing dependencies or files"
echo "• Incorrect command arguments"
echo "• Environment-specific issues"
echo
echo "🛠 NEXT STEPS:"
echo "1. Run this debug script first"
echo "2. Then test your specific failing command in isolation"
echo "3. Check command syntax and arguments"
echo "4. Verify all required files exist"
