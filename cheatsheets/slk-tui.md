# slk-tui — Slack TUI (gammons/slk)

> **Help:** `?` in TUI · [wiki Keybindings](https://github.com/gammons/slk/wiki/Keybindings) · `cheat slkcli` (CLI/agents)

> Keyboard-first Slack client (~20 MB, Go). Multi-workspace, Vim modes, SQLite scrollback. Unofficial — same browser-session auth as the web app.

**Pairing:** scripts / agents / quick one-shots → [slkcli](slkcli.md) (`slk`). All-day terminal Slack → **this** tool (`slk-tui`).

## Install

```bash
just install-slk-tui            # ~/.local/bin/slk-tui (dotfiles)
# or: brew install gammons/tap/slk   then: ln -sf "$(brew --prefix)/bin/slk" ~/.local/bin/slk-tui
# or: go install github.com/gammons/slk/cmd/slk@latest  → rename binary to slk-tui

slk-tui --add-workspace         # paste xoxc token + d cookie from browser DevTools
```

Setup walkthrough: https://github.com/gammons/slk/wiki/Setup

## Launch

```bash
slk-tui                         # all configured workspaces
tui                             # fuzzy picker (registry entry slk-tui)
```

Workspaces: `1`–`9` to switch (unread badges in rail).

## Depuis Slack desktop (macOS)

| Slack | slk-tui | Notes |
|-------|---------|--------|
| `Cmd+K` quick switcher | **`Ctrl+t`** ou **`Ctrl+p`** | Fuzzy canal/DM — pas la liste « récents non-lus » Slack |
| Historique récent (approx.) | **`Ctrl+h`** / **`Ctrl+k`** | Retour / avant dans les canaux **déjà visités** (pas les unreads) |
| Parcourir les non-lus | **`Ctrl+b`** → **`j`/`k`** | Canaux **gras + point bleu** |
| `?` aide | **`?`** | Modal keybindings |
| `/` recherche messages | ❌ **non branché** (v0.8.x) | Déclaré dans le code mais pas câblé — utiliser **`Ctrl+t`** |
| `gg` / `G` haut / bas | **`G`** = bas ✅ · **`g`/`gg`** = haut ❌ | Bug upstream : touche `g` dans la doc mais **pas de handler** — voir contournements ci-dessous |

**Haut de liste (contournements)** : `PgUp`, **`Ctrl+u`** (demi-page, répéter), ou beaucoup de **`k`**.

Pas de « jump next unread ». Workflow : sidebar + `j`/`k`, ou `Ctrl+t`.

## Core keys (normal mode)

| Key | Action |
|-----|--------|
| `j` / `k` | Scroll messages / sidebar (selon focus) |
| `h` / `l` | Changer de panneau |
| `Tab` | Cycle focus |
| `i` | Insert — compose message |
| `Esc` | Normal mode |
| `Ctrl+t` / `Ctrl+p` | Fuzzy channel / DM finder |
| `Ctrl+w` | Workspace picker |
| `Ctrl+b` | Toggle sidebar |
| `G` | Bas de la liste (messages / sidebar / thread) |
| `PgUp` / `Ctrl+u` | Haut (demi-page) — pas de `g`/`gg` fiable en 0.8.x |
| `Ctrl+h` / `Ctrl+k` | Canal précédent / suivant (historique de navigation) |
| `Enter` | Ouvrir canal (sidebar) ou fil (message) |
| `1`–`9` | Switch workspace |

Full list: https://github.com/gammons/slk/wiki/Keybindings

## WezTerm / tmux

**Kitty images in tmux:**

```tmux
set -g allow-passthrough on
```

**Unread in tab title (tmux):**

```tmux
set -g set-titles on
set -g set-titles-string '#T'
```

## Config

Perf snippet to merge: `conf/slk/config.performance.toml` in dotfiles. XDG: [Configuration wiki](https://github.com/gammons/slk/wiki/Configuration).

**Typing feels slow?** In `~/.config/slk/config.toml`:

```toml
[animations]
enabled = false
smooth_scrolling = false
typing_indicators = false   # main fix: stops API ping per keystroke

[appearance]
image_protocol = "off"
```

Also: compose only after **`i`** (insert mode); test **outside tmux**; one workspace if possible; quit **SLK_DEBUG**.

Debug: `SLK_DEBUG=1 slk-tui` → `slk-debug.log` in cwd (truncated each run).

## Limits

No huddles/calls, some Block Kit gaps. Enterprise Grid may flag session — see README disclaimer.

## Name clash

| Binary | Tool |
|--------|------|
| `slk-tui` | this cheatsheet (gammons/slk) |
| `slk` | [slkcli](slkcli.md) on macOS |

## Links

- Site: https://getslk.sh/
- Repo: https://github.com/gammons/slk
