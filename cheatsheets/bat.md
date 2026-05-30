# bat — syntax-highlighted cat

> **Help:** `bat --help` · `man bat`

> Replaces `cat`. Aliased: `cat` → `bat --paging=never`, `catp` → `bat` (with pager)

## Everyday usage

```bash
cat file.py              # syntax-highlighted output (no pager)
catp file.py             # same but scrollable (pager mode)
bat -l json < data.txt   # force language detection
bat -A file.txt          # show non-printable characters (tabs, newlines)
bat --diff file.py       # highlight git changes inline
bat -r 10:20 file.py     # show only lines 10–20
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-n` | line numbers only (no header, no grid) |
| `-p` | plain mode (just colored code) |
| `--style=numbers` | only show line numbers |
| `-l <lang>` | force language (e.g. `-l json`, `-l yaml`) |
| `--list-languages` | show supported languages |
| `--list-themes` | show available themes |
| `--theme=<name>` | override theme |

## Combine with other tools

```bash
# Preview in fzf (already configured in zshrc)
fzf --preview 'bat --style=numbers --color=always {}'

# Diff two files with syntax highlighting
diff -u a.py b.py | bat -l diff

# Colorize help output
some_command --help | bat -l help

# Colorize man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
```

## Links

- Repo: https://github.com/sharkdp/bat
- Config file: `~/.config/bat/config`
