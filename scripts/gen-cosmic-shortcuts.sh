#!/usr/bin/env bash
# Merge COSMIC system defaults + perso AeroSpace overrides → shortcuts.ron
# The `custom` file REPLACES defaults entirely — never ship a partial custom.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEFAULTS="$ROOT/conf/cosmic/defaults.ron"
if [[ -f /usr/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/defaults ]]; then
  DEFAULTS=/usr/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/defaults
fi
FRAG="$ROOT/conf/cosmic/aerospace-overrides.ron"
OUT="$ROOT/conf/cosmic/shortcuts.ron"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

sed \
  -e '/(modifiers: \[Super\]): System(Launcher),/d' \
  -e 's/(modifiers: \[Super\], key: "space"): System(InputSourceSwitch)/(modifiers: [Super], key: "space"): System(Launcher)/' \
  -e '/(modifiers: \[Super, Alt\], key: "Left"): SwitchOutput(Left),/d' \
  -e '/(modifiers: \[Super, Alt\], key: "Right"): SwitchOutput(Right),/d' \
  -e '/(modifiers: \[Super, Alt\], key: "h"): SwitchOutput(Left),/d' \
  -e '/(modifiers: \[Super, Alt\], key: "l"): SwitchOutput(Right),/d' \
  "$DEFAULTS" >"$tmp"

# Drop closing "}" from defaults, append overrides, close map
sed '$d' "$tmp" >"$OUT"
cat "$FRAG" >>"$OUT"
echo "}" >>"$OUT"

echo "Wrote $OUT ($(wc -l <"$OUT") lines) from $DEFAULTS"
