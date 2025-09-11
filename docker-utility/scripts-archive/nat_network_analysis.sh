#!/bin/bash

# NAT Network-Only Analysis
# Focuses purely on networking and NAT behavior (no storage/volume tests)

set -euo pipefail

banner() {
  echo "=================================================================================="
  echo "$1"
  echo "=================================================================================="
}

section() {
  echo
  echo "--- $1 ---"
}

banner "🔄 NAT NETWORK ANALYSIS (Network-only)"
echo "Goal: Verify how Cloud Run Jobs egress to the internet/VPC and what public IP is used."

echo

# Config
TARGET_HOST=${TARGET_HOST:-google.com}
ALT_IP_SERVICE_1="https://httpbin.org/ip"
ALT_IP_SERVICE_2="https://ifconfig.me"

analyze_ip_addrs_and_routes() {
  banner "📍 IP ADDRESSES, INTERFACES, ROUTING"

  section "Container internal IPs (expected 169.254.x.x)"
  hostname -i 2>/dev/null || true

  section "Network interfaces"
  ip addr show 2>/dev/null || true

  section "Routing table"
  ip route show 2>/dev/null || true

  section "DNS configuration"
  cat /etc/resolv.conf 2>/dev/null || true
}

clarify_nat_types() {
  banner "ℹ️  NAT TYPES IN THIS CONTEXT"
  cat <<'EOF'
- Cloud Run containers use link-local IPs (169.254.x.x) internally.
- When "Route all traffic to VPC" is enabled, outbound traffic is NAT'd at the VPC boundary.
- This is automatic VPC NAT for Cloud Run Jobs. You do NOT need to configure Cloud NAT unless you want fixed egress IPs via a Serverless VPC Connector.
- If using a Serverless VPC Connector + Cloud NAT with static addresses, the public egress IP will match one of the NAT IPs.
- If using Google-managed egress (no connector), egress IPs are Google-managed and may vary.
EOF
}

external_ip_visibility() {
  banner "🌐 EXTERNAL IP AS SEEN BY THE INTERNET"

  section "Query external IP via httpbin.org"
  if curl -sS --max-time 10 "$ALT_IP_SERVICE_1" | sed -e 's/\n/ /g'; then
    true
  else
    echo "(fallback)"
    section "Query external IP via ifconfig.me"
    curl -sS --max-time 10 "$ALT_IP_SERVICE_2" || echo "Unable to determine external IP"
  fi
}

basic_connectivity_checks() {
  banner "✅ BASIC CONNECTIVITY"

  section "DNS resolution for target host: $TARGET_HOST"
  nslookup "$TARGET_HOST" 2>/dev/null || getent hosts "$TARGET_HOST" 2>/dev/null || echo "DNS lookup failed"

  section "TCP reachability to $TARGET_HOST:443 (timeout 5s)"
  if timeout 5 bash -c "</dev/tcp/$TARGET_HOST/443" 2>/dev/null; then
    echo "TCP 443 reachable"
  else
    echo "TCP 443 NOT reachable"
  fi

  section "HTTPS HEAD to https://$TARGET_HOST"
  curl -I --max-time 10 "https://$TARGET_HOST" 2>/dev/null | head -3 || echo "HTTPS request failed"
}

verbose_tls_handshake() {
  banner "🔐 TLS HANDSHAKE (first lines)"
  echo "openssl s_client -connect $TARGET_HOST:443 -servername $TARGET_HOST"
  # Don't fail script if openssl not present in minimal images
  if command -v openssl >/dev/null 2>&1; then
    openssl s_client -connect "$TARGET_HOST:443" -servername "$TARGET_HOST" </dev/null 2>/dev/null | openssl x509 -noout -dates 2>/dev/null || echo "Unable to read certificate dates"
  else
    echo "openssl not available"
  fi
}

troubleshooting_hints() {
  banner "🛠️ TROUBLESHOOTING & NEXT STEPS"
  cat <<'EOF'
- If external IP cannot be determined, egress may be blocked by firewall or no internet path is allowed.
- For fixed egress IPs, attach a Serverless VPC Connector and configure Cloud NAT with static external addresses.
- Use VPC Flow Logs on the connector subnet to see egress flows (resource.type=gce_subnetwork).
- If using Private Google Access/restricted.googleapis.com, expect traffic to Google VIPs (199.36.153.0/30) instead of general internet.
- Check firewall egress rules for TCP/443 and destination ranges.
EOF

  echo
  echo "Logs Explorer queries (paste in Cloud Logging):"
  echo "- Cloud Run stdout/stderr:"
  echo "  resource.type=(\"cloud_run_job\" OR \"cloud_run_task\")"
  echo "  logName=(\"projects/${GOOGLE_CLOUD_PROJECT:-YOUR_PROJECT}/logs/run.googleapis.com%2Fstdout\" OR \"projects/${GOOGLE_CLOUD_PROJECT:-YOUR_PROJECT}/logs/run.googleapis.com%2Fstderr\")"
  echo
  echo "- VPC Flow Logs (connector subnet):"
  echo "  resource.type=\"gce_subnetwork\""
  echo "  logName=\"projects/${GOOGLE_CLOUD_PROJECT:-YOUR_PROJECT}/logs/compute.googleapis.com%2Fvpc_flows\""
}

summary() {
  banner "📋 SUMMARY"
  echo "- Internal IPs (expected): 169.254.x.x"
  echo "- Egress mode: VPC NAT (automatic) unless using Serverless VPC Connector + Cloud NAT"
  echo "- External IP: printed above (from httpbin/ifconfig) if reachable"
  echo "- Target host tested: $TARGET_HOST"
}

# Execute
analyze_ip_addrs_and_routes
clarify_nat_types
external_ip_visibility
basic_connectivity_checks
verbose_tls_handshake
troubleshooting_hints
summary
