# Zed — IDE (parallel transition from Cursor / Neovim)

Config: [`conf/zed/settings.json`](../conf/zed/settings.json) and [`conf/zed/keymap.json`](../conf/zed/keymap.json) (linked to `~/.config/zed/`, XDG on macOS + Linux).

Zed runs `vim_mode: true` with `base_keymap: "Cursor"`. Most Cmd-prefixed bindings (Cmd+P, Cmd+Shift+P, Cmd+B, Cmd+J, …) come from the Cursor base keymap; the leader layer below mirrors **Neovim** (see `conf/nvim/lua/plugins/which-key.lua`).

Which-key popup is native since Zed Dec 2025 — type `space` and pause to see the prefix tree.

## Spatial model

```
[ProjectPanel] ←Ctrl+Left— [Editor] —Ctrl+Right→ [AgentPanel]
                              ↕ Ctrl+Down / Ctrl+Up
                          [Terminal]
```

Zed unifies docks and editor splits in a single pane tree, so the same Ctrl+arrow chord walks across sidebar, editor splits, terminal and AI panel.

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

## Leader layer (Vim normal mode) — mirrors Neovim

### Files & navigation

| Key | Action |
|-----|--------|
| `Space + p p` | File finder (fuzzy) |
| `Space + p r` | Recent projects |
| `Space + r` | Recent files (file finder shows recents on top) |
| `Space + b` | Buffer / tab switcher |
| `Space + e` | Toggle project panel |
| `Space + E` | Reveal current file in project panel |

Zed file finder doesn't expose `fd` flags (hidden / no_ignore / dirs / glob) like fzf-lua. Set inclusions/exclusions in `settings.json` (`file_scan_exclusions`, `file_scan_inclusions`) instead.

### Search (grep)

| Key | Action |
|-----|--------|
| `Space + f f` | Project search panel (literal / regex) |
| `Space + f /` or `Space + /` | Buffer search (current file) |

Zed has a single project search panel; toggles for case / word / regex live inside the panel — see [search panel section](#inside-the-project-search-panel-cmdshiftf--space--f-f). All `<leader>f*` variants from nvim (icase, word, hidden, no_ignore, fixed) collapse to this one panel.

### Git

| Key | Action |
|-----|--------|
| `Space + g g` / `Space + g s` | Toggle git panel (status, stage, commit) |
| `Space + g b` | Branches picker (`git::Branches`) |
| `Space + g d` | Diff for current file |

No neogit binding — run `gu` (gitui) from any terminal (`Space + t` or external WezTerm) for a full standalone git TUI.

### Git hunks

| Key | Action |
|-----|--------|
| `Space + h n` / `Space + h N` | Next / previous hunk |
| `Space + h s` | Stage hunk and move to next |
| `Space + h r` / `Space + h u` | Restore hunk (also unstage) |
| `Space + h S` | Stage all (whole repo) |
| `Space + h R` | Restore file (reset all hunks) |
| `Space + h p` | Expand all diff hunks (preview) |
| `Space + h d` | Open file diff |
| `Space + h b` | Toggle inline git blame |
| `Space + h B` | Open full git blame view |

Vim mode also exposes git defaults: `] c` / `[ c` (next/prev change), `d o` (expand hunk), `d O` (toggle staged), `d p` (restore change).

### LSP / format

| Key | Action |
|-----|--------|
| `Space + l a` | Code actions (also `g .` in vim mode) |
| `Space + l f` | Format buffer |
| `Space + l r` | Rename symbol (also `c d` in vim mode) |

### Symbols

| Key | Action |
|-----|--------|
| `Space + s` | Document symbols (outline) |
| `Space + S` | Project / workspace symbols |

### AI agent

| Key | Action |
|-----|--------|
| `Space + a a` / `Space + a t` | Toggle agent panel |
| `Space + a n` | New thread |

### Misc / actions

| Key | Action |
|-----|--------|
| `Space + c` | Clear search highlight (`:noh`) |
| `Space + t` | Toggle terminal panel |
| `Space + d` | Toggle debugger panel |
| `Space + v` | Command palette (mirror nvim `<leader>v` "vim commands") |
| `Space + w` | Save |
| `Space + q` / `Space + x` | Close active item |
| `Space + z` | Zen mode (centered layout) |
| `Space + \\` | Split right |
| `Space + -` | Split down |
| `Space + ?` / `Space + :` | Command palette |

## Search & navigation (Cmd-based, Cursor base keymap)

| Action | Shortcut |
|--------|----------|
| File finder (fuzzy) | `Cmd + P` or `Space + p p` |
| Project symbols (fuzzy) | `Cmd + T` or `Space + S` |
| Document symbols (fuzzy outline) | `Cmd + Shift + O` or `Space + s` |
| Command palette (fuzzy) | `Cmd + Shift + P` or `Space + v` |
| Buffer search (current file) | `Cmd + F` or `/` (vim) or `Space + /` |
| Project search | `Cmd + Shift + F` or `Space + f f` |
| Project search & replace | `Cmd + Shift + H` |

### Inside the project search panel (`Cmd+Shift+F` / `Space + f f`)

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

### Inside the buffer search panel (`Cmd+F` / `Space + /`)

| Action | Shortcut |
|--------|----------|
| Next / previous match | `Enter` / `Shift + Enter` |
| Select all matches (multi-cursor) | `Alt + Enter` |
| Focus the editor (keep panel open) | `Tab` |
| Dismiss panel | `Esc` |
| Toggle replace | `Cmd + Alt + F` |
| Use current selection as query | `Cmd + E` |
| Restrict search to current selection | `Cmd + Alt + L` |

## LSP & code (vim mode core + nvim aliases)

| Action | Shortcut |
|--------|----------|
| Go to definition | `g d` |
| Go to declaration | `g D` |
| Go to type definition | `g y` (default) or `g t` (alias) |
| Go to implementation | `g I` (default) or `g i` (alias) |
| All references | `g A` (default) or `g r` (alias) |
| Hover | `g h` |
| Code actions | `g .` or `Space + l a` |
| Rename | `c d` or `Space + l r` |
| Document / project symbols | `g s` / `g S` (or `Space + s` / `S`) |
| Next / previous diagnostic | `] d` / `[ d` |

## Git (vim mode core)

| Action | Shortcut |
|--------|----------|
| Next / previous hunk | `] c` / `[ c` (vim) or `Space + h n` / `h N` |
| Expand diff hunk | `d o` |
| Toggle staged | `d O` |
| Restore change | `d p` |

## AI agent (Zed)

| Action | Shortcut |
|--------|----------|
| Toggle agent panel | `Space + a a` |
| New thread | `Space + a n` |
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
| `?` | Refocus editor |

## Discovery

| Action | Shortcut |
|--------|----------|
| Command palette | `Cmd + Shift + P` or `Space + v` / `Space + :` |
| Open keymap editor | `Cmd + K Cmd + S` |
| Show active key context | `dev: open key context view` (palette) |
| Open default keymap | `zed: open default keymap` (palette) |

## What's *not* ported from Neovim

These plugins live only in standalone Neovim — Zed has built-in or extension equivalents (or no equivalent yet):

| Neovim plugin | Zed status |
|---------------|------------|
| `fzf-lua` (files / grep / git pickers) | File finder + project search panel; granular fd/rg variants collapse to in-panel toggles. Telescope-like picker: shipping in next release. |
| `flash.nvim` (labelled jumps) | No equivalent today (vim core `f/t/F/T`, `/`, `*` only). |
| `which-key.nvim` | Native (Zed ≥ Dec 2025). No custom group descriptions yet. |
| `neo-tree` | Project panel (`Space + e`) — sidebar tree. `Space + o` / `-` for oil bulk edits. |
| `gitsigns` (hunks) | `Space + h*` bindings + `] c` / `[ c` vim mode. |
| `neogit` / `gitui` integration | Run `gu` (gitui) in terminal (`Space + t`). Neogit lives only in Neovim. |
| `surround.vim` / `nvim-surround` | Built into vim mode (`ys`, `cs`, `ds`). |
| `comment.nvim` | Built into vim mode (`gc` / `gcc`). |
| `trouble.nvim` | Diagnostics view (`Cmd + Shift + M`). |
| `avante.nvim` / `supermaven` | Zed Agent + Edit Predictions. |
| `obsidian.nvim` | No equivalent — keep Neovim for vault. |
| `undotree` | No equivalent. |
| `persistence.nvim` | Auto-restore last session (`restore_on_startup`). |

For a full keybindings comparison table, see [keymaps-hub.md](keymaps-hub.md).
