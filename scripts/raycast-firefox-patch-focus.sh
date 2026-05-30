#!/usr/bin/env bash
# Patch ~/.raycast-firefox native host so tab switch foregrounds Firefox Developer Edition.
# Run after Raycast → Firefox Tabs → Setup Firefox Bridge (re-run if the host is regenerated).

set -euo pipefail

HOST="${RAYCAST_FIREFOX_HOST:-$HOME/.raycast-firefox/bin/host.bundle.js}"

if [[ ! -f "$HOST" ]]; then
  echo "raycast-firefox-patch-focus: host not found at $HOST" >&2
  echo "Run Raycast → Firefox Tabs → Setup Firefox Bridge first." >&2
  exit 1
fi

if grep -q 'org.mozilla.firefoxdeveloperedition' "$HOST"; then
  echo "Already patched: $HOST"
  exit 0
fi

export HOST
python3 <<'PY'
from pathlib import Path
import os
import sys

host = Path(os.environ["HOST"])
text = host.read_text(encoding="utf-8")
old = """        var apps = $.NSRunningApplication.runningApplicationsWithBundleIdentifier("org.mozilla.firefox");
        if (apps.count > 0) apps.objectAtIndex(0).activateWithOptions(2);"""
new = """        var ids = ["org.mozilla.firefoxdeveloperedition", "org.mozilla.firefox"];
        for (var i = 0; i < ids.length; i++) {
          var apps = $.NSRunningApplication.runningApplicationsWithBundleIdentifier(ids[i]);
          if (apps.count > 0) { apps.objectAtIndex(0).activateWithOptions(2); break; }
        }"""
if old not in text:
    print("raycast-firefox-patch-focus: pattern not found (host format changed?)", file=sys.stderr)
    sys.exit(1)
host.write_text(text.replace(old, new, 1), encoding="utf-8")
print(f"Patched: {host}")
PY
