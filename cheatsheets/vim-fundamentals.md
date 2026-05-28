# Vim fundamentals — buffer / window / tab / ex commands

> **Help:** `:help` · `:help user-manual` · `:help {topic}`

> The 30 vim-native commands you need to stop forgetting when you come back from a VS Code / Cursor break.
> Pure vim (no custom keymaps): works everywhere — local, ssh, container, fresh nvim install.
> For Loïc's custom keymaps, see [keyboard-navigation.md](keyboard-navigation.md).

## Mental model

```
Vim
├── Tab page 1                  ← layout/workspace (rare; usually just 1)
│   ├── Window (split) A         ← container
│   │   └── Buffer X (file.ts)
│   └── Window (split) B
│       └── Buffer Y (other.ts)
└── Tab page 2
    └── Window C
        └── Buffer Z (notes.md)
```

- **Buffer** = a file loaded in memory. You can have 50, only one is visible per window.
- **Window** (or "split") = a container that displays a buffer. Multiple windows can show the same buffer.
- **Tab page** = a layout of windows. Think workspace, not VS Code tab.
- The bar at the top of your nvim (`bufferline.nvim`) shows **buffers**, not tabs — confusing convention.

## Save / quit

| Command | Action |
|---------|--------|
| `:w` | Write (save) current buffer |
| `:w filename` | Save current buffer as `filename` |
| `:wa` | Write all modified buffers |
| `:q` | Quit current window (fails if buffer modified) |
| `:q!` | Force quit, discard changes |
| `:wq` (or `:x`, `ZZ`) | Save + quit |
| `:qa` | Quit all windows (fails on modified) |
| `:qa!` | Force quit nvim entirely |
| `:wqa` | Save all + quit all |
| `<C-z>` | Suspend nvim (back to shell). Resume with `fg` |

## Buffers (files)

| Command | Action |
|---------|--------|
| `:e path/to/file` | Open file in current window (creates buffer) |
| `:ls` (or `:buffers`) | List all open buffers |
| `:bnext` (`:bn`) | Switch to next buffer |
| `:bprevious` (`:bp`) | Previous buffer |
| `:b <name>` | Jump to buffer by name (tab-completes) |
| `:b 3` | Jump to buffer number 3 |
| `:bd` | Delete (close) current buffer + window |
| `:bd 3` | Delete buffer 3 |
| `:bd!` | Force delete (discards changes) |
| `:%bd\|e#` | Close all buffers except current (common trick) |
| `<C-^>` (or `<C-6>`) | Toggle between last 2 buffers |

> Loïc's custom: `<leader>q` closes the buffer but **keeps the window/split** alive. Vim native `:bd` closes both.

## Windows (splits)

All under `<C-w>` prefix (W as Window):

### Create / close

| Command | Action |
|---------|--------|
| `:split` (`:sp`) | Horizontal split (duplicate current buffer) |
| `:vsplit` (`:vs`) | Vertical split |
| `:sp file.lua` | Split + open file |
| `:vs file.lua` | Vsplit + open file |
| `<C-w>s` | Horizontal split (mnemonic: Split) |
| `<C-w>v` | Vertical split (Vertical) |
| `<C-w>c` (or `:close`) | Close current window |
| `<C-w>o` (or `:only`) | Close all OTHER windows |
| `<C-w>q` | Quit window (like `:q`) |

### Navigate

| Command | Action |
|---------|--------|
| `<C-w>h/j/k/l` | Move to window left/down/up/right |
| `<C-w>w` | Cycle to next window |
| `<C-w>p` | Previous window (toggle) |
| `<C-w>t` | Top-left window |
| `<C-w>b` | Bottom-right window |

> Loïc's custom: `<C-Left/Down/Up/Right>` (Ctrl+arrows) via smart-splits. Same effect, easier on Kyria.

### Move / resize

| Command | Action |
|---------|--------|
| `<C-w>H/J/K/L` (Shift) | **Move** window to far left/bottom/top/right |
| `<C-w>r` | Rotate windows |
| `<C-w>x` | Swap with next window |
| `<C-w>=` | Equalize all window sizes |
| `<C-w>\|` | Maximize width (current window) |
| `<C-w>_` | Maximize height |
| `<C-w>>` `<C-w><` | Wider / narrower (by 1 column) |
| `<C-w>+` `<C-w>-` | Taller / shorter (by 1 row) |
| `10<C-w>>` | Wider by 10 columns (prefix with count) |
| `:resize 30` | Set window height to 30 |
| `:vertical resize 80` | Set window width to 80 |

> Loïc's custom: `<leader>z` = zoom toggle (saves layout, maximizes, restore on second press).

## Folds (dotfiles: treesitter)

Configured in `treesitter.lua`: folds appear automatically; new buffers start unfolded.

| Key | Action |
|-----|--------|
| `za` | Toggle fold at cursor |
| `zc` / `zo` | Close / open fold |
| `zM` / `zR` | Close all / open all folds |
| `zj` / `zk` | Move to next / previous fold |

## Tab pages (rare but useful)

Custom mappings (see `keymaps.lua`): `<leader>Tn` / `<leader>Tp` next/prev, `<leader>TN` new tab, `<leader>Tc` / `<leader>To` close. On LSP buffers, `gt` is type definition — use `<leader>Tn`/`Tp` for tabpages, not `gt`/`gT`.

| Command | Action |
|---------|--------|
| `:tabnew` | New empty tab |
| `:tabnew file.lua` | New tab with file |
| `:tabedit %` | Open current buffer in a new tab |
| `:tabclose` (`:tabc`) | Close current tab |
| `:tabonly` (`:tabo`) | Close all other tabs |
| `<leader>Tn` / `<leader>Tp` | Next / previous tab |
| `<leader>TN` | New tab (rare) |
| `1gt` / `2gt` / `3gt` | Go to tab N (1-indexed) |
| `:tabs` | List all tabs and their windows |
| `<C-w>T` | Move current window to a new tab |
| `:tabmove +1` | Move tab one position right |

> When to use tabs: separating **strongly different contexts** (prod code vs tests vs docs). Otherwise, splits are enough.

## Other ex commands worth knowing

| Command | Action |
|---------|--------|
| `:cd path/to/dir` | Change working directory (global) |
| `:lcd path` | Change cwd for current window only |
| `:pwd` | Show current working directory |
| `:!shell-command` | Run shell command (e.g. `:!ls -la`) |
| `:r filename` | Read file content under cursor |
| `:r !command` | Insert shell command output |
| `:source %` | Source the current file (reload nvim config on the fly) |
| `:noh` | Clear search highlight |
| `:reg` (or `:registers`) | Show all registers (clipboard, yanks, macros) |
| `<leader>vr` | Registers picker (fzf-lua, Enter = paste, Ctrl-x = clear) |
| `:marks` | Show all marks |
| `<leader>vm` | Marks picker (fzf-lua, Enter = jump, Ctrl-x = delete) |
| `<leader>uk` | Toggle keystroke log (`:NvimKeylogAnalyze`, `nvim-keylog-analyze`) |
| `:undolist` | Undo history |
| `:checkhealth` | Diagnose plugins / nvim setup |
| `:Lazy` | Open lazy.nvim plugin manager |
| `:messages` | Show recent messages (useful when something flashed) |
| `:%s/old/new/g` | Replace all in buffer (`%` = whole file, `g` = all on line) |
| `:5,10s/old/new/g` | Replace in lines 5-10 only |
| `:g/pattern/d` | Delete all lines matching pattern |
| `:v/pattern/d` | Delete all lines NOT matching pattern |

## Common confusion traps

**"My buffer is gone but the file is there"** — `:bd` closed the buffer (in-memory state); the file on disk is untouched. Just `:e file` to reopen.

**"I have 20 'tabs' open in bufferline"** — those are **buffers**, not tabs. Use `:bd` or `<leader>q` to close them. `:tabs` will show you actually have 1 tab.

**"I split, now I can't get out"** — `<C-w>` then `h/j/k/l` to navigate, or `<C-w>w` to cycle. `<C-w>c` to close the split.

**"I want VS Code's `Cmd+W` to close tab"** — in vim that's `<leader>q` (you) or `:bd` (vim native). Habit: in vim, "close" usually means buffer not tab.

**"How do I know what buffer I'm in?"** — `:ls` lists them with markers: `%` = current, `#` = alternate (last visited), `+` = modified, `a` = active in a window, `h` = hidden.

## Practice routine (5 min/day, ADHD-friendly)

1. **Open** `nvim` in a project. Look at the alpha dashboard footer — there's a random tip. Try to use it in this session.
2. **`:ls`** to see your buffers. Read the markers.
3. Open 3 files: `:e file1`, `:e file2`, `:e file3`. Switch between them with `:bn`, `:bp`, `<C-^>`.
4. `<C-w>v` to vsplit. Move it around with `<C-w>HL`. Close with `<C-w>c`.
5. `:tabnew`, then `gt` back to tab 1, then `:tabc` to close.

That's it. Do that for a week and you'll never forget again.

## See also

- [keyboard-navigation.md](keyboard-navigation.md) — all your custom keymaps on top of these vim natives.
- `:help windows`, `:help tabpage`, `:help buffers` — the canonical reference inside nvim itself.
- `<leader>aa` (avante ask) — Claude/Cursor in a sidebar when you forget something specific.

## Links

- Repo: https://github.com/neovim/neovim
- Help: `:help user-manual` inside Neovim
