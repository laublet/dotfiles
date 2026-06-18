# glow — markdown reader for the terminal

> **Help:** `?` in TUI · `glow --help`

> Render markdown with proper styling (Charm). Quick render and folder browse — for **comfort reading** use [markdown-reading](markdown-reading.md) (`readmd` / `readweb`).

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

Custom styles: dotfiles `conf/glow/glow.yml` → `~/Library/Preferences/glow/glow.yml` (mac) or `~/.config/glow/glow.yml` (linux). Style is **`dracula`** (matches WezTerm / nvim rice).

In Neovim, `Space + np` uses a local preview (`utils/glow-preview.lua`) that runs `glow` in a real terminal (`termopen`) so ANSI colors work in the float window.

## When to use what

| Need | Tool |
|------|------|
| **Pick the right reader** | [markdown-reading](markdown-reading.md) |
| Read a `.md` file with style | `glow file.md` |
| **Centered focus reading** (terminal) | **`readmd file.md`** → [glum](glum.md) |
| **Focus reading** (browser, Mermaid) | **`readweb [dir]`** → [mdfocus](mdfocus.md) |
| Browse cheatsheets folder | `glow cheatsheets/` (or `cheat` for fzf) |
| Remote README without cloning | `glow github.com/user/repo` |
| CI / pipes | `glow -s notty` |
| Edit | nvim |

## Links

- Repo: https://github.com/charmbracelet/glow
