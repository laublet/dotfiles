# Raycast alternatives (note for later)

Captured 2026-05 — revisit if Raycast Pro / theming / policy / free-tier limits push a move away from Raycast.

**Decision (2026-05):** stay on **Raycast free**. Alfred + Powerpack is not worth migrating today — see [Decision 2026](#decision-2026-stay-on-raycast-free) and [Alfred for this workflow](#alfred-for-this-workflow).

## What Raycast does here (not just launcher)

Raycast is a thin **orchestration hub** on top of a keyboard-first stack (AeroSpace, WezTerm, Neovim, Cursor, Choosy, CLI for heavy work).

| Role | Dotfiles / habit |
|------|------------------|
| Launcher | `Cmd+Space`, replaces Spotlight |
| Clipboard history | ex-Maccy, 3 months retention (free) |
| Quicklinks | `conf/raycast/quicklinks-*.json`, Choosy `ff` / Chrome `gc` |
| Script commands | `conf/raycast/scripts/` (`jfmt`, `jmin`, `sg`, …) |
| Extensions | [`extensions.md`](extensions.md) — Brew, GitHub, Firefox Dev, Obsidian, GitLab, Jira, … |
| Appearance | Free = follow macOS dark (`just mac-raycast-appearance`). Custom Dracula = **Pro only**. |

**Not delegated to Raycast:** window tiling (AeroSpace), AI (Cursor), reliable menu-bar metrics (Stats), deep GitLab/Jira (`glab`, `gp`), secrets (`bw`).

## Decision 2026: stay on Raycast free

| Criterion (priority) | Raycast today | Alfred + Powerpack (~46 € once) |
|----------------------|---------------|----------------------------------|
| Firefox Dev: open tabs from launcher | `ft` + add-on + `just raycast-firefox-patch` | Possible via [deanishe/alfred-firefox](https://github.com/deanishe/alfred-firefox) — **stale** (last release 2021), extension + native messaging, possible Rosetta on Apple Silicon |
| Firefox Dev: history while typing | `f` + profile `dev-edition-default` | `hist` (deanishe) or [alfred-firefox-bookmarks](https://github.com/FireFingers21/alfred-firefox-bookmarks) `bh` (maintained 2026) |
| Chrome work: tab switch | Store **Google Chrome → Search Tabs** | [epilande/alfred-browser-tabs](https://github.com/epilande/alfred-browser-tabs) (active 2026) — **only clear Alfred win** |
| Versioned quicklinks | `just raycast-quicklinks` + JSON | Manual port to Alfred custom searches / workflows |
| Dotfiles investment | High (`conf/raycast/`, `just raycast-*`) | Rebuild from scratch |
| Clipboard | Free, configured | Powerpack required |
| macOS / Linux parity | Raycast (mac) vs Rofi + Greenclip (Linux) | Alfred mac-only; diverges further from Linux setup |

**Verdict:** navigation Firefox (your #1 criterion) is **not better** on Alfred — same constraint (no AppleScript), weaker long-term maintenance than the current Raycast + dotfiles setup. Alfred mainly offers slightly faster app/file launch and a one-time license; that does not justify migration cost now.

## Alfred for this workflow

### What Alfred could add

| Benefit | Weight for this setup |
|---------|------------------------|
| Slightly faster app / file search | Low — much launching is WezTerm, AeroSpace, Neovim, `just` |
| One-time Powerpack purchase vs free Raycast | Medium psychologically, low practically (you already have clipboard + workflows free) |
| Mature Alfred workflows (Chrome tabs via epilande) | Medium for work Chrome only; Raycast store already covers it |
| Forum / Gallery workflows | Low — you prefer CLI (`glab`, `bw`, `brew`) for heavy tasks |

### What Alfred does not improve

- Choosy, AeroSpace, Cursor, Obsidian vault, `research-capture` — unchanged
- Quicklinks (`k`, `dl`, `ff`, `gh`, …) — **regression** without JSON import
- Firefox Dev integration — **equal or worse** (no `just raycast-firefox-patch` equivalent documented)
- Linux desktop parity — **worse** (Rofi stack on Pop!_OS)

### Alfred without Powerpack (no trial)

| Feature | Free Alfred | Powerpack |
|---------|-------------|-----------|
| Launch apps, files, calculator, web search | Yes | Yes |
| Import / run workflows (Firefox tabs, etc.) | **No** | Yes |
| Clipboard history | No | Yes |

You cannot benchmark **browser navigation** on Alfred without buying Powerpack (or using the trial). Free Alfred only allows a **launcher-only** comparison (`Cmd+Space` speed), not `tab` / `ft`-class behaviour.

### If migrating to Alfred later (navigation-first stack)

| Role | Tool |
|------|------|
| Launcher + clipboard | Alfred + Powerpack |
| Firefox Dev tabs | deanishe/alfred-firefox (`tab `) + Firefox extension |
| Firefox Dev history | FireFingers21 `bh` and/or deanishe `hist` |
| Chrome work tabs | epilande/alfred-browser-tabs |
| Quicklinks / Choosy | Alfred custom searches (manual port from `quicklinks-*.json`) |
| Scripts | Alfred Script Filter or keep `conf/raycast/scripts/` as shell + hotkeys |

## Navigation benchmark (reference)

### Firefox Developer Edition

| Capability | Raycast | Alfred |
|------------|---------|--------|
| Live open tabs | `ft` — Firefox Tabs + [Tab Manager add-on](https://addons.mozilla.org/en-US/firefox/addon/raycast-tab-manager/) + bridge + `just raycast-firefox-patch` | `tab ` — deanishe workflow + extension; Dev Edition supported; **one Firefox instance** at a time |
| History / omnibar-style | `f` — Mozilla Firefox extension → **New Tab** (`places.sqlite`) | `hist` (deanishe) or `bh` (FireFingers21, 2026, profile channel config) |
| Profile `dev-edition-default` | `just raycast-firefox-profile` | Configure in extension / workflow UI |
| Window focus behind launcher | Patched in dotfiles | Test on POC — may need custom fix |

**deanishe risks:** last release 2021; open issues (Alfred 5.5, Sequoia); [#47](https://github.com/deanishe/alfred-firefox/issues/47) — `Bad CPU type` on Apple Silicon → sometimes needs Rosetta.

### Chrome (work)

| Capability | Raycast | Alfred |
|------------|---------|--------|
| Tab search | Store extension | epilande (AppleScript, updated 2026) or [alfred-chromium-workflow](https://github.com/jopemachine/alfred-chromium-workflow) |

### Built-in Alfred Automation Tasks

List/switch tabs for **Chrome, Safari, Arc, Orion** (frontmost browser) — **not Firefox** (no AppleScript).

## 30-minute Alfred POC (only if a [re-evaluation trigger](#re-evaluation-triggers) fires)

Prerequisites: Alfred 5 + **Powerpack** (purchase or trial), **only** Firefox Developer Edition open for tab tests.

1. Install [Firefox-Assistant 0.2.2](https://github.com/deanishe/alfred-firefox/releases) → run `ffass` → Install Firefox Extension in Dev Edition.
2. Optional history: [Firefox Bookmarks](https://alfred.app/workflows/firefingers21/firefox-bookmarks/) — set release channel **Developer**, default profile = `dev-edition-default`.
3. Chrome work: [Browser-Tabs 1.0.8](https://github.com/epilande/alfred-browser-tabs/releases).
4. Hotkeys mirroring Raycast: `tab` (FF tabs), `bh` or `hist` (history), `chrome tabs` (work).

| # | Scenario | Pass? | Notes |
|---|----------|-------|-------|
| A | 5 FF tabs, search by title, Enter — window foreground? | | |
| B | Duplicate URL in two tabs — which wins? | | |
| C | 3 letters of yesterday’s page — open (vs Raycast `f`) | | |
| D | 10 Chrome work tabs — switch (vs Raycast) | | |
| E | After FF switch, `Cmd+Tab` — correct app? | | |

**Go Alfred:** A + C pass, E pass, no Rosetta, latency ≤ Raycast. **Stay on Raycast:** extension disconnects, focus broken, or deanishe unstable.

## Plausible replacements (single app)

| App | Fit | Cost |
|-----|-----|------|
| [Alfred](https://www.alfredapp.com/) | Closest “one hub”; workflows mature; **Firefox tabs via third-party workflow** | **Powerpack** (~46 € once) for clipboard + workflows |
| [LaunchBar](https://www.obdev.at/products/launchbar/) | Excellent Mac launcher / Instant Send | Paid license; weak vs extension-heavy setup |
| Spotlight only | Launcher only | Free, no extension store |

Not serious 1:1 replacements: Quicksilver (legacy), Ueli, Flow (too minimal). Sol / Monarch / SuperCmd — minimal extension ecosystems vs this dotfiles setup.

## Modular stack (avoid one “Raycast clone”)

| Need | Tool | Already in dotfiles? |
|------|------|----------------------|
| Launcher | Alfred / LaunchBar / Spotlight | — |
| Clipboard | [Maccy](https://github.com/p0deje/Maccy) | Was replaced by Raycast |
| Browser routing | Choosy | Yes (`conf/mac-apps/`) |
| Window manager | AeroSpace | Yes |
| Menu bar metrics | Stats + Ice | Yes |
| Scripts / URLs | `just`, shell, Keyboard Maestro | Partial |

## Migration cost (if leaving Raycast)

Highest friction = **re-wiring extensions**, not the hotkey:

- Firefox Dev Edition + tab search → Alfred workflow or CLI + Firefox extension (same class of problem as Raycast)
- Quicklinks JSON → Alfred snippets / custom searches (no automatic import)
- GitLab / Jira / Brew UI → workflows or terminal (`glab`, `gh`, `brew`)
- Script Commands directory → Alfred scripts or shell + hotkeys
- Clipboard habits → Maccy or Alfred Powerpack

## Re-evaluation triggers

Revisit this doc when **any** of:

1. Raycast **free tier** blocks you (clipboard retention, feature removed, perf regression).
2. **Firefox Raycast** extensions break often and maintaining `just raycast-firefox-patch` + add-on is no longer acceptable.
3. You want a **one-time purchase** and accept **2–3 days** to port quicklinks + scripts + Alfred workflows.
4. **App/file launch via Raycast** frustrates you daily (not monthly).

Until then: **stay on Raycast free**; keep investing in `conf/raycast/` not `conf/alfred/`.

## Stay on Raycast free (checklist)

Reasonable while:

- Dark built-in + rest of desktop is Dracula (`just mac-appearance`, Ship wallpaper)
- Extension store + dotfiles quicklinks worth more than theme Pro
- Clipboard 3-month retention is enough
- Firefox Dev `f` / `ft` + patch remain stable

## Commands today

```bash
just mac-raycast-appearance   # free dark (follow system)
just raycast-quicklinks       # import quicklinks (Raycast UI)
just raycast-quicklinks work  # work Chrome quicklinks
just raycast-firefox-profile  # FF Dev profile hint for Mozilla Firefox extension
just raycast-firefox-patch    # foreground Dev Edition on tab switch
```

See also: [`cheatsheets/raycast.md`](../../cheatsheets/raycast.md), [`cheatsheets/mac-rice.md`](../../cheatsheets/mac-rice.md), [`README.md`](README.md).
