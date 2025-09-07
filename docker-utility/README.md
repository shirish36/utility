# Utility Docker Image

This Docker image provides a lightweight utility container with various networking and development tools for testing and debugging purposes.

## Included Tools

- **Networking**: curl, wget, ping, traceroute, nslookup, dig, nc (netcat), tcpdump
- **Development**: git, python3, pip, vim, nano, bash
- **System Monitoring**: htop, tree, jq

## Building the Image

```bash
docker build -t utility-image .
```

## Running the Container

```bash
# Interactive shell
docker run -it utility-image

# With volume mount for file access
docker run -it -v $(pwd):/workspace utility-image

# Run specific commands
docker run --rm utility-image curl -I https://www.google.com
docker run --rm utility-image ping -c 4 google.com
```

## Example Usage

```bash
# Test website access
curl -I https://example.com

# Download a file
wget https://example.com/file.txt

# Check DNS resolution
nslookup google.com

# Trace network path
traceroute google.com

# Monitor network traffic (requires --cap-add=NET_ADMIN)
tcpdump -i eth0

# Run Python scripts
python3 script.py
```

## GCP Cloud Run Jobs Deployment

This image is designed to work with Google Cloud Run Jobs for flexible command execution without hardcoded values.

### Prerequisites
- Google Cloud Project with Cloud Run API enabled
- Docker image pushed to Google Container Registry (GCR) or Artifact Registry
- gcloud CLI installed and authenticated

### Pushing to Google Container Registry

```bash
# Tag the image
docker tag utility-image gcr.io/YOUR_PROJECT_ID/utility-image

# Push to GCR
docker push gcr.io/YOUR_PROJECT_ID/utility-image
```

### Creating Cloud Run Jobs

#### Example 1: Network Test Job
```bash
gcloud run jobs create network-test-job \
  --image gcr.io/YOUR_PROJECT_ID/utility-image \
  --set-env-vars TARGET_HOST=example.com \
  --command /workspace/scripts/network_test.sh \
  --region us-central1 \
  --max-retries 0 \
  --cpu 1 \
  --memory 512Mi
```

#### Example 2: File Download Job
```bash
gcloud run jobs create download-job \
  --image gcr.io/YOUR_PROJECT_ID/utility-image \
  --set-env-vars DOWNLOAD_URL=https://example.com/file.txt,OUTPUT_FILE=myfile.txt \
  --command /workspace/scripts/download_file.sh \
  --region us-central1 \
  --max-retries 0 \
  --cpu 1 \
  --memory 512Mi
```

#### Example 3: Custom Command Job
```bash
gcloud run jobs create custom-command-job \
  --image gcr.io/YOUR_PROJECT_ID/utility-image \
  --command /bin/bash \
  --args -c,"curl -s https://httpbin.org/get | jq .url" \
  --region us-central1 \
  --max-retries 0 \
  --cpu 1 \
  --memory 512Mi
```

### Environment Variables

You can externalize configurations using environment variables:

- `TARGET_URL`: Default URL for HTTP requests
- `TARGET_HOST`: Default hostname for network tests
- `DOWNLOAD_URL`: Default URL for file downloads
- `OUTPUT_FILE`: Default output filename for downloads

### Running Jobs

```bash
# Execute a job
gcloud run jobs execute network-test-job --region us-central1

# Check job status
gcloud run jobs executions list --region us-central1

# View execution logs
gcloud run jobs executions logs read EXECUTION_ID --region us-central1
```

### Notes

- The container runs as root by default
- For network monitoring tools like tcpdump, you may need to add `--cap-add=NET_ADMIN` when running (not supported in Cloud Run Jobs)
- Mount volumes to access local files: `-v /host/path:/container/path` (not applicable for Cloud Run Jobs)
- Cloud Run Jobs are designed for batch processing and run-to-completion tasks
