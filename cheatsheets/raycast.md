# Raycast — launcher + clipboard (macOS)

> **Help:** Raycast: select a command → shortcut hints · [docs](https://manual.raycast.com)

Remplace Albert + Maccy. Free tier OK for clipboard (3 months). Install : `brew install --cask raycast`.

Versioned in dotfiles: [`conf/raycast/`](../conf/raycast/) (Quicklinks JSON + Script Commands). App settings stay in Raycast cloud / Keychain.

Alternatives / décision 2026 (rester sur Raycast free) : [`conf/raycast/ALTERNATIVES.md`](../conf/raycast/ALTERNATIVES.md).

## Your side (after dotfiles update)

1. `just raycast-quicklinks` → Raycast **Import Quicklinks** → set aliases (`k`, `dl`, `gh`, …).
2. `just raycast-quicklinks work` → import work bundle → aliases `jira`, `gl`.
3. **Manage Script Commands** → add directory `~/dev/perso/dotfiles/conf/raycast/scripts` → aliases `jfmt`, `jmin`.
4. Install extensions: [`conf/raycast/extensions.md`](../conf/raycast/extensions.md) (waves 1–3).

`just raycast-quicklinks` only reveals JSON in Finder — it does not configure Raycast by itself.

## First-run setup

Settings (`Cmd+,` from Raycast) :

### Hotkeys

| Action | Hotkey | Pane |
|--------|--------|------|
| Open Raycast | `Cmd+Space` | General → Raycast Hotkey |
| Clipboard History | `Cmd+Shift+V` | Extensions → Clipboard History |

Disable Spotlight on `Cmd+Space` (System Settings → Keyboard → Shortcuts → Spotlight).

### Clipboard History

- *Ignore Password Managers* : ON
- Retention : 3 months (free)

### Quicklinks (import)

`just raycast-quicklinks` / `work` — see [`conf/raycast/README.md`](../conf/raycast/README.md).

| Alias | Name | Browser |
|-------|------|---------|
| `ff` | Open URL | Choosy (`x-choosy://open`) |
| `ffp` / `ffc` | Open clipboard URL | Choosy (script) |
| `gc` | Open URL | Chrome (work) |
| `gcp` | Open clipboard URL | Chrome (script) |
| `k` | Kagi | Choosy |
| `dl` | DeepL FR | Choosy |
| `gh` | GitHub | Choosy |
| `yt` | YouTube | Choosy |
| `npm` | NPM | Choosy |
| `mdn` | MDN | Choosy |
| `maps` | Google Maps | Choosy |
| `ama` | Amazon | Choosy |
| `obs` | Obsidian Main | Obsidian |
| `jira` | Jira search | Chrome |
| `gl` | GitLab search | Chrome |

Placeholder : `{argument}`.

### JSON clipboard

| Alias | Command |
|-------|---------|
| `json` | Store **Format JSON** → Format Clipboard JSON |
| `jfmt` | Script: Prettify JSON |
| `jmin` | Script: Minify JSON |

Copy JSON → run command → paste formatted result.

## Usage

| Cmd | Action |
|-----|--------|
| `Cmd+Space` | Launcher |
| `Cmd+Shift+V` | Clipboard history |
| `ff https://…` | Open URL via Choosy (rules + FF Dev default) |
| `ffp` / `ffc` | Open clipboard URL via Choosy |
| `gc https://…` | Open URL in Chrome |
| `gcp` | Open clipboard URL in Chrome |
| `k query` | Kagi (Choosy) |
| `dl text` | DeepL FR |
| `jfmt` / `jmin` | JSON prettify / minify clipboard |
| `Cmd+K` on result | Action panel |

## Extensions (install checklist)

See [`conf/raycast/extensions.md`](../conf/raycast/extensions.md).

| Wave | Extensions |
|------|------------|
| 1 | Format JSON, Brew, GitHub, Obsidian |
| 2 | GitLab, Jira, Bitwarden |
| 3 (test) | Notion, Language Tool, Menubar System Monitor |

**Perf:** extensions run on demand; disable unused commands. `glab`/`gp` stay for heavy GitLab work.

## What else

- **Snippets**, **Calculator**, **File search**, **Emoji** — built-in
- **Firefox (store):** **Mozilla Firefox → New Tab** (`f`) — extension prefs: **Firefox Developer Edition** + profil `dev-edition-default` (`just raycast-firefox-profile`) ; **Firefox Tabs** (`ft`) — add-on dans Dev Edition + bridge + `just raycast-firefox-patch`.
- **Chrome (work, store):** **Google Chrome → Search Tabs** — pas d’équivalent historique+onglets unifié côté Raycast.
- **Choosy:** `ff` / `ffp` / perso quicklinks use `x-choosy://open/…` (rules + Firefox Developer Edition fallback). Chrome work quicklinks still bypass Choosy.
- **Notion web:** Choosy → Chrome (`notion.so` / `www.notion.so`); Raycast Notion extension = API search/capture
- Skip Raycast Pro AI (use Cursor); AeroSpace for daily window layout

## Versioning

- No dotbot symlink for Raycast SQLite
- `conf/raycast/*.json` + `scripts/` = source of truth for Quicklinks / JSON tools
- Raycast account (free) syncs Quicklinks across machines

## Troubleshooting

- **Mozilla Firefox / New Tab — historique vide** — Extension prefs: app **Firefox Developer Edition**, suffix **`dev-edition-default`** (not Firefox + `default-release`). Run `just raycast-firefox-profile`.
- **`just raycast-quicklinks` exit 1** — missing JSON; pull dotfiles / check `conf/raycast/`
- **`Cmd+Space` dead** — disable Spotlight shortcut
- **Clipboard empty** — Raycast running + Launch at login
- **Auto-paste fails** — Accessibility → Raycast
- **Menubar monitor not visible** — open the Raycast command once, then command settings → **Pin to Menu Bar**
- **Still no reliable monitor in menu bar** — use `Stats` in the **visible** Ice zone (not hidden); see [`conf/mac-apps/README.md`](../conf/mac-apps/README.md) § Ice

## Related

- [clipboard.md](clipboard.md)
- [keyboard-navigation.md](keyboard-navigation.md)
- [glab.md](glab.md) · [bitwarden-cli.md](bitwarden-cli.md)
