# dust — intuitive disk usage

> Replaces `du`. Shows disk usage as a visual tree sorted by size.

## Everyday usage

```bash
dust                                 # current directory
dust /path/to/dir                    # specific directory
dust -r                              # reverse order (smallest first)
dust -n 10                           # only show top 10 entries
dust -d 2                            # limit depth to 2 levels
dust -s                              # use apparent size (not disk usage)
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-d <N>` | limit directory depth |
| `-n <N>` | show top N entries |
| `-r` | reverse sort (smallest first) |
| `-s` | apparent size instead of disk usage |
| `-b` | no percent bars (compact output) |
| `-c` | no color |
| `-p` | full path for each entry |
| `-X <dir>` | exclude directory |
| `-e <regex>` | exclude regex pattern |
| `-f` | show file count instead of size |

## Recipes

```bash
# Find what's eating disk in home
dust -d 2 ~

# Ignore node_modules and .git
dust -X node_modules -X .git

# Only files (no directories)
dust -F

# Compare two directories
dust dir1/ dir2/
```

## Links

- Repo: https://github.com/bootandy/dust
