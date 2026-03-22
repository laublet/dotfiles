# yazi — terminal file manager

> Fast file manager with vim keybindings. Alias: `y` (cd to last dir on exit).

## Launch

```bash
y                        # open yazi, cd to last visited dir on quit
y /some/path             # open at specific directory
yazi                     # open without cd-on-exit behavior
```

## Navigation

| Key | Action |
|-----|--------|
| `h` | parent directory |
| `l` / `Enter` | open file / enter directory |
| `j` / `k` | move down / up |
| `gg` | go to top |
| `G` | go to bottom |
| `~` | go to home |
| `/` | search in current directory |
| `n` / `N` | next / previous search match |

## File operations

| Key | Action |
|-----|--------|
| `y` | yank (copy) selected files |
| `x` | cut selected files |
| `p` | paste |
| `d` | trash selected files |
| `D` | permanently delete |
| `a` | create file (add trailing `/` for directory) |
| `r` | rename |
| `Space` | toggle selection |
| `V` | visual mode (select range) |
| `.` | toggle hidden files |

## Tabs

| Key | Action |
|-----|--------|
| `t` | new tab |
| `1-9` | switch to tab N |
| `[` / `]` | previous / next tab |

## Previews

Yazi previews files inline:
- Code files with syntax highlighting
- Images (in supported terminals like WezTerm)
- Directories as tree

## Config

- `~/.config/yazi/yazi.toml` — main config
- `~/.config/yazi/theme.toml` — Dracula theme (configured)

## Links

- Repo: https://github.com/sxyazi/yazi
- Docs: https://yazi-rs.github.io
