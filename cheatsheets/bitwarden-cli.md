# Bitwarden CLI (`bw`)

> **Help:** `bw --help` · `bw help <cmd>` · `bw-help` (fzf) · [bitwarden.com/help/cli](https://bitwarden.com/help/cli/)

> Secrets for scripts and local dev — **never** commit tokens to dotfiles. Install: `brew install bitwarden-cli`.

## Command index (quick)

| Command | Purpose |
|---------|---------|
| `bw login` | Authenticate (once per machine) |
| `bw unlock` | Decrypt vault → session key |
| `bw lock` | Destroy session |
| `bw sync` | Pull latest vault from server |
| `bw status` | Logged in? locked? last sync? |
| `bw list items` | All login/secure-note items (JSON) |
| `bw list folders` | Folder list |
| `bw get password <name\|id>` | Password field |
| `bw get username <name\|id>` | Username field |
| `bw get uri <name\|id>` | URL field |
| `bw get notes <name\|id>` | Secure note body |
| `bw get totp <name\|id>` | TOTP code |
| `bw get item <id>` | Full item JSON |
| `bw generate` | Random password/passphrase |
| `bw create item` | Create item (JSON pipe) |
| `bw edit item` | Edit item |
| `bw delete item` | Move to trash |
| `bw export` | Backup vault (encrypted CSV/JSON) |

Browse full reference:

```bash
bw-help              # fzf → pick command → show bw help <cmd>
bw help get          # one command
bw help list         # list sub-options (--search, --folderid, …)
```

## Session (in `~/.secrets`, not versioned)

`~/.secrets` is sourced from [`conf/zsh/zshrc`](../conf/zsh/zshrc). Example:

```bash
# ~/.secrets — DO NOT COMMIT
export BW_SESSION="$(bw unlock --raw)"
```

Unlock once per login session. Raycast / browser extension use the app separately.

Check session (prefer `status`, not `unlock --check`):

```bash
bw status                    # human-readable
bw status --raw | python3 -c "import json,sys; print(json.load(sys.stdin)['status'])"
# → unlocked | locked | unauthenticated
```

`bwpick` calls `_bw_ensure_unlocked`: if status is `locked`, it runs `bw unlock --raw` and exports `BW_SESSION` for the current shell.

## Common commands

```bash
bw login
bw unlock
bw sync
bw status

bw get password "GitHub"           # match by item name
bw get notes "API tokens"
bw get username "GitLab"
bw get totp "AWS console"

bw list items --search github      # filter by name
bw list items --url google.com     # logins matching URL
```

## Pick an item interactively (fzf)

```bash
bwpick              # fzf all items → copy password (Enter)
bwpick github       # pre-filter with --search
```

| In `bwpick` | Action |
|-------------|--------|
| Enter | Copy **password** to clipboard |
| Ctrl-u | Copy **username** |
| Ctrl-n | Copy **notes** |
| Ctrl-y | Print `bw get password '…'` command (no copy) |

Requires unlocked vault (`bw unlock` or `BW_SESSION`).

## Script one-liners

```bash
# Env var for a single command (not in shell history if wrapped carefully)
GITHUB_TOKEN="$(bw get password 'GitHub PAT')" gh pr list

# Pipe JSON item
bw get item "$(bw list items --search 'My API' --raw | python3 -c "import json,sys; print(json.load(sys.stdin)[0]['id'])")"
```

Prefer **`bwpick`** or explicit names over hardcoding IDs in scripts.

## Clipboard

**greenclip** blacklists Bitwarden on Linux ([`conf/greenclip/greenclip.toml`](../conf/greenclip/greenclip.toml)). macOS Raycast: ignore password managers enabled in [raycast](raycast.md).

## vs 1Password

This setup assumes **Bitwarden** as the daily vault. No `op` CLI in Brewfile unless you migrate.

## Links

- Rule: [no-secrets](../.cursor/rules/no-secrets.mdc)
- Shell helpers: [`conf/zsh/zshrc`](../conf/zsh/zshrc) (`bw-help`, `bwpick`)
