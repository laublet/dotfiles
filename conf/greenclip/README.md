# Clipboard Manager Setup

Cross-platform clipboard history with keyboard-centric workflow.

## macOS: Raycast Clipboard History

- **Install**: `brew install --cask raycast`
- **Hotkey**: `Cmd+Shift+V` (Raycast Settings → Extensions → Clipboard History)
- **Config**: not versioned (Raycast cloud sync, free tier OK)

Password managers auto-ignored. See [`cheatsheets/raycast.md`](../../cheatsheets/raycast.md) for full setup.

## Linux: Greenclip + Rofi

- **Install**: 
  ```bash
  # Arch
  yay -S greenclip
  
  # Ubuntu/Debian (download from GitHub releases)
  wget https://github.com/erebe/greenclip/releases/latest/download/greenclip
  chmod +x greenclip
  sudo mv greenclip /usr/local/bin/
  ```

- **Start daemon**: Add to autostart
  ```bash
  greenclip daemon &
  ```

- **Hotkey**: Bind `Ctrl+Shift+V` to `clipboard-rofi` in your WM/DE

- **Config**: `~/.config/greenclip.toml`

### Clear history
```bash
greenclip clear
```

### Rofi integration
The `clipboard-rofi` script launches rofi with greenclip as a modi.
