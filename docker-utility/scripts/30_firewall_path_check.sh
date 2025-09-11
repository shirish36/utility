#!/usr/bin/env bash
set -euo pipefail
DEST=${1:-storage.googleapis.com}

banner() { echo "==== $* ===="; }

banner "FIREWALL/PATH CHECK to $DEST"

banner "DNS"
nslookup "$DEST" 2>/dev/null | grep -E "(Name|Address)" || echo "DNS failed"

banner "TCP 443"
if timeout 8 bash -c "</dev/tcp/$DEST/443" 2>/dev/null; then echo OK; else echo FAIL; fi

banner "TLS cert dates"
if command -v openssl >/dev/null; then
  echo | openssl s_client -connect "$DEST:443" -servername "$DEST" 2>/dev/null | openssl x509 -noout -dates || true
else
  echo "openssl not installed"
fi

banner "Traceroute (first hops)"
(traceroute -n "$DEST" 2>/dev/null || mtr -n -r -c 5 "$DEST" 2>/dev/null || echo "traceroute/mtr unavailable") | head -10 || true
