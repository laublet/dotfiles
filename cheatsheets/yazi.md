# yazi — terminal file manager

> Fast file manager with vim keybindings. Alias: `y` (cd to last dir on exit).

## Launch

```bash
y                        # open yazi, cd to last visited dir on quit
y /some/path             # open at specific directory
yazi                     # open without cd-on-exit behavior
yazi-pick                # pick file(s) for scripts; prints path(s) to stdout
path=$(yazi-pick)        # single selection
yazi-pick --multi        # all selections, one path per line
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

- `~/.config/yazi/yazi.toml` — main config (`[mgr]`, `[open]` rules use `url` / `mime`, not `name`)
- `~/.config/yazi/theme.toml` — `[flavor] dark = "dracula"` (vendored in `flavors/dracula.yazi/`)

## Links

## File picker (browser upload, etc.)

| Platform | Browser “Choose file” dialog |
|----------|------------------------------|
| **macOS** | Native panel only — **cannot** swap in yazi (Safari/Chrome use `NSOpenPanel`). Workaround: pick in terminal with `yazi-pick`, copy path (`c` → `c` in yazi), or drag file into the page if the site allows. |
| **Linux** | Possible via [xdg-desktop-portal-termfilechooser](https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser) + Firefox `widget.use-xdg-desktop-portal.file-picker=1`. |

- Repo: https://github.com/sxyazi/yazi
- Docs: https://yazi-rs.github.io
