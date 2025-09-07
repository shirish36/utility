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

echo "=== Volume Mount Test Complete ==="
echo "If all tests show ✓, your volume mounts are working correctly!"
