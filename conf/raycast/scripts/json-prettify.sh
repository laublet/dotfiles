#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Prettify JSON
# @raycast.mode silent
# @raycast.packageName Developer Utilities

# Optional parameters:
# @raycast.icon { "source": "file-icon", "fileIcon": "public.json" }

# Documentation:
# @raycast.description Pretty-print JSON from clipboard back to clipboard.

set -euo pipefail

if ! pbpaste | python3 -m json.tool 2>/dev/null | pbcopy; then
  echo "Invalid JSON in clipboard"
  exit 1
fi

echo "JSON prettified (clipboard)"
