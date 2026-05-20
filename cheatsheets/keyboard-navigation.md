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

## System (macOS / Linux)

| Shortcut | Action |
|---|---|
| Ctrl + Cmd + Alt + I | Switch input source (language) |
| Ctrl + Cmd + Alt + M | Mouseless: show overlay |
| Ctrl + Cmd + Alt + V | Mouseless: execute mouse move (uppercase V) |
| Ctrl + Cmd + Alt + Z | Mouseless: toggle free mode (free cursor without grid) |
| Cmd + Alt + J / K | Mouseless: move overlay between monitors (overlay visible; not LCAG) |

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

Full cheatsheet (panes, tabs, copy mode, workspaces, resurrect, config) : [wezterm.md](wezterm.md).

| Shortcut | Action |
|---|---|
| Ctrl + arrows | Navigate panes (smart-splits, crosses into Neovim) |
| Ctrl + Alt + arrows | Resize panes |
| Ctrl + Alt + Shift + arrows | Swap with neighbor in that direction (2 panes: rotate; 3+: picker) |
| Cmd + D | Split horizontal |
| Cmd + Shift + D | Split vertical |
| Cmd + W | Close pane |
| Cmd + Shift + Z | Zoom pane (Cmd+Z stays free for undo) |
| Cmd + Shift + X | Rotate panes (2 = swap; 3+ = cycle order) |
| Cmd + Shift + Left/Right | Prev/next tab |
| Cmd + Shift + Ctrl + Left/Right | **Move** active tab left/right (intercalate between two tabs) |
| Cmd + Shift + , | Rename current tab (empty input = reset, persisted via resurrect) |
| Cmd + Up/Down | Scroll to previous/next prompt in scrollback (OSC 133 markers from zsh) |
| Cmd + Shift + Up | Fast copy of the latest command output (status bar flashes purple to confirm) |
| Ctrl + Shift + O | fzf picker on all outputs of this pane (preview with bat, Enter copies, Esc cancels — opens as a split pane, auto-closes) |
| Cmd + Ctrl + Space | CharSelect — fuzzy Unicode / Nerd Font / emoji picker (matches macOS system shortcut) |
| Cmd + Shift + ; | Launch menu picker (btop, gitui, lazydocker, bandwhich, nettop, mac-startup-clean) |
| Cmd + click on `file.ts:42:10` | Open path at line/column in Cursor (works in any compiler/linter output) |
| `printf '\a'` after a command | macOS toast notification (audible bell disabled, subtle cursor flash) |
| Ctrl + Shift + R / Cmd + R | Reload WezTerm config (defaults) |
| Cmd + Shift + S / O | Resurrect: save session / restore session (fuzzy) |
| Cmd + Shift + Ctrl + D | Resurrect: delete one saved state (fuzzy) |
| Cmd + Shift + Ctrl + X | Resurrect: wipe all saved states (type `DELETE`) |
| Cmd + Shift + L | Switch workspace (fuzzy launcher, lists existing) |
| Cmd + Shift + N | New/switch workspace by name (prompt) |
| Cmd + Shift + F | QuickSelect (URLs, paths, hashes, words 3+) |
| Cmd + Alt + Space | Enter copy mode (vim-like) |
| Cmd + Backspace | Sends Ctrl+U (kill line backward in zsh / vim insert) |
| Cmd + T | New tab |
| Cmd + 1-9 | Go to tab |

Scrollback search: **Cmd+F** (overlay, bottom bar — Ctrl+Shift+C copy per WezTerm docs). **Copy mode** (Cmd+Alt+Space) then **`/`** or **`?`** to start a pattern; **Enter** accepts and auto-selects the current match (press **`y`** to copy immediately). Navigate matches with **`n`** / **`Shift+n`** (vim-style; `Ctrl+n`/`Ctrl+p` and arrows also work). **`Esc`** clears the pattern + closes — important: wezterm retriggers search on every terminal redraw, so a leftover pattern would periodically yank the cursor back to the first match.

Tab title: shows `<index>: <title>`. When an AI agent CLI (cursor-agent, claude, aider, codex) runs in the active pane, its status glyph (`⏳`, `✅`, `🧭`, `🔐`, `🔄`, spinner braille) is prefixed automatically and disappears when the agent exits.

### iTerm2 (same ⌘⌫ behavior)

Settings → Profiles → Keys → **+** → Shortcut **⌘⌫** → Action **Send Hex Code** `0x15` (same as Ctrl+U).

## Cursor IDE

### Chat / Composer input

| Shortcut | Action |
|---|---|
| Shift + Enter | New line in the chat or Composer prompt (does not send) |
| Enter | Send the message |

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

Quick reference (Mason, debug, tests, troubleshooting): [neovim-ide.md](neovim-ide.md).

### Leader layer (Space + key)

**Builtin Vim prefixes (`g`, `z`, `[`, `]`, `"`, `'`, …):** type the key in normal mode and pause — which-key shows the preset popup. **Space + V** opens a **complete Vim command reference** (a-z, A-Z, symbols) with short descriptions; selecting opens the which-key popup if sub-commands exist.

| Key | Action |
|---|---|
| Ctrl+P | Quick open files (same as Space + PP) (fzf-lua) |
| Space + PP | Find files — default (fzf-lua) |
| Space + PH, PI, PD, PF, PG | Find variants: hidden, no ignore, dirs, files only, glob (`fd.md`) |
| Space + FF | Live grep project (fzf-lua) |
| Space + F + second key | More grep modes: I/W/H/N/glob/resume/fixed (`ripgrep.md`; `fF` = fixed string) |
| Space + F / | Search in buffer (fzf-lua) |
| Space + g + g | Neogit (status, magit-style — in-editor git) |
| Space + g + C / p / P / l / v / V / x | Neogit commit / push / pull / log ; Diffview open / file history / close |
| Space + G + S/C/B/F | Git pickers (fzf-lua): status / commits / branches / tracked files |
| Space + H + n / N | Next / previous hunk |
| Space + H + p/s/r/u | Hunk preview / stage / reset / undo stage |
| Space + H + S / R | Hunk stage/reset for whole buffer |
| Space + H + b / B | Hunk blame line / full blame |
| Space + H + d | Hunk diff this |
| Space + n + h | Clear search highlight (`:noh`) |
| Space + H | Cheatsheets folder (fzf-lua) |
| Space + B | Buffers |
| Space + e | Toggle Neo-tree (sidebar; lazy-loaded on first use) |
| Space + E | Reveal current file in Neo-tree |

> Neo-tree does not auto-open on startup. If it reappears after `nvim`, `persistence` restored a saved session — close it once, then `<leader>qd` before quit to drop that layout from the session.
| (in tree) `zR` / `zM` | Expand / close ALL nodes (vim-fold mnemonic) |
| (in tree) `zr` / `zm` | Expand / close subtree under cursor |
| (in tree) `zo` / `zc` | Toggle / close node under cursor |
| (in tree) `Shift+Right` / `Shift+Left` | Single-key alternative to `zR`/`zM` (no timeout) |
| (in tree) `+` / `=` | Single-key alternative to `zr`/`zm` |

> Note : à l'intérieur du buffer Neo-tree, `timeoutlen` est bumpé à 600ms (vs 300ms global) pour laisser le temps de taper les séquences `zX` sur clavier layered.
| Space + O | Oil floating (manipulation fs: rename, create, move, then `:w`) |
| `-` | Oil parent dir (vinegar style) |
| Space + w | Save (manual; autosave also writes on focus/buffer change) |
| Space + q | Close buffer (keep window/split) |
| Space + Q | Close buffer + force (closes window too) |
| Space + t | Toggle floating terminal (modal) |
| Space + ; | Toggle bottom split terminal (persistent, side-by-side with code) |
| `Ctrl + q` | **Close** any active terminal (float / bottom / cursor-agent) — works from inside or outside |
| `Esc Esc` | Exit terminal-insert mode without closing (then scroll, copy, `:q`, …) |
| Space + z | Zoom toggle (maximize split — use on the tree to read long paths) |
| Space + a + c | **cursor-agent** CLI in a vsplit on the right (toggle; raw TUI) |
| Space + a + a | Ask AI (avante → cursor-agent via ACP, Claude as fallback) |
| Space + a + t | Toggle Avante sidebar |
| Space + a + f | **Focus** Avante sidebar (more reliable than smart-splits arrows on multi-pane layouts) |
| Space + a + r | Refresh Avante |
| Space + a + n | New ask (clear conversation) |
| Space + a + m | Switch ACP mode (agent / plan / ask) |
| Space + a + ? | Switch provider/model |
| Space + u | Undo tree (Undotree, opens on the RIGHT — layout 3 to avoid clashing with Neo-tree sidebar) |
| Space + Ur | Refocus float UI (fzf, which-key, …) — normal/terminal only; **Shift+u**, then `r` |
| Space + Ux | Close all floating windows — normal/terminal only; **Shift+u**, then `x` |
| Alt + Esc (insert) | Close all floating windows — no leader (avoids Space timeout in insert) |
| Space + \| | Vertical split |
| Space + - | Horizontal split |
| Space + X | Close split |
| Space + T + n / p | Tabpage next / previous (Diffview, etc.) |
| Space + T + N | New tabpage (rare) |
| Space + T + c / o | Close tabpage / close other tabpages |
| Space + L + G | Toggle LTeX grammar (buffer) |
| Space + L + F | Format buffer (conform) |
| Space + L + I | Toggle inlay hints (LSP) |
| Space + u + d / D | Diagnostics workspace / buffer (Trouble) |
| Space + V + key | Vim command reference — all commands a-z, A-Z, symbols with descriptions |

### Debug (nvim-dap, Node/TS)

| Key | Action |
|---|---|
| F5 | Continue / launch |
| F10 / F11 / F12 | Step over / into / out |
| Space + d + b | Toggle breakpoint |
| Space + d + c | Continue |
| Space + d + u | Toggle dap-ui |
| Space + d + r | REPL |
| Space + d + t | Terminate session |

Mason: `:MasonInstall js-debug-adapter`. Optional: `.vscode/launch.json` loaded automatically.

### Tests (neotest — Jest or Vitest per repo)

| Key | Action |
|---|---|
| Space + c + t | Run nearest test |
| Space + c + f | Run file |
| Space + c + S | Run suite (cwd) |
| Space + c + w | Toggle watch |
| Space + c + o | Output |
| Space + c + n / N | Next / prev failure |
| Space + c + y | Summary |

### AI — who does what (avoid overlap)

| Layer | Tool | Role |
|---|---|---|
| Agent / chat | Avante (`Space + a*`) | Sidebar, cursor-agent via ACP — not inline completion |
| Inline ghost | Supermaven | Code buffers only; off markdown, Avante, neo-tree, oil |
| Completion menu | nvim-cmp + LSP + LuaSnip | Tab accepts Supermaven ghost first, else cmp/snippet |
| Lint (TS/JS) | eslint LSP + ts_ls | Mason: `eslint-lsp` |
| Debug (TS/JS) | nvim-dap + js-debug-adapter | Mason: `js-debug-adapter` |
| Tests | neotest (jest + vitest) | `Space + c + t` nearest |

### Notes — Obsidian + Markdown (Space + n, in markdown files)

| Key | Action |
|---|---|
| Space + nf | Find note (ObsidianQuickSwitch) |
| Space + nd | Daily note |
| Space + nn | New note |
| Space + nb | Backlinks |
| Space + ns | Search text in vault |
| Space + nt | Tags |
| Space + nl | Links in current note |
| Space + nm | Toggle render-markdown |
| Space + np | Preview with glow (popup) |
| gd | Follow [[wiki-link]] |

### LSP

| Key | Action |
|---|---|
| gd | Go to definition |
| gi | Go to implementation |
| gr | Go to references |
| gt | Go to type definition (not tab next — use Space + T + n/p for tabpages) |
| gh | Show hover |
| Leader + l + a | Code action (LSP / LTeX fixes) — not Leader + a (Avante) |
| Ctrl + Tab / Ctrl + Shift + Tab | Prev/next buffer |
| Ctrl + PageDown / Ctrl + PageUp | Prev/next buffer (terminal fallback) |

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
| Cmd+Shift + E | Focus Notebook Navigator |
| Cmd+Shift + R | Toggle right sidebar |
| Cmd + P | Quick switcher |
| Cmd+Shift + P | Command palette (also for sidebar views) |
| Cmd+Shift + N | New note from template |
| Ctrl+Shift + Left | Reveal active file in Notebook Navigator |

### Notebook Navigator (arrows navigation)

| Shortcut | Action |
|---|---|
| Up / Down | Move selection |
| Left / Right | Collapse/expand folder, switch panes |
| Enter | Open selected note |
| Tab / Shift+Tab | Switch between navigation and list panes |
| Shift + arrows | Extend selection |

### Vim mode (Space leader, via obsidian-vimrc)

| Key | Action |
|---|---|
| Space + F | Quick switcher |
| Space + G | Global search |
| Space + W | Save |
| Space + Q | Close |
| Space + e | Toggle left sidebar |
| Space + E | Focus Notebook Navigator |
| Space + r | Toggle right sidebar |
| Space + R | Reveal in Notebook Navigator |
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

Task-oriented detail: [tridactyl.md](tridactyl.md).

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

**LCAG** (`Ctrl+Cmd+Alt+…`) for overlay, execute move, free mode; **`Cmd+Alt+J/K`** for moving the overlay between monitors (those are **not** LCAG). Full table: [conf/mac-apps/README.md § Mouseless](../conf/mac-apps/README.md#mouseless).

| Shortcut | Action |
|---|---|
| Ctrl + Cmd + Alt + M | Show overlay (`m` lowercase in config; if a letter hotkey ever misbehaves, try uppercase per Mouseless docs) |
| Ctrl + Cmd + Alt + V | Execute mouse move |
| Ctrl + Cmd + Alt + Z | Toggle free mode (cursor + scroll without grid) |
| Cmd + Alt + J / K | Move overlay prev / next monitor (only while overlay is up) |

If nothing happens: app must be running (menu bar), Accessibility enabled for Mouseless + app restarted, then see [conf/mac-apps/README.md § Mouseless](../conf/mac-apps/README.md#mouseless) (Secure Input, conflicts, debug).

Once overlay active:

| Key | Action |
|---|---|
| Grid keys (QWERTY layout) | Select cell |
| Space | Left click |
| R | Right click |
| E | Middle click |
| Arrows | Move cursor |
| Hold Ctrl (left) | Slow down |
| Hold Shift (left) | Speed up |
| Hold Cmd (left) | Drag |
| Hold Option (left) | Move mode (hold for move) |
| M / , / . / / | Scroll up/down/left/right |
| Escape | Close overlay |

Subgrid nudge: ESDF (left hand, WASD-like), HJKL (right hand, vim-like).

## Terminal aliases (zsh)

| Alias | Action |
|---|---|
| `c` | Open Cursor in current dir |
| `ff <url>` | Open Firefox Developer Edition |
| `v` | Neovim |
| `gu` | gitui (standalone git TUI) |
| `lzd` | Lazydocker |
| `y` | Yazi (cd on exit) |
| `on <name>` | Open Obsidian note by name |
| `od` | Open today's daily note |
| `os` | Fuzzy search vault (fzf) |
| `oq "text"` | Quick capture to daily note |
| `oe` | Open vault in Neovim |
| `cheat` | Browse cheatsheets (fzf) |

## Kyria layers (quick reference)

Full reference (every layer table, combo, OSM, arcane, debug workflow) lives in **[kyria.md](kyria.md)**. Quick map:

| # | Layer | Activation | Content |
|---|---|---|---|
| 0 | ALPHA | Default | QWERTY + home-row mods (CAGS) |
| 1 | NAV_L | Hold **left Space** | Arrows on left (SDFG), HOME/END/PG, undo/cut/copy/paste, OSMs + combined mods on right |
| 2 | NAV_R | Hold **right Space** | Arrows on right (HJKL), HOME/END/PG, OSMs + combined mods on left |
| 3 | NUMPAD | Hold **Esc** (L thumb) | Right-hand numpad, `0` on right thumb |
| 4 | SYM_L | Hold **`:`** (R thumb) | Brackets, parens, braces, left-hand symbols |
| 5 | SYM_R | Hold **R** (L thumb) | Operators, comparators, right-hand symbols |
| 6 | MOUSE | TT (R pinky bottom) | Mouse keys + scroll wheel |
| 7 | MEDIA | TT (L pinky home) | Media controls + F-keys (TD on F1/F2) |
| 8 | GAMING | TT (L pinky bottom) | No home-row mods |
| 9 | SETTINGS | TT (L pinky top) | RGB, backlight, EE_CLR |

Home-row mods (CAGS): A=Ctrl, S=Alt, D=Gui, F=Shift / J=Shift, K=Gui, L=Alt, `;`=Ctrl. Uniform 200ms tap term, 80ms flow tap. Opposite-hand `CHORDAL_HOLD`.

Key combos: **D+F** / **J+K** = Enter, **Space+Space** = toggle NAV_R, **Z+/** = PANIC (clear all mods/layers), **Q+P** = MARK debug separator to `qmk console`.

Capitalization: both shifts = **Caps Word** (1 word, auto-end), hold NAV + tap Arcane = **one-shot Shift**, OSM Shift ×5 = lock, MEDIA layer `KC_CAPS` = OS CapsLock.

Arcane keys (inner-bottom): on ALPHA same-hand = repeat, cross-hand = magic (alt-repeat); on NAV any side = one-shot Shift.

Special bindings: **Shift+Backspace** = Delete, **Shift+Esc** = `~`, **GUI+Esc** = `` ` ``.
