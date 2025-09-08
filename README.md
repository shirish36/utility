# Utility Repository

This repository contains utility tools and Docker images for various testing and automation tasks.

## Docker Utility Image

The `docker-utility/` directory contains a c#### Available Commands

- `/workspace/scripts/multi_command_test.sh` - Full container #### Application Failure Debugging

Use the comprehensive debug script for systematic troubleshooting:

```bash
# Debug application startup failures
/workspace/scripts/debug_app_failure.sh
```

This script tests:
- Container health and environment
- Volume mount accessibility
- Script availability and permissions
- Basic command functionality
- Network connectivity
- System resource availability

### Step-by-Step Application Debugging

#### **Phase 1: Basic Container Health**
```bash
# Test if container starts at all
gcloud run jobs execute utility-job \
  --command "echo 'Container started successfully'"
```

#### **Phase 2: Environment Verification**
```bash
# Check environment setup
gcloud run jobs execute utility-job \
  --command "/workspace/scripts/debug_app_failure.sh"
```

#### **Phase 3: Command Isolation**
```bash
# Test your command components separately
gcloud run jobs execute utility-job \
  --command "which your-command"  # Check if command exists

gcloud run jobs execute utility-job \
  --command "your-command --help"  # Test basic functionality
```

#### **Phase 4: Full Command Test**
```bash
# Test your complete command with error output
gcloud run jobs execute utility-job \
  --command "bash -c 'your-full-command' 2>&1"
```

### Common Application Failure Patterns

#### **Pattern 1: Command Not Found**
**Symptoms:** `exec: command not found`
**Debug:**
```bash
gcloud run jobs execute utility-job \
  --command "which your-command || echo 'Command not found in PATH'"
```

#### **Pattern 2: Missing Files/Directories**
**Symptoms:** `No such file or directory`
**Debug:**
```bash
gcloud run jobs execute utility-job \
  --command "ls -la /path/to/expected/file"
```

#### **Pattern 3: Permission Issues**
**Symptoms:** `Permission denied`
**Debug:**
```bash
gcloud run jobs execute utility-job \
  --command "ls -la /path/to/file && whoami && id"
```

#### **Pattern 4: Environment Variables**
**Symptoms:** Application can't find configuration
**Debug:**
```bash
gcloud run jobs execute utility-job \
  --command "env | grep -E '(your|variables|here)'"
```

#### **Pattern 5: Working Directory Issues**
**Symptoms:** Files not found in expected location
**Debug:**
```bash
gcloud run jobs execute utility-job \
  --command "pwd && ls -la && echo 'Working dir contents above'"
```

### Advanced Debugging Techniques

#### **Capture Full Error Output:**
```bash
gcloud run jobs execute utility-job \
  --command "bash -x your-script.sh 2>&1"  # Show execution trace
```

#### **Test with Simplified Command:**
```bash
# Start with minimal working command, then add complexity
gcloud run jobs execute utility-job \
  --command "echo 'Step 1' && ls /data/in && echo 'Step 2 complete'"
```

#### **Check Exit Codes:**
```bash
gcloud run jobs execute utility-job \
  --command "your-command; echo 'Exit code: $?'"
```

### Debugging Checklist

- [ ] **Container starts**: Basic echo command works
- [ ] **Environment set**: Required variables are available
- [ ] **Files accessible**: Input/output directories mounted
- [ ] **Command exists**: Executable is in PATH or full path provided
- [ ] **Permissions correct**: User can read/write required files
- [ ] **Working directory**: Command runs from expected location
- [ ] **Arguments valid**: Command syntax and parameters are correct
- [ ] **Dependencies met**: All required libraries/tools available

### Getting Detailed Logs

For maximum debugging information, use:

```bash
gcloud run jobs execute utility-job \
  --command "bash -x /workspace/scripts/your-script.sh" \
  --args "2>&1 | tee /data/out/debug.log"
```

This will:
- Show execution trace (`-x`)
- Capture all output (`2>&1`)
- Save logs to mounted volume (`tee /data/out/debug.log`)`/workspace/scripts/vpc_test.sh` - VPC connectivity testing
- `/workspace/scripts/volume_test.sh` - Comprehensive volume mount testing
- `/workspace/scripts/list_volumes.sh` - Quick volume file listing
- `/workspace/scripts/mount_investigation.sh` - GCS mount investigation
- `/workspace/scripts/debug_gcs_mount.sh` - GCS mount debugging
- `/workspace/scripts/debug_app_failure.sh` - Application failure debugging
- `/workspace/scripts/network_diag.sh` - Network diagnostics
- `/workspace/scripts/system_info.sh` - System information
- `sh` - Interactive shell (for manual testing)ive Docker image with networking tools and diagnostic scripts for Cloud Run Jobs.

### Included Tools
- **Networking**: `curl`, `ping`, `nslookup`, `dig`, `traceroute`, `netstat`, `ip`
- **System**: `ps`, `top`, `free`, `df`, `uptime`
- **Development**: `git`, `vim`, `nano`, `bash`

### Diagnostic Scripts

Located in `docker-utility/scripts/`:

- **`master_diagnostic.sh`**: 🏆 **MASTER DIAGNOSTIC** - Complete health check
  - Runs all diagnostic scripts in sequence
  - Provides comprehensive system overview
  - Shows volume mount status and network connectivity
  - One-stop diagnostic solution

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
  - Shows mount information and filesystem details

- **`list_volumes.sh`**: Quick volume file listing
  - Lists all files in mounted volumes
  - Shows permissions and ownership
  - Displays file and directory counts
  - Provides manual testing commands

- **`mount_investigation.sh`**: GCS mount investigation
  - Analyzes how GCS volumes are mounted
  - Shows FUSE filesystem details
  - Tests file access patterns
  - Investigates authentication setup

- **`debug_gcs_mount.sh`**: GCS mount debugging
  - Analyzes Cloud Run logs for mount issues
  - Tests file operations on mounted volumes
  - Verifies bucket connectivity
  - Diagnoses application startup failures

- **`debug_app_failure.sh`**: Application failure debugging
  - Systematic debugging of container startup issues
  - Tests basic container functionality
  - Verifies environment and resources
  - Isolates application-specific problems

- **`network_traffic_analysis.sh`**: Network traffic analysis
  - Analyzes VPC traffic flows to Cloud Storage and Cloud SQL
  - Checks VPC Flow Logs configuration
  - Monitors network connections and routing
  - Provides traffic monitoring recommendations

- **`system_info.sh`**: System information
  - Container resource usage
  - Process information
  - File system details

#### 🏆 Master Diagnostic Script

For the most comprehensive diagnostic experience, use the **master diagnostic script**:

```bash
# Run complete diagnostic suite
/workspace/scripts/master_diagnostic.sh
```

**What it provides:**
- 📊 **System Overview**: Complete environment and resource summary
- 💾 **Volume Status**: Detailed mount information and file counts
- 🌐 **Network Status**: Connectivity and DNS resolution tests
- 🔧 **All Individual Tests**: Runs every diagnostic script automatically
- 📋 **Executive Summary**: Clear pass/fail indicators and recommendations

**Perfect for:**
- ✅ **First-time debugging**: Get complete picture quickly
- ✅ **Comprehensive health checks**: Verify all systems working
- ✅ **Documentation**: Generate detailed diagnostic reports
- ✅ **Troubleshooting**: Identify issues across all components

**Runtime**: ~2-3 minutes (runs all diagnostics in sequence)

### VPC Networking

The Cloud Run Jobs are configured to run in VPC `vpc-core-dev` with subnet `app-dev` (10.10.2.0/24) in region `us-central1`.

**Note**: Cloud Run Jobs use internal IP addresses in the 169.254.x.x range even when attached to a VPC. This is normal behavior - the VPC attachment provides access to internal resources while maintaining Cloud Run's serverless networking model.

### VPC Egress Firewall Analysis

The `vpc_egress_firewall_analysis.sh` script provides comprehensive analysis of traffic flow through egress firewalls when accessing Google APIs like Cloud Storage.

#### End-to-End Traffic Flow with NAT

```
Cloud Run Job → NAT Translation → VPC (app-dev subnet) → Egress Firewall → Google APIs
     ↓                ↓                    ↓                        ↓
169.254.x.x    →  10.10.2.x      →   10.10.2.0/24     →   storage.googleapis.com
```

#### NAT (Network Address Translation) Behavior

**Cloud Run Jobs use NAT when connecting through VPC:**

1. **Internal IP**: Cloud Run containers use `169.254.x.x` internal IPs
2. **NAT Translation**: When "Route all traffic to VPC" is enabled, internal IPs are translated to VPC subnet IPs (`10.10.2.x`)
3. **Firewall Evaluation**: The egress firewall sees the NAT'd VPC subnet IP, not the internal IP
4. **Traffic Flow**: `169.254.x.x` → `10.10.2.x` → Firewall check → `storage.googleapis.com`

#### Firewall Configuration

- **Target**: `storage.googleapis.com`
- **Allowed CIDR**: `10.10.0.0/22` (includes your subnet `10.10.2.0/24`)
- **Protocol**: TCP/443 (HTTPS)
- **Direction**: Egress

#### Running NAT Analysis

```bash
# Analyze NAT behavior in Cloud Run Jobs
/workspace/scripts/nat_analysis.sh
```

This script will:
- Show internal vs external IP addresses
- Demonstrate NAT translation process
- Test connectivity with detailed logging
- Explain firewall-NAT interaction

#### Running the Analysis

```bash
# Analyze VPC egress firewall configuration and connectivity
/workspace/scripts/vpc_egress_firewall_analysis.sh
```

This script will:
- Analyze VPC routing configuration
- Validate egress firewall rules
- Test Cloud Storage connectivity
- Debug network path issues
- Provide troubleshooting commands

#### Common Firewall Issues

1. **Source IP not in allowed CIDR**
   - Your subnet `10.10.2.0/24` must be within `10.10.0.0/22`
   - Cloud Run uses internal IPs (169.254.x.x) but traffic is NAT'd

2. **Destination not matching**
   - Ensure requests go to `storage.googleapis.com`
   - Check for hardcoded IPs or alternative endpoints

3. **Protocol/Port issues**
   - Cloud Storage requires TCP/443 (HTTPS)
   - Ensure SSL/TLS is properly configured

#### Debugging Commands

```bash
# Test basic connectivity
gcloud run jobs execute utility-job \
  --command "curl -I https://storage.googleapis.com" \
  --region us-central1

# Debug DNS resolution
gcloud run jobs execute utility-job \
  --command "nslookup storage.googleapis.com" \
  --region us-central1

# Check firewall rules
gcloud compute firewall-rules list \
  --filter='direction=EGRESS' \
  --format='table(name,network,direction,priority,sourceRanges,targetTags)'
```

#### Quick Firewall Test

For rapid validation of egress firewall connectivity:

```bash
# Quick test of Cloud Storage access through firewall
/workspace/scripts/quick_firewall_test.sh
```

This script performs:
- HTTPS connectivity test to `storage.googleapis.com`
- DNS resolution validation
- Network path verification
- SSL certificate validation

#### Cloud Logging Guide

Access comprehensive logging information for all diagnostic activities:

```bash
# View all logging locations and queries
/workspace/scripts/cloud_logging_guide.sh
```

This guide covers:
- **Cloud Run Jobs logs**: Execution output and errors
- **VPC Flow Logs**: Network traffic patterns and NAT behavior
- **Firewall Logs**: Rule evaluations and traffic decisions
- **Log queries**: Ready-to-use filter expressions
- **Troubleshooting**: How to diagnose issues using logs

#### Ready-to-use Cloud Logging queries (VPC traffic)

Use these in Logs Explorer to inspect traffic from your VPC/subnet. Replace values if needed.

All VPC traffic from subnet `app-dev` in `us-central1`:

```
resource.type="gce_subnetwork"
resource.labels.subnetwork_name="app-dev"
resource.labels.region="us-central1"
logName="projects/gifted-palace-468618-q5/logs/compute.googleapis.com%2Fvpc_flows"
```

Egress-only traffic:

```
resource.type="gce_subnetwork"
resource.labels.subnetwork_name="app-dev"
resource.labels.region="us-central1"
logName="projects/gifted-palace-468618-q5/logs/compute.googleapis.com%2Fvpc_flows"
jsonPayload.connection.direction="EGRESS"
```

Traffic to Google APIs (HTTPS on 443):

```
resource.type="gce_subnetwork"
resource.labels.subnetwork_name="app-dev"
resource.labels.region="us-central1"
logName="projects/gifted-palace-468618-q5/logs/compute.googleapis.com%2Fvpc_flows"
jsonPayload.connection.direction="EGRESS"
jsonPayload.connection.dest_port=443
```

Traffic to Private Google Access VIPs (if using restricted/private googleapis):

```
resource.type="gce_subnetwork"
resource.labels.subnetwork_name="app-dev"
resource.labels.region="us-central1"
logName="projects/gifted-palace-468618-q5/logs/compute.googleapis.com%2Fvpc_flows"
jsonPayload.connection.direction="EGRESS"
(jsonPayload.connection.dest_ip:"199.36.153." OR jsonPayload.connection.dest_ip:"199.36.153.4" OR jsonPayload.connection.dest_ip:"199.36.153.8")
```

Broad Google front-end ranges (approximate; adjust as needed):

```
resource.type="gce_subnetwork"
resource.labels.subnetwork_name="app-dev"
resource.labels.region="us-central1"
logName="projects/gifted-palace-468618-q5/logs/compute.googleapis.com%2Fvpc_flows"
jsonPayload.connection.direction="EGRESS"
(jsonPayload.connection.dest_ip:"142.250." OR jsonPayload.connection.dest_ip:"172.217." OR jsonPayload.connection.dest_ip:"216.58.")
```

Firewall decisions (ALLOW/DENY):

```
resource.type="gce_firewall_rule"
logName="projects/gifted-palace-468618-q5/logs/compute.googleapis.com%2Ffirewall"
```

Only DENIED egress traffic:

```
resource.type="gce_firewall_rule"
logName="projects/gifted-palace-468618-q5/logs/compute.googleapis.com%2Ffirewall"
jsonPayload.connection.direction="EGRESS"
jsonPayload.disposition="DENIED"
```

DNS query logs (optional; enable DNS logging first):

```
resource.type="dns_query"
logName="projects/gifted-palace-468618-q5/logs/dns.googleapis.com%2Fqueries"
jsonPayload.queryName="storage.googleapis.com."
```

Tips:
- In Logs Explorer, use Aggregate by → `jsonPayload.connection.dest_ip` or `dest_port`.
- Set a narrow time range for faster results (e.g., Last 1 hour).
- Ensure VPC Flow Logs are enabled on subnet `app-dev`.

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

#### Quick Volume Listing

Use the `list_volumes.sh` script for a quick overview:

```bash
# Quick file listing
/workspace/scripts/list_volumes.sh
```

This provides:
- File and directory counts
- Permissions and ownership details
- Mount information
- Manual testing commands

#### Manual Volume Verification

You can also verify volumes manually using these commands:

```bash
# Check if directories exist
ls -la /data/in
ls -la /data/out

# Test write permissions
touch /data/in/test.txt
touch /data/out/test.txt

# Check mount information
mount | grep data
df -h /data/in /data/out

# List all files recursively
find /data/in -type f
find /data/out -type f
```

#### Volume Mount Indicators

**✅ Volume is properly mounted if:**
- Directories `/data/in` and `/data/out` exist
- You can create and modify files in both directories
- `mount` command shows volume mounts
- `df -h` shows disk usage for mounted volumes
- File operations (read/write/copy) work successfully

**❌ Volume mount issues if:**
- Directories don't exist or are empty
- Permission denied errors when accessing files
- No mount entries in `mount` output
- File operations fail

### GCS Volume Mount Technical Details

When you mount GCS buckets as volumes in Cloud Run Jobs, here's how the system works:

#### Mount Path and Access
- **Mount Point**: GCS buckets are mounted at `/data/in` and `/data/out`
- **Filesystem Type**: FUSE (Filesystem in Userspace) based filesystem
- **Access Method**: Standard POSIX filesystem operations (open, read, write, close)

#### APIs and Services Involved

**🔗 Primary APIs:**
- **Cloud Storage JSON API** (`storage.googleapis.com`)
  - Handles all GCS operations (read, write, list, delete)
  - RESTful API for object storage operations
  - Used by gcsfuse for file operations

- **GCS FUSE Driver**
  - Translates POSIX filesystem calls to GCS API calls
  - Provides local filesystem interface to cloud storage
  - Handles caching and connection management

**🔐 Authentication:**
- **Service Account**: Uses the configured service account for authentication
- **OAuth2 Flow**: Automatic token refresh and management
- **Scopes**: Requires `https://www.googleapis.com/auth/devstorage.full_control`

#### File Access Patterns

**Read Operations:**
1. Application calls `open()` → FUSE intercepts call
2. FUSE makes API call to `storage.googleapis.com/b/bucket/o/object`
3. GCS returns object data → FUSE provides to application
4. Data is cached locally for performance

**Write Operations:**
1. Application calls `write()` → FUSE buffers data
2. On `close()` or `fsync()`, FUSE uploads to GCS
3. Uses multipart upload for large files
4. Metadata updated after successful upload

#### Performance Considerations

**✅ Optimized for:**
- Sequential reads/writes
- Small to medium file sizes
- Read-heavy workloads
- Directory listing operations

**⚠️ Performance Notes:**
- First access may have higher latency (cold start)
- Large directory listings can be slow
- Concurrent writes to same file not recommended
- Metadata operations are network calls

#### GCS Mount Debugging

Use the debug script to analyze your specific GCS mount setup:

```bash
# Debug GCS mount issues
/workspace/scripts/debug_gcs_mount.sh
```

This script will:
- Analyze mount status from Cloud Run logs
- Test file operations on mounted volumes
- Verify bucket connectivity
- Diagnose application startup failures

### Troubleshooting Application Failures

If you see "Application failed to start" in your logs:

#### **Common Issues:**

**1. Command Not Found:**
```bash
# Test with simple command first
gcloud run jobs execute your-job \
  --command "ls -la /data/in"
```

**2. Environment Variables Missing:**
```bash
# Check environment variables
gcloud run jobs execute your-job \
  --command "env | grep -E '(INPUT_DIR|OUTPUT_DIR)'"
```

**3. File Permissions:**
```bash
# Test file operations
gcloud run jobs execute your-job \
  --command "touch /data/out/test.txt && echo 'Success'"
```

**4. Script Execution Issues:**
```bash
# Test script directly
gcloud run jobs execute your-job \
  --command "/workspace/scripts/debug_gcs_mount.sh"
```

#### **Debug Steps:**

1. **Start Simple**: Use basic commands first (`ls`, `pwd`, `echo`)
2. **Check Mounts**: Verify volumes are mounted correctly
3. **Test File Ops**: Ensure read/write permissions work
4. **Check Environment**: Verify required variables are set
5. **Review Logs**: Look for specific error messages

#### **Example Debug Commands:**

```bash
# Test basic functionality
gcloud run jobs execute utility-job \
  --command "echo 'Container started' && ls -la /data/"

# Test volume access
gcloud run jobs execute utility-job \
  --command "test -d /data/in && echo 'Input mounted' || echo 'Input not mounted'"

# Test your application script
gcloud run jobs execute utility-job \
  --command "bash -c 'your-command-here' 2>&1"
```

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

- `/workspace/scripts/master_diagnostic.sh` - 🏆 Complete diagnostic suite
- `/workspace/scripts/network_traffic_analysis.sh` - Network traffic analysis
- `/workspace/scripts/multi_command_test.sh` - Full container diagnostics
- `/workspace/scripts/vpc_test.sh` - VPC connectivity testing
- `/workspace/scripts/volume_test.sh` - Comprehensive volume mount testing
- `/workspace/scripts/list_volumes.sh` - Quick volume file listing
- `/workspace/scripts/mount_investigation.sh` - GCS mount investigation
- `/workspace/scripts/debug_gcs_mount.sh` - GCS mount debugging
- `/workspace/scripts/debug_app_failure.sh` - Application failure debugging
- `/workspace/scripts/network_diag.sh` - Network diagnostics
- `/workspace/scripts/system_info.sh` - System information
- `sh` - Interactive shell (for manual testing)

 
 # # #   V P C   N e t w o r k   T r a f f i c   A n a l y s i s 
 
 T o   m o n i t o r   a n d   a n a l y z e   n e t w o r k   t r a f f i c   f l o w s   b e t w e e n   y o u r   V P C   a n d   G o o g l e   C l o u d   s e r v i c e s ,   u s e   t h e   n e t w o r k   t r a f f i c   a n a l y s i s   s c r i p t : 
 
 ` ` ` b a s h 
 #   A n a l y z e   V P C   t r a f f i c   f l o w s 
 / w o r k s p a c e / s c r i p t s / n e t w o r k _ t r a f f i c _ a n a l y s i s . s h 
 ` ` ` 
 
 T h i s   s c r i p t   p r o v i d e s   c o m p r e h e n s i v e   a n a l y s i s   o f : 
 
 # # # #   * * =�
�  T r a f f i c   F l o w   A n a l y s i s : * * 
 -   * * C l o u d   S t o r a g e   T r a f f i c * * :   G C S   F U S E   o p e r a t i o n s   a n d   A P I   c a l l s 
 -   * * C l o u d   S Q L   T r a f f i c * * :   D a t a b a s e   c o n n e c t i o n   p a t t e r n s   a n d   p r o t o c o l s 
 -   * * V P C   F l o w   L o g s * * :   N e t w o r k   f l o w   m o n i t o r i n g   s e t u p 
 -   * * N e t w o r k   T o p o l o g y * * :   R o u t i n g   a n d   c o n n e c t i v i t y   a n a l y s i s 
 
 # # # #   * *   M o n i t o r i n g   C a p a b i l i t i e s : * * 
 -   * * R e a l - t i m e   C o n n e c t i o n s * * :   A c t i v e   n e t w o r k   c o n n e c t i o n s   m o n i t o r i n g 
 -   * * D N S   R e s o l u t i o n * * :   N a m e   r e s o l u t i o n   p a t t e r n s 
 -   * * P r o t o c o l   A n a l y s i s * * :   T C P / U D P   t r a f f i c   p a t t e r n s 
 -   * * E n d p o i n t   A n a l y s i s * * :   S e r v i c e   e n d p o i n t   c o n n e c t i v i t y 
 
 # # # #   * *   E n a b l e   V P C   F l o w   L o g s * * 
 
 F o r   d e t a i l e d   n e t w o r k   t r a f f i c   a n a l y s i s ,   e n a b l e   V P C   F l o w   L o g s : 
 
 ` ` ` b a s h 
 #   E n a b l e   V P C   F l o w   L o g s   o n   y o u r   s u b n e t 
 g c l o u d   c o m p u t e   n e t w o r k s   s u b n e t s   u p d a t e   a p p - d e v   \ 
     - - r e g i o n = u s - c e n t r a l 1   \ 
     - - e n a b l e - f l o w - l o g s   \ 
     - - f l o w - l o g s - s a m p l i n g = 0 . 5   \ 
     - - f l o w - l o g s - m e t a d a t a = i n c l u d e - a l l 
 ` ` ` 
 
 # # # #   * *   C l o u d   M o n i t o r i n g   M e t r i c s * * 
 
 K e y   m e t r i c s   t o   m o n i t o r   f o r   V P C   t r a f f i c : 
 
 * * N e t w o r k   M e t r i c s : * * 
 -   ` n e t w o r k i n g . g o o g l e a p i s . c o m / v p c _ f l o w / b y t e s _ c o u n t ` 
 -   ` n e t w o r k i n g . g o o g l e a p i s . c o m / v p c _ f l o w / p a c k e t _ c o u n t ` 
 -   ` n e t w o r k i n g . g o o g l e a p i s . c o m / v p c _ f l o w / t c p _ c o n n e c t i o n _ c o u n t ` 
 
 * * C l o u d   S t o r a g e   M e t r i c s : * * 
 -   ` s t o r a g e . g o o g l e a p i s . c o m / a p i / r e q u e s t _ c o u n t ` 
 -   ` s t o r a g e . g o o g l e a p i s . c o m / n e t w o r k / s e n t _ b y t e s _ c o u n t ` 
 -   ` s t o r a g e . g o o g l e a p i s . c o m / n e t w o r k / r e c e i v e d _ b y t e s _ c o u n t ` 
 
 * * C l o u d   S Q L   M e t r i c s : * * 
 -   ` c l o u d s q l . g o o g l e a p i s . c o m / d a t a b a s e / c o n n e c t i o n / c o u n t ` 
 -   ` c l o u d s q l . g o o g l e a p i s . c o m / d a t a b a s e / n e t w o r k / c o n n e c t i o n _ e r r o r s ` 
 -   ` c l o u d s q l . g o o g l e a p i s . c o m / d a t a b a s e / n e t w o r k / s e n t _ b y t e s _ c o u n t ` 
 
 # # # #   * *   T r a f f i c   C a p t u r e   a n d   A n a l y s i s * * 
 
 F o r   d e e p   p a c k e t   i n s p e c t i o n ,   u s e   t h e   t r a f f i c   c a p t u r e   s c r i p t   p r o v i d e d   i n   t h e   a n a l y s i s   o u t p u t : 
 
 ` ` ` b a s h 
 #   C a p t u r e   n e t w o r k   t r a f f i c   f o r   3 0   s e c o n d s 
 / w o r k s p a c e / s c r i p t s / c a p t u r e _ t r a f f i c . s h 
 ` ` ` 
 
 T h i s   w i l l   c a p t u r e   t r a f f i c   t o : 
 -   ` s t o r a g e . g o o g l e a p i s . c o m `   ( C l o u d   S t o r a g e ) 
 -   P o r t   3 3 0 6   ( M y S Q L   C l o u d   S Q L ) 
 -   P o r t   5 4 3 2   ( P o s t g r e S Q L   C l o u d   S Q L ) 
 
 # # # #   * *   N e t w o r k   I n t e l l i g e n c e   C e n t e r * * 
 
 U s e   N e t w o r k   I n t e l l i g e n c e   C e n t e r   f o r   a d v a n c e d   n e t w o r k   m o n i t o r i n g : 
 
 1 .   * * C o n n e c t i v i t y   T e s t s * * :   T e s t   r e a c h a b i l i t y   t o   C l o u d   S t o r a g e   a n d   C l o u d   S Q L 
 2 .   * * N e t w o r k   T o p o l o g y * * :   V i s u a l i z e   y o u r   V P C   n e t w o r k 
 3 .   * * F i r e w a l l   I n s i g h t s * * :   A n a l y z e   f i r e w a l l   r u l e s   i m p a c t 
 4 .   * * P e r f o r m a n c e   D a s h b o a r d * * :   M o n i t o r   n e t w o r k   l a t e n c y   a n d   t h r o u g h p u t 
 
 # # # #   * *   T r a f f i c   F l o w   P a t t e r n s * * 
 
 * * C l o u d   S t o r a g e   ( G C S   F U S E ) : * * 
 ` ` ` 
 C o n t a i n e r     G C S   F U S E     s t o r a g e . g o o g l e a p i s . c o m : 4 4 3   ( H T T P S ) 
                   
       P O S I X   O p e r a t i o n s     R E S T   A P I   C a l l s     G C S   O b j e c t s 
 ` ` ` 
 
 * * C l o u d   S Q L   ( P r i v a t e   I P ) : * * 
 ` ` ` 
 C o n t a i n e r     V P C   N e t w o r k     C l o u d   S Q L   P r i v a t e   I P 
                   
       D a t a b a s e   P r o t o c o l     D i r e c t   T C P   C o n n e c t i o n 
 ` ` ` 
 
 * * C l o u d   S Q L   ( C l o u d   S Q L   P r o x y ) : * * 
 ` ` ` 
 C o n t a i n e r     C l o u d   S Q L   P r o x y     C l o u d   S Q L   I n s t a n c e 
                   
       L o c a l   P o r t     E n c r y p t e d   T u n n e l     D a t a b a s e 
 ` ` ` 
 
 # # # #   * *   P e r f o r m a n c e   O p t i m i z a t i o n * * 
 
 * * F o r   C l o u d   S t o r a g e : * * 
 -   U s e   G C S   F U S E   w i t h   a p p r o p r i a t e   c a c h e   s e t t i n g s 
 -   E n a b l e   p a r a l l e l   d o w n l o a d s   f o r   l a r g e   f i l e s 
 -   M o n i t o r   ` s t o r a g e . g o o g l e a p i s . c o m / a p i / r e q u e s t _ c o u n t ` 
 
 * * F o r   C l o u d   S Q L : * * 
 -   U s e   c o n n e c t i o n   p o o l i n g 
 -   E n a b l e   S S L / T L S   e n c r y p t i o n 
 -   M o n i t o r   c o n n e c t i o n   c o u n t   a n d   l a t e n c y 
 -   U s e   p r i v a t e   I P   w h e n   p o s s i b l e 
 
 # # # #   * *   A l e r t i n g   S e t u p * * 
 
 S e t   u p   a l e r t s   f o r   t r a f f i c   a n o m a l i e s : 
 
 ` ` ` b a s h 
 #   H i g h   e g r e s s   t r a f f i c   a l e r t 
 g c l o u d   m o n i t o r i n g   a l e r t - p o l i c i e s   c r e a t e   h i g h - e g r e s s - t r a f f i c   \ 
     - - c o n d i t i o n = " r e s o u r c e . t y p e = g c e _ i n s t a n c e   A N D   m e t r i c . t y p e = c o m p u t e . g o o g l e a p i s . c o m / i n s t a n c e / n e t w o r k / s e n t _ b y t e s _ c o u n t   A N D   m e t r i c . t h r e s h o l d > 1 0 0 0 0 0 0 "   \ 
     - - n o t i f i c a t i o n - c h a n n e l s = y o u r - c h a n n e l 
 ` ` ` 
 
 T h i s   c o m p r e h e n s i v e   n e t w o r k   t r a f f i c   a n a l y s i s   w i l l   g i v e   y o u   c o m p l e t e   v i s i b i l i t y   i n t o   y o u r   V P C   t r a f f i c   f l o w s   t o   C l o u d   S t o r a g e   a n d   C l o u d   S Q L ! 
 
 