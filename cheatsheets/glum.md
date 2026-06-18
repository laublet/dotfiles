# glum — focus markdown reader (terminal)

> **Help:** `?` in viewer · `glum --help`

> Reader mode for the terminal. Hub: [markdown-reading](markdown-reading.md). **`readmd` = glum with dotfiles defaults** (plain theme, 72 cols, centered). Install: `just install-glum`.

## readmd vs glum

Same binary. Difference is only how you invoke it:

| Command | Theme | Layout |
|---------|-------|--------|
| **`readmd file.md`** | `plain` (WezTerm Dracula bg) | 72 cols, centered |
| **`glum file.md`** | last used theme, or **`dark`** on first run | glum defaults |

`glum` **remembers** your last theme (`T` key, or a previous `--theme dark`). So bare `glum` can still look near-black even after `readmd` feels fine.

**Fix:** use `readmd` for reading, or reset once:

```bash
glum --theme plain --align center --measure 72 cheatsheets/glow.md   # persisted for bare glum
# or press T in glum until you land on plain
```

## Everyday usage

```bash
readmd README.md                      # ← preferred entry point
glum --theme plain README.md          # same look, without the wrapper
glum --theme night cheatsheets/glow.md   # blue-dark if plain feels too flat
glum --theme sepia --measure 68 note.md
glum -f note.md                       # follow file changes while editing
cat draft.md | glum -                 # stdin
```

## Dracula / theme notes

| Tool | Dracula |
|------|---------|
| **readmd** (default) | `--theme plain` — **no own background**; inherits WezTerm `#282a36` |
| glum `dark` | Near-black `#16161a` — harsher than Dracula; avoid for long reads |
| glum `night` | Blue-dark, purple accents — closest built-in colored dark |
| [glow](glow.md) | Built-in `-s dracula` (dotfiles default in `conf/glow/glow.yml`) |
| [mdfocus](mdfocus.md) | No built-in Dracula — Stylus: `conf/mdfocus/dracula-stylus.css` |
| Overview | [markdown-reading](markdown-reading.md) |

Override default: `READMD_THEME=night readmd file.md`

## Keys (reading)

| Key | Action |
|-----|--------|
| `j/k` or `↑/↓` | Scroll line |
| `Space` / `b` | Page down / up |
| `d/u` | Half page |
| `g/G` | Top / bottom |
| `t` | Table of contents |
| `/` then `n/N` | Search / next match |
| `T` | Cycle theme (dark, sepia, night, …) |
| `A` | Toggle align (center → left → right) |
| `L` | Layout (minimal ↔ vivid) |
| `e` | Open in `$EDITOR` at nearest heading |
| `?` | Help |
| `q` | Quit |

## When to use what

| Need | Tool |
|------|------|
| Comfortable centered reading in terminal | **`readmd`** |
| Browser focus + Mermaid | **`readweb`** → [mdfocus](mdfocus.md) |
| Browse folder, remote README, pipes | [glow](glow.md) |
| Which tool when | [markdown-reading](markdown-reading.md) |
| Preview in Neovim float | `Space + np` (glow) |
| Edit | nvim |

## Install

```bash
just install-glum                     # ~/.local/bin/glum
# or: install-glum
# or: cargo install glum
```

## Links

- Repo: https://github.com/jaschadub/glum
