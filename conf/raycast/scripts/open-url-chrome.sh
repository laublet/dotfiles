#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open URL in Chrome
# @raycast.mode silent
# @raycast.packageName Browser

# Optional parameters:
# @raycast.icon 🌐

# @raycast.argument1 { "type": "text", "placeholder": "URL or domain" }

# Documentation:
# @raycast.description Open a URL in Google Chrome (bypasses Choosy / system default).

set -euo pipefail

browser="${RAYCAST_CHROME:-Google Chrome}"
url="${1:-}"

if [[ -z "$url" ]]; then
  echo "URL required"
  exit 1
fi

if [[ ! "$url" =~ ^https?:// ]]; then
  url="https://${url}"
fi

open -a "$browser" --args "$url"
echo "Opened in $browser"
