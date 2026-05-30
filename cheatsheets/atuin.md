# atuin — searchable shell history

> **Help:** `Ctrl+R` then `?` / inspector · `atuin help`

> Replaces fzf `Ctrl+R`. Stores history with context: directory, exit code, duration, timestamp.

## Everyday usage

```bash
# Open interactive search (replaces Ctrl+R)
Ctrl+R

# Search from command line
atuin search "docker"
atuin search --exit 0 "make"         # only successful commands
atuin search --cwd ~/projects        # only from a specific directory
atuin search --after "2h ago"        # last 2 hours
atuin search --before "1w ago"       # older than 1 week
```

## Useful flags

| Flag | Effect |
|------|--------|
| `--exit <code>` | filter by exit code (0 = success) |
| `--cwd <dir>` | filter by working directory |
| `--after <time>` | after time (e.g. `1h`, `2d`, `1w`) |
| `--before <time>` | before time |
| `-c` / `--cmd-only` | show only the command (no metadata) |
| `--format "{time} {command}"` | custom output format |

## Interactive search keybindings

| Key | Action |
|-----|--------|
| `Ctrl+R` | open search (insert mode / emacs keymap) |
| `/` | open search (vi **normal** mode at the prompt — `Ctrl+R` stays vim redo) |
| `Enter` | execute selected command |
| `Tab` | insert into prompt (edit before running) |
| `Ctrl+D` | delete entry from history |
| `Ctrl+O` | toggle **Inspect** panel (see below) |

## Inspect mode

`Ctrl+O` from the search view opens the **inspector** for the currently selected command. It shows everything atuin recorded around that execution and every previous run of the same command — perfect for "how long did this migration take last time?", "did that deploy actually exit 0?", or "from which directory did I run that?".

Panel contents:

- **Stats** — execution count, success rate, average duration
- **Context** — host, user, session id, cwd, exit code, duration, timestamp
- **History** — every prior execution of the same command, navigable with arrows

Keys inside Inspect:

| Key | Action |
|-----|--------|
| `Ctrl+O` / `Esc` | back to search |
| `↑` / `↓` | navigate previous executions |
| `Enter` | run the highlighted execution |
| `Ctrl+D` | delete the highlighted execution |

## Stats & management

```bash
atuin stats                          # usage statistics
atuin history list --cmd-only        # plain history dump
atuin history list -n 20             # last 20 commands
atuin import auto                    # import from zsh/bash history
```

## Config

- Config file: `~/.config/atuin/config.toml`
- Key settings: `style`, `inline_height`, `filter_mode`, `search_mode`

## Links

- Repo: https://github.com/atuinsh/atuin
