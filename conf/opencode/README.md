# OpenCode config (plan secours)

Template for **backup agent** when Cursor / `cursor-agent` is unavailable. Cursor stays the default until switchover.

**Runbook:** vault `Wiki/OpenCode — plan secours agent.md`.

## A/B compare (Cursor Pro vs OpenCode Go)

Use **`agent-compare`** (dotbot → `~/.local/bin/agent-compare`) and vault wiki **Agent compare — Cursor Pro vs OpenCode Go**.

One provider at a time: gateway `agent_provider` on uruk + `:AvanteSwitchProvider` on Mac.

## Activate (at switchover only)

```bash
brew install anomalyco/tap/opencode
mkdir -p ~/.config/opencode
cp ~/dev/perso/dotfiles/conf/opencode/opencode.json.example ~/.config/opencode/opencode.json
```

1. Subscribe to [OpenCode Go](https://opencode.ai/go), then in `opencode`: `/connect` → OpenCode Go.
2. Run `/models` and replace `REPLACE_*` placeholders in `opencode.json`.
3. `opencode auth login` if prompted.
4. Neovim: `:AvanteSwitchProvider opencode` (provider pre-wired in `avante.lua`).

## Secrets

- **Do not** commit API keys in this repo.
- OpenCode Go key: stored via `/connect` in `~/.local/share/opencode/auth.json`.
- Vault MCP: token in `~/.config/research-vault-mcp.env` (same as Cursor). The wrapper `research-vault-mcp-remote` loads it automatically.

## MCP path

If your home directory differs, edit `mcp.research-vault.command` in `opencode.json` to point at `~/.local/bin/research-vault-mcp-remote` (installed by dotbot `install-mac.conf.yaml`).

## CLI wrapper

`opencode-launch` (dotbot → `~/.local/bin/opencode-launch`) fixes TTY/colors in WezTerm like `cursor-agent-launch`. Optional zsh alias (not enabled by default):

```bash
# opencode() { opencode-launch "$@"; }
```

## Neovim optional keymap

To bind `<leader>ao` to an OpenCode vsplit while testing backup:

```lua
-- init.local.lua (not in repo)
vim.g.agent_backup = "opencode"
```

See `keymaps.lua` for the gated mapping.
