#!/usr/bin/env bash
# Stop keyd so Linux uses native Super/Ctrl/Alt (no Cmd→Ctrl remap).
set -euo pipefail

if ! command -v systemctl &>/dev/null; then
  echo "systemctl not found; skip"
  exit 0
fi

sudo rm -f /etc/keyd/default.conf /etc/keyd/games-classic.conf /etc/keyd/mac-cmd-passthrough.conf 2>/dev/null || true

if systemctl is-active keyd &>/dev/null; then
  echo "Stopping keyd..."
  sudo systemctl stop keyd
fi

if systemctl is-enabled keyd &>/dev/null 2>&1; then
  echo "Disabling keyd at boot..."
  sudo systemctl disable keyd
fi

echo "keyd disabled. Log out/in if modifiers still feel wrong."
