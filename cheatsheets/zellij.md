# zellij — terminal multiplexer

> **Help:** `?` in TUI · `zellij --help`

> Config unifiée : macOS (Ghostty lab) + serveur SSH.
> Ghostty lab : [ghostty-lab.md](ghostty-lab.md) · WezTerm main : [wezterm.md](wezterm.md).

## Session management

```bash
zellij                               # new session (or attach if one exists)
zellij -s myproject                  # named session
zellij attach myproject              # reattach to named session
zellij attach -c lab                 # Ghostty lab session (create if missing)
zellij list-sessions                 # list all sessions (ls alias)
zellij kill-session myproject        # kill a session
zellij kill-all-sessions             # kill all sessions
```

Ghostty lab launcher : `ghostty-lab` (= `zellij attach -c lab` inside Ghostty).

## Navigation (primary — all platforms)

Works with **smart-splits.nvim** + `vim-zellij-navigator` WASM (`conf/zellij/plugins/`).

| Shortcut | Action |
|----------|--------|
| `Ctrl + arrows` | Navigate panes (crosses into Neovim) |
| `Ctrl + Shift + arrows` | Same — macOS fallback when `Ctrl+←/→` stolen by Mission Control |
| `Ctrl + Alt + arrows` | Resize panes |

## Panes & tabs (Super = Cmd on macOS)

| Shortcut | Action |
|----------|--------|
| `Cmd + D` | Split right |
| `Cmd + Shift + D` | Split down |
| `Cmd + W` | Close pane |
| `Cmd + Shift + Z` | Zoom pane (fullscreen) |
| `Cmd + T` | New tab |
| `Cmd + Shift + ←/→` | Prev / next tab |
| `Cmd + 1`..`9` | Go to tab |
| `Cmd + Shift + ,` | Rename tab |

## Scroll / copy mode

Enter : `Cmd + Alt + Space` (macOS).

| Key | Action |
|-----|--------|
| `↑` / `↓` | Scroll line by line |
| `Page Up` / `Page Down` | Half page |
| `Home` / `End` | Top / bottom |
| `/` | Search |
| In search : `↑` / `↓` | Previous / next match |
| In search : `Page Up` / `Page Down` | Scroll line by line |
| `Esc` or `q` | Exit scroll mode |
| `Ctrl+C` | Exit scroll/search → shell (SIGINT in normal mode) |

## SSH fallback (minimal Ctrl+a)

| Key | Action |
|-----|--------|
| `Ctrl+a` `d` | Detach (session keeps running) |

On headless server without Cmd key : use `zellij action` for splits, or SSH from a Mac terminal.

## Workflow: SSH server

```bash
ssh myserver
zellij attach -c work

# Detach: Ctrl+a d
# Reconnect:
ssh myserver
zellij attach work
```

## Config

- File : [`conf/zellij/config.kdl`](../conf/zellij/config.kdl)
- Plugin : [`conf/zellij/plugins/vim-zellij-navigator.wasm`](../conf/zellij/plugins/vim-zellij-navigator.wasm)
- Theme : Dracula (matches WezTerm / Neovim)

## Links

- Repo : https://github.com/zellij-org/zellij
- Docs : https://zellij.dev/documentation
- vim-zellij-navigator : https://github.com/hiasr/vim-zellij-navigator
