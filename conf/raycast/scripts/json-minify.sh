#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Minify JSON
# @raycast.mode silent
# @raycast.packageName Developer Utilities

# Optional parameters:
# @raycast.icon { "source": "file-icon", "fileIcon": "public.json" }

# Documentation:
# @raycast.description Compact JSON from clipboard to one line, back to clipboard.

set -euo pipefail

if ! pbpaste | python3 -c "import json,sys; print(json.dumps(json.load(sys.stdin), separators=(',',':')))" 2>/dev/null | pbcopy; then
  echo "Invalid JSON in clipboard"
  exit 1
fi

echo "JSON minified (clipboard)"
