#!/bin/bash

echo "=== Volume Mount File Lister ==="
echo "Listing files in mounted volumes"
echo

# Function to list directory contents
list_directory() {
    local dir=$1
    local label=$2

    echo "$label Contents ($dir):"
    if [ -d "$dir" ]; then
        echo "  Directory exists: ✓"
        echo "  Permissions: $(ls -ld "$dir" | awk '{print $1}')"
        echo "  Owner: $(ls -ld "$dir" | awk '{print $3}')"
        echo "  Group: $(ls -ld "$dir" | awk '{print $4}')"
        echo
        echo "  Files and directories:"
        ls -la "$dir" 2>/dev/null || echo "    Unable to list contents (permission denied?)"
        echo
        echo "  File count: $(find "$dir" -maxdepth 1 -type f 2>/dev/null | wc -l) files"
        echo "  Directory count: $(find "$dir" -maxdepth 1 -type d 2>/dev/null | wc -l) directories"
    else
        echo "  Directory does not exist: ✗"
    fi
    echo
}

# List input directory
list_directory "/data/in" "📥 INPUT VOLUME"

# List output directory
list_directory "/data/out" "📤 OUTPUT VOLUME"

# Show mount information
echo "=== Mount Information ==="
echo "Current mounts related to /data:"
mount | grep "/data" || echo "No /data mounts found"
echo

# Show disk usage
echo "=== Disk Usage ==="
df -h /data/in /data/out 2>/dev/null || echo "Unable to check disk usage"
echo

echo "=== Quick Commands for Manual Testing ==="
echo "To list files manually:"
echo "  ls -la /data/in"
echo "  ls -la /data/out"
echo
echo "To check if directories are writable:"
echo "  touch /data/in/test_write.txt"
echo "  touch /data/out/test_write.txt"
echo
echo "To check mount details:"
echo "  mount | grep data"
echo "  df -h /data/in /data/out"
