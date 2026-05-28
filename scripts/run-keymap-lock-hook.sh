#!/usr/bin/env bash
set -euo pipefail

# Escape hatch for exceptional local situations:
#   SKIP_KEYMAP_LOCK=1 git commit ...
if [[ "${SKIP_KEYMAP_LOCK:-}" == "1" ]]; then
  exit 0
fi

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

echo "[keymap-lock] running just keymap-lock-check"
just keymap-lock-check
