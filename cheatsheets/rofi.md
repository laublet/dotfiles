# Rofi — launcher & clipboard (Linux)

Application launcher with greenclip integration for clipboard history.

## Launch

Bind these in your window manager:

| Action | Command | Suggested binding |
|--------|---------|-------------------|
| App launcher | `rofi -show drun` | `Super+Space` |
| Clipboard history | `rofi -modi "clipboard:greenclip print" -show clipboard` | `Ctrl+Shift+V` |
| Window switcher | `rofi -show window` | `Super+Tab` |
| Run command | `rofi -show run` | `Super+R` |

## In-rofi navigation

| Key | Action |
|-----|--------|
| `↑` / `Ctrl+K` | Previous item |
| `↓` / `Ctrl+J` | Next item |
| `Enter` | Select |
| `Escape` / `Ctrl+G` | Cancel |
| `Ctrl+Space` | Toggle item selection (multi-select) |

## Config

- Main config: `~/.config/rofi/config.rasi`
- Theme: `~/.config/rofi/dracula.rasi`

## Greenclip setup

```bash
# Start daemon (add to autostart)
greenclip daemon &

# Clear history
greenclip clear
```

Config: `~/.config/greenclip.toml`

## Customization

Edit `config.rasi`:
```css
configuration {
    font: "FiraCode Nerd Font 14";
    show-icons: true;
    terminal: "wezterm";
}
```

## macOS equivalent

On macOS, use **Raycast** for both launcher (`Cmd+Space`) and clipboard (`Cmd+Shift+V`).

See [raycast.md](raycast.md) and [clipboard.md](clipboard.md).
