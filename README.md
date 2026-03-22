# Dotfiles

Keyboard-centric development environment, unified across macOS and Linux.

## Quick start

```bash
# Fresh machine (installs packages + links dotfiles)
just bootstrap         # or: ./bootstrap

# Re-link dotfiles only (after config changes)
just link              # or: ./install

# Minimal server setup (vim, zsh, nvim, git, tmux)
just server            # or: ./install-server

# List all available tasks
just
```

## Architecture

### Apps

| Layer | macOS | Linux (Pop!_OS) |
|-------|-------|-----------------|
| Window manager | AeroSpace | Pop Shell (GNOME) |
| Terminal | WezTerm | WezTerm |
| Editor (IDE) | Cursor (vscode-neovim) | Cursor (vscode-neovim) |
| Editor (standalone) | Neovim | Neovim |
| Editor (server) | Vim (minimal) | Vim (minimal) |
| Multiplexer (server) | Zellij | Zellij |
| Email | Thunderbird (tbkeys-lite) | Thunderbird (tbkeys-lite) |
| Notes | Obsidian (vim mode) | Obsidian (vim mode) |
| Shell | zsh + Prezto + Starship | zsh + Prezto + Starship |
| Theme | Dracula everywhere | Dracula everywhere |
| Font | FiraCode Nerd Font | FiraCode Nerd Font |

### Modifier keys

On Linux, **keyd** makes the three modifiers behave like macOS:

```
Super + key     → Ctrl+key  (Cmd: copy, save, undo, tab switch…)
Super + arrows  → Home/End  (Cmd+arrows: beginning/end of line)
Super + Tab     → Alt+Tab   (Cmd+Tab: app switching)
Super + Space   → real Super (Cmd+Space: GNOME launcher)
Alt + arrows    → word nav  (Option+arrows: handled per-app)
Ctrl            → Ctrl      (split navigation, unchanged)
```

Alt+arrows word navigation is handled per-app (not in keyd) to
avoid conflicts with Ctrl+arrows split navigation:
Cursor (keybindings.json `isLinux`), zsh (bindkey), WezTerm.

### Keybinding layers

All apps share the same navigation model. Physical keys are identical
on both platforms — keyd handles the translation on Linux.

```
┌─────────────────────────────────────────────────────────────┐
│ GLOBAL (window manager)                                     │
│                                                             │
│   macOS                       Linux                          │
│   Ctrl+Cmd+Alt + arrows       Ctrl+Alt + arrows    → focus   │
│   Ctrl+Cmd+Alt+Shift + arr.   Ctrl+Alt+Shift + arr.→ move    │
│   Cmd+Alt + number             Ctrl+Alt + number   → workspace│
│   Cmd+Alt+Shift + number       Ctrl+Alt+Shift+num  → move ws │
├─────────────────────────────────────────────────────────────┤
│ IN-APP (WezTerm / Neovim / Cursor)                          │
│                                                             │
│   Ctrl + arrows           → navigate between splits/panes   │
│   Ctrl+Alt + arrows       → resize / move editor groups     │
│   Cmd+d / Cmd+Shift+d     → create split (horiz / vert)      │
│   Cmd+Shift + ←/→         → prev / next tab                 │
│   Cmd+Shift + Space       → copy mode (WezTerm)             │
│   Space + key             → leader layer (files, LSP, etc.) │
├─────────────────────────────────────────────────────────────┤
│ TEXT EDITING (preserved on both platforms)                   │
│                                                             │
│   Option + ←/→            → jump word                       │
│   Option + Shift + ←/→    → select word                     │
│   Cmd + ←/→               → beginning / end of line         │
└─────────────────────────────────────────────────────────────┘
```

### CLI tools

| Tool | Replaces | Usage |
|------|----------|-------|
| atuin | `Ctrl+R` | Searchable shell history with context (dir, exit code, duration) |
| bat | cat | Syntax-highlighted file viewer |
| bottom | htop | Lightweight system monitor, vim keys (`btm`) |
| btop | htop | Beautiful system dashboard, vim keys (`btop`) |
| dust | du | Intuitive disk usage viewer with tree |
| eza | ls | `ll`, `lt` aliases |
| fd | find | Used by fzf |
| fzf | — | Fuzzy finder (`Ctrl+T`, `Ctrl+F`) |
| just | make | Task runner (`just` in dotfiles, see `justfile`) |
| ouch | tar/zip/gzip | Universal compress/decompress (`ouch c`, `ouch d`) |
| procs | ps | Modern process viewer with color and tree |
| ripgrep | grep | `rg`, `rgf`, `rgv`, `rgt`, `rgc` functions |
| sd | sed | Intuitive find & replace (`sd 'from' 'to' file`) |
| tokei | cloc | Fast code line counter by language |
| zoxide | cd | `z` for smart directory jumping |
| yazi | ranger/vifm | Terminal file manager, vi keys (`y`) |
| delta | — | Git diff viewer (side-by-side, Dracula theme) |
| lazygit | — | TUI git client (`lg`) |
| lazydocker | — | TUI Docker client (`lzd`) |
| starship | — | Prompt with vi-mode indicator |
| mise | fnm/direnv/asdf | Runtime versions + env vars + tasks (auto-install) |
| zellij | tmux | Terminal multiplexer for servers (`Ctrl+a` prefix) |
| tldr (tlrc) | man | Community-maintained command cheatsheets |

### Documentation

Each CLI tool has a personal cheatsheet in `cheatsheets/` documenting
aliases, keybindings, and how tools are wired together. Three ways to access:

| Context | Command | What it does |
|---------|---------|-------------|
| Neovim | `Space H` | fzf-lua picker with markdown preview |
| Terminal | `cheat` | fzf + bat preview, opens in pager |
| Obsidian | symlink folder | native search and backlinks |

For generic reference, `tldr <tool>` shows community-maintained summaries,
`man <tool>` or `<tool> --help` for full documentation.

## Keybinding cheatsheet

### Splits (unified across all apps)

| Action | WezTerm | Neovim | Cursor |
|--------|---------|--------|--------|
| Navigate splits | `Ctrl+arrows` | `Ctrl+arrows` | `Ctrl+arrows` |
| Resize splits | `Ctrl+Alt+arrows` | `Ctrl+Alt+arrows` | `Ctrl+Alt+arrows` |
| Create horizontal | `Cmd+d` | `Space -` | `Cmd+d` |
| Create vertical | `Cmd+Shift+d` | `Space \|` | `Cmd+Shift+d` |
| Close split | `Cmd+w` | `Space x` | `Cmd+w` |
| Zoom split | `Cmd+z` | `Space z` | — |

### Tabs / Buffers

| Action | WezTerm | Neovim | Cursor |
|--------|---------|--------|--------|
| Prev tab/buffer | `Cmd+Shift+Left` | `Shift+H` | `Cmd+Shift+Left` |
| Next tab/buffer | `Cmd+Shift+Right` | `Shift+L` | `Cmd+Shift+Right` |
| New tab | `Cmd+t` | — | `Cmd+t` |
| Close tab/buffer | `Cmd+w` | `Space q` | `Cmd+w` |

### Neovim leader layer (Space + key)

| Key | Action | Plugin |
|-----|--------|--------|
| `f` | Find file | fzf-lua |
| `g` | Live grep | fzf-lua |
| `b` | Buffers | fzf-lua |
| `o` | Recent files | fzf-lua |
| `/` | Search in buffer | fzf-lua |
| `s` | Document symbols | fzf-lua |
| `e` | Toggle file tree | neo-tree |
| `E` | Reveal in tree | neo-tree |
| `d` | Diagnostics (workspace) | trouble |
| `D` | Diagnostics (buffer) | trouble |
| `r` | Rename symbol | LSP |
| `a` | Code action | LSP |
| `lf` | Format buffer | conform |
| `t` | Floating terminal | — |
| `lg` | Lazygit | — |
| `w` | Save | — |
| `q` | Close buffer | — |
| `z` | Zoom toggle | — |
| `?` | Keymaps cheatsheet | fzf-lua |
| `H` | CLI cheatsheets | fzf-lua |

### Neovim navigation (no leader)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `gh` | Hover info |
| `gs` | Signature help |
| `[d` / `]d` | Prev / next diagnostic |
| `[h` / `]h` | Prev / next git hunk |
| `Space h p/s/r/b` | Hunk: preview / stage / reset / blame |

### Cursor zone navigation

| Key | Action |
|-----|--------|
| `Ctrl+Left` | File tree → editor |
| `Ctrl+Right` | Sidebar → editor |
| `Ctrl+Up` | Terminal/panel → editor |
| `Ctrl+Left` | AI chat → editor |
| `Escape` | Any zone → editor (when not typing) |
| `Space v` | Open Git panel (vscode-neovim) |
| `Space c` | Open AI chat (vscode-neovim) |

### WezTerm extras

| Key | Action |
|-----|--------|
| `Cmd+Shift+Space` | Copy mode (vim-like selection) |
| `Cmd+Shift+f` | Quick select (URLs, paths, hashes) |
| `Cmd+Shift+p` | Command palette |
| `Cmd+Shift+s` | Save session |
| `Cmd+Shift+r` | Restore session |
| `Cmd+1-9` | Switch to tab N |

## Repo structure

```
├── justfile               # Task runner (just -l to list recipes)
├── bootstrap              # Full setup: packages + dotfiles
├── install                # Re-link dotfiles (detects OS)
├── install-server         # Minimal server setup
├── Brewfile               # macOS packages
├── packages-linux.sh      # Pop!_OS / Ubuntu packages
├── install.conf.yaml      # Shared symlinks
├── install-mac.conf.yaml  # macOS symlinks (AeroSpace, Cursor)
├── install-linux.conf.yaml# Linux symlinks (Cursor, Pop Shell dconf)
├── cheatsheets/           # Per-tool markdown docs (Space H / cheat)
├── server/
│   └── install.conf.yaml  # Server symlinks
└── conf/
    ├── aerospace/         # Tiling WM (macOS)
    ├── cursor/            # Keybindings + settings
    ├── git/               # gitconfig + gitignore + gitconfig-perso
    ├── ssh/               # SSH config (NO keys — keys are secrets)
    ├── nvim/              # Neovim (lazy.nvim, shared with Cursor)
    ├── obsidian/          # Obsidian vim bindings
    ├── keyd/              # macOS-like modifier remapping (Linux)
    ├── pop-shell/         # Pop Shell keybindings (Linux)
    ├── starship/          # Prompt config
    ├── vim/               # Minimal vimrc (server / git)
    ├── wezterm/           # Terminal config
    ├── yazi/              # File manager (Dracula theme)
    ├── zellij/            # Multiplexer config (server, Dracula theme)
    └── zsh/               # zshrc + Prezto
```

## Security

**Never commit secrets to this repo.** Files that must stay out:

- `~/.ssh/*` private keys (`github_perso`, `gitlab_pro`, etc.)
- `~/.ssh/*.pub` public keys (fingerprint exposure)
- `~/.gnupg/` (GPG private keys, trust DB)
- `~/dev/work/.gitconfig-work` (work identity, employer info)
- `.env`, credentials, tokens, API keys

Only configuration (paths, hostnames, key IDs) goes in the repo — never the actual key material.
