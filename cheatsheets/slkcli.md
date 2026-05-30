# slkcli — Slack CLI (macOS, agents & scripts)

> **Help:** `slk auth` · `cheat slk-tui` (full TUI client)

> Reads session credentials from **Slack.app** (no manual token). Command name: `slk`. Not affiliated with Slack.

**Pairing:** daily chat in terminal → [slk-tui](slk-tui.md) (`slk-tui`). Quick reads, agents, shell → **this** tool (`slk`).

## Install

```bash
mise install                    # from ~/.config/mise/config.toml (npm:slkcli)
# or: npm install -g slkcli

slk auth                        # first run: Keychain prompt for "Slack Safe Storage"
```

**Requires:** macOS, Slack desktop logged in, Node 18+ (via mise). Linux: use slk-tui only; slkcli is macOS-only.

## Everyday

```bash
slk unread                      # channels with unreads (respects mutes)
slk activity                    # all channels + mention counts
slk channels                    # list channels (name + ID)
slk read general 30             # last 30 messages
slk read C08A8AQ2AFP 20 --ts   # by ID; show timestamps for threads
slk send general "from terminal"
slk search "deploy failed" 20
slk thread general 1769753479.788949
slk react general 1769753479.788949 thumbsup
slk dms                         # DM list
slk read @username 50 --threads
slk send @username "ping"
slk pins engineering
slk saved
slk starred
```

## Drafts (sync to Slack UI)

```bash
slk draft engineering "WIP message…"
slk draft thread general 1769753479.788949 "reply draft"
slk drafts
slk draft drop <id>
```

## Flags

| Flag | Effect |
|------|--------|
| `--ts` | Raw Slack timestamps (for `slk thread`) |
| `--threads` | Expand threads when reading |
| `--from` / `--to` | `YYYY-MM-DD` date range |
| `--no-emoji` | Plain text output |
| `--all` | `slk saved` includes completed items |

## Auth & cache

- Token: `xoxc-` from Slack LevelDB + `d` cookie (Keychain).
- Cache: `~/.local/slk/token-cache.json` (re-extracts on `invalid_auth`).
- **Keychain:** prefer **Allow** on shared machines; **Always Allow** = any local process using `slk` can read credentials silently.

## Name clash

| Binary | Tool |
|--------|------|
| `slk` | slkcli (this cheatsheet) |
| `slk-tui` | [gammons/slk](slk-tui.md) TUI |

Install TUI: `install-slk-tui` or `just install-slk-tui`.

## Links

- Repo: https://github.com/therohitdas/slkcli
- TUI: https://getslk.sh/
