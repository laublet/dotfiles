# Ghostty + Zellij lab (parallel track)

> **Help:** `ghostty-lab` · [zellij](zellij.md) · [WezTerm main](wezterm.md)

> Thin native terminal (Ghostty) + Zellij mux. **WezTerm reste le main** (resurrect, output picker, duti, AeroSpace LCAG+Enter).
> Launch : `ghostty-lab` ou **LCAG+Shift+Enter** (AeroSpace).

## Quick start

```bash
brew install --cask ghostty   # once
just link                     # symlinks conf/ghostty + bin/ghostty-lab
ghostty-lab                   # or: just ghostty-lab
```

Attacher une session existante :

```bash
zellij attach lab
```

Config : [`conf/ghostty/config`](../conf/ghostty/config) · [`conf/zellij/config.kdl`](../conf/zellij/config.kdl) (unifiée).

## Navigation (identique à WezTerm / Neovim)

| Raccourci | Action |
|-----------|--------|
| `Ctrl + flèches` | Navigate panes (Neovim ↔ Zellij via smart-splits + vim-zellij-navigator) |
| `Ctrl + Shift + flèches` | Idem — fallback macOS si Mission Control vole `Ctrl+←/→` |
| `Ctrl + Alt + flèches` | Resize pane |

## Panes & tabs (Zellij — Super = Cmd sur macOS)

| Raccourci | Action |
|-----------|--------|
| `Cmd + D` | Split right |
| `Cmd + Shift + D` | Split down |
| `Cmd + W` | Close pane |
| `Cmd + Shift + Z` | Zoom pane (fullscreen) |
| `Cmd + T` | New tab |
| `Cmd + Shift + ←/→` | Prev / next tab |
| `Cmd + 1`..`9` | Go to tab |
| `Cmd + Shift + ,` | Rename tab |

## Scrollback & shell

| Raccourci | Action |
|-----------|--------|
| `Cmd + Alt + Space` | Scroll / copy mode (vim-like) |
| `Cmd + ↑/↓` | Jump prompt (OSC 133 — zsh + Ghostty natif) |
| Ghostty `Cmd + F` | Scrollback search (Ghostty 1.3+) |
| `Ctrl + a` `d` | Detach session (SSH fallback) |

## Ghostty natif (hors Zellij)

- **Notifications** : fin de commande si fenêtre unfocused (`notify-on-command-finish`)
- **Kitty keyboard protocol** : supporté (comme WezTerm)
- **Liens cliquables** : dans Zellij → **Shift+Ctrl+clic** (sinon Ctrl+clic hors Zellij)
- **Mux Ghostty désactivé** : pas de double-couche Cmd+D / Cmd+T

## Volontairement absent vs WezTerm

| Feature WezTerm | Lab |
|-----------------|-----|
| resurrect workspaces | `zellij attach -c lab` + `session_serialization` |
| Output picker fzf (`Ctrl+Shift+O`) | copie output Ghostty / scrollback search |
| Tab glyphs agents | non |
| `Cmd+clic` → `nvim +line` custom | hyperlinks Ghostty par défaut |
| CharSelect / QuickSelect custom | non en v1 |

## Test checklist

1. `ghostty-lab` → 2 panes, `nvim` + shell
2. `Ctrl+flèches` traverse Neovim ↔ shell
3. `cargo test` fail → copier output (scroll mode ou Ghostty copy command output)
4. Fermer Ghostty → `ghostty-lab` restaure session `lab`
5. WezTerm : smart-splits OSC + resurrect inchangés

## Notes (gotchas)

- **CLI Ghostty** : le cask installe `Ghostty.app` seulement — le binaire est `/Applications/Ghostty.app/Contents/MacOS/ghostty` (pas dans `PATH`). `bin/ghostty-lab` le résout ; après edit : `just link`.
- **smart-splits** : ne pas mettre `multiplexer_integration = "auto"` (module inexistant). Omettre l’option → auto-detect (`ZELLIJ` → zellij, `TERM_PROGRAM=wezterm` → wezterm). Overrides OSC WezTerm gardés derrière `mux.type == "wezterm"`.
- **Ctrl+C** : avec `keybinds clear-defaults=true`, ne pas binder `Ctrl+c` dans `shared_except` (sinon avalé en mode normal). En shell = SIGINT / annuler la ligne ; en scroll/search = quitter le mode.
- **Scroll Zellij** : flèches (pas `j/k`) ; en recherche `↑/↓` = match préc./suiv.

## Links

- Ghostty : https://ghostty.org
- Zellij : https://zellij.dev
- vim-zellij-navigator : https://github.com/hiasr/vim-zellij-navigator
