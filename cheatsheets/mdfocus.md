# mdfocus — focus markdown reader (browser)

> **Help:** `npx mdfocus --help` · hub: [markdown-reading](markdown-reading.md)

> Zero-config localhost server: focus UI, file tree, TOC, Mermaid, live reload. Dotfiles wrapper: **`readweb`** (pairs with terminal **`readmd`**).

## Everyday usage

```bash
readweb                               # current dir → http://localhost:4242
readweb ~/dev/perso/vaults/Research
readvault                             # zsh: vault path + open browser (macOS)
OPEN=1 readweb cheatsheets/           # open browser explicitly
PORT=8080 readweb .

mdfocus-launch .                      # alias of readweb (back-compat)
npx --yes mdfocus@latest .            # without dotfiles wrapper
```

Requires **Node.js** (`npx`). First run downloads the package.

## Themes (in-app)

Click the **palette** icon to cycle: `light` → `sepia` → `dark` → `oled`. Saved in `localStorage` (`mdfocus-theme`).

**Dracula:** not built-in. Optional Stylus on `http://localhost:*` — paste [`conf/mdfocus/dracula-stylus.css`](../conf/mdfocus/dracula-stylus.css). Without Stylus, **`sepia`** is often easier to read than **`dark`** / **`oled`**.

## Features

| Feature | Notes |
|---------|--------|
| Focus mode | Minimal chrome |
| File tree | Browse folder of markdown |
| Reading status | Mark files 🟡 🟢 🔴 |
| TOC | From headings |
| Live reload | `.md` / `.mdx` edits refresh |
| Mermaid | Diagrams in browser |
| Scroll memory | Tree + scroll position |

## When to use what

| Need | Tool |
|------|------|
| Browser + Mermaid + vault tree | **`readweb`** |
| Centered terminal reading | [glum](glum.md) / **`readmd`** |
| Quick terminal render / browse | [glow](glow.md) |
| Pick the right tool | [markdown-reading](markdown-reading.md) |
| Edit + sync preview in nvim | `Space + nv` |

## Links

- Repo: https://github.com/tzador/mdfocus
