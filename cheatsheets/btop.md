# btop — beautiful system monitor

> Replaces `htop`. Graphical dashboard with CPU, memory, network, disk, processes.

## Launch

```bash
btop                                 # full dashboard
```

## Vim navigation

| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | navigate |
| `Enter` | select / expand |
| `Esc` | back / cancel |
| `q` | quit |

## Process management

| Key | Action |
|-----|--------|
| `f` | filter processes |
| `/` | search processes |
| `t` | toggle tree view |
| `r` | reverse sort order |
| `k` | kill selected process |
| `s` | select signal to send |
| `e` | toggle per-core CPU graph |
| `Tab` | cycle through panels |

## Sort processes

| Key | Sort by |
|-----|---------|
| `P` | CPU% |
| `M` | Memory% |
| `N` | PID |
| `T` | Time |

## Toggle panels

| Key | Panel |
|-----|-------|
| `1` | CPU |
| `2` | Memory |
| `3` | Network |
| `4` | Processes |

## Config

- Config file: `~/.config/btop/btop.conf`
- Theme dir: `~/.config/btop/themes/`
- Key settings: `vim_keys`, `color_theme`, `update_ms`, `proc_tree`

## Links

- Repo: https://github.com/aristocratos/btop
