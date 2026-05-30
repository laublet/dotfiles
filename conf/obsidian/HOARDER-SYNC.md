# Hoarder Sync (Karakeep → Obsidian Main)

Plugin: [hoarder-sync](https://github.com/jhofker/obsidian-hoarder).

**Vault Main only** — Research stays wiki/capture (`research-capture`, clippings); Karakeep sync here would duplicate noise.

## Install

```bash
just link              # Main uses community-plugins-main.json (includes hoarder-sync)
just hoarder-sync-setup
```

Obsidian **Main**:

1. **Community plugins** → **Karakeep (Hoarder) Sync**
2. Paste **API key**
3. **Hoarder Sync: Start Sync**

## Defaults

| Setting | Value |
|---------|--------|
| Endpoint | `http://karakeep.home.loicaublet.fr/api/v1` |
| Folder | `Literature/Karakeep/` |
| Included tags | `wiki-candidate` (tight; clear in settings to sync all) |
| Excluded | `imported` |

## Plugin lists

| Vault | `community-plugins` |
|-------|---------------------|
| Main | `community-plugins-main.json` (+ hoarder-sync) |
| Research | `community-plugins.json` (no hoarder-sync) |
