# Mac App Configs

Exported via `defaults export`. To update after changing settings:

```bash
./mac-apps-export.sh
```

### Neovim as default text editor (Finder)

Requires `brew install duti` (in Brewfile). After dotbot:

```bash
mac-neovim-defaults          # apply (also run from install-mac if duti is installed)
mac-neovim-defaults --dry-run
```

Covers extensions (json, csv, yaml, md, …) and UTIs (`public.plain-text`, `public.source-code`, …). Override per file in Finder → Open With if needed (e.g. keep Obsidian for vault `.md` via Obsidian’s own association). Re-apply after Cursor claims types: `just mac-neovim-defaults`. Skips `svg` (preview in Chrome) and bare `ts` (video — see below).

### Video `.ts` vs TypeScript

On macOS, the extension **`.ts` is always `public.mpeg-2-transport-stream`** (MPEG transport), even for a file that contains TypeScript source. Finder cannot assign “video → IINA” and “code → Neovim” for the same extension.

| Goal | How |
|------|-----|
| Play `.ts` video files | `just mac-video-defaults` → **IINA** (also runs at end of `mac-neovim-defaults`) |
| Edit TypeScript | `nvim src/foo.ts` in WezTerm, or double-click **`.tsx`** (separate UTI; may still be Cursor until you change it) |

Do **not** set Neovim as default for `.ts` unless you want transport streams to open in the editor.

### Slack / Signal / Todoist — no login launch

`mac-comm-no-autostart` (also run from `install-mac`): removes legacy Login Items, sets Todoist `open_on_system_startup` to false. If apps still reopen after reboot, they were left running at logout (macOS session restore) — quit them before shutdown, or uncheck **Open at Login** in each app’s Dock menu.

## Apps

- **Neovim (bob)** — `Neovim-bob.app` → `~/Applications/Neovim.app`; default handler for text-like files via `duti` (`bin/mac-neovim-defaults`). CLI `nvim` stays on bob (`~/.local/share/bob/nvim-bin`); the `.app` is only for Finder / double-click / “Open With”.
- **Choosy** — browser routing rules (URL → browser). `gitlab.com` (incl. OAuth) → Chrome; `notion.so` → Chrome; unmatched URLs → prompt. Reload: `cp -f conf/mac-apps/choosy-behaviours.plist ~/Library/Application\ Support/Choosy/behaviours.plist` then restart Choosy.
- **SteerMouse** — mouse button/gesture mapping
- **LanguageTool** — spell/grammar checker preferences
- **Amphetamine** — keep-awake preferences (`amphetamine.plist`)
- **Ice** — menu bar manager (notch / MacBook without external display). **Stats** for CPU/RAM/network in the bar; Raycast menubar monitor is optional and click-to-detail.
- **Stats** — menu bar CPU / RAM / network (`conf/mac-apps/stats.plist`). Apply: `just mac-stats-defaults` (restarts Stats). Export after GUI tweaks: `./mac-apps-export.sh` or `mac-stats-defaults --export`.
- **Dracula RICE** — dark mode, purple accent, dock, wallpaper (`conf/theme/dracula.env`, Ship 4K). Apply: `just mac-appearance`. Checklist: [`DRACULA-RICE.md`](DRACULA-RICE.md).

### Ice (menu bar)

Install: `brew install --cask jordanbaird-ice@beta` (Tahoe / macOS 26; stable `jordanbaird-ice` conflicts — pick one).

**First-run (MacBook notch, no external display):**

1. Open **Ice** → enable **Launch at Login**.
2. `Cmd` + drag icons: **right of Ice’s separator** = always visible (keep **Stats**, Wi‑Fi, battery, Ice chevron minimal).
3. **Left of separator** = hidden until you click Ice’s chevron or hover (Raycast, Docker, Nextcloud, etc.).
4. **Always-hidden** section (Ice settings): printer/GPU/Steam helpers you never want to see.
5. **Stats**: CPU mini `utilization` (vert/orange/rouge), RAM mini `purple` + memory, Network speed ; re-apply: `just mac-stats-defaults`.

**With Stats + Raycast:** do not pin Raycast System Monitor for ambient metrics; use Stats in the visible zone. Raycast stays launcher + clipboard.

**Menu bar « centered » / flottante (Ice Appearance):** macOS ne permet pas de centrer les icônes dans la barre comme sur Linux. Ice peut seulement **imiter** une barre flottante :

1. Ice → **Menu Bar Appearance**
2. **Shape:** `Split` + **Rounded** edges
3. MacBook **avec encoche** : activer **Use inset shape on screens with notch** (barre détachée des bords de l’écran)
4. Tint discret `#282a36` ou `#44475a` si tu veux un bloc visible (tester lisibilité Tahoe / Liquid Glass)
5. **Menu Bar Item Spacing** (bêta) : ajuster l’espacement — pas un vrai centrage des icônes système

Sur écran externe sans encoche, la barre restera pleine largeur ; le look « pilule centrée » est surtout notch + inset.

Docs: [Ice repo](https://github.com/jordanbaird/Ice) · [Getting started](https://github.com/jordanbaird/Ice#usage)

**Later (not scheduled):** trial [Bartender 6](https://www.macbartender.com/) vs Ice — triggers, Bartender Bar, presets. Keep Ice + Stats until then; export/compare icon layout before switching.

### Window borders (borders / JankyBorders)

Fenêtre active : dégradé **violet → rose** ; inactive `#44475a`. Couleurs dans `conf/theme/dracula.env`. Si les bordures ont disparu :

```bash
just mac-borders
```

**Ne pas** `brew services start borders` (instance sans couleurs qui bloque la config dotfiles). Voir commentaire dans [`aerospace.toml`](../aerospace/aerospace.toml).

### Mouseless

Install: `brew install --cask mouseless` (bundle `net.sonuscape.mouseless`). Canonical config path:

`~/Library/Containers/net.sonuscape.mouseless/Data/.mouseless/configs/config.yaml`

Dotbot copies [`mouseless.yaml`](mouseless.yaml) there from `install-mac.conf.yaml`. After editing the file in this repo, re-run the install shell block or copy manually, then **restart Mouseless** (menu bar → Quit, reopen).

**Hotkeys** (see [`../aerospace/aerospace.toml`](../aerospace/aerospace.toml) for LCAG vs `Cmd+Alt`):

| Binding | Command |
|---------|---------|
| `Ctrl+Cmd+Alt+m` | Show overlay (**m** lowercase here; Mouseless docs prefer uppercase for alpha keys — if a letter binding fails, try **`M`**) |
| `Ctrl+Cmd+Alt+V` | Execute mouse move (uppercase **V** — required by Mouseless for letter keys) |
| `Ctrl+Cmd+Alt+Z` | Toggle free mode |
| `Cmd+Alt+K` / `Cmd+Alt+J` | Move overlay to previous / next monitor (**overlay must be visible**). **Not** LCAG — `Cmd+Alt` only. Uses home-row **J/K** (not bound in AeroSpace); change in YAML if a future layout conflicts. |

**AeroSpace:** `LCAG+←↑↓→` focuses windows again. While the Mouseless overlay is up, those keys go to Mouseless first, so there is no double action. When the overlay is **closed**, `LCAG+arrows` only affect AeroSpace. **`Cmd+Alt+↑/↓`** remains AeroSpace **focus monitor** (system); **`Cmd+Alt+J/K`** are reserved here for Mouseless overlay monitor cycling only.

`hold for move` stays **Option left** (see keymap in `mouseless.yaml`). Option **tap** is no longer bound (was conflicting with normal use).

**Free mode:** move the system cursor with arrow keys and scroll keys without the grid — for fine adjustment; toggle with **LCAG+Z**.

#### If the overlay / hotkey does nothing

1. **Mouseless is running** — check the menu bar icon. The app cannot add itself to Login Items (sandbox); add `Mouseless.app` under **System Settings → General → Login Items** if you want it at boot.
2. **Accessibility** — **System Settings → Privacy & Security → Accessibility** → enable **Mouseless**, then **quit and relaunch** the app (required after granting).

   macOS menu paths below are **English UI** names (Spotlight/search works in English even on a French system). French equivalents in parentheses when useful.
3. **Still broken after a macOS update or stuck state** — with Mouseless **fully quit**, remove Mouseless from the Accessibility list (`-`), launch again, accept the prompt, restart once more. (See [official troubleshooting](https://mouseless.click/docs/troubleshooting.html#hotkeys-dont-work-on-app-startup).)
4. **Secure Input** — if hotkeys stop while typing (e.g. password field), macOS can leave “secure input” on. In Mouseless: config editor → **Check Secure Input Status** (bottom). [Espanso explainer](https://espanso.org/docs/troubleshooting/secure-input/) for context; last resort: log out and back in.
5. **Conflict with another app** — Karabiner, Raycast, Alfred, BetterTouchTool, etc. can steal or reshape modifier chords. Try changing launch order or the `show overlay` binding in the in-app editor (Tab from overlay, or import YAML).
6. **Event tap / ordering** — if another utility also uses a low-level keyboard tap, try **System / debug → event tap location** in the config editor (`hid_head` vs alternatives; see tooltips). Official: [Conflicts with other utility apps](https://mouseless.click/docs/troubleshooting.html#conflicts-with-other-utility-apps).
7. **Debug** — run from Terminal to see logs:  
   `open -W --stdout $(tty) --stderr $(tty) --stdin $(tty) /Applications/Mouseless.app --args -d`  
   (`-p` / `--print-hid-events` also available — see [troubleshooting](https://mouseless.click/docs/troubleshooting.html#debug-modes)).

Docs: [Getting started](https://mouseless.click/docs/getting_started.html) · [Troubleshooting](https://mouseless.click/docs/troubleshooting.html) · [Customizing](https://mouseless.click/docs/customizing_mouseless.html).
