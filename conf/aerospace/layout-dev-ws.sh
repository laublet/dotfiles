#!/bin/bash
# Arrange workspace 2 (Dev) in 2 columns of stacks:
#   Left column:  WezTerm (top) / Cursor (bottom)
#   Right column: Firefox Dev (top) / Obsidian (bottom)
#
# Gracefully handles missing windows (e.g. only 2 apps open).
# Can be run from after-login-command or manually via keybinding.

A=/opt/homebrew/bin/aerospace

$A workspace 2
$A flatten-workspace-tree

wid_by_bundle() {
  $A list-windows --workspace 2 --app-bundle-id "$1" --format '%{window-id}' 2>/dev/null | head -1
}

wid_by_name() {
  $A list-windows --workspace 2 --format '%{window-id}|%{app-name}' 2>/dev/null \
    | grep -i "$1" | head -1 | cut -d'|' -f1
}

wt=$(wid_by_bundle 'com.github.wez.wezterm')
cur=$(wid_by_name 'Cursor')
ff=$(wid_by_bundle 'org.mozilla.firefoxdeveloperedition')
obs=$(wid_by_bundle 'md.obsidian')

move_n() {
  local id=$1 dir=$2 n=${3:-4}
  $A focus --window-id "$id"
  for _ in $(seq 1 "$n"); do $A move "$dir" 2>/dev/null; done
}

# Left column: WezTerm + Cursor
if [ -n "$wt" ] && [ -n "$cur" ]; then
  move_n "$cur" left
  move_n "$wt" left
  $A focus --window-id "$cur"
  $A join-with left
fi

# Right column: Firefox Dev + Obsidian
if [ -n "$ff" ] && [ -n "$obs" ]; then
  move_n "$ff" right
  move_n "$obs" right
  $A focus --window-id "$ff"
  $A join-with right
fi

$A balance-sizes --workspace 2
[ -n "$wt" ] && $A focus --window-id "$wt"
