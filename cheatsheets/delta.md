# delta — git diff viewer

> Syntax-highlighted git pager. Configured: side-by-side, line numbers, Dracula theme.

## Automatic usage (via gitconfig)

Delta is the pager for all git output. Just use git normally:

```bash
git diff                 # side-by-side diff with syntax highlighting
git diff --staged        # staged changes
git log -p               # patches in log
git show <commit>        # show commit diff
git stash show -p        # stash diff
git add -p               # interactive staging (colored by delta)
git blame file           # blame with syntax highlighting
```

## Navigation inside delta

| Key | Action |
|-----|--------|
| `n` | next file (navigate = true) |
| `N` | previous file |
| `/` | search |
| `q` | quit |
| `Space` | page down |
| `b` | page up |
| `g` | go to top |
| `G` | go to bottom |

## Standalone usage

```bash
# Diff two files directly
delta file_A file_B

# Pipe any diff into delta
diff -u old.py new.py | delta

# Pipe git diff from another repo
git -C /other/repo diff | delta
```

## Current config (from gitconfig)

```ini
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    navigate = true        # n/N to jump between files
    dark = true
    side-by-side = true    # two-column view
    line-numbers = true
    syntax-theme = Dracula
[diff]
    colorMoved = default   # detect moved lines
```

## Temporary overrides

```bash
# Force inline mode (no side-by-side)
git -c delta.side-by-side=false diff

# Different theme
git -c delta.syntax-theme=GitHub diff
```

## Links

- Repo: https://github.com/dandavison/delta
- Themes: https://dandavison.github.io/delta/supported-languages-and-themes.html
