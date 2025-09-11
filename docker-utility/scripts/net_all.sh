#!/usr/bin/env bash
set -euo pipefail

/workspace/scripts/00_net_info.sh
/workspace/scripts/20_external_ip_check.sh
/workspace/scripts/10_connectivity_check.sh "${TARGET_HOST:-google.com}"
/workspace/scripts/30_firewall_path_check.sh "${TARGET_DEST:-storage.googleapis.com}"
