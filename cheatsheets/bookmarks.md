# Bookmarks & read-later — compare options

> **Adopted:** [karakeep.md](karakeep.md) (self-hosted on uruk). Compare other tools below.
> You already have: Vimium (browser); Tridactyl quickmarks paused — [tridactyl.md](tridactyl.md), Obsidian, `research-capture`, Choosy.

## Options

| Tool | Type | Pros | Cons |
|------|------|------|------|
| **Raindrop.io** | SaaS bookmarks + tags | Extension, mobile, collections | Account, subscription for pro |
| **Karakeep** | Self-hosted + optional IA | Data at home | Ops, hosting |
| **Linkwarden** | Self-hosted archive | Saves page/PDF | Heavier setup |
| **Pinboard** | Minimal SaaS | Fast, no fluff | Paid |
| **Readwise Reader** | Read-later + highlights | Reading workflow | Cost |
| **Omnivore** | Read-later | — | Project discontinued — skip |

## Fit with this dotfiles setup

| Need | Use |
|------|-----|
| Quick jump to fixed URL | Vimium (active) or Tridactyl `quickmark` when re-enabled ([tridactyl](tridactyl.md)) |
| Research note → vault | `research-capture` |
| Long-form knowledge | Obsidian vault |
| « Save this article for later » | [Karakeep](karakeep.md) (homelab) |

## If you adopt Raindrop later

- **Do not** put API tokens in git
- Tridactyl: `quickmark r https://app.raindrop.io/...`
- Raycast: Quicklink « Save to Raindrop »
- Optional: `brew install --cask raindropio` (GUI)

## Other utilities (optional, not in Brewfile)

| Tool | Role |
|------|------|
| MonitorControl | Per-monitor brightness/volume (mac) |
| Pearcleaner | Clean app uninstall (mac) |
| entr / watchexec | Re-run command on file change |

See `just doctor` after brew changes.
