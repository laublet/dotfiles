#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open URL in Firefox
# @raycast.mode silent
# @raycast.packageName Browser

# Optional parameters:
# @raycast.icon 🦊

# @raycast.argument1 { "type": "text", "placeholder": "URL or domain" }

# Documentation:
# @raycast.description Open a URL via Choosy rules (default: Firefox Developer Edition). Set RAYCAST_BROWSER to force a specific app.

set -euo pipefail

url="${1:-}"

if [[ -z "$url" ]]; then
  echo "URL required"
  exit 1
fi

if [[ ! "$url" =~ ^https?:// ]]; then
  url="https://${url}"
fi

if [[ -n "${RAYCAST_BROWSER:-}" ]]; then
  open -a "$RAYCAST_BROWSER" --args "$url"
  echo "Opened in $RAYCAST_BROWSER"
else
  open "x-choosy://open/${url}"
  echo "Opened via Choosy"
fi
