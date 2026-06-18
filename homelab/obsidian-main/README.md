# Obsidian Main — LiveSync + CouchDB (uruk)

Real-time sync for `~/dev/perso/vaults/Main` (journal). **Not** Research (Syncthing + MCP).

| Item | Value |
|------|-------|
| Public URL | `https://obsidian-main.loicaublet.fr/vault` |
| CouchDB database | `obsidian-main` |
| Backup (off-site) | Codeberg `HanP77/vault-main` (git snapshot, not transport) |

## Deploy on uruk

```bash
mkdir -p ~/homelab/obsidian-main
# Copy this folder from dotfiles or Codeberg homelab repo
cd ~/homelab/obsidian-main
cp .env.example .env   # set COUCHDB_USER / COUCHDB_PASSWORD
docker compose up -d
```

DNS: `A` record `obsidian-main.loicaublet.fr` → public IP (or CNAME if proxied).

```bash
sudo cp nginx/obsidian-main.loicaublet.fr.conf.snippet /etc/nginx/sites-available/obsidian-main.loicaublet.fr
sudo ln -sf /etc/nginx/sites-available/obsidian-main.loicaublet.fr /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
sudo certbot --nginx -d obsidian-main.loicaublet.fr
```

Verify: open `https://obsidian-main.loicaublet.fr/vault/_utils` → login with `.env` credentials.

## Obsidian LiveSync (Mac, then iPhone)

1. Last sync via Obsidian Sync; then disable Obsidian Sync on **Main** only.
2. `just link` on Mac (enables `obsidian-livesync` in community plugins).
3. Obsidian → Main → Community plugins → enable **Self-hosted LiveSync**.
4. Quick setup:
   - **URI:** `https://obsidian-main.loicaublet.fr/vault`
   - **Username / password:** from uruk `.env`
   - **Database:** `obsidian-main` (created on first connect)
   - Enable **End-to-end encryption** (passphrase in password manager).
5. Mac: upload / merge local vault to remote.
6. iPhone: import Setup URI from Mac → **Fetch from remote** (Rebuild everything).
7. Enable **LiveSync** mode on both devices; test edit latency (~1–2 s).

## Codeberg backup (Mac)

One-way git snapshot if uruk is down. **Do not** enable Obsidian Git auto-sync.

```bash
just vault-main-git-init    # once: repo + Codeberg remote
just vault-main-backup      # manual or cron
```

## Pitfalls

- One transport per vault: LiveSync only on Main; no Nextcloud client on the vault folder.
- Research stays on Syncthing — do not point LiveSync at Research.
- Rotate CouchDB password in `.env` + plugin settings if leaked.

## See also

- Vault note: `Projects/Main vault — LiveSync CouchDB.md` (Research vault)
- Plugin docs: https://github.com/vrtmrz/obsidian-livesync
