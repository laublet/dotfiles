# COSMIC (perso) — équivalent AeroSpace

**Même doigts que sur Mac (AeroSpace)** ; COSMIC reçoit ses raccourcis **natifs** via keyd.

| Physical (Mac) | keyd envoie | COSMIC (defaults) |
|----------------|-------------|-------------------|
| LCAG + flèches | Super + flèches | Focus fenêtre |
| HYPR + flèches | Super + Shift + flèches | Déplacer |
| Cmd+Alt + N | Super + N | Workspace N |
| Cmd+Alt + ←/→ | Super + Ctrl + ←/→ | WS prev/next |
| Cmd+Alt+Shift + N | Super + Shift + N | Move to WS |
| LCAG + Y / G | Super + Y / G | Tiling / float |
| Cmd+Shift+V | Ctrl+Shift+V | clipboard-rofi (custom) |
| LCAG + Enter | LCAG + Enter | WezTerm (custom) |

Fichier custom minimal : `shortcuts.ron` (4 overrides). Le reste = `/usr/share/cosmic/.../defaults`.

## Après changement keyd

```bash
cd ~/dev/perso/dotfiles && git pull && ./install
sudo cp conf/keyd/default.conf /etc/keyd/ && sudo systemctl restart keyd
```

Pas besoin de logout pour keyd ; oui pour dock.

## Tiling

- `autotile` + `autotile_behavior: Global` dans dotfiles
- Si bloqué : **LCAG+Y** (→ Super+Y) toggle tiling

## Dock

Autohide + hover — voir `com.system76.CosmicPanel.Dock/v1/autohide`.
