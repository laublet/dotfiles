# Dotfiles workspace

**Canonical agent config (preferences, skills, workspaces):**  
[`~/dev/perso/vaults/Research/AGENTS-core.md`](../vaults/Research/AGENTS-core.md) (index: [`AGENTS.md`](../vaults/Research/AGENTS.md))

Read that file first. Tool-specific: [`CURSOR.md`](../vaults/Research/CURSOR.md) in Cursor.

## This repo only

| Item | Location |
|------|----------|
| Agent skills (all) | `~/.agents/skills` → Research `.agents/skills/` (after `just link`) |
| No secrets | `.cursor/rules/no-secrets.mdc` |
| Neovim conventions | `.cursor/rules/neovim-conventions.mdc` |
| Research capture CLI | `bin/research-capture` |
| Work repo local stub | `bin/work-agents-stub` → `AGENTS.local.md` (gitignored) |

## Dotfiles skills (in Research vault)

`dotfiles-add-keybinding`, `dotfiles-new-cli-tool`, `dotfiles-dotbot-change`, `dotfiles-cheatsheet-maintain`

## Quick tasks

```bash
just              # list recipes
just link         # re-symlink dotbot
just link-agents  # agent hub only
just work-agents-stub ~/dev/work/<repo>  # AGENTS.local.md
just cheat        # browse cheatsheets
```

Keep this file as a **pointer** — edit preferences in Research `AGENTS-core.md` / `AGENTS-vault.md`, not here.
