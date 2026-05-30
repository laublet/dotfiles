#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Clipboard URL in Firefox
# @raycast.mode silent
# @raycast.packageName Browser

# Optional parameters:
# @raycast.icon 🦊

# Documentation:
# @raycast.description Open the clipboard URL via Choosy rules. Set RAYCAST_BROWSER to force a specific app.

set -euo pipefail

url="$(pbpaste | tr -d '[:space:]')"

if [[ -z "$url" ]]; then
  echo "Clipboard is empty"
  exit 1
fi

if [[ ! "$url" =~ ^https?:// ]]; then
  echo "Clipboard is not a URL: $url"
  exit 1
fi

if [[ -n "${RAYCAST_BROWSER:-}" ]]; then
  open -a "$RAYCAST_BROWSER" --args "$url"
  echo "Opened in $RAYCAST_BROWSER"
else
  open "x-choosy://open/${url}"
  echo "Opened via Choosy"
fi
