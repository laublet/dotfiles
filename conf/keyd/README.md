# keyd (removed)

**Status (2026-05-28):** Abandonné — remap Cmd→Ctrl OS-wide retiré du repo ; `install` Linux désactive keyd. LCAG WM via COSMIC (`Super+Ctrl+Alt`), pas keyd.

OS-wide **Cmd → Ctrl** remapping via keyd was dropped. Linux uses native modifiers:

| Key | Role |
|-----|------|
| **Super** (Cmd key) | COSMIC WM, launcher (`Super+Space`) |
| **Ctrl** | Apps, terminal, WezTerm splits |
| **Alt** | Word navigation (per-app: Cursor, zsh, GTK) |

**Mac** keeps Cmd-based shortcuts (AeroSpace, WezTerm, apps). Same Kyria layout; different modifier semantics on Linux.

## WM on Linux (LCAG fingers)

Physical **Super+Ctrl+Alt** + arrows matches macOS AeroSpace LCAG — see `conf/cosmic/aerospace-overrides.ron` (not keyd).

## Disable keyd on an existing machine

`./install` (Linux) stops and removes perso keyd config. Or manually:

```bash
sudo rm -f /etc/keyd/default.conf /etc/keyd/games-classic.conf
sudo systemctl disable --now keyd
```

Logout if modifiers still feel wrong.
