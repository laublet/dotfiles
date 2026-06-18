# Markdown reading — glow, glum, mdfocus

> **Help:** [glow](glow.md) · [glum](glum.md) · [mdfocus](mdfocus.md) · `readmd --help` via glum

> Three tools, one job: read `.md` comfortably. Pick by context — not by habit alone.

## Quick pick

| I want… | Command | Where |
|---------|---------|--------|
| **Focus read** (centered column, terminal) | `readmd file.md` | WezTerm |
| **Focus read** (browser, tree, Mermaid) | `readweb [dir]` | Firefox / Chrome |
| **Quick render** or browse folder | `glow file.md` / `glow .` | terminal |
| **Preview in nvim** | `Space + np` (glow) · `Space + nv` (browser + Mermaid) | Neovim |

**Shell shortcuts:** `readmd` = glum with dotfiles defaults · `readweb` = mdfocus on localhost · `readvault` = `readweb` on Obsidian vault (opens browser on macOS).

## The three CLIs

```text
readmd note.md          terminal, centered, Dracula via WezTerm (theme plain)
readweb cheatsheets/    browser,  http://localhost:4242, live reload
glow -p README.md       terminal, Dracula colors, pager — no center column
```

### readmd vs glum

Same binary (`glum`). **`readmd`** always passes `--theme plain --measure 72 --align center` (plain = inherit WezTerm `#282a36`).

Bare **`glum file.md`** uses the **last remembered theme** (often `dark` = near-black `#16161a`). Prefer `readmd`, or once:

```bash
glum --theme plain --align center --measure 72 file.md
```

### readweb vs mdfocus-launch

Same thing. **`readweb`** is the dotfiles name (pairs with `readmd`). `mdfocus-launch` still works (wrapper).

```bash
readweb .                              # serve current folder
OPEN=1 readweb cheatsheets/            # open browser too
readvault                              # zsh: vault + OPEN=1 (see zshrc)
PORT=8080 readweb ~/notes
```

## Dracula (dotfiles rice)

| Tool | How |
|------|-----|
| **readmd** | `--theme plain` → WezTerm background `#282a36` |
| **glow** | `conf/glow/glow.yml` → `style: dracula` · `Space + np` same |
| **readweb / mdfocus** | No built-in Dracula — optional Stylus: [`conf/mdfocus/dracula-stylus.css`](../conf/mdfocus/dracula-stylus.css) on `http://localhost:*` |
| **mdfocus in-app** | Palette icon → `sepia` often nicer than `dark` / `oled` without Stylus |

Override terminal theme: `READMD_THEME=night readmd file.md`

## Install

```bash
just install-glum    # ~/.local/bin/glum (readmd needs it)
just link            # readmd, readweb → ~/.local/bin
```

`readweb` only needs Node (`npx`); no extra install.

## See also

- [glow.md](glow.md) — browse, remote README, CI pipes
- [glum.md](glum.md) — keys, themes, `readmd` vs `glum`
- [mdfocus.md](mdfocus.md) — browser UI, Stylus Dracula
- [tui-guide.md](tui-guide.md) — launcher matrix
