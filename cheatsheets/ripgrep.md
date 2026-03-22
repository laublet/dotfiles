# ripgrep (rg) — fast grep

> Replaces `grep`. Respects `.gitignore`, fast recursive search. Aliases in zshrc.

## Everyday usage

```bash
rg pattern               # search recursively in current dir
rg pattern file.txt      # search in specific file
rg pattern src/           # search in specific directory
rg -i pattern            # case insensitive (alias: rgi)
rg -w word               # whole word match (alias: rgw)
rg --hidden pattern      # include hidden files (alias: rgh)
rg --no-ignore pattern   # ignore .gitignore rules (alias: rgn)
```

## Aliases (from zshrc)

| Alias | Expands to |
|-------|-----------|
| `rgi` | `rg -i` (case insensitive) |
| `rgw` | `rg -w` (whole word) |
| `rgh` | `rg --hidden` |
| `rgn` | `rg --no-ignore` |

## Useful flags

| Flag | Effect |
|------|--------|
| `-i` | case insensitive |
| `-w` | whole word |
| `-l` | only print filenames |
| `-c` | count matches per file |
| `-n` | show line numbers (default) |
| `-C 3` | show 3 lines of context |
| `-B 2` / `-A 2` | show 2 lines before/after |
| `-t <type>` | filter by file type (`-t py`, `-t js`) |
| `-g '*.json'` | glob filter |
| `-e <pattern>` | explicit pattern (useful for leading `-`) |
| `--json` | JSON output |
| `-F` | fixed string (no regex) |
| `-m 5` | max 5 matches per file |

## Recipes

```bash
# Search only in Python files
rg -t py "def main"

# Search for TODO/FIXME
rg "TODO|FIXME"

# Replace pattern (preview)
rg "old_name" -l | xargs sed -i '' 's/old_name/new_name/g'

# Search but exclude test files
rg pattern -g '!*test*'

# Search for multiline pattern
rg -U 'fn main.*\n.*println'

# List all file types rg knows
rg --type-list

# Stats about matches
rg --stats pattern
```

## fzf integration (from zshrc)

```bash
rgf "pattern"   # interactive: rg → fzf → open at line
rgv "pattern"   # file list: matching files → fzf → open
rgt py "def"    # type filter: rg in .py → fzf with preview
rgc "pattern"   # count: matches per file, sorted desc
```

## Links

- Repo: https://github.com/BurntSushi/ripgrep
