# Raycast extensions — install checklist (macOS)

Config lives in Raycast only (Keychain / cloud). **Never** commit API tokens here.

Full launcher doc: [`cheatsheets/raycast.md`](../../cheatsheets/raycast.md).

## Performance

- Extensions run **on demand** (no permanent background worker per extension).
- Idle cost ≈ Raycast menu bar app (~50–120 MB RAM).
- Heavy commands (large note/contact lists) can spike briefly or hit JS heap limits — disable unused subcommands (`⌥ ⌫`).
- Install in **waves** (below); check Activity Monitor → `Raycast` if curious.

## Wave 1 — daily

| Extension | Store search | Auth | Alias hint |
|-----------|--------------|------|------------|
| Format JSON | `Format JSON` (destiner) | — | `json` on « Format Clipboard JSON » |
| Homebrew | `Brew` | — | `brew` |
| GitHub | `GitHub` | OAuth | `gh` |
| Obsidian | `Obsidian` | Vault **Main** (`~/dev/perso/vaults/Main`) | `obs` (extension; Quicklink also in firefox JSON) |
| Mozilla Firefox | `Mozilla Firefox` (crisboarna) | Lit `places.sqlite` | `f` on **New Tab**. **Configure Extension:** app **Firefox Developer Edition** (not Firefox), suffix **`dev-edition-default`** (`just raycast-firefox-profile`) |
| Firefox Tabs | `Firefox Tabs` (stephen_lau) | Add-on [Raycast Tab Manager](https://addons.mozilla.org/en-US/firefox/addon/raycast-tab-manager/) + **Setup Firefox Bridge** | `ft` on **Search Firefox Tabs** ; puis `just raycast-firefox-patch` si Dev Edition reste derrière Raycast |

## Wave 2 — work

| Extension | Store search | Auth | Notes |
|-----------|--------------|------|-------|
| GitLab | `GitLab` (tonka3000) | PAT `gitlab.com` | Prefer **Chrome** for open-in-browser; complements `glab` / `gp` |
| Google Chrome | `Google Chrome` | — | **Search Tabs** for work tab switch (no dotfiles script) |
| Jira | `Jira` | Host `https://neok.atlassian.net` + API token | Same Chrome preference |
| Bitwarden | `Bitwarden` | App unlocked | Complements `bw` CLI — no secrets in Quicklinks |

Import work Quicklinks: `just raycast-quicklinks work` → **Import Quicklinks** → aliases `jira`, `gl` (optional).

## Wave 3 — try and keep or drop

| Extension | Store search | Auth | Notes |
|-----------|--------------|------|-------|
| Notion | `Notion` | Integration token in Raycast | Choosy sends `notion.so` web to Chrome |
| Language Tool | `Language Tool` (lucastaonline) | LanguageTool API if needed | Spell/grammar on text; network call per use |
| Menubar System Monitor | `Menubar System Monitor` | — | If the icon does not show, open the command and enable **Pin to Menu Bar** in command settings |

## Script Commands (versioned)

1. Raycast → **Manage Script Commands** → **Add Script Directory**
2. Path: `~/dev/perso/dotfiles/conf/raycast/scripts` (absolute path)
3. Aliases: `jfmt` (Prettify JSON), `jmin` (Minify JSON)

Requires clipboard JSON before running; output back to clipboard.

## After install

- **Settings → Quicklinks** → set aliases from [`README.md`](README.md)
- Hide/disable unused extension commands
- **Prefer Existing Tabs** ON (Settings → Quicklinks) if you like
- Clipboard: **Ignore Password Managers** ON
- For **Menubar System Monitor**: run the command once, then set **Pin to Menu Bar**.

## Menu bar fallback (recommended)

If Raycast menubar commands are flaky after updates/restarts, use the native macOS app **Stats** (`brew install --cask stats`) as the persistent monitor in the top bar.

## Coexistence

| Tool | Keep using |
|------|------------|
| MR/CI deep work | `glab`, `gp` ([`cheatsheets/glab.md`](../../cheatsheets/glab.md)) |
| Vault passwords | `bw`, Bitwarden app ([`cheatsheets/bitwarden-cli.md`](../../cheatsheets/bitwarden-cli.md)) |
| Window tiling | AeroSpace ([`cheatsheets/aerospace.md`](../../cheatsheets/aerospace.md)) |
| AI / code | Cursor (skip Raycast Pro AI) |
