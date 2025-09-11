#!/bin/bash

echo "=== Volume Mount Test Script ==="
echo "Testing /data/in and /data/out volume mounts"
echo

# Check if directories exist and are accessible
echo "1. Checking volume mount directories:"
echo "   /data/in exists: $(test -d /data/in && echo "YES" || echo "NO")"
echo "   /data/out exists: $(test -d /data/out && echo "YES" || echo "NO")"
echo

# Test permissions
echo "2. Testing directory permissions:"
echo "   /data/in permissions: $(ls -ld /data/in | awk '{print $1}')"
echo "   /data/out permissions: $(ls -ld /data/out | awk '{print $1}')"
echo

# List contents of input directory
echo "3. Contents of /data/in:"
if [ -d "/data/in" ]; then
    ls -la /data/in || echo "   Unable to list /data/in"
else
    echo "   Directory /data/in not found"
fi
echo

# List contents of output directory
echo "4. Contents of /data/out:"
if [ -d "/data/out" ]; then
    ls -la /data/out || echo "   Unable to list /data/out"
else
    echo "   Directory /data/out not found"
fi
echo

# Test file operations
echo "5. Testing file operations:"
TEST_FILE_IN="/data/in/test_input.txt"
TEST_FILE_OUT="/data/out/test_output.txt"

# Create test file in input directory
echo "   Creating test file in /data/in..."
echo "This is a test input file created at $(date)" > "$TEST_FILE_IN" 2>/dev/null && \
    echo "   ✓ Successfully created $TEST_FILE_IN" || \
    echo "   ✗ Failed to create $TEST_FILE_IN"

# Copy file from input to output
if [ -f "$TEST_FILE_IN" ]; then
    cp "$TEST_FILE_IN" "$TEST_FILE_OUT" 2>/dev/null && \
        echo "   ✓ Successfully copied to $TEST_FILE_OUT" || \
        echo "   ✗ Failed to copy to $TEST_FILE_OUT"
fi

# Test writing to output directory
echo "   Writing test data to /data/out..."
echo "Test output data generated at $(date)" >> "/data/out/test_data.txt" 2>/dev/null && \
    echo "   ✓ Successfully wrote to /data/out/test_data.txt" || \
    echo "   ✗ Failed to write to /data/out/test_data.txt"
echo

# Show disk usage
echo "6. Disk usage of mounted volumes:"
df -h /data/in /data/out 2>/dev/null || echo "   Unable to check disk usage"
echo

# Test environment variables
echo "7. Environment variables for volumes:"
echo "   INPUT_DIR: ${INPUT_DIR:-Not set}"
echo "   OUTPUT_DIR: ${OUTPUT_DIR:-Not set}"
echo

# Advanced mount point verification
echo "8. Advanced mount verification:"
echo "   Mount points:"
mount | grep -E "/data/(in|out)" || echo "   No /data volume mounts found in mount table"
echo

echo "   File system types:"
if [ -d "/data/in" ]; then
    df -T /data/in 2>/dev/null | tail -1 | awk '{print "   /data/in: " $2}' || echo "   Unable to determine /data/in filesystem type"
fi
if [ -d "/data/out" ]; then
    df -T /data/out 2>/dev/null | tail -1 | awk '{print "   /data/out: " $2}' || echo "   Unable to determine /data/out filesystem type"
fi
echo

# Test file metadata
echo "9. File metadata test:"
if [ -f "$TEST_FILE_IN" ]; then
    echo "   Test file metadata (/data/in/test_input.txt):"
    ls -la "$TEST_FILE_IN"
    echo "   File size: $(stat -c%s "$TEST_FILE_IN" 2>/dev/null || echo "unknown") bytes"
    echo "   Last modified: $(stat -c%y "$TEST_FILE_IN" 2>/dev/null || echo "unknown")"
fi
if [ -f "$TEST_FILE_OUT" ]; then
    echo "   Copied file metadata (/data/out/test_output.txt):"
    ls -la "$TEST_FILE_OUT"
fi
echo

echo "=== Volume Mount Test Complete ==="
echo "If all tests show ✓, your volume mounts are working correctly!"
