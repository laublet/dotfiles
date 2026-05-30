# fzf — fuzzy finder

> **Help:** `fzf --help` · `man fzf`

> Universal fuzzy finder. Integrated with shell (Ctrl+T/R/F) and Neovim (fzf-lua).

## Shell keybindings (configured in zshrc)

| Key | Action | Backend |
|-----|--------|---------|
| `Ctrl+T` | Find and insert file path | fd + bat preview |
| `Ctrl+R` | Search command history | |
| `Ctrl+F` | cd into directory | fd + eza tree preview |

## Standalone usage

```bash
# Fuzzy find a file and open it
nvim $(fzf)

# Pipe anything into fzf
ls | fzf
git branch | fzf
ps aux | fzf

# Multi-select with Tab
fzf -m                   # select multiple with Tab, confirm with Enter

# With preview
fzf --preview 'bat --color=always {}'
```

## Navigation inside fzf

| Key | Action |
|-----|--------|
| Type | filter results |
| `Up/Down` | move selection |
| `Enter` | confirm |
| `Tab` | toggle selection (multi-mode) |
| `Ctrl+A` | select all |
| `Esc` / `Ctrl+C` | cancel |
| `?` | toggle preview (in Ctrl+R) |

## Common patterns

```bash
# Kill a process
kill -9 $(ps aux | fzf | awk '{print $2}')

# Checkout git branch
git checkout $(git branch | fzf)

# Docker exec into container
docker exec -it $(docker ps --format '{{.Names}}' | fzf) bash

# Open recent file
nvim $(fzf --history=$HOME/.fzf_history)
```

## Custom ripgrep+fzf functions (from zshrc)

| Command | What it does |
|---------|-------------|
| `rgf <pattern>` | rg → fzf → open file at line in editor |
| `rgv <pattern>` | list matching files → fzf → open in editor |
| `rgt <type> <pattern>` | search in file type → fzf with preview |
| `rgc <pattern>` | count matches per file, sorted |

## Links

- Repo: https://github.com/junegunn/fzf
