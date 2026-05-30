# Dracula RICE (macOS)

System + GUI checklist. Automated: `just mac-appearance` (reads [`conf/theme/dracula.env`](../theme/dracula.env)).

## Status (automated — dotfiles)

| Item | Command / file | Notes |
|------|----------------|-------|
| Palette | [`conf/theme/dracula.env`](../theme/dracula.env) | Hex + `DRACULA_BORDERS_*`, `WALLPAPER` |
| macOS dark + accent + dock | `just mac-appearance` | Accent `5` = purple |
| Wallpaper **Ship** 4K | `~/Pictures/wallpapers/dracula-ship-4k.png` | [source](https://github.com/aynp/dracula-wallpapers/blob/main/Art/4k/Ship.png) |
| Stats menu bar | `just mac-stats-defaults` | CPU `utilization`, RAM `purple`, network speed |
| Window borders | `just mac-borders` | Violet → rose actif, `#6272a4` inactif, width `6.0` |
| WezTerm tabs / flash | reload WezTerm | Funk Dracula accents (purple/pink/cyan/orange) |
| Raycast dark (free) | `just mac-raycast-appearance` | Suit macOS dark, pas thème Dracula Pro |
| Health check | `just mac-doctor` | Accent, wallpaper path, borders, … |
| Cheatsheet | [`cheatsheets/mac-rice.md`](../../cheatsheets/mac-rice.md) | |

Re-apply after pull:

```bash
just link
just mac-appearance
just mac-stats-defaults
just mac-borders
just mac-raycast-appearance
```

## Manual (one-time)

| App | Action | Done? |
|-----|--------|-------|
| **Firefox Dev** | [draculatheme.com/firefox](https://draculatheme.com/firefox) | ☐ |
| **Obsidian** | Settings → Appearance → community theme **Dracula** | ☑ |
| **Ice** | Visible zone: Stats, Wi‑Fi, battery ; tint `#282a36` optional | ☑ |
| **Bartender** (trial later) | Compare vs Ice — not today | ☐ deferred |

## Current profile (2026-05-28)

- System wallpaper: `dracula-ship-4k.png` (default kept)
- AeroSpace + borders tuned for tiled contrast (larger gaps, borders width `6.0`)
- Slack custom theme: **Purple Punch**
- WezTerm: solid Dracula background (`opacity = 1.0`); wallpaper is macOS desktop only
- Ice menu bar remains manual; centered icons are not possible on macOS
- Calendar: no dedicated Dracula theme workflow; keep Dark/Match system

## Wallpaper

Browse / change: [`conf/wallpapers/README.md`](../wallpapers/README.md) — update `WALLPAPER=` in `dracula.env`, then `just mac-appearance`. Solid background: `just mac-appearance --wallpaper minimal`.

## Already Dracula (no action)

WezTerm colorscheme, Neovim, Cursor, Zed, Starship, btop, yazi, zellij, delta, glow — see [README](../../README.md) § Theme.

## What else you can tweak

Grouped by effort. Prefer editing dotfiles + `just …` so it survives reinstall.

### Quick (env / one command)

| Knob | Where | Example |
|------|--------|---------|
| Border gradient / width | `dracula.env` → `just mac-borders` | `width=6.0`, autre dégradé JankyBorders |
| Wallpaper | `WALLPAPER=` in `dracula.env` | Autre PNG dans `~/Pictures/wallpapers/` |
| macOS accent | `DRACULA_APPLE_ACCENT` in `dracula.env` | `0` gray … `6` pink (puis `just mac-appearance`) |
| Dock | `bin/mac-appearance` or `appearance.plist` | Taille tuiles, autohide, recents |
| Stats colors/widgets | `conf/mac-apps/stats.plist` | `CPU_mini_color`, modules on/off ; GUI puis `--export` |
| WezTerm “glass” | `conf/wezterm/.wezterm.lua` | `window_background_opacity = 0.93` |
| WezTerm tab accent | same file | `tab_bar.active_tab` — vert actuel, ou repasser `#bd93f9` |

### GUI (not in dotfiles, or export after tweak)

| App | Ideas |
|-----|--------|
| **Ice** | Bar tint `#282a36`, split/rounded pill, which icons stay visible |
| **Stats** | Per-module colors (network, disk if enabled), chart style |
| **Slack / Calendar / etc.** | Per-app dark / “match system” — no global API |
| **Raycast** | Free = dark only ; custom Dracula = Pro |

### Dev stack (already themed, optional depth)

| Tool | File / note |
|------|-------------|
| **Starship** | `conf/starship/starship.toml` — prompt colors |
| **btop / yazi** | theme files under `conf/` |
| **Neovim** | `conf/nvim` — Dracula via colorscheme plugin |
| **delta / glow** | `conf/glow/` — diff / markdown preview |
| **AeroSpace** | `conf/aerospace/aerospace.toml` — gaps, padding, workspaces |
| **keyd** (Linux) | removed — native Super/Ctrl/Alt (`conf/keyd/README.md`) |

### Limited on macOS

- **Menu bar centering** — Apple does not center third-party icons (Ice split is the workaround).
- **Raycast theme** — custom import without Pro.
- **Universal “force dark”** for Electron apps — per app only.

## Optional polish

- **WezTerm** : `window_background_opacity` 0.92–0.95 in [`.wezterm.lua`](../wezterm/.wezterm.lua)
- **Ice** : subtle layout only vs tinted bar — test on your macOS version
- **Borders inactive glow** : JankyBorders supports `glow(0xAARRGGBB)` instead of flat `inactive_color` — try in `dracula.env` if you want inactive windows to pop more
