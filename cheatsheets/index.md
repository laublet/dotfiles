# CLI toolbox — what to use for what

> Quick reference: "I want to do X" → use this tool.
> Run `cheat <tool>` for the full cheatsheet of any tool listed here.
> Keyboard shortcuts across apps: [keymaps-hub.md](keymaps-hub.md) → [keyboard-navigation.md](keyboard-navigation.md). Firefox + Tridactyl (by task): [tridactyl.md](tridactyl.md).

## Launcher & clipboard

| I want to... | Command | Tool |
|--------------|---------|------|
| Launch app / search web (macOS) | `Cmd+Space` | [albert](albert.md) |
| Launch app (Linux) | `Super+Space` | [rofi](rofi.md) |
| Clipboard history | `Cmd+Shift+V` / `Ctrl+Shift+V` | [clipboard](clipboard.md) |
| Search Kagi | `k query` in Albert | albert |
| Translate (DeepL) | `tr texte` in Albert | albert |
| Manage windows (macOS) | `Ctrl+Cmd+Alt + arrows` | [aerospace](aerospace.md) |

## Find & navigate

| I want to... | Command | Tool |
|--------------|---------|------|
| Find a file by name | `fd pattern` | fd |
| Find a file interactively | `Ctrl+T` | fzf |
| Search text in files | `rg pattern` | ripgrep |
| Search + open in editor | `rgf pattern` | ripgrep+fzf |
| Jump to a recent directory | `z partial-name` | zoxide |
| Jump to a directory interactively | `Ctrl+F` | fzf |
| Browse files visually | `y` | yazi |
| Find previous command | `Ctrl+R` | atuin |

## View & inspect

| I want to... | Command | Tool |
|--------------|---------|------|
| View a file with syntax highlighting | `cat file` (aliased to bat) | bat |
| View a file with pager | `catp file` | bat |
| See disk usage (what's eating space) | `dust` | dust |
| Count lines of code | `tokei` | tokei |
| See running processes | `procs` or `procs keyword` | procs |
| Full system dashboard | `btop` | btop |
| Lightweight system monitor | `btm` | bottom |
| See git diff nicely | `git diff` (uses delta) | delta |
| Git TUI client | `lg` | lazygit |
| Docker TUI client | `lzd` | lazydocker |

## Edit & transform

| I want to... | Command | Tool |
|--------------|---------|------|
| Find & replace in files | `sd 'old' 'new' file` | sd |
| Find & replace across many files | `fd -e py \| xargs sd 'old' 'new'` | fd + sd |
| Rename with regex in bulk | `fd pattern \| xargs sd ...` | fd + sd |
| Preview a replacement before applying | `sd -p 'old' 'new' file` | sd |

## Compress & decompress

| I want to... | Command | Tool |
|--------------|---------|------|
| Extract any archive | `ouch d archive.tar.gz` | ouch |
| Create an archive | `ouch c files/ out.tar.gz` | ouch |
| List archive contents | `ouch l archive.zip` | ouch |

## Dev environment

| I want to... | Command | Tool |
|--------------|---------|------|
| Install a Node version | `mise use node@22` | mise |
| Install a Python version | `mise use python@3.12` | mise |
| Set per-project env vars | `.mise.toml` → `[env]` section | mise |
| Set global tool version | `mise use --global node@22` | mise |
| See installed tool versions | `mise ls` | mise |
| Run project tasks | `just` or `mise run task` | just / mise |

## Server / remote

| I want to... | Command | Tool |
|--------------|---------|------|
| Persistent terminal session | `zellij attach -c work` | zellij |
| Detach from session | `Ctrl+a d` | zellij |
| Split panes (remote) | `Ctrl+a v` (right) / `Ctrl+a b` (down) | zellij |
| Navigate panes (remote) | `Ctrl+a h/j/k/l` | zellij |

## Everyday shortcuts

| Shortcut | What it does |
|----------|-------------|
| `ll` | detailed file listing (eza) |
| `lt` | tree view (eza) |
| `cat` | syntax-highlighted viewer (bat) |
| `z dir` | smart cd (zoxide) |
| `y` | file manager (yazi) |
| `lg` | lazygit |
| `lzd` | lazydocker |
| `v` | neovim |
| `just` | list dotfiles tasks |
| `cheat` | browse all cheatsheets |
| `Ctrl+R` | search history (atuin) |
| `Ctrl+T` | find file (fzf) |
| `Ctrl+F` | find directory (fzf) |
