# Clipboard manager

Cross-platform clipboard history with keyboard-centric workflow.

## Hotkey

Same on both platforms: **Shift+V** with main modifier.

| Platform | Hotkey |
|----------|--------|
| macOS | `Cmd+Shift+V` |
| Linux | `Ctrl+Shift+V` |

## macOS: Maccy

Lightweight clipboard manager.

```bash
brew install --cask maccy
```

### Features
- Clipboard history (default 200 items)
- Search in history
- Pin items
- Ignore apps (password managers configured)

### Ignored apps
Configured to ignore: 1Password, Bitwarden, KeePassXC, LastPass, Keychain.

### Config
Exported to `conf/mac-apps/maccy.plist`. To update after changes:

```bash
defaults export org.p0deje.Maccy ~/dev/perso/dotfiles/conf/mac-apps/maccy.plist
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

## Related

- Launcher: [albert.md](albert.md)
