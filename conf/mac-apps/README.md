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

Covers extensions (json, csv, yaml, md, …) and UTIs (`public.plain-text`, `public.source-code`, …). Override per file in Finder → Open With if needed (e.g. keep Obsidian for vault `.md` via Obsidian’s own association).

## Apps

- **Neovim (bob)** — `Neovim-bob.app` → `~/Applications/Neovim.app`; default handler for text-like files via `duti` (`bin/mac-neovim-defaults`). CLI `nvim` stays on bob (`~/.local/share/bob/nvim-bin`); the `.app` is only for Finder / double-click / “Open With”.
- **Choosy** — browser routing rules (URL → browser)
- **SteerMouse** — mouse button/gesture mapping
- **LanguageTool** — spell/grammar checker preferences
- **Amphetamine** — keep-awake preferences (`amphetamine.plist`)
- **Hidden Bar** — hide menu bar icons (no config, just install)

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

1. **Mouseless is running** — check the menu bar icon. The app cannot add itself to Login Items (sandbox); add `Mouseless.app` under System Settings → General → Login Items if you want it at boot.
2. **Accessibility** — System Settings → Privacy & Security → Accessibility → enable **Mouseless**, then **quit and relaunch** the app (required after granting).
3. **Still broken after a macOS update or stuck state** — with Mouseless **fully quit**, remove Mouseless from the Accessibility list (`-`), launch again, accept the prompt, restart once more. (See [official troubleshooting](https://mouseless.click/docs/troubleshooting.html#hotkeys-dont-work-on-app-startup).)
4. **Secure Input** — if hotkeys stop while typing (e.g. password field), macOS can leave “secure input” on. In Mouseless: config editor → **Check Secure Input Status** (bottom). [Espanso explainer](https://espanso.org/docs/troubleshooting/secure-input/) for context; last resort: log out and back in.
5. **Conflict with another app** — Karabiner, Raycast, Alfred, BetterTouchTool, etc. can steal or reshape modifier chords. Try changing launch order or the `show overlay` binding in the in-app editor (Tab from overlay, or import YAML).
6. **Event tap / ordering** — if another utility also uses a low-level keyboard tap, try **System / debug → event tap location** in the config editor (`hid_head` vs alternatives; see tooltips). Official: [Conflicts with other utility apps](https://mouseless.click/docs/troubleshooting.html#conflicts-with-other-utility-apps).
7. **Debug** — run from Terminal to see logs:  
   `open -W --stdout $(tty) --stderr $(tty) --stdin $(tty) /Applications/Mouseless.app --args -d`  
   (`-p` / `--print-hid-events` also available — see [troubleshooting](https://mouseless.click/docs/troubleshooting.html#debug-modes)).

Docs: [Getting started](https://mouseless.click/docs/getting_started.html) · [Troubleshooting](https://mouseless.click/docs/troubleshooting.html) · [Customizing](https://mouseless.click/docs/customizing_mouseless.html).
