#!/usr/bin/env bash
# Print Firefox profile folders and the Profile Directory Suffix for Raycast → Mozilla Firefox.
set -euo pipefail

profiles="${HOME}/Library/Application Support/Firefox/Profiles"
if [[ ! -d "$profiles" ]]; then
  echo "No Firefox profiles at: $profiles" >&2
  exit 1
fi

echo "Raycast → Extensions → Mozilla Firefox → Configure Extension:"
echo "  Firefox Application     → Firefox Developer Edition  (not Firefox)"
echo "  Profile Directory Suffix → part after the dot in the profile folder name"
echo ""
echo "Profiles on this machine:"
for d in "$profiles"/*; do
  [[ -d "$d" ]] || continue
  name=$(basename "$d")
  suffix="${name#*.}"
  if [[ "$name" == *.* ]]; then
    marker=""
    [[ "$suffix" == "dev-edition-default" ]] && marker="  ← typical for Firefox Developer Edition"
    printf "  %-40s suffix: %s%s\n" "$name" "$suffix" "$marker"
  else
    printf "  %-40s (no dot suffix)\n" "$name"
  fi
done
