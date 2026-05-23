# COSMIC (perso)

**Important:** `~/.config/cosmic/.../custom` **replaces** system defaults — not a merge.  
Always generate via `scripts/gen-cosmic-shortcuts.sh` (defaults + `aerospace-overrides.ron`).

## Launcher

- **Cmd+Space** → launcher (`Super+Space` in COSMIC; tap Cmd seul = rien)
- keyd: `oneshot(dummy)` on Super tap

## WM (AeroSpace fingers)

keyd envoie `Super+Ctrl+Alt` / `Super+Alt` ; raccourcis dans `aerospace-overrides.ron`.

Regénérer après update COSMIC:

```bash
scripts/gen-cosmic-shortcuts.sh && ./install
sudo cp conf/keyd/default.conf /etc/keyd/ && sudo systemctl restart keyd
```

Logout si le dock ou les raccourcis ne se rechargent pas.
