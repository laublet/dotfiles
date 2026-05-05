# Zed — IDE (parallel transition from Cursor)

Config: [`conf/zed/settings.json`](../conf/zed/settings.json) and [`conf/zed/keymap.json`](../conf/zed/keymap.json) (linked to `~/.config/zed/`, XDG on macOS + Linux).

Zed runs `vim_mode: true` with `base_keymap: "Cursor"`. Most Cmd-prefixed bindings (Cmd+P, Cmd+Shift+P, Cmd+B, Cmd+J, …) come from the Cursor base keymap; the leader layer below is custom and mirrors the Neovim / Cursor v6 architecture.

## Spatial model

```
[ProjectPanel] ←Ctrl+Left— [Editor] —Ctrl+Right→ [AgentPanel]
                              ↕ Ctrl+Down / Ctrl+Up
                          [Terminal]
```

Zed unifies docks and editor splits in a single pane tree, so the same Ctrl+arrow chord walks across sidebar, editor splits, terminal and AI panel — no separate "zone" vs "split" tier.

## Pane / dock navigation

| Action | Shortcut |
|--------|----------|
| Focus pane left / right / up / down | `Ctrl + ←↓↑→` |
| Toggle left dock (project panel) | `Cmd + B` |
| Toggle right dock (AI agent) | `Cmd + R` |
| Toggle bottom dock (terminal) | `Cmd + J` |

## Tabs

| Action | Shortcut |
|--------|----------|
| Previous / next tab | `Cmd + Shift + ←/→` |
| Reorder tab left / right | `Cmd + Alt + ←/→` |
| Close tab | `Cmd + W` |

## Splits

| Action | Shortcut |
|--------|----------|
| Split right | `Cmd + D` (in editor) or `Space + \` |
| Split down | `Cmd + Shift + D` or `Space + -` |

## Leader layer (Vim normal mode)

| Key | Action |
|-----|--------|
| `Space + e` | Toggle project panel (file tree) |
| `Space + f` / `Space + p p` | Find file (file finder) |
| `Space + g` | Search in files |
| `Space + b` | Switch buffer (tab switcher) |
| `Space + t` | Toggle terminal panel |
| `Space + v` | Toggle git panel |
| `Space + c` | Toggle AI agent panel |
| `Space + d` | Toggle debugger panel |
| `Space + w` | Save file |
| `Space + q` / `Space + x` | Close active item |
| `Space + z` | Zen mode (toggle centered layout) |

## Search & navigation

| Action | Shortcut |
|--------|----------|
| File finder (fuzzy) | `Cmd + P` or `Space + f` |
| Project symbols (fuzzy, LSP workspace) | `Cmd + T` |
| Symbols in current file (fuzzy outline) | `Cmd + Shift + O` (or `g s` in vim mode) |
| Command palette (fuzzy) | `Cmd + Shift + P` |
| Buffer search (current file) | `Cmd + F` (or `/` in vim mode) |
| Project search (regex / literal, all files) | `Cmd + Shift + F` or `Space + g` |
| Project search & replace | `Cmd + Shift + H` |

Project content search is **literal / regex**, not fuzzy — same model as Neovim's `live_grep`. Fuzzy matching only applies to files, symbols and commands. Toggle regex with `Alt + Cmd + X` to cover most "fuzzy-like" needs (e.g. `foo.*bar`).

### Inside the project search panel (`Cmd+Shift+F` / `Space+g`)

| Action | Shortcut |
|--------|----------|
| Submit search | `Enter` |
| Open results in a new tab (keep previous results) | `Cmd + Enter` |
| Next / previous match | `Cmd + G` / `Cmd + Shift + G` |
| Move focus query ↔ results | `Esc` |
| Toggle case sensitive | `Alt + Cmd + C` |
| Toggle whole word | `Alt + Cmd + W` |
| Toggle regex | `Alt + Cmd + X` (alias `Alt + Cmd + G`) |
| Toggle replace mode | `Cmd + Shift + H` |
| Toggle include / exclude filters | `Cmd + Shift + J` (or `Alt + Cmd + F`) |
| Expand / collapse all results | `Cmd + Shift + Enter` |
| Restrict search to current selection | `Cmd + Alt + L` |
| Browse query history | `↑` / `↓` in the search field |
| Replace next / replace all | `Enter` / `Cmd + Enter` (in replace field) |

### Inside the buffer search panel (`Cmd+F`)

| Action | Shortcut |
|--------|----------|
| Next / previous match | `Enter` / `Shift + Enter` |
| Select all matches (multi-cursor) | `Alt + Enter` |
| Focus the editor (keep panel open) | `Tab` |
| Dismiss panel | `Esc` |
| Toggle replace | `Cmd + Alt + F` |
| Use current selection as query | `Cmd + E` |
| Restrict search to current selection | `Cmd + Alt + L` |

## LSP & code (vim mode core)

| Action | Shortcut |
|--------|----------|
| Go to definition | `g d` |
| Go to type definition | `g y` |
| Go to implementation | `g I` (or `g i` alias) |
| All references | `g A` (or `g r` alias) |
| Hover (inline error) | `g h` |
| Code actions | `g .` |
| Rename | `c d` |
| Symbol in file / project | `g s` / `g S` |
| Next / previous diagnostic | `] d` / `[ d` |

## Git (vim mode core)

| Action | Shortcut |
|--------|----------|
| Next / previous hunk | `] c` / `[ c` |
| Expand diff hunk | `d o` |
| Toggle staged | `d O` |
| Restore change | `d p` |

## AI agent (Zed)

| Action | Shortcut |
|--------|----------|
| Toggle agent panel | `Space + c` |
| Submit message (in agent) | `Cmd + Enter` |
| Accept all edits | `Cmd + Shift + Enter` |
| Reject all edits | `Cmd + Shift + Backspace` |

Agent action names may shift between Zed releases — if a chord stops working, run `cmd-k cmd-s` to open the keymap editor and re-bind from the live action list.

## Terminal

When focused in the terminal panel, Cmd-prefixed bindings target the panel itself:

| Action | Shortcut |
|--------|----------|
| New terminal | `Cmd + T` |
| Close terminal | `Cmd + W` |
| Split right / down | `Cmd + D` / `Cmd + Shift + D` |
| Switch terminal tabs | `Cmd + Shift + ←/→` |

## Project panel (file tree, vim-style)

When focused in the project panel:

| Key | Action |
|-----|--------|
| `h` / `l` | Collapse / expand entry |
| `j` / `k` | Move down / up |
| `o` | Open file |
| `a` / `A` | New file / new directory |
| `r` | Rename |
| `d` | Delete |
| `x` / `c` / `p` | Cut / copy / paste |

## Discovery

| Action | Shortcut |
|--------|----------|
| Command palette | `Cmd + Shift + P` |
| Open keymap editor | `Cmd + K Cmd + S` |
| Show active key context | `dev: open key context view` (palette) |
| Open default keymap | `zed: open default keymap` (palette) |

## What's *not* ported from Neovim

These plugins live only in standalone Neovim — Zed has built-in or extension equivalents:

| Neovim plugin | Zed equivalent |
|---------------|----------------|
| `fzf-lua` / Telescope | `Cmd + P` (file finder) + `Space + g` (project search) |
| `neo-tree` | Project panel (`Space + e`) |
| `gitsigns` | Git gutter + git panel (`Space + v`) |
| `which-key` | Native menu prompt after partial chord |
| `surround.vim` / `nvim-surround` | Built into vim mode (`ys`, `cs`, `ds`) |
| `comment.nvim` | Built into vim mode (`gc` / `gcc`) |
| `trouble.nvim` | Diagnostics view (`:cl[ist]` / `Cmd + Shift + M`) |
| `avante.nvim` / `supermaven` | Zed Agent + Edit Predictions |

For a full keybindings comparison table, see [keymaps-hub.md](keymaps-hub.md).
