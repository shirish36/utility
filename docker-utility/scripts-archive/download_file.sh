#!/bin/bash

# File Download Script
# Usage: ./download_file.sh [url] [output_filename]
# If no URL provided, uses DOWNLOAD_URL environment variable
# If no output filename provided, uses OUTPUT_FILE environment variable

URL=${1:-$DOWNLOAD_URL}
OUTPUT=${2:-$OUTPUT_FILE}

if [ -z "$URL" ]; then
    echo "Usage: $0 <url> [output_filename] or set DOWNLOAD_URL and OUTPUT_FILE environment variables"
    exit 1
fi

echo "Downloading $URL to $OUTPUT..."
curl -L -o $OUTPUT $URL

if [ $? -eq 0 ]; then
    echo "Download completed successfully."
    ls -la $OUTPUT
else
    echo "Download failed."
fi
