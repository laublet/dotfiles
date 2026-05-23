# COSMIC (perso) — équivalent AeroSpace

Pop!_OS 24 **COSMIC** remplace AeroSpace + Pop Shell sur Mac. Les **raccourcis** sont déjà alignés dans `shortcuts.ron` (même architecture LCAG / HYPR / Super+Alt).

## OBS (pour info)

**OBS** = *Open Broadcaster Software* — enregistrement ou diffusion **écran + micro + webcam**.  
Utile si tu captures ton bureau ou une visio, **pas** lié au gaming. Installé en flatpak par le profil desktop ; tu peux l’ignorer ou le retirer :

```bash
flatpak uninstall com.obsproject.Studio
```

## Déjà comme AeroSpace

| Mac (AeroSpace) | perso (COSMIC) | Action |
|-----------------|----------------|--------|
| LCAG + flèches | idem (physique) | Focus fenêtre |
| HYPR + flèches | idem | Déplacer fenêtre |
| HYPR + -/= | idem | Redimensionner |
| Cmd+Alt + 1…9 | Super+Alt + 1…9 | Workspace |
| Cmd+Alt + ←/→ | Super+Alt + ←/→ | WS prev/next |
| LCAG + Enter | idem | WezTerm |
| Cmd+Shift+V | idem (via keyd) | Clipboard rofi |

Fichier déployé : `~/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom`

## Différences (limites COSMIC vs AeroSpace)

- **Pas de règles auto workspace** aussi riches qu’`on-window-detected` (Steam → WS 2, etc.) sans config Window Rules + workspaces épinglés (UI d’abord).
- **Pas d’accordion layout** identique ; tiling COSMIC + `ToggleStacking` / `ToggleOrientation` (LCAG+s, LCAG+o).
- **Gaps / bordures actives** : réglages dans **Settings → Desktop → Windows** (pas encore versionnés ici).

## Fichiers versionnés (dotbot)

| Fichier | Effet |
|---------|--------|
| `com.system76.CosmicComp/v1/autotile` | Tiling activé |
| `com.system76.CosmicComp/v1/autotile_behavior` | `Global` (toutes fenêtres, pas par workspace) |
| `com.system76.CosmicAppList/v1/favorites` | Apps épinglées au dock |
| `com.system76.CosmicPanel.Dock/v1/autohide` | Dock masqué, révélé au survol du bord |
| `com.system76.CosmicPanel.Dock/v1/exclusive_zone` | `false` (requis avec autohide) |
| `shortcuts.ron` | Raccourcis custom |

Après `./install` : **se déconnecter / reconnecter** (dock + tiling). Si un workspace reste en flottant : **LCAG+Y** (`Ctrl+Cmd+Alt+Y`) = basculer tiling.

## Dépannage raccourcis WM

1. **Tiling** : `autotile` + `autotile_behavior: Global` — sans tiling, LCAG+flèches ne fait presque rien.
2. **Ordre des touches** : maintenir **Cmd (Super)** puis **Ctrl+Alt+flèche** pour LCAG.
3. **Workspaces** : **Cmd+Alt + chiffre** (pas Cmd+chiffre seul — celui-là est pris par COSMIC par défaut).
4. Config non prise en compte → logout/login (pas seulement `./install`).

## Workspaces perso (suggestion manuelle)

Machine **loisir**, pas le layout dev du Mac :

| WS | Usage |
|----|--------|
| 1 | Jeux (Steam) |
| 2 | Navigateur / média |
| 3 | Discord / chat |
| 4+ | Libre |

Basculer avec **Super+Alt + chiffre** (comme Cmd+Alt sur Mac).
