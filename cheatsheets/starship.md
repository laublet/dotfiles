# starship — cross-shell prompt

> **Help:** `starship explain` · `starship --help`

> Customizable prompt with git info, vi-mode indicator, language versions, etc.

## How it works

Starship runs at each prompt render. It detects your context and shows relevant info:
- Git branch + status (ahead/behind, dirty, staged)
- Language versions when in a project (Node, Python, Rust, etc.)
- Vi mode indicator (normal/insert)
- Command duration (for slow commands)
- Exit code of last command

## Configuration

Config file: `~/.config/starship/starship.toml` (symlinked from dotfiles)

```bash
# Edit config
nvim ~/.config/starship/starship.toml

# Check what starship detects
starship explain         # show which modules are active and why

# Preview with a different config
STARSHIP_CONFIG=/path/to/test.toml starship prompt
```

## Useful commands

```bash
starship explain         # show active modules
starship timings         # show how long each module takes to render
starship module git_branch  # render just one module
starship preset          # list presets
```

## Links

- Repo: https://github.com/starship/starship
- Config reference: https://starship.rs/config/
- Presets: https://starship.rs/presets/
