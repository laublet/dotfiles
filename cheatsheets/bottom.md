# bottom (btm) — lightweight system monitor

> **Help:** `?` in TUI · `btm --help`

> Replaces `htop`. Lightweight, customizable, Rust-based. Use for quick monitoring.

## Launch

```bash
btm                                  # default view
btm --basic                          # simplified view (no graphs)
btm --battery                        # show battery widget
btm --rate 500                       # update every 500ms
btm -t                               # default tree mode for processes
```

## Vim navigation

| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | navigate |
| `g` `g` | go to top |
| `G` | go to bottom |
| `Ctrl+d` / `Ctrl+u` | half page down / up |
| `Ctrl+f` / `Ctrl+b` | full page down / up |
| `Tab` / `Shift+Tab` | cycle widgets |
| `Esc` | close dialog / deselect |
| `q` | quit |

## Process management

| Key | Action |
|-----|--------|
| `/` | search processes |
| `t` | toggle tree view |
| `s` | sort menu |
| `P` | sort by CPU |
| `M` | sort by memory |
| `N` | sort by PID |
| `I` | invert sort |
| `dd` | kill selected process (SIGTERM) |
| `x` | kill selected process (SIGKILL) |

## Toggle widgets

| Key | Widget |
|-----|--------|
| `e` | expand selected widget |
| `=` / `+` | zoom in on chart |
| `-` | zoom out on chart |

## Config

- Config file: `~/.config/bottom/bottom.toml`
- Customize layout, colors, default widgets, update rate

```toml
# Example: ~/.config/bottom/bottom.toml
[flags]
rate = 1000
tree = true
```

## Links

- Repo: https://github.com/ClementTsang/bottom
- Docs: https://clementtsang.github.io/bottom
