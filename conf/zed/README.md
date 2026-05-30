# Zed — when to use which editor

Config: [`settings.json`](settings.json), [`keymap.json`](keymap.json) → `~/.config/zed/`.

| Editor | Role |
|--------|------|
| **Neovim** | Daily driver — editing, git (neogit), terminal (WezTerm), LSP, tests |
| **Cursor** | Fallback — agent sidebar, odd LSP edge cases, quick fixes when nvim blocks |
| **Zed** | **Large projects** — big monorepos, heavy TS/rust workspaces, native perf |

## Open Zed

```bash
zed .                 # same as below when CLI is on PATH
just zed              # fallback if only Zed.app is installed
```

**CLI on PATH (macOS):** after `brew install --cask zed`:

```bash
ln -sf /Applications/Zed.app/Contents/MacOS/cli ~/.local/bin/zed
```

## When to prefer Zed over Neovim

- Repo so large that LSP + file tree feel sluggish in nvim
- Long sessions in one workspace with many crates/packages
- You want Zed’s native multi-buffer UX without tuning nvim further

Stay in **nvim** for: vault markdown, small scripts, git-heavy flows, anything already wired (`<leader>*`, overseer, neotest).

## Dotfiles

- Cheatsheet: [`cheatsheets/zed.md`](../../cheatsheets/zed.md)
- No neogit inside Zed — use `gu` (gitui) from WezTerm or `<leader>gg` in nvim
