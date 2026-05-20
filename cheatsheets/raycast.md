## Raycast — launcher + clipboard (macOS)

Remplace Albert + Maccy en un seul binaire. Free tier suffit pour le clipboard (rétention 3 mois), Pro ($8/mo) ajoute AI + sync illimité. Install : `brew install --cask raycast`.

## First-run setup (5 min, à faire une fois après install)

À l'ouverture de Raycast, suivre l'onboarding puis configurer **Settings** (`Cmd+,` depuis Raycast) :

### 1. Hotkeys

| Action | Raycast Hotkey | Pane |
|---|---|---|
| Open Raycast (launcher) | `Cmd+Space` | General → Raycast Hotkey |
| Clipboard History | `Cmd+Shift+V` | Extensions → Clipboard History → Hotkey |
| Window Management → menu | (optionnel) | Extensions → Window Management |

**Important** : pour libérer `Cmd+Space`, désactiver Spotlight (System Settings → Keyboard → Keyboard Shortcuts → Spotlight → décocher *Show Spotlight search*). Spotlight reste accessible via menu bar si besoin.

### 2. Login item

General → **Launch Raycast at login** : ON.

### 3. Privacy

Advanced → **Send Analytics** : OFF (préférence perso, opt-out).

### 4. Clipboard History

Extensions → **Clipboard History** :
- Hotkey : `Cmd+Shift+V` (cf table)
- *Pasteboard polling* : laisser default
- *Ignore Password Managers* : ON (1Password, Bitwarden, Keychain auto-détectés)
- Retention : 3 months sur free tier (Pro = illimité)

### 5. Quicklinks (web search — à recréer depuis Albert)

Extensions → **Quicklinks** → `+` pour chacun. Le `{Query}` est le placeholder de Raycast.

| Trigger (alias) | Name | URL |
|---|---|---|
| `k` | Kagi | `https://kagi.com/search?q={Query}` |
| `tr` | DeepL FR | `https://www.deepl.com/translator#auto/fr/{Query}` |
| `gh` | GitHub | `https://github.com/search?q={Query}` |
| `yt` | YouTube | `https://www.youtube.com/results?search_query={Query}` |
| `npm` | NPM | `https://www.npmjs.com/search?q={Query}` |
| `mdn` | MDN | `https://developer.mozilla.org/en-US/search?q={Query}` |
| `maps` | Google Maps | `https://www.google.com/maps/search/{Query}/` |
| `wa` | Wolfram Alpha | `https://www.wolframalpha.com/input/?i={Query}` |
| `ama` | Amazon | `https://www.amazon.com/s/?field-keywords={Query}` |

Pour chaque entrée : open Quicklinks → Create Quicklink → Name + Link (avec `{Query}`) + Open With (Firefox / default) → set **Alias** (le trigger court). Une fois fait, tu peux les invoquer en tapant `k mon search` dans Raycast.

Tip : tu peux aussi exporter cette table en JSON et importer en bulk via *Settings → Extensions → Quicklinks → … menu → Import* — format `[{"name": "Kagi", "link": "https://kagi.com/search?q={Query}"}]`. Voir migration script ci-dessous si besoin.

### 6. Disable / hide unused commands

Extensions → list complète. Pour réduire le bruit dans la palette, *Disable* tout ce qui ne sert pas (Calendar, Mail, etc.) ou set `⌥ ⌫` sur une commande pour la masquer du fuzzy search.

## Usage

| Cmd | Action |
|---|---|
| `Cmd+Space` | Open Raycast (launcher) |
| `Cmd+Shift+V` | Clipboard history (fuzzy search, Enter = paste auto) |
| `k foo` | Search Kagi (any Quicklink alias) |
| `<app name>` | Launch app |
| Type `calc` / `42 * 18` | Calculator (inline) |
| `snip` | Snippets (saved text expansion) |
| `kill` | Kill process by name |
| `flush` | Empty Trash, etc. (system commands) |
| `Cmd+,` from Raycast | Open settings |
| `Cmd+K` on a result | Action panel (rename, change icon, etc.) |

## Recommended extensions (Store, gratuit)

Install via Raycast : tape **Store** → search :

- **GitHub** — search repos, PRs, issues, gists from launcher
- **Visit** — open recent URLs in browser history
- **Color Picker** — pick + copy hex/rgb from anywhere
- **Kill Process** — fuzzy kill (built-in mais à activer)
- **Brew** — wrapper `brew search/install/uninstall` sans terminal
- **Tailscale** — toggle nodes, copy IPs
- **Apple Notes / Obsidian Search** — fuzzy notes (Obsidian extension officielle)
- **Window Management** — built-in tilers (move halves/quarters) si tu veux compléter AeroSpace pour des cas one-off

Tape simplement le nom dans la Store pour install.

## Limitations (free tier)

- **Clipboard retention** : 3 mois (Pro = illimité). Suffisant en pratique.
- **Pas de sync** entre machines sans Pro. Tu as une seule machine macOS donc non-bloquant.
- **AI chat** : Pro only. Pas grave, tu as Cursor.

## Versioning / dotfiles

**Raycast n'a pas de config file plain-text exportable**. Tout vit dans `~/Library/Application Support/com.raycast.macos/` (SQLite + binaires opaques) et `~/Library/Preferences/com.raycast.macos.plist` (avec des binary blobs). Versionner ça serait fragile et tu re-sync les Quicklinks à chaque setup machine via cloud Raycast (compte free suffit).

Stratégie ici :
- **Pas de symlink dotbot** (rien à versionner).
- **Cette cheatsheet** est la source de vérité pour recréer la config en 5 min sur une machine neuve.
- **Compte Raycast** (free) sauve les Quicklinks dans leur cloud → log in sur nouvelle machine = tout revient.

## Migration depuis Albert/Maccy (done)

- Albert : uninstall via brew (`brew uninstall --cask albert`), suppression de `conf/albert/`, des entries dotbot et de la cheatsheet.
- Maccy : nuclear uninstall (cassé sur macOS Tahoe — auto-paste ne fonctionnait plus malgré perms Accessibility + Input Monitoring + Developer Tools + reinstall complet ; voir [Maccy#1381](https://github.com/p0deje/Maccy/issues)).
- `conf/aerospace/aerospace.toml` : règle de float pour `org.p0deje.Maccy` supprimée (Raycast gère son popup nativement).

## Troubleshooting

- **`Cmd+Space` ne fait rien** : Spotlight pas désactivé, le binding est swallowed. System Settings → Keyboard → Keyboard Shortcuts → Spotlight → décocher.
- **Clipboard history vide** : Raycast doit être lancé en background. Vérifier le menu bar icon ; sinon, activer *Launch at login*.
- **Auto-paste depuis clipboard ne marche pas** : Accessibility permission requise (System Settings → Privacy & Security → Accessibility → Raycast). Re-grant après chaque update.
- **Une extension ne s'install pas** : `~/Library/Application Support/com.raycast.macos/extensions` peut être corrompue. Force reinstall depuis la Store.

## Related

- [keyboard-navigation.md](keyboard-navigation.md) — Raycast hotkeys dans le contexte global
- [clipboard.md](clipboard.md) — clipboard cross-platform (Linux = Greenclip + Rofi)
