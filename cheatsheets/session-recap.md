# Session recap — new CLI tools (March 2026)

> Everything installed, configured and documented in one session.
> Take it tool by tool, don't try to learn everything at once.
> Run `cheat` to browse individual cheatsheets anytime.

## What changed

### New tools installed

| Tool | What it does | Try this right now |
|------|--------------|--------------------|
| **atuin** | Smart shell history (replaces Ctrl+R) | `Ctrl+R` then type a keyword |
| **dust** | Disk usage viewer (replaces du) | `dust` in any directory |
| **sd** | Find & replace (replaces sed) | `sd 'old' 'new' file.txt` |
| **just** | Task runner (replaces make) | `just` in the dotfiles repo |
| **tokei** | Count lines of code | `tokei` in any project |
| **procs** | Process viewer (replaces ps) | `procs node` to find node processes |
| **ouch** | Compress/decompress anything | `ouch d archive.tar.gz` |
| **btop** | System dashboard (replaces htop) | `btop` (Dracula + vim keys) |
| **bottom** | Lightweight system monitor | `btm` for a quick glance |
| **mise** | Runtime manager (replaced fnm+direnv) | `mise use node@22` |
| **zellij** | Terminal multiplexer (replaces tmux) | `zellij` to try locally |

### Config changes

- **zshrc**: atuin init, mise init, removed fnm + direnv
- **WezTerm**: Ctrl+Tab/T/W pass-through (fixes home-row mod conflicts)
- **atuin config**: Tab = copy to prompt (keymap fix)
- **btop config**: Dracula theme path fixed (no more hardcoded version)
- **Brewfile**: 11 new packages, removed fnm + direnv
- **install.conf.yaml**: symlinks for atuin, btop, mise, zellij configs
- **server/install.conf.yaml**: zellij replaces tmux
- **packages-linux.sh**: all new tools via cargo, mise via installer

### New files

- **justfile** at dotfiles root (run `just` to see recipes)
- **conf/zellij/config.kdl** (Dracula, Ctrl+a prefix, vim keys)
- **conf/atuin/config.toml**, **conf/btop/btop.conf**, **conf/mise/config.toml**
- **12 cheatsheets** in `cheatsheets/` (+ favorites system)

## Learning plan — one tool per day

### Day 1: atuin
Use `Ctrl+R` instead of arrow-up. Try typing partial commands.
Press `Ctrl+R` again inside atuin to cycle filter modes (global → host → directory).
Tab = edit before running. Enter = run immediately.

### Day 2: dust + ouch
Run `dust` in your home dir. Run `dust -d 2 ~/dev`.
Next time you need to extract something: `ouch d file.zip`.
Next time you compress: `ouch c dir/ archive.tar.gz`.

### Day 3: sd
Next time you'd use sed, try sd instead.
`sd 'console.log' 'logger.info' src/*.ts`
Use `-p` to preview without writing: `sd -p 'old' 'new' file`.

### Day 4: just
Run `just` in the dotfiles repo to see recipes.
Try `just stats` and `just size`.
Consider adding a `justfile` to your work projects.

### Day 5: mise
Run `mise ls` to see what's installed.
Go into a project with a `.nvmrc` — mise should pick it up.
Try `mise use python@3.12` in a project to add Python.

### Day 6: procs + tokei + btop
`procs` to see all processes. `procs docker` to filter.
`tokei` in a project for code stats.
`btop` for the full system dashboard (remember: vim keys with hjkl).

### Day 7: zellij
Run `zellij` locally to get familiar.
`Ctrl+a v` = split right, `Ctrl+a b` = split down.
`Ctrl+a h/j/k/l` = navigate. `Ctrl+a d` = detach.
`zellij attach` to reattach.

## Quick reference

```
cheat                    browse all cheatsheets (★ = favorites)
cheat → index.md         "I want to do X" → tool lookup
just                     list dotfiles tasks
just stats               lines of code in dotfiles
just size                disk usage of dotfiles
mise doctor              check mise health
atuin stats              your command history stats
atuin import auto        import zsh history (do this once)
```

## Don't forget

- `exec zsh` after editing zshrc to reload
- All configs are symlinked — edit in `~/.config/` and it's in the repo
- `btop`: activate vim_keys in options if not already on (Esc → Options)
- `atuin import auto` if you haven't imported your old history yet
