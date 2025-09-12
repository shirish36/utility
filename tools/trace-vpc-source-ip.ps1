<#!
.SYNOPSIS
  Execute a Cloud Run Job and trace the VPC source IP (10.10.2.x) via VPC Flow Logs.

.DESCRIPTION
  This script helps you:
    1) Optionally execute a Cloud Run Job and wait for it to finish
    2) Fetch the latest job execution logs
    3) Query VPC Flow Logs to see the VPC subnet source IP used for egress

  Notes:
  - Inside the container you’ll see 169.254.x.x (expected). The VPC’s source IP
    is only visible from VPC Flow Logs on the subnet attached to your Serverless VPC Connector.
  - Ensure VPC Flow Logs are enabled on the subnet.

.PARAMETER ProjectId
  GCP Project ID. If not provided, tries to derive from ServiceAccountKeyPath or current gcloud config.

.PARAMETER Region
  GCP Region of the Cloud Run Job (default: us-central1).

.PARAMETER JobName
  Cloud Run Job name (default: utility-image).

.PARAMETER SubnetName
  Name of the VPC Subnet with Flow Logs enabled (default: app-dev).

.PARAMETER Freshness
  Time window to read logs (e.g., 10m, 1h). Default: 10m.

.PARAMETER Destination
  Optional DNS name to focus on (e.g., storage.googleapis.com). If provided, resolves A records and filters Flow Logs to these IPs.

.PARAMETER ExecuteJob
  If set, executes the job and waits for completion before reading logs.

.PARAMETER Tail
  If set, streams (tails) the VPC Flow Logs instead of a one-time read.

.PARAMETER ServiceAccountKeyPath
  Optional path to a GCP SA JSON (e.g., gha-sa-key-*.json). Used only to derive ProjectId safely.

.EXAMPLE
  ./tools/trace-vpc-source-ip.ps1 -ProjectId gifted-palace-468618-q5 -Region us-central1 -JobName utility-image -SubnetName app-dev -ExecuteJob

.EXAMPLE
  ./tools/trace-vpc-source-ip.ps1 -Destination storage.googleapis.com -Tail
#>

[CmdletBinding()]
param(
  [string]$ProjectId,
  [string]$Region = 'us-central1',
  [string]$JobName = 'utility-image',
  [string]$SubnetName = 'app-dev',
  [string]$Freshness = '10m',
  [string]$Destination,
  [switch]$ExecuteJob,
  [switch]$Tail,
  [string]$ServiceAccountKeyPath
)

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "[ERROR] $msg" -ForegroundColor Red }

try {
  # Validate gcloud
  if (-not (Get-Command gcloud -ErrorAction SilentlyContinue)) {
    throw 'gcloud CLI is not installed or not on PATH.'
  }

  # Derive ProjectId if missing
  if (-not $ProjectId) {
    if ($ServiceAccountKeyPath -and (Test-Path $ServiceAccountKeyPath)) {
      $json = Get-Content -Path $ServiceAccountKeyPath -Raw | ConvertFrom-Json
      if ($json.project_id) { $ProjectId = $json.project_id }
    }
  }
  if (-not $ProjectId) {
    $current = (& gcloud config get-value project 2>$null).Trim()
    if ($current -and $current -ne '(unset)') { $ProjectId = $current }
  }
  if (-not $ProjectId) {
    throw 'ProjectId not provided and could not be derived. Provide -ProjectId or authenticate and set gcloud project.'
  }

  Write-Info "Using Project: $ProjectId | Region: $Region | Job: $JobName | Subnet: $SubnetName"
  & gcloud config set project $ProjectId | Out-Null

  # Optionally execute the job and wait
  if ($ExecuteJob) {
    Write-Info "Executing Cloud Run Job $JobName ..."
    $execResult = & gcloud run jobs execute $JobName --region $Region --wait 2>&1
    Write-Host $execResult
  }

  # Fetch latest execution logs
  Write-Info "Fetching latest execution logs for job $JobName ..."
  $execRaw = & gcloud run jobs executions list --job $JobName --region $Region --limit 1 --format 'value(name)' 2>$null
  $exec = if ($execRaw) { $execRaw.Trim() } else { $null }
  if ($exec) {
    Write-Info "Latest execution: $exec"
    $logs = & gcloud run jobs executions logs read $exec --region $Region 2>&1
    Write-Host $logs
  } else {
    if ($ExecuteJob) {
      Write-Warn "Job executed but no executions listed yet. This can be eventual consistency. Retrying list..."
      Start-Sleep -Seconds 5
      $execRaw = & gcloud run jobs executions list --job $JobName --region $Region --limit 1 --format 'value(name)' 2>$null
      $exec = if ($execRaw) { $execRaw.Trim() } else { $null }
      if ($exec) {
        Write-Info "Latest execution: $exec"
        $logs = & gcloud run jobs executions logs read $exec --region $Region 2>&1
        Write-Host $logs
      } else {
        Write-Warn "Still no executions found. Try again shortly or ensure the job completed."
      }
    } else {
      Write-Warn "No executions found for $JobName in region $Region. Run with -ExecuteJob to create one."
    }
  }

  # Build VPC Flow Logs filter
  $baseFilter = @(
    'resource.type=gce_subnetwork',
    "resource.labels.subnetwork_name=$SubnetName",
    "resource.labels.region=$Region",
    "logName=projects/$ProjectId/logs/compute.googleapis.com%2Fvpc_flows",
    'jsonPayload.connection.direction=EGRESS'
  ) -join ' AND '

  $destClause = $null
  if ($Destination) {
    try {
      $ips = @(Resolve-DnsName -Name $Destination -Type A -ErrorAction Stop | Where-Object { $_.Type -eq 'A' } | Select-Object -ExpandProperty IPAddress)
      if ($ips.Count -gt 0) {
        $orList = $ips | ForEach-Object { "jsonPayload.connection.dest_ip=$_" }
        $destClause = '(' + ($orList -join ' OR ') + ')'
      } else {
        Write-Warn "No A records found for $Destination; proceeding without destination filter."
      }
    } catch {
      Write-Warn "DNS resolve failed for $Destination; proceeding without destination filter. $_"
    }
  }

  $fullFilter = if ($destClause) { "$baseFilter AND $destClause" } else { $baseFilter }
  Write-Info "VPC Flow Logs filter: $fullFilter"

  if ($Tail) {
    Write-Info 'Tailing VPC Flow Logs (Ctrl+C to stop) ...'
    & gcloud beta logging tail $fullFilter --project $ProjectId --format "value(timestamp, jsonPayload.connection.src_ip, jsonPayload.connection.dest_ip, jsonPayload.connection.dest_port, jsonPayload.disposition)"
    return
  }

  # One-time read
  $read = & gcloud logging read $fullFilter --project $ProjectId --freshness $Freshness --limit 100 --format "table(timestamp, jsonPayload.connection.src_ip, jsonPayload.connection.dest_ip, jsonPayload.connection.dest_port, jsonPayload.disposition)" 2>&1
  if (-not $read -or ($read -is [System.Array] -and $read.Count -eq 0)) {
    Write-Warn 'No VPC Flow Log entries returned. Ensure Flow Logs are enabled on the subnet and increase -Freshness if needed.'
    Write-Info "To enable: gcloud compute networks subnets update $SubnetName --region $Region --enable-flow-logs --project $ProjectId"
  } else {
    Write-Host $read
  }

} catch {
  Write-Err $_
  exit 1
}

exit 0
