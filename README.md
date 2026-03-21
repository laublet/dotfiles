# Dotfiles

Keyboard-centric development environment, unified across macOS and Linux.

## Quick start

```bash
# Fresh machine (installs packages + links dotfiles)
./bootstrap

# Re-link dotfiles only (after config changes)
./install

# Minimal server setup (vim, zsh, nvim, git, tmux)
./install-server
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
| bat | cat | Syntax-highlighted file viewer |
| eza | ls | `ll`, `lt` aliases |
| fd | find | Used by fzf |
| fzf | — | Fuzzy finder (`Ctrl+T`, `Ctrl+R`, `Ctrl+F`) |
| ripgrep | grep | `rg`, `rgf`, `rgv`, `rgt`, `rgc` functions |
| zoxide | cd | `z` for smart directory jumping |
| yazi | ranger/vifm | Terminal file manager, vi keys (`y`) |
| delta | — | Git diff viewer (side-by-side, Dracula theme) |
| lazygit | — | TUI git client (`lg`) |
| lazydocker | — | TUI Docker client (`lzd`) |
| starship | — | Prompt with vi-mode indicator |
| direnv | — | Per-directory env vars |
| fnm | nvm | Fast Node version manager |

## Repo structure

```
├── bootstrap              # Full setup: packages + dotfiles
├── install                # Re-link dotfiles (detects OS)
├── install-server         # Minimal server setup
├── Brewfile               # macOS packages
├── packages-linux.sh      # Pop!_OS / Ubuntu packages
├── install.conf.yaml      # Shared symlinks
├── install-mac.conf.yaml  # macOS symlinks (AeroSpace, Cursor)
├── install-linux.conf.yaml# Linux symlinks (Cursor, Pop Shell dconf)
├── server/
│   └── install.conf.yaml  # Server symlinks
└── conf/
    ├── aerospace/         # Tiling WM (macOS)
    ├── cursor/            # Keybindings + settings
    ├── git/               # gitconfig + gitignore
    ├── nvim/              # Neovim (lazy.nvim, shared with Cursor)
    ├── obsidian/          # Obsidian vim bindings
    ├── keyd/              # macOS-like modifier remapping (Linux)
    ├── pop-shell/         # Pop Shell keybindings (Linux)
    ├── starship/          # Prompt config
    ├── vim/               # Minimal vimrc (server / git)
    ├── wezterm/           # Terminal config
    ├── yazi/              # File manager (Dracula theme)
    └── zsh/               # zshrc + Prezto
```
