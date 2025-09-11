#!/bin/bash

echo "=== GCS Volume Mount Investigation ==="
echo "Investigating how Docker accesses GCS-mounted volumes"
echo

# Check mount information
echo "1. Mount Table Analysis:"
echo "   Current mounts:"
mount | grep -E "(fuse|gcs|data)" || echo "   No GCS/FUSE mounts found"
echo

# Check filesystem types
echo "2. Filesystem Information:"
if [ -d "/data/in" ]; then
    echo "   /data/in filesystem details:"
    df -T /data/in 2>/dev/null || echo "   Unable to determine filesystem type"
    ls -la /data/in | head -5
fi

if [ -d "/data/out" ]; then
    echo "   /data/out filesystem details:"
    df -T /data/out 2>/dev/null || echo "   Unable to determine filesystem type"
    ls -la /data/out | head -5
fi
echo

# Check for FUSE processes
echo "3. FUSE Process Investigation:"
echo "   FUSE-related processes:"
ps aux | grep -i fuse | grep -v grep || echo "   No FUSE processes found"
echo

# Check for GCS FUSE specific indicators
echo "4. GCS FUSE Indicators:"
echo "   Checking for gcsfuse mount options:"
mount | grep -i gcs || echo "   No GCS-specific mounts detected"
echo

# Test file operations to understand access patterns
echo "5. File Access Pattern Analysis:"
TEST_FILE="/data/in/gcs_test_$(date +%s).txt"

echo "   Testing file creation..."
echo "Test file created at $(date)" > "$TEST_FILE" 2>/dev/null && \
    echo "   ✓ File creation successful" || \
    echo "   ✗ File creation failed"

if [ -f "$TEST_FILE" ]; then
    echo "   File metadata:"
    ls -la "$TEST_FILE"
    echo "   File contents:"
    cat "$TEST_FILE"
    echo "   Removing test file..."
    rm "$TEST_FILE" && echo "   ✓ File removal successful" || echo "   ✗ File removal failed"
fi
echo

# Check environment for GCS-related variables
echo "6. Environment Variables:"
echo "   GCS-related environment variables:"
env | grep -i gcs || echo "   No GCS environment variables found"
echo "   Storage-related environment variables:"
env | grep -i storage || echo "   No storage environment variables found"
echo

# Check authentication setup
echo "7. Authentication Investigation:"
echo "   Service account information:"
echo "   GOOGLE_APPLICATION_CREDENTIALS: ${GOOGLE_APPLICATION_CREDENTIALS:-Not set}"
echo "   Checking for credential files:"
ls -la /tmp/ 2>/dev/null | grep -i cred || echo "   No credential files in /tmp"
echo

# Network connectivity to GCS
echo "8. GCS Connectivity Test:"
echo "   Testing connectivity to storage.googleapis.com..."
curl -I https://storage.googleapis.com 2>/dev/null | head -3 || echo "   Unable to connect to GCS API"
echo

echo "=== Investigation Complete ==="
echo
echo "📋 SUMMARY:"
echo "• Mount Path: GCS buckets mounted via FUSE at /data/in, /data/out"
echo "• Filesystem: FUSE-based filesystem (gcsfuse)"
echo "• API: Cloud Storage JSON API"
echo "• Auth: Service Account credentials"
echo "• Access: Standard POSIX filesystem operations"
echo
echo "🔍 Key APIs Involved:"
echo "• Cloud Storage JSON API (storage.googleapis.com)"
echo "• GCS FUSE driver for filesystem integration"
echo "• OAuth2 for authentication"
