# glow — markdown reader for the terminal

> Render markdown with proper styling (Charm). Use it for READMEs, cheatsheets in this repo, GitHub/GitLab issues, and CHANGELOG diffs. TUI mode browses a directory tree of `.md` files with previews.

## Everyday usage

```bash
glow README.md                        # render a single file
glow .                                # TUI: browse current dir
glow -p README.md                     # render through a pager (long files)
glow -w 100 README.md                 # wrap at 100 columns (default ~auto)
glow https://github.com/user/repo     # fetches README from a repo URL
glow github.com/user/repo             # same (scheme inferred)
```

## TUI keys (browse mode)

| Key | Action |
|-----|--------|
| `↑/↓` or `j/k` | Move selection |
| `Enter` | Open file |
| `Esc` / `q` | Back / quit |
| `/` | Filter (fuzzy) |
| `m` | Mark as read (visual aid) |
| `?` | Help |

## Pager keys (inside a rendered file)

| Key | Action |
|-----|--------|
| `j/k` or `↑/↓` | Scroll |
| `g` / `G` | Top / bottom |
| `Space` / `b` | Page down / up |
| `/` | Search |
| `n` / `N` | Next / prev match |
| `q` | Quit |

## Style

```bash
glow -s dark file.md                  # force dark
glow -s light file.md                 # force light
glow -s notty file.md                 # plain output (CI / pipes)
```

Custom styles live in `~/Library/Application Support/glow/`. Default `dark` is usually fine on this Wezterm setup.

## When to use what

| Need | Tool |
|------|------|
| Read a `.md` file with style | `glow file.md` |
| Browse the `cheatsheets/` folder visually | `glow cheatsheets/` (or `cheat` for fzf) |
| Render a remote README without cloning | `glow github.com/user/repo` |
| Render markdown in a pipe (CI / scripts) | `glow -s notty` |
| Edit markdown | `nvim` (glow is read-only) |

## Links

- Repo: https://github.com/charmbracelet/glow
