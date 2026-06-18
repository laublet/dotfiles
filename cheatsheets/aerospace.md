# AeroSpace — tiling window manager (macOS)

> **Help:** `aerospace --help` · [AeroSpace guide](https://nikitabobko.github.io/AeroSpace/guide)

Modifier architecture:
- `Ctrl+Cmd+Alt` (LCAG) → focus, layout, split
- `Ctrl+Cmd+Alt+Shift` (HYPR) → move, resize
- `Cmd+Alt` → workspaces
- `Cmd+Alt+Shift` → move to workspace/monitor

## Focus & Move windows

| Action | Shortcut |
|--------|----------|
| Focus left/down/up/right | `Ctrl+Cmd+Alt + ←↓↑→` |
| Move window left/down/up/right | `Ctrl+Cmd+Alt+Shift + ←↓↑→` |

## Layout

| Action | Shortcut |
|--------|----------|
| Tiles (default) | `Ctrl+Cmd+Alt + E` |
| Vertical accordion | `Ctrl+Cmd+Alt + S` |
| Horizontal accordion | `Ctrl+Cmd+Alt + W` |
| Toggle floating/tiling | `Ctrl+Cmd+Alt + T` |
| Zoom window (tiling fullscreen) | `Ctrl+Cmd+Alt+Shift + Z` |
| Native fullscreen | `Ctrl+Cmd+Alt+Shift + F` |
| Balance sizes | `Ctrl+Cmd+Alt + =` |

## Resize

| Action | Shortcut |
|--------|----------|
| Shrink | `Ctrl+Cmd+Alt+Shift + -` |
| Grow | `Ctrl+Cmd+Alt+Shift + =` |

## Join containers

| Action | Shortcut |
|--------|----------|
| Join with right | `Ctrl+Cmd+Alt + R` |
| Join with left | `Ctrl+Cmd+Alt + L` |
| Join with up | `Ctrl+Cmd+Alt + U` |
| Join with down | `Ctrl+Cmd+Alt + D` |

## Workspaces

| Action | Shortcut |
|--------|----------|
| Previous workspace | `Cmd+Alt + ←` |
| Next workspace | `Cmd+Alt + →` |
| Switch to workspace N | `Cmd+Alt + 0-9` |
| Back and forth | `Cmd+Alt + Tab` |
| Move window to workspace N | `Cmd+Alt+Shift + 0-9` |

## Monitors

| Action | Shortcut |
|--------|----------|
| Focus next monitor | `Cmd+Alt + ↓` |
| Focus prev monitor | `Cmd+Alt + ↑` |
| Move window to next monitor | `Cmd+Alt+Shift + ↓` |
| Move window to prev monitor | `Cmd+Alt+Shift + ↑` |
| Move workspace to next monitor | `Cmd+Alt+Shift + Tab` |

## Terminal

| Action | Shortcut |
|--------|----------|
| New WezTerm window | `Ctrl+Cmd+Alt + Enter` |
| Ghostty + Zellij lab | `Ctrl+Cmd+Alt+Shift + Enter` |
| Focus WezTerm | `Ctrl+Cmd+Alt + `` ` |

## Service mode

Enter: `Ctrl+Cmd+Alt+Shift + ;`

| Key | Action |
|-----|--------|
| `Esc` | Reload config, exit |
| `R` | Flatten workspace tree |
| `F` | Toggle floating |
| `=` | Balance sizes |
| `Backspace` | Close all windows but current |
| `L` | Re-apply dev layout |
| `←↓↑→` | Join with direction |
| `S/W/E` | Layout (accordion/tiles) |

## Workspace assignments

| WS | Purpose | Apps |
|----|---------|------|
| 0 | Dashboard | Calendar, Todoist, Music |
| 1 | Work/Comms | Slack, Chrome, Signal |
| 2 | Dev | WezTerm, Cursor, Firefox Dev, Obsidian |
| 3 | Test/Browse | Firefox, Postman |
| 4–9 | Secondary monitor (manual) | Spill workspaces — no auto app rules. Prefs (System Settings, SteerMouse, …) open on **focused** workspace. |

## Tips

- **Prefs / utilities** (System Settings, SteerMouse, …) stay on the workspace you’re on — no auto-move to WS 4. Pin with `Cmd+Alt+Shift + N` if needed.
- Pointer warps to **window center** on focus (`on-focus-changed` → `window-lazy-center`) and to **monitor center** on display change (`monitor-lazy-center`) — Kyria scroll / wheel under cursor.
- `Cmd+H` disabled (interferes with tiling)
- Raycast popup is managed natively (no float rule needed)
- Default stack: **vertical** accordion (`default-root-container-orientation = 'vertical'`)
- Dev layout auto-applies 30s after startup (WS 2 = 2 columns; other workspaces stay vertical stack)

## Links

- Repo: https://github.com/nikitabobko/AeroSpace
- Dotfiles config: [`conf/aerospace/aerospace.toml`](../conf/aerospace/aerospace.toml)
