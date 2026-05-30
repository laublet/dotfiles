# Tridactyl (Firefox) — task-oriented

## Status (2026-05)

| | |
|---|---|
| **Active in Firefox** | **Vimium** (Tridactyl extension disabled) |
| **Why paused** | YouTube was painful even with `mode ignore` + `UriChange` + selective `bindurl` in tridactylrc |
| **Dotfiles** | Config kept in [`conf/tridactyl/tridactylrc`](../conf/tridactyl/tridactylrc) (dotbot link unchanged); not re-enabling today |

**Future option (not planned now):** Tridactyl on most sites + Vimium (or [Vimium C](https://github.com/gdh1995/vimium-c)) on “backup” hosts only. Requires **one** vim extension per tab: Tridactyl `superignore` / `blacklistadd` on backup domains, Vimium excluded everywhere else (Vimium C allowlist is easier than stock Vimium blacklist-only). Do not run both fully active on the same page.

---

> **Help:** `:help` in Tridactyl command line · [wiki](https://github.com/tridactyl/tridactyl/wiki)

Config canonique : [`conf/tridactyl/tridactylrc`](../conf/tridactyl/tridactylrc). Résumé tabulaire : [keyboard-navigation.md § Tridactyl](keyboard-navigation.md#tridactyl-firefox).

## References (official-ish)

- **`:help`** — Dans la barre Tridactyl, ouvre l’aide intégrée (liste des commandes et concepts).
- **Wiki** — [github.com/tridactyl/tridactyl/wiki](https://github.com/tridactyl/tridactyl/wiki)
- **Defaults des raccourcis** — Le fichier [`src/lib/config.ts`](https://github.com/tridactyl/tridactyl/blob/master/src/lib/config.ts) du dépôt (objets `nmaps`, `imaps`, etc.) est la source de vérité quand la doc web est floue.
- **`:viewconfig`** — Affiche la config effective (utile après `sanitise` / imports).

---

## I want to…

### Open / follow a link without the mouse (hints)

| Action | Keys / command |
|--------|----------------|
| Follow link in current tab | `f`, then hint chars (home row: `asdfghjkl`) |
| Follow link in new tab | `F` |
| Yank link URL | `;y` |
| Copy element text | `;p` |
| Open image / in new tab | `;i` / `;I` |
| Save link / save as | `;s` / `;S` |

`hintchars` is set to **`asdfghjkl`** in this config (fast two-key combos on Kyria).

### Change tabs or move them

| Action | Keys |
|--------|------|
| Previous / next tab | `J` / `K` |
| Move tab left / right | `gJ` / `gK` |
| Close tab / undo close | `d` / `u` (defaults) |

### Go back / forward in history

| Action | Keys |
|--------|------|
| Back / forward | `H` / `L` (defaults) |

### Scroll the page

| Action | Keys |
|--------|------|
| Line down / up | `j` / `k` |
| Column left / right | `h` / `l` |
| Half page | `Ctrl+d` / `Ctrl+u` |
| Full page | `Ctrl+f` / `Ctrl+b` |
| Top / bottom | `gg` / `G` |

### Focus a text field (insert mode)

| Action | Keys |
|--------|------|
| Focus first input | `gi` (default) |
| Leave insert → normal | `Ctrl+[` (bound in config: unfocus + normal mode) |

### Jump to a bookmarked URL (quickmarks)

Letters are defined in tridactylrc (`quickmark <letter> <url>`): **g** GitHub, **m** Gmail, **c** Calendar, **t** Todoist, **y** YouTube, **o** Obsidian vault.

| Action | Keys |
|--------|------|
| Open quickmark | `g` `o` then letter (see table above) |
| Same in new tab | `g` `n` then letter |

### Search the web from the command line

Examples (prefix `:open`):

| I want to search… | Example |
|-------------------|---------|
| GitHub | `:open gh query` |
| MDN | `:open mdn query` |
| npm | `:open npm query` |
| crates.io | `:open crates query` |
| YouTube | `:open yt query` |
| Wikipedia | `:open w query` |
| Rust std | `:open rs query` |

### Clip the page into Obsidian

| Action | Keys |
|--------|------|
| Trigger Obsidian Web Clipper | `;o` (extension must be installed; see comment in tridactylrc) |

### When a site steals my shortcuts (Gmail, Notion, …)

Those hosts use **`mode ignore`** via `autocmd DocStart …` in tridactylrc (Firefox, Google Docs, Notion, Figma, YouTube, etc.). In **ignore** mode, Tridactyl does not intercept keys; use the site’s own UI or temporarily adjust bindings.

---

## Modes (short)

| Mode | Role |
|------|------|
| **normal** | Default; motions, hints, `:` commands. |
| **insert** | When focused in an input; `Ctrl+[` returns to normal per config. |
| **ignore** | On configured sites — passthrough to the page. |

---

## Useful ex-commands

| Command | Role |
|---------|------|
| `:help` | Built-in help. |
| `:source` | Reload config (after editing tridactylrc). |
| `:installnative` | Native messenger (needed once for some features). |
| `:viewconfig` | Inspect effective configuration. |

---

## Editor integration

`editorcmd` is set to **`wezterm start -- nvim %f`** so external edit opens Neovim in WezTerm.
