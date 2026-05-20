# Clipboard manager

Cross-platform clipboard history with keyboard-centric workflow.

## Hotkey

Same on both platforms: **Shift+V** with main modifier.

| Platform | Hotkey | Tool |
|----------|--------|------|
| macOS | `Cmd+Shift+V` | [Raycast](raycast.md) (Clipboard History) |
| Linux | `Ctrl+Shift+V` | Greenclip + Rofi |

## macOS: Raycast Clipboard History

Built into Raycast (free tier, 3-month retention). Replaces Maccy, which was abandoned because auto-paste was broken on macOS Tahoe ([Maccy#1381](https://github.com/p0deje/Maccy/issues)).

### Setup

Full Raycast setup (hotkeys, Quicklinks, extensions) : [raycast.md](raycast.md). For clipboard specifically :

1. Raycast Settings (`Cmd+,`) → Extensions → **Clipboard History**.
2. Hotkey : `Cmd+Shift+V`.
3. *Ignore Password Managers* : ON.
4. Accessibility permission required for auto-paste : System Settings → Privacy & Security → Accessibility → Raycast.

Raycast's auto-paste actually works on Tahoe (unlike Maccy) — pick an item, Enter, it paste into the focused app immediately.

### Usage

```
Cmd+Shift+V                 → open clipboard history
type to fuzzy filter
Enter                       → paste into focused app
Cmd+K on item               → action menu (pin, delete, copy as plain)
```

## Linux: Greenclip + Rofi

Daemon-based clipboard manager with rofi integration.

### Install

```bash
# Arch
yay -S greenclip

# Ubuntu/Debian
wget https://github.com/erebe/greenclip/releases/latest/download/greenclip
chmod +x greenclip
sudo mv greenclip /usr/local/bin/
```

### Start daemon

Add to autostart:
```bash
greenclip daemon &
```

### Usage

Bind `Ctrl+Shift+V` to `clipboard-rofi` script in your WM:

```bash
~/.local/bin/clipboard-rofi
```

### Commands

```bash
greenclip clear          # Clear history
greenclip print          # Print history (used by rofi)
```

### Config

`~/.config/greenclip.toml`:
- `max_history_length`: Number of items to keep
- `blacklisted_applications`: Apps to ignore (password managers)

## Fallback si Raycast déçoit (macOS)

**Pastebot** (Tapbots, $9.99 one-time) — clipboard manager standalone signé Developer ID, donc immune au bug Tahoe qui a tué Maccy. Polished, smart transformations (URL clean, casse, etc.), filters par app, sync iCloud. C'est *le* clipboard recommandé par les power users macOS depuis ~5 ans. À évaluer si :
- Raycast clipboard hit la limite des 3 mois et c'est gênant, ou
- Raycast plante un workflow critique, ou
- Tu switches de launcher vers Alfred et veux un clipboard séparé.

Install : `brew install --cask pastebot` quand le moment vient. Pas dans Brewfile tant que Raycast suffit.

## Related

- Launcher (macOS) : [raycast.md](raycast.md)
- Launcher (Linux) : [rofi.md](rofi.md)
