# zellij — terminal multiplexer (server)

> Replaces `tmux`. Persistent sessions, vim navigation, Dracula theme.
> Prefix: `Ctrl+a` (same as old tmux config).

## Session management

```bash
zellij                               # new session (or attach if one exists)
zellij -s myproject                  # named session
zellij attach myproject              # reattach to named session
zellij list-sessions                 # list all sessions (ls alias)
zellij kill-session myproject        # kill a session
zellij kill-all-sessions             # kill all sessions
zellij attach -c myproject           # attach or create if doesn't exist
```

## Prefix key: Ctrl+a

All actions below require pressing `Ctrl+a` first, then the key.

### Panes

| Key | Action |
|-----|--------|
| `v` | split right (vertical) |
| `b` | split down (horizontal) |
| `h` `j` `k` `l` | navigate panes |
| `H` `J` `K` `L` | resize panes (hold for continuous) |
| `x` | close current pane |
| `z` | toggle fullscreen (zoom) |
| `f` | toggle floating pane |

### Tabs

| Key | Action |
|-----|--------|
| `c` | new tab |
| `n` / `p` | next / previous tab |
| `1`-`5` | go to tab by number |
| `,` | rename current tab |

### Session

| Key | Action |
|-----|--------|
| `d` | detach (session keeps running) |
| `w` | session manager |

### Scroll / copy mode

| Key | Action |
|-----|--------|
| `[` | enter scroll mode |
| `j` / `k` | scroll line by line |
| `Ctrl+d` / `Ctrl+u` | half page |
| `Ctrl+f` / `Ctrl+b` | full page |
| `g` / `G` | top / bottom |
| `/` | search |
| `n` / `N` | next / previous match |
| `q` or `Esc` | exit scroll mode |

## Workflow: SSH server

```bash
# Connect and start/attach session
ssh myserver
zellij attach -c work

# Detach: Ctrl+a d
# Disconnect SSH, session survives
# Reconnect later:
ssh myserver
zellij attach work
```

## Links

- Repo: https://github.com/zellij-org/zellij
- Docs: https://zellij.dev/documentation
- Config: `~/.config/zellij/config.kdl`
