# Keymaps hub

> **Help:** This file · `cheat keymaps-hub` · Neovim: `<leader>H`

Single entry point for cross-app shortcuts (AeroSpace, WezTerm, Cursor, Zed, Neovim, Mouseless, etc.). The canonical reference is **[keyboard-navigation.md](keyboard-navigation.md)** — this file is only a map and entry point.

From the shell, run `cheat` when your setup exposes cheatsheets that way (same idea as Neovim **Space + H**).

## Neovim

**Standalone IDE** (replaces Cursor for TS/debug/tests): [neovim-ide.md](neovim-ide.md) — Mason, dap, neotest, overseer, harpoon, Go, WezTerm links.

In standalone Neovim: **Space + H** opens an fzf picker on the whole cheatsheets directory.

Split convention (pickers/menus): **`<C-v>` vertical · `<C-x>` horizontal · `<C-t>` tab**.
Applies when supported (Oil, Neo-tree, Harpoon menu, ast-grep/fzf pickers). Global split creation remains `<leader>|` / `<leader>-`.

Keymap lock check (strict drift detector): `just keymap-lock-check`.
This validates canonical cross-tool mappings with **Neovim + WezTerm as references**.
Local git hooks: `just install-git-hooks` (runs keymap lock on pre-push).
Current policy: pre-push only (no pre-commit block).

## Table of contents

Sections below match headings in [keyboard-navigation.md](keyboard-navigation.md). In VS Code or Neovim, use the document outline / `:Outline` to jump; in a browser or GitHub, fragments follow usual Markdown heading slug rules.

1. [System (macOS / Linux)](keyboard-navigation.md#system-macos-linux)
2. [AeroSpace (window manager)](keyboard-navigation.md#aerospace-window-manager)
3. [WezTerm](keyboard-navigation.md#wezterm)
4. [Cursor IDE](keyboard-navigation.md#cursor-ide) — includes **Chat / Composer input** (newline vs send), zone navigation, leader layer, AI accept/reject
5. [Zed](zed.md) — Cursor v6 architecture ported, Vim leader layer, Dracula
6. [Neovim (standalone)](keyboard-navigation.md#neovim-standalone)
7. [Obsidian](keyboard-navigation.md#obsidian)
8. [Tridactyl (Firefox)](keyboard-navigation.md#tridactyl-firefox) — **paused**; Vimium active — [tridactyl.md](tridactyl.md) (status + hybrid option)
9. [Mouseless](mouseless.md) — full cheatsheet; summary also in [keyboard-navigation.md](keyboard-navigation.md#mouseless)
10. [Terminal aliases (zsh)](keyboard-navigation.md#terminal-aliases-zsh)
11. [Kyria layers (quick reference)](keyboard-navigation.md#kyria-layers-quick-reference) — quick map; **full reference (every layer, combo, OSM, arcane, debug) lives in [kyria.md](kyria.md)**. Next iteration design (FR/EN/ES, Arcane-on-thumbs): [kyria-next.md](kyria-next.md).

Related: **iTerm2 (same ⌘⌫ behavior)** — subsection under WezTerm in the same file (search the heading if the outline does not list it).

## Links

- Cheatsheets repo: https://github.com/laublet/dotfiles/tree/master/cheatsheets
