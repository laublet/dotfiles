# eza — modern ls

> Replaces `ls`. Aliased: `ls` → `eza`, `ll` → `eza -la --git --icons`, `lt` → `eza --tree --level=2 --icons`

## Everyday usage

```bash
ls                       # basic listing
ll                       # detailed: permissions, size, git status, icons
lt                       # tree view (2 levels deep)
lt --level=4             # deeper tree
ll -s modified           # sort by modification time
ll -s size               # sort by size
ll --sort=ext            # sort by extension
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-a` | show hidden files |
| `-l` | long format (permissions, size, date) |
| `--git` | show git status per file (M, N, -, etc.) |
| `--icons` | show file-type icons |
| `--tree` | recursive tree view |
| `--level=N` | limit tree depth |
| `-s <field>` | sort: `name`, `size`, `modified`, `ext`, `type` |
| `-r` | reverse sort order |
| `--group-directories-first` | directories at the top |
| `-I <pattern>` | ignore glob (e.g. `-I "node_modules"`) |

## Recipes

```bash
# Files modified today
ll -s modified | head -20

# Only directories
eza -D

# Only files
eza -f

# Tree ignoring node_modules and .git
lt -I "node_modules|.git" --level=3

# Just filenames, one per line (for piping)
eza -1
```

## Links

- Repo: https://github.com/eza-community/eza
