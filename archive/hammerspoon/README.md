# Hammerspoon — archived (2026)

**Replaced by** `on-focus-changed = ['move-mouse window-lazy-center']` in `conf/aerospace/aerospace.toml`. Hammerspoon removed from Brewfile / install-mac.

---

# Hammerspoon — focus warp (historical)

Moved the pointer to the center of the focused window so the Kyria encoder scroll hits the focused app (macOS sends wheel events to the window under the cursor). **Cursor hide was disabled** — `CGDisplayHideCursor` / `NSCursor` did not work on this Mac.

## Setup (once)

1. `brew install --cask hammerspoon`
2. Dotbot mac install (symlink `~/.hammerspoon` + `~/.local/bin/mac-cursor`)
3. **System Settings → General → Login Items** → add **Hammerspoon**
4. **Accessibilité** (si le toggle ne « prend » pas) :
   - Terminal : `tccutil reset Accessibility org.hammerspoon.Hammerspoon`
   - Quitte Hammerspoon, relance depuis `/Applications/Hammerspoon.app` (pas une autre copie).
   - Réglages Système → Confidentialité et sécurité → **Accessibilité** → Hammerspoon **ON**.
   - Console HS : doit afficher `Hammerspoon accessibility: true`.
   - En dernier recours : redémarrage du Mac, puis refaire les étapes ci-dessus.
5. Reload config: Hammerspoon menu bar → Reload Config, ou `hs.reload()`

`window.filter` n’est pas utilisé (évite les erreurs `hs.axuielement` au reload). Détection focus via `application.watcher` + polling léger.

AeroSpace only keeps `on-focused-monitor-changed` (monitor warp fallback). Per-window warp+hide is handled here (`CGDisplayHideCursor` + delayed re-hide after warp; pointer returns on `mouseMoved`).

## WezTerm splits

macOS sees one WezTerm window — pointer warps to window center, not per split. WezTerm config still re-hides on pane switch.
