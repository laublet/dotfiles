#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Clipboard URL in Chrome
# @raycast.mode silent
# @raycast.packageName Browser

# Optional parameters:
# @raycast.icon 🌐

# Documentation:
# @raycast.description Open the clipboard URL in Google Chrome (bypasses Choosy).

set -euo pipefail

browser="${RAYCAST_CHROME:-Google Chrome}"
url="$(pbpaste | tr -d '[:space:]')"

if [[ -z "$url" ]]; then
  echo "Clipboard is empty"
  exit 1
fi

if [[ ! "$url" =~ ^https?:// ]]; then
  echo "Clipboard is not a URL: $url"
  exit 1
fi

open -a "$browser" --args "$url"
echo "Opened in $browser"
