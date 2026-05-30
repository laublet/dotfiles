# Raycast — versioned Quicklinks + scripts (macOS)

Raycast app settings are not symlinked by dotbot. This folder holds **importable JSON** and **Script Commands** only.

**Appearance (free):** `just mac-raycast-appearance` — suit le mode sombre macOS (`raycastShouldFollowSystemAppearance`). Thème custom Dracula = Pro ; [`dracula-classic.json`](dracula-classic.json) ignoré sans Pro.

**Migrer plus tard ?** [`ALTERNATIVES.md`](ALTERNATIVES.md) — décision 2026 : rester sur Raycast free ; Alfred, benchmarks, déclencheurs de réévaluation.

## Quicklinks import

```bash
just raycast-quicklinks        # Firefox bundle → Finder
just raycast-quicklinks work   # Chrome work bundle → Finder
```

Then in Raycast: **Import Quicklinks** → pick the revealed file → **Settings → Quicklinks** → assign **aliases** (import does not set them).

### Firefox (`quicklinks-firefox.json`)

| Alias | Quicklink |
|-------|-----------|
| `ff` | Open URL via Choosy (`{argument}` = full URL) |
| `k` | Kagi |
| `dl` | DeepL FR |
| `gh` | GitHub |
| `yt` | YouTube |
| `npm` | NPM |
| `mdn` | MDN |
| `maps` | Google Maps |
| `ama` | Amazon |
| `obs` | Obsidian Main |

### Work Chrome (`quicklinks-work-chrome.json`)

| Alias | Quicklink |
|-------|-----------|
| `gc` | Open URL in Chrome (`{argument}` = full URL) |
| `jira` | Jira search |
| `gl` | GitLab search |
| (none) | GitLab neo-k (dashboard) |

## Script Commands

1. **Manage Script Commands** → **Add Script Directory** → `~/dev/perso/dotfiles/conf/raycast/scripts`
2. Aliases: `ff` / `ffp` or `ffc` (Choosy URL / clipboard), `gc` / `gcp` (Chrome URL / clipboard), `jfmt`, `jmin`, `sgp` (ast-grep dropdown → clipboard)
3. After editing [`ast-grep-patterns.lua`](../nvim/lua/ast-grep-patterns.lua): `just gen-raycast-sg`

Or install Store **Format JSON** and alias `json` on « Format Clipboard JSON ».

## Browser

- **`ff` / `ffp` (or `ffc`)** — Choosy rules via `x-choosy://open/…` (default fallback: **Firefox Developer Edition** in `conf/mac-apps/choosy-behaviours.plist`). Force a browser: `RAYCAST_BROWSER='Firefox Developer Edition'` on the script command.
- **Chrome (work, bypass Choosy):** Quicklink/script `gc`, clipboard `gcp`. Work JSON: `"openWith": "Google Chrome"`.
- Re-import after JSON changes: `just raycast-quicklinks` → Raycast **Import Quicklinks**.

Note: zsh alias `ff` = `open -a "Firefox Developer Edition"`; Raycast `ff` uses Choosy (Jira/GitLab/Notion → Chrome, else prompt or Dev Edition fallback in rules).

## Extensions

Install checklist: [`extensions.md`](extensions.md).

### Mozilla Firefox extension — Developer Edition (obligatoire)

L’extension store **Mozilla Firefox** cible par défaut l’app **Firefox** et souvent le profil `default-release`. Sur cette machine le navigateur perso est **Firefox Developer Edition** — sans ces prefs, l’historique est vide ou celui du mauvais profil.

1. Raycast → **Store** → **Mozilla Firefox** → installer.
2. Raycast → **Extensions** → **Mozilla Firefox** → **Configure Extension** (icône engrenage) :
   - **Firefox Application** → **Firefox Developer Edition** (pas « Firefox »)
   - **Profile Directory Suffix** → suffixe après le `.` du dossier profil (`about:profiles` dans Dev Edition), en général **`dev-edition-default`**
3. Vérifier les dossiers locaux : `just raycast-firefox-profile`
4. Tester **New Tab** (`f`) : taper un site déjà visité dans Dev Edition → entrées historique visibles.

| Mauvais réglage | Symptôme |
|-----------------|----------|
| Firefox au lieu de Dev Edition | `open -a` ouvre le mauvais navigateur |
| Suffixe `default-release` au lieu de `dev-edition-default` | Historique vide ou profil Firefox stable |

### Firefox Tabs (Developer Edition)

Store extension **Firefox Tabs** + add-on [Raycast Tab Manager](https://addons.mozilla.org/en-US/firefox/addon/raycast-tab-manager/) in **Firefox Developer Edition**, then **Setup Firefox Bridge**.

The stock host only raises **Firefox** (`org.mozilla.firefox`), not Dev Edition — tabs switch but the window stays behind Raycast. Fix (re-run after bridge updates):

```bash
just raycast-firefox-patch
```

Then quit and reopen Firefox Developer Edition once.

### Firefox — barre d’adresse dans Raycast

Aucune extension store ne fusionne aujourd’hui **onglets ouverts + historique + recherche** dans une seule liste (comme la awesomebar). Deux commandes, complémentaires :

| Alias (suggéré) | Extension store | Rôle |
|-----------------|-----------------|------|
| `f` | **Mozilla Firefox** → **New Tab** | Historique (`places.sqlite`) pendant la frappe ; Entrée = recherche (moteur dans les prefs de l’extension) ; ligne historique = ouvrir l’URL |
| `ft` | **Firefox Tabs** → **Search Firefox Tabs** | Onglet déjà ouvert → bascule dessus (add-on + bridge + patch ci-dessus) |

Voir la section **Mozilla Firefox extension** ci-dessus (`just raycast-firefox-profile` pour le suffixe).

**Limites** (extensions officielles) : *New Tab* n’interroge pas les onglets live — pour un onglet ouvert, utiliser `ft`. Ouvrir une URL depuis l’historique utilise `open -a` (peut dupliquer l’onglet selon les prefs Firefox).

**Chrome (work)** : store **Google Chrome** → **Search Tabs** (pas de bridge type Firefox).

## Docs

[`cheatsheets/raycast.md`](../../cheatsheets/raycast.md)
