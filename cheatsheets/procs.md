# procs — modern process viewer

> **Help:** `procs --help`

> Replaces `ps`. Color output, tree view, keyword search.

## Everyday usage

```bash
procs                                # all processes (colored)
procs <keyword>                      # search by name
procs --tree                         # process tree
procs --watch 1                      # auto-refresh every 1 second
procs --sortd cpu                    # sort by CPU descending
procs --sortd mem                    # sort by memory descending
```

## Useful flags

| Flag | Effect |
|------|--------|
| `--tree` | show process tree |
| `--watch <N>` | refresh every N seconds |
| `--sortd <col>` | sort descending by column |
| `--sorta <col>` | sort ascending by column |
| `--or <keyword>` | match any keyword (default: all) |
| `--nopager` | don't use a pager |
| `--pager <cmd>` | use a specific pager |

## Search modes

```bash
procs node                           # processes matching "node"
procs node rust                      # matching "node" AND "rust"
procs --or node rust                 # matching "node" OR "rust"
procs --pid 1234                     # specific PID
```

## Sort columns

`pid`, `user`, `cpu`, `mem`, `read`, `write`, `state`, `start`, `command`

## Config

- Config file: `~/.config/procs/config.toml`
- Customize columns, colors, and default sort

## Links

- Repo: https://github.com/dalance/procs
