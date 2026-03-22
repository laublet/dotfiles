# Keyboard Navigation — Unified Cheatsheet

Full shortcut map across the stack. Modifier escalation architecture:

```
Ctrl              → in-app navigation (zone nav, pane nav)
Ctrl + Shift      → in-app split navigation (editor groups, terminal panes)
Ctrl + Alt        → in-app resize (WezTerm/Neovim/Cursor move groups)
Cmd + Shift       → tab switching (all apps)
Cmd + Alt         → AeroSpace workspaces / tab reorder
Ctrl + Cmd + Alt  → AeroSpace focus / layout (LCAG)
LCAG + Shift      → AeroSpace move / resize (HYPR)
```

## AeroSpace (window manager)

| Shortcut | Action |
|---|---|
| LCAG + arrows | Focus window (wrap-around) |
| HYPR + arrows | Move window |
| HYPR + -/= | Resize ±50 |
| LCAG + E | Toggle tiles layout |
| LCAG + T | Toggle floating/tiling |
| LCAG + F | Fullscreen |
| LCAG + Enter | New WezTerm window |
| Cmd+Alt + Left/Right | Prev/next workspace |
| Cmd+Alt + 0-9 | Go to workspace |
| Cmd+Alt+Shift + 0-9 | Move window to workspace |
| Cmd+Alt + Up/Down | Focus monitor prev/next |
| Cmd+Alt+Shift + Up/Down | Move window to monitor |
| HYPR + ; | Enter service mode |

Service mode: `Esc` reload + exit, `R` flatten, `E` tiles, `=` balance, `L` re-apply dev layout.

## WezTerm

| Shortcut | Action |
|---|---|
| Ctrl + arrows | Navigate panes (smart-splits, crosses into Neovim) |
| Ctrl + Alt + arrows | Resize panes |
| Cmd + D | Split horizontal |
| Cmd + Shift + D | Split vertical |
| Cmd + W | Close pane |
| Cmd + Z | Zoom pane |
| Cmd + Shift + Left/Right | Prev/next tab |
| Cmd + T | New tab |
| Cmd + 1-9 | Go to tab |

## Cursor IDE

### Spatial model

```
[Sidebar] ←Ctrl+Left— [Editor] —Ctrl+Right→ [AI Chat]
                          ↕ Ctrl+Down / Ctrl+Up
                       [Terminal]
```

### Zone navigation (Ctrl + arrows)

| Shortcut | Action |
|---|---|
| Ctrl + Left | Editor → sidebar |
| Ctrl + Right | Editor → AI chat |
| Ctrl + Down | Editor → terminal |
| Ctrl + Up | Terminal → editor |
| Ctrl + Right | Sidebar → editor |
| Escape | Any zone → editor |

Note: Ctrl+Left from chat does NOT work (webview limitation). Use Escape.

### Split navigation (Ctrl + Shift + arrows)

| Shortcut | Action |
|---|---|
| Ctrl+Shift + Left/Right/Up/Down | Focus adjacent editor group |

### Terminal management (when terminal focused)

| Shortcut | Action |
|---|---|
| Cmd + D | Split terminal |
| Cmd + T | New terminal |
| Cmd + W | Kill terminal |
| Ctrl+Shift + Left/Right | Navigate split terminal panes |
| Cmd+Shift + Left/Right | Switch terminal instances |

### Tabs

| Shortcut | Action |
|---|---|
| Cmd+Shift + Left/Right | Prev/next editor tab |
| Cmd+Alt + Left/Right | Reorder tab |
| Ctrl+Alt + arrows | Move editor group |

### Editor splits

| Shortcut | Action |
|---|---|
| Cmd + D | Split editor right |
| Cmd + Shift + D | Split editor down |

### Leader layer (Space + key, normal mode via vscode-neovim)

| Key | Action |
|---|---|
| Space + E | Toggle explorer sidebar |
| Space + F | Quick open file |
| Space + G | Find in files |
| Space + T | Toggle terminal |
| Space + V | Git (SCM) |
| Space + C | AI chat |
| Space + D | Debugger |
| Space + B | Buffers (MRU) |
| Space + W | Save file |
| Space + Q | Close editor |
| Space + Z | Zen mode |

### AI accept/reject

| Shortcut | Action |
|---|---|
| Cmd + Enter | Accept inline chat (Cmd+K) |
| Cmd+Shift + Enter | Accept diff / approve tool call |
| Cmd+Shift + Backspace | Reject diff / cancel tool call |
| Cmd+Ctrl + Enter | Accept ALL AI-edited files |
| Cmd+Ctrl + Backspace | Reject ALL AI-edited files |

## Neovim (standalone)

### Leader layer (Space + key)

| Key | Action |
|---|---|
| Space + F | Fuzzy find files (fzf-lua) |
| Space + G | Live grep |
| Space + B | Buffers |
| Space + E | Toggle Neo-tree |
| Space + W | Save |
| Space + Q | Close buffer |
| Space + T | Toggle floating terminal |
| Space + Z | Zoom toggle (maximize split) |
| Space + \| | Vertical split |
| Space + - | Horizontal split |
| Space + X | Close split |
| Space + LG | Lazygit |

### Obsidian (Space + O, in markdown files)

| Key | Action |
|---|---|
| Space + OF | Find note (ObsidianQuickSwitch) |
| Space + OD | Daily note |
| Space + ON | New note |
| Space + OB | Backlinks |
| Space + OS | Search text in vault |
| Space + OT | Tags |
| Space + OL | Links in current note |
| Space + OM | Toggle render-markdown |
| Space + OP | Preview with glow (popup) |
| gd | Follow [[wiki-link]] |

### LSP

| Key | Action |
|---|---|
| gd | Go to definition |
| gi | Go to implementation |
| gr | Go to references |
| gh | Show hover |
| Shift + H / L | Prev/next buffer |

### Splits

| Shortcut | Action |
|---|---|
| Ctrl + arrows | Navigate panes (smart-splits, crosses into WezTerm) |
| Ctrl + Alt + arrows | Resize panes |

## Obsidian

### Hotkeys (native)

| Shortcut | Action |
|---|---|
| Ctrl + arrows | Navigate between panes |
| Cmd + D / Cmd+Shift+D | Split vertical / horizontal |
| Cmd + W | Close tab |
| Cmd + T | New note |
| Cmd+Shift + Left/Right | Prev/next tab |
| Cmd + E | Toggle left sidebar |
| Cmd+Shift + E | Toggle right sidebar |
| Cmd + P | Quick switcher |
| Cmd+Shift + P | Command palette |
| Cmd+Shift + F | Global search |
| Cmd+Shift + N | New note from template |

### Vim mode (Space leader, via obsidian-vimrc)

| Key | Action |
|---|---|
| Space + F | Quick switcher |
| Space + G | Global search |
| Space + W | Save |
| Space + Q | Close |
| Space + E | Toggle left sidebar |
| Space + Shift+E | Toggle right sidebar |
| Space + R | Reveal in explorer |
| Space + D | Daily note |
| Space + ]/[ | Next/prev daily |
| Space + P | Command palette |
| Space + V | Toggle preview |
| Space + G | Graph view |
| Space + 1/2/3 | Set heading H1/H2/H3 |
| Space + X | Toggle checklist |
| Ctrl+O / Ctrl+I | Back / forward |
| gd | Follow link |
| za / zM / zR | Toggle fold / fold all / unfold all |

## Tridactyl (Firefox)

| Key | Action |
|---|---|
| j / k | Scroll down / up |
| J / K | Prev / next tab |
| gJ / gK | Move tab left / right |
| f / F | Hint links / hint in new tab |
| d / u | Close tab / undo close |
| H / L | Back / forward |
| gg / G | Top / bottom of page |
| gi | Focus first input |
| Ctrl+[ | Escape to normal mode |
| go + key | Open quickmark (g=GitHub, m=Gmail, t=Todoist, o=Obsidian) |
| gn + key | Quickmark in new tab |
| ;o | Obsidian Web Clipper |
| :open gh query | Search GitHub |
| :open mdn query | Search MDN |

Hint chars: `asdfghjkl` (home row only).

## Mouseless

| Trigger | Ctrl + Alt + M |
|---|---|

Once overlay active:

| Key | Action |
|---|---|
| Grid keys (QWERTY layout) | Select cell |
| Space | Left click |
| R | Right click |
| E | Middle click |
| Arrows | Move cursor |
| Hold A (Ctrl) | Slow down |
| Hold F (Shift) | Speed up |
| Hold D (Cmd) | Drag |
| Hold S (Alt) | Move mode |
| M / , / . / / | Scroll up/down/left/right |
| Escape | Close overlay |

Subgrid nudge: ESDF (left hand, WASD-like), HJKL (right hand, vim-like).

## Terminal aliases (zsh)

| Alias | Action |
|---|---|
| `c` | Open Cursor in current dir |
| `ff <url>` | Open Firefox Developer Edition |
| `v` | Neovim |
| `lg` | Lazygit |
| `lzd` | Lazydocker |
| `y` | Yazi (cd on exit) |
| `on <name>` | Open Obsidian note by name |
| `od` | Open today's daily note |
| `os` | Fuzzy search vault (fzf) |
| `oq "text"` | Quick capture to daily note |
| `oe` | Open vault in Neovim |
| `cheat` | Browse cheatsheets (fzf) |

## Kyria layers (quick reference)

| Layer | Activation | Content |
|---|---|---|
| 0 ALPHA | Default | QWERTY + home-row mods (CAGS) |
| 1 NAV | Hold Space | Arrows, Home/End/PgUp/PgDn, explicit mods, LCAG/HYPR |
| 2 NUMPAD | Hold Esc | Right-hand numpad |
| 3 SYM_L | Hold ; (right) | Brackets, parens, braces, symbols (left hand) |
| 4 SYM_R | Hold R (left) | Operators, comparators, symbols (right hand) |
| 5 MOUSE | Toggle | Mouse keys, scroll wheel |
| 6 MEDIA | Toggle | Media controls, F-keys |
| 7 GAMING | Toggle | No home-row mods |

Home-row mods (CAGS): A=Ctrl, S=Alt, D=Gui, F=Shift / J=Shift, K=Gui, L=Alt, ;=Ctrl.
