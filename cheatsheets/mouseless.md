# Mouseless — keyboard mouse (macOS)

> **Help:** `Tab` with overlay open → config editor · [docs](https://mouseless.click/docs/getting_started.html)

> Replace the trackpad for clicks, moves, and scroll. Config in dotfiles: [`conf/mac-apps/mouseless.yaml`](../conf/mac-apps/mouseless.yaml) → deployed by dotbot to `~/Library/Containers/net.sonuscape.mouseless/Data/.mouseless/configs/config.yaml`. After edit: copy or re-run mac install, then **quit & reopen** Mouseless.

## Workflow (30 seconds)

1. **Show grid** — `Ctrl+Cmd+Alt+M` (LCAG+M). Overlay appears on the monitor under the cursor.
2. **Type cell keys** — letters on the grid (QWERTY home rows: `QWERT` / `ASDFG` / …). Subgrid refines position; **Backspace** undoes last key.
3. **Confirm move** — `Ctrl+Cmd+Alt+V` (LCAG+V) moves the virtual cursor to the target (or use overlay flow per your habit).
4. **Click** — `Space` = left, `R` = right, `E` = middle. Hold **Cmd left** to drag; **Option left** = move mode (hold to move without clicking).
5. **Done** — `Escape` closes overlay.

**Free mode** (no grid, move + scroll): `Ctrl+Cmd+Alt+Z`. Auto-off after 10s. `Escape` exits.

**Multi-monitor** (overlay visible only): `Cmd+Alt+J` = next monitor, `Cmd+Alt+K` = previous.

## Global hotkeys (always)

| Shortcut | Action |
|----------|--------|
| LCAG + M | Show overlay |
| LCAG + V | Execute mouse move |
| LCAG + Z | Toggle free mode |
| Cmd + Alt + J / K | Overlay: prev / next monitor |

LCAG = `Ctrl+Cmd+Alt`. Letter keys: config uses lowercase `m`; if a binding fails, try uppercase per [Mouseless docs](https://mouseless.click/docs/customizing_mouseless.html).

## While overlay is active

| Key | Action |
|-----|--------|
| Grid letters | Select cell / subgrid |
| Space | Left click |
| R | Right click |
| E | Middle click |
| W / Q | Back / forward mouse button |
| Arrows | Nudge cursor |
| E S D F / H J K L | Subgrid nudge (vim-ish right hand) |
| M , . / | Scroll up / down / left / right |
| Hold Ctrl (left) | Slower move |
| Hold Shift (left) | Faster move |
| Hold Cmd (left) | Drag |
| Hold Option (left) | Move (no click) |
| `1` | Toggle continuous mode until closed |
| `2` / Shift+`3` | Cycle grid level / font |
| Tab | Open config editor |
| Escape | Close overlay / cancel |

## Troubleshooting (hotkeys dead)

1. **App not running** — menu bar icon missing → `open -a Mouseless` or add Login Item manually (sandbox cannot self-register).
2. **Config not deployed** — dotbot uses `command cp -f` (macOS `cp` is often aliased to `cp -i`). Manual: `command cp -f conf/mac-apps/mouseless.yaml ~/Library/Containers/net.sonuscape.mouseless/Data/.mouseless/configs/config.yaml` then quit & reopen Mouseless.
3. **Accessibility** — **System Settings → Privacy & Security → Accessibility** → Mouseless ON → quit & relaunch. (UI in French: *Réglages Système → Confidentialité et sécurité → Accessibilité*.)
4. **Stuck after macOS update** — remove Mouseless from Accessibility (`-`), relaunch, re-grant, restart app.
5. **Secure Input** — config editor (Tab from overlay) → Check Secure Input Status.
6. **Modifier conflicts** — Karabiner / Raycast / AeroSpace: try LCAG+`M` vs uppercase; see [mac-apps README](../conf/mac-apps/README.md#mouseless).
7. **Debug** — `open -W --stdout $(tty) --stderr $(tty) /Applications/Mouseless.app --args -d`

## Conflicts & tips

- **AeroSpace** uses the same LCAG+arrows for focus — when the Mouseless overlay is **open**, it captures those keys; when **closed**, AeroSpace wins.
- **Cmd+Alt+↑/↓** stays AeroSpace focus-monitor; **Cmd+Alt+J/K** are reserved for Mouseless overlay only.
- App must run (menu bar). **Accessibility** permission required; re-launch after granting.
- Hotkeys dead in password fields: [Secure Input](https://mouseless.click/docs/troubleshooting.html) — check in config editor.
- Not at login: add `Mouseless.app` under **System Settings → General → Login Items** (sandbox). (French UI: *Réglages Système → Général → Ouverture*.)

## Links

- Product & docs: https://mouseless.click
- Getting started: https://mouseless.click/docs/getting_started.html
- Troubleshooting: https://mouseless.click/docs/troubleshooting.html
- Dotfiles config: [`conf/mac-apps/mouseless.yaml`](../conf/mac-apps/mouseless.yaml) · [mac-apps README](../conf/mac-apps/README.md#mouseless)
- Cross-app map: [keyboard-navigation.md](keyboard-navigation.md#mouseless)
