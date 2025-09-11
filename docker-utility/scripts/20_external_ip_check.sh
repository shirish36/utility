#!/usr/bin/env bash
set -euo pipefail

banner() { echo "==== $* ===="; }

banner "EXTERNAL EGRESS IP"

if ! curl -sS --max-time 8 https://httpbin.org/ip; then
  echo "httpbin failed, trying ifconfig.me"
  curl -sS --max-time 8 https://ifconfig.me || echo "Unable to determine external IP"
fi
