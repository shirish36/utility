#!/bin/bash

echo "=== GCS FUSE Mount Analysis ==="
echo "Analyzing the Cloud Run logs for mount details"
echo

# Check current mount status
echo "1. Current Mount Status:"
mount | grep -E "(fuse|gcs)" || echo "   No GCS FUSE mounts found"
echo

# Check directories
echo "2. Volume Directory Status:"
echo "   /data/in exists: $(test -d /data/in && echo "YES" || echo "NO")"
echo "   /data/out exists: $(test -d /data/out && echo "YES" || echo "NO")"
echo

# Check GCS bucket connectivity
echo "3. GCS Bucket Connectivity:"
BUCKET_NAME="gifted-palace-468618-q5-enterprise-app-processing-development"

echo "   Testing bucket access..."
# Try to list bucket contents (this will test if mount is working)
if [ -d "/data/in" ]; then
    echo "   Input directory contents:"
    ls -la /data/in 2>/dev/null | head -10 || echo "   Unable to list /data/in"
fi

if [ -d "/data/out" ]; then
    echo "   Output directory contents:"
    ls -la /data/out 2>/dev/null | head -10 || echo "   Unable to list /data/out"
fi
echo

# Check for any GCS FUSE processes
echo "4. GCS FUSE Process Status:"
ps aux | grep -i gcsfuse | grep -v grep || echo "   No GCS FUSE processes running"
echo

# Test file operations
echo "5. File Operation Tests:"
TEST_FILE_IN="/data/in/gcs_test_$(date +%s).txt"
TEST_FILE_OUT="/data/out/gcs_test_$(date +%s).txt"

echo "   Testing write to /data/in..."
echo "Test file from $(hostname) at $(date)" > "$TEST_FILE_IN" 2>/dev/null && \
    echo "   ✓ Successfully wrote to input volume" || \
    echo "   ✗ Failed to write to input volume"

echo "   Testing write to /data/out..."
echo "Test file from $(hostname) at $(date)" > "$TEST_FILE_OUT" 2>/dev/null && \
    echo "   ✓ Successfully wrote to output volume" || \
    echo "   ✗ Failed to write to output volume"

# Test read operations
if [ -f "$TEST_FILE_IN" ]; then
    echo "   Testing read from /data/in..."
    cat "$TEST_FILE_IN" 2>/dev/null && echo "   ✓ Successfully read from input volume" || echo "   ✗ Failed to read from input volume"
fi

if [ -f "$TEST_FILE_OUT" ]; then
    echo "   Testing read from /data/out..."
    cat "$TEST_FILE_OUT" 2>/dev/null && echo "   ✓ Successfully read from output volume" || echo "   ✗ Failed to read from output volume"
fi
echo

# Check disk usage
echo "6. Volume Disk Usage:"
df -h /data/in /data/out 2>/dev/null || echo "   Unable to check disk usage"
echo

# Check mount options
echo "7. Mount Options Analysis:"
mount | grep -A 5 -B 5 "/data" 2>/dev/null || echo "   No /data mounts found in mount table"
echo

echo "=== Analysis Summary ==="
echo "Based on your Cloud Run logs:"
echo "• GCS FUSE version: 3.2.0"
echo "• Bucket: gifted-palace-468618-q5-enterprise-app-processing-development"
echo "• Mount Status: SUCCESS (both input and output)"
echo "• Application Status: FAILED TO START"
echo
echo "🔍 Next Steps:"
echo "1. Check your application startup command"
echo "2. Verify environment variables are set correctly"
echo "3. Test with a simple command first (e.g., 'ls -la /data/in')"
echo "4. Check application logs for specific error messages"
