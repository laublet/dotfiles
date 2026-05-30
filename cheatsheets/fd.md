# fd — modern find

> **Help:** `fd --help`

> Replaces `find`. Fast, respects `.gitignore`, sane defaults. Powers fzf file search.

## Everyday usage

```bash
fd pattern               # find files matching pattern (regex)
fd -e py                 # find all .py files
fd -e js -e ts           # find .js and .ts files
fd config                # find anything named *config*
fd '^main\.'             # regex: files starting with "main."
fd -t d src              # find directories named *src*
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-e <ext>` | filter by extension |
| `-t f` | files only |
| `-t d` | directories only |
| `-t l` | symlinks only |
| `-H` | include hidden files |
| `-I` | don't respect `.gitignore` |
| `-g <glob>` | glob pattern instead of regex |
| `-d <depth>` | max directory depth |
| `-s` | case-sensitive (default: smart case) |
| `-x <cmd>` | execute command for each result |
| `-X <cmd>` | execute command with all results at once |
| `-E <pattern>` | exclude pattern |

## Recipes

```bash
# Delete all .DS_Store files
fd -H .DS_Store -x rm

# Find large files (combine with du)
fd -t f -e log -x du -h {} | sort -hr

# Find and open in editor
fd -e py | fzf | xargs nvim

# Find files modified in last 24h
fd --changed-within 1d

# Find files bigger than 1MB
fd -t f -S +1M

# Exclude node_modules
fd pattern -E node_modules

# Run prettier on all .ts files
fd -e ts -X prettier --write
```

## How it integrates

- `Ctrl+T` in shell → `fzf` uses `fd` to list files
- `Ctrl+F` in shell → `fzf` uses `fd` to list directories
- fzf-lua in Neovim uses `fd` for file finding

## Links

- Repo: https://github.com/sharkdp/fd
