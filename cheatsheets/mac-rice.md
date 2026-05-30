# macOS Dracula RICE

> Dark mode, purple accent, dock, wallpaper. Dev stack already Dracula (WezTerm, Neovim, Cursor, Starship).

## Apply

```bash
just link                  # once
just mac-appearance        # dark, accent, dock, Ship wallpaper
just mac-stats-defaults    # menu bar modules
just mac-borders           # fenêtres: contour violet/rose (JankyBorders)
just mac-raycast-appearance
just mac-doctor            # verify
```

Config: [`conf/theme/dracula.env`](../conf/theme/dracula.env) · checklist + status: [`conf/mac-apps/DRACULA-RICE.md`](../conf/mac-apps/DRACULA-RICE.md)

## Wallpaper (current)

**Ship** (4K) — [aynp/dracula-wallpapers](https://github.com/aynp/dracula-wallpapers/blob/main/Art/4k/Ship.png)

Stored: `~/Pictures/wallpapers/dracula-ship-4k.png`

## Browse more

| Link | Notes |
|------|-------|
| https://dracula-wallpapers.netlify.app/ | Gallery |
| https://github.com/dracula/wallpaper | Official (Mist Over Transylvania, Morbius) |
| https://draculatheme.com/wallpaper | Index |

Change `WALLPAPER=` in `dracula.env`, then `just mac-appearance`.

## Raycast (sans Pro)

```bash
just mac-raycast-appearance   # suit le dark mode macOS + redémarre Raycast
```

Thème custom Dracula = Pro uniquement. Avec le reste du RICE (Ship, WezTerm, Cursor…) c’est déjà cohérent côté dev.

## Related

| Topic | Doc |
|-------|-----|
| Ice + Stats menu bar | [`conf/mac-apps/README.md`](../conf/mac-apps/README.md) |
| WezTerm (no status CPU — use Stats) | [wezterm](wezterm.md) |
| Raycast | [raycast](raycast.md) |
