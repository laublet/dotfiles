# COSMIC (perso)

**Important:** `~/.config/cosmic/.../custom` **replaces** system defaults — not a merge.  
Always generate via `scripts/gen-cosmic-shortcuts.sh` (defaults + `aerospace-overrides.ron`).

## Launcher

- **Super+Space** — COSMIC launcher (physical Cmd key = Super on Linux)

## WM (AeroSpace fingers)

Native modifiers — no keyd. LCAG = `Super+Ctrl+Alt` ; workspaces = `Super+Alt` + number.  
Bindings in `aerospace-overrides.ron`.

Regénérer après update COSMIC:

```bash
scripts/gen-cosmic-shortcuts.sh && ./install
```

Logout si le dock ou les raccourcis ne se rechargent pas.
