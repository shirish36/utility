# Utility Repository

This repository contains utility tools and Docker images for various testing and automation tasks.

## Docker Utility Image

The `docker-utility/` directory contains a comprehensive Docker image with networking tools and diagnostic scripts for Cloud Run Jobs.

### Included Tools
- **Networking**: `curl`, `ping`, `nslookup`, `dig`, `traceroute`, `netstat`, `ip`
- **System**: `ps`, `top`, `free`, `df`, `uptime`
- **Development**: `git`, `vim`, `nano`, `bash`

### Diagnostic Scripts

Located in `docker-utility/scripts/`:

- **`multi_command_test.sh`**: Comprehensive container diagnostics
  - Network interface inspection
  - IP address and routing information
  - Environment variables
  - System resources

- **`vpc_test.sh`**: VPC connectivity testing
  - VPC metadata access
  - Internal DNS resolution
  - Subnet connectivity verification
  - Network reachability tests

- **`network_diag.sh`**: Network diagnostics
  - DNS resolution testing
  - External connectivity checks
  - Network interface details

- **`volume_test.sh`**: Volume mount testing
  - Tests `/data/in` and `/data/out` directory access
  - Verifies file read/write permissions
  - Demonstrates volume mount functionality

### VPC Networking

The Cloud Run Jobs are configured to run in VPC `vpc-core-dev` with subnet `app-dev` (10.10.2.0/24) in region `us-central1`.

**Note**: Cloud Run Jobs use internal IP addresses in the 169.254.x.x range even when attached to a VPC. This is normal behavior - the VPC attachment provides access to internal resources while maintaining Cloud Run's serverless networking model.

### Volume Mounts

The Docker image includes support for volume mounts at `/data/in` and `/data/out`:

- **`/data/in`**: Input directory for reading files
- **`/data/out`**: Output directory for writing results

#### Cloud Run Jobs Volume Configuration

To use volume mounts in Cloud Run Jobs:

1. **Create GCS Buckets** (if using GCS volumes):
   ```bash
   # Create buckets for input and output
   gsutil mb gs://your-project-input-bucket
   gsutil mb gs://your-project-output-bucket
   ```

2. **Configure Volume Mounts** in Cloud Run Jobs:
   - Mount `/data/in` to your input GCS bucket
   - Mount `/data/out` to your output GCS bucket

3. **Environment Variables**:
   - `INPUT_DIR=/data/in` - Points to input volume
   - `OUTPUT_DIR=/data/out` - Points to output volume

#### Testing Volume Mounts

Use the `volume_test.sh` script to verify volume mount functionality:

```bash
# Run volume mount test
/workspace/scripts/volume_test.sh
```

This script will:
- Check if directories exist and are accessible
- Test read/write permissions
- Demonstrate file operations between volumes
- Show disk usage information

## GCP Service Account Setup

This repository uses a GCP Service Account for deploying to Cloud Run Jobs:

- **Service Account**: `github-actions@gifted-palace-468618-q5.iam.gserviceaccount.com`
- **Project ID**: `gifted-palace-468618-q5`

### Required GCP Permissions

The service account needs the following IAM roles:
- `roles/run.admin` - For managing Cloud Run Jobs
- `roles/storage.admin` - For pushing images to GCR
- `roles/iam.serviceAccountUser` - For using the service account

### GitHub Secrets Setup

⚠️ **Important**: The service account key file (`gha-sa-key-0831.json`) is NOT committed to this repository for security reasons.

To set up GitHub Actions:

1. Go to Repository Settings > Secrets and variables > Actions
2. Add a new repository secret named `GCP_SA_KEY`
3. Copy the entire contents of your `gha-sa-key-0831.json` file and paste it as the secret value

### Usage

The GitHub Actions workflow will automatically:
- Build the Docker image when changes are pushed to `docker-utility/`
- Push the image to Google Container Registry
- Deploy to Cloud Run Jobs
- Optionally execute the job and show logs

You can also manually trigger the workflow with custom parameters via GitHub Actions tab.

#### Running Diagnostic Scripts

To run a diagnostic script in Cloud Run Jobs:

1. Go to GitHub Actions tab
2. Click "Run workflow" on the deploy workflow
3. Set the following parameters:
   - **Command**: `/workspace/scripts/multi_command_test.sh` (or other script)
   - **Arguments**: (leave empty for most scripts)
   - **Execute Job**: `true`
   - **Show Logs**: `true`

#### Available Commands

- `/workspace/scripts/multi_command_test.sh` - Full container diagnostics
- `/workspace/scripts/vpc_test.sh` - VPC connectivity testing
- `/workspace/scripts/volume_test.sh` - Volume mount testing
- `/workspace/scripts/network_diag.sh` - Network diagnostics
- `/workspace/scripts/system_info.sh` - System information
- `sh` - Interactive shell (for manual testing)
