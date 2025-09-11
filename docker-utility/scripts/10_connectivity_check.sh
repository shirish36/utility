#!/usr/bin/env bash
set -euo pipefail
TARGET=${1:-${TARGET_HOST:-google.com}}

banner() { echo "==== $* ===="; }

banner "CONNECTIVITY CHECKS against $TARGET"

banner "DNS resolution"
nslookup "$TARGET" 2>/dev/null || getent hosts "$TARGET" || echo "DNS lookup failed"

banner "TCP reachability 443"
if timeout 5 bash -c "</dev/tcp/$TARGET/443" 2>/dev/null; then echo OK; else echo FAIL; fi

banner "HTTPS HEAD"
curl -I --max-time 10 "https://$TARGET" 2>/dev/null | head -3 || echo "HTTPS failed"
