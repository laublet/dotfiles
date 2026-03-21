#!/usr/bin/env bash
# Export macOS app configs to conf/mac-apps/ (run after changing app settings)
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/conf/mac-apps"
mkdir -p "$DIR"

echo "Exporting Mac app configs..."

defaults export com.choosyosx.Choosy "$DIR/choosy.plist"
cp ~/Library/Application\ Support/Choosy/behaviours.plist "$DIR/choosy-behaviours.plist"

defaults export jp.plentycom.app.SteerMouse "$DIR/steermouse.plist" 2>/dev/null || true
defaults export org.languagetool.desktop "$DIR/languagetool.plist" 2>/dev/null || true
defaults export com.if.Amphetamine "$DIR/amphetamine.plist" 2>/dev/null || true

# Mouseless (sandboxed app, YAML config)
MOUSELESS_CFG=~/Library/Containers/net.sonuscape.mouseless/Data/.mouseless/configs/config.yaml
[ -f "$MOUSELESS_CFG" ] && cp "$MOUSELESS_CFG" "$DIR/mouseless.yaml"

# Convert plists to XML for readable git diffs
for f in "$DIR"/*.plist; do
  plutil -convert xml1 "$f" 2>/dev/null
done

echo "Done. Configs in conf/mac-apps/"
