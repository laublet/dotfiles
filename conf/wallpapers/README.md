# Wallpapers (Dracula RICE)

Wallpaper **files** live in `~/Pictures/wallpapers/` (not committed — too large).

## Current pick

| File | Source |
|------|--------|
| `dracula-ship-4k.png` | [aynp/dracula-wallpapers — Ship.png (4k)](https://github.com/aynp/dracula-wallpapers/blob/main/Art/4k/Ship.png) |

Path is set in [`conf/theme/dracula.env`](../theme/dracula.env) as `WALLPAPER`.

## Apply

```bash
just mac-appearance
# or
mac-appearance
```

Re-download Ship:

```bash
curl -fsSL -o ~/Pictures/wallpapers/dracula-ship-4k.png \
  "https://raw.githubusercontent.com/aynp/dracula-wallpapers/main/Art/4k/Ship.png"
```

## Browse more

- Official: https://draculatheme.com/wallpaper · https://github.com/dracula/wallpaper
- Gallery: https://dracula-wallpapers.netlify.app/ · https://github.com/aynp/dracula-wallpapers

After choosing another image, update `WALLPAPER=` in `dracula.env` and run `just mac-appearance`.
