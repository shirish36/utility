#!/usr/bin/env bash
set -euo pipefail

banner() { echo "==== $* ===="; }

banner "BASIC NETWORK INFO"

banner "Interfaces & IPs"
ip addr show || true

banner "Routing Table"
ip route show || true

banner "DNS Config"
cat /etc/resolv.conf || true

banner "Environment"
echo "TARGET_HOST=${TARGET_HOST:-}"; echo "TARGET_URL=${TARGET_URL:-}"; echo "REGION=${REGION:-}"; echo "PROJECT=${GOOGLE_CLOUD_PROJECT:-}"
