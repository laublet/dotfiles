#!/usr/bin/env bash
# Export macOS app configs to conf/mac-apps/ (run after changing app settings)
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$ROOT/conf/mac-apps"
mkdir -p "$DIR"

echo "Exporting Mac app configs..."

defaults export com.choosyosx.Choosy "$DIR/choosy.plist"
cp ~/Library/Application\ Support/Choosy/behaviours.plist "$DIR/choosy-behaviours.plist"

defaults export jp.plentycom.app.SteerMouse "$DIR/steermouse.plist" 2>/dev/null || true
defaults export org.languagetool.desktop "$DIR/languagetool.plist" 2>/dev/null || true
defaults export com.if.Amphetamine "$DIR/amphetamine.plist" 2>/dev/null || true

python3 - "$DIR/appearance.plist" <<'PY'
import plistlib
import subprocess
import sys

out = {}
for domain, keys in (
    ("NSGlobalDomain", ("AppleInterfaceStyle", "AppleAccentColor", "AppleHighlightColor")),
):
    for key in keys:
        r = subprocess.run(["defaults", "read", domain, key], capture_output=True, text=True)
        if r.returncode != 0:
            continue
        v = r.stdout.strip()
        if v in ("Dark", "Light"):
            out[key] = v
        else:
            try:
                out[key] = int(v)
            except ValueError:
                out[key] = v

with open(sys.argv[1], "wb") as f:
    plistlib.dump(out, f, fmt=plistlib.FMT_XML)
PY

# Stats (menu bar monitor) — sanitize machine-specific keys
if defaults read eu.exelban.Stats &>/dev/null && [[ -x "$ROOT/bin/mac-stats-defaults" ]]; then
  DOTFILES="$ROOT" "$ROOT/bin/mac-stats-defaults" --export
fi

# Mouseless (sandboxed app, YAML config)
MOUSELESS_CFG=~/Library/Containers/net.sonuscape.mouseless/Data/.mouseless/configs/config.yaml
[ -f "$MOUSELESS_CFG" ] && command cp -f "$MOUSELESS_CFG" "$DIR/mouseless.yaml"

# Convert plists to XML for readable git diffs
for f in "$DIR"/*.plist; do
  plutil -convert xml1 "$f" 2>/dev/null
done

echo "Done. Configs in conf/mac-apps/"
