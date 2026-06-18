# CLI toolbox — what to use for what

> **Help:** `cheat` (fzf all sheets) · `cheat <name>`

> Quick reference: "I want to do X" → use this tool.
> Run `cheat <tool>` for the full cheatsheet of any tool listed here, or `tui` to fuzzy-launch a TUI directly.
> For TUI-by-task overview with launch contexts: [tui-guide.md](tui-guide.md).
> Terminal local (panes / tabs / workspaces / resurrect) : [wezterm.md](wezterm.md).
> Lab parallèle (Ghostty + Zellij) : [ghostty-lab.md](ghostty-lab.md).
> Keyboard shortcuts across apps: [keyboard-navigation.md](keyboard-navigation.md). Firefox: **Vimium** (active); Tridactyl paused — config + future hybrid notes: [tridactyl.md](tridactyl.md). Kyria QMK keymap — current → [kyria.md](kyria.md) ; next iteration design (FR/EN/ES, Arcane on thumbs) → [kyria-next.md](kyria-next.md).

## Launcher & clipboard

| I want to... | Command | Tool |
|--------------|---------|------|
| Launch app / search web (macOS) | `Cmd+Space` | [raycast](raycast.md) |
| Launch app (Linux) | `Super+Space` | [rofi](rofi.md) |
| Clipboard history | `Cmd+Shift+V` / `Ctrl+Shift+V` | [clipboard](clipboard.md) |
| Open URL (Choosy / Chrome) | `ff` / `gc` (URL) or `ffp`/`ffc` / `gcp` (clipboard) in Raycast | raycast |
| Search Kagi | `k query` in Raycast | raycast |
| Translate (DeepL) | `dl texte` in Raycast | raycast |
| Prettify / minify JSON (clipboard) | `jfmt` / `jmin` in Raycast | raycast |
| Jira / GitLab quick search | `jira` / `gl` in Raycast | raycast |
| Read / post Slack (macOS CLI) | `slk read general` · `slk send …` | [slkcli](slkcli.md) |
| Slack in terminal (full TUI) | `slk-tui` or `tui` | [slk-tui](slk-tui.md) |
| Manage windows (macOS) | `Ctrl+Cmd+Alt + arrows` | [aerospace](aerospace.md) |
| Hide menu bar clutter (notch MacBook) | Ice chevron / `Cmd`+drag icons | [`conf/mac-apps/README.md`](../conf/mac-apps/README.md) § Ice |
| System metrics in menu bar (macOS) | Stats modules (visible zone) | [`conf/mac-apps/README.md`](../conf/mac-apps/README.md) § Ice |
| Dracula RICE (wallpaper, accent, dark) | `just mac-appearance` | [mac-rice](mac-rice.md) |
| Move/click without mouse (macOS) | `Ctrl+Cmd+Alt+M` then grid keys | [mouseless](mouseless.md) |

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
| Browse cheatsheets | `cheat` | cheatsheets/ |
| Read markdown (pick tool) | `cheat markdown-reading` | [markdown-reading](markdown-reading.md) |
| Focus-read `.md` (terminal) | `readmd file.md` | [glum](glum.md) |
| Focus-read folder (browser) | `readweb [dir]` · `readvault` | [mdfocus](mdfocus.md) |
| Launch any installed TUI | `tui` | [tui-guide](tui-guide.md) |

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
| Structural diff (AST-aware) | `git dft` | [difftastic](difftastic.md) |
| Git TUI in Neovim | `<leader>gg` | [neogit](neogit.md) |
| Git TUI standalone (Cursor / shell) | `gu` | [gitui](gitui.md) |
| GitLab MR / CI from terminal | `gp` (glab-pick), `glab mr list`, `glab ci view` | [glab](glab.md) |
| Docker TUI client | `lzd` | lazydocker |
| HTTP client (TUI Postman) | `posting` | [posting](posting.md) |

## Develop

| I want to... | Command | Tool |
|--------------|---------|------|
| Go module / build / test | `go test ./...` | [go](go.md) |
| Go in Neovim (LSP, format) | open `go.mod` project | [neovim-ide](neovim-ide.md#go) |
| Fast TS/JS lint on save | open `.ts` in nvim | [neovim-ide](neovim-ide.md#lint-oxlint--eslint-lsp) (oxlint) |
| Structural code search (pattern list) | nvim `<leader>fs` · `sg-pick` · Raycast | [ast-grep](ast-grep.md) |
| Run several dev servers in one TUI | `mprocs` | [mprocs](mprocs.md) |
| Open large repo in Zed | `zed .` or `just zed` | [zed](zed.md) |
| Get a password for scripts | `bw get password Item` · `bwpick` · `bw-help` | [bitwarden-cli](bitwarden-cli.md) |
| Save / browse bookmarks (Karakeep) | extension + web UI · `cheat karakeep` | [karakeep](karakeep.md) |
| Compare bookmark / read-later apps | read doc | [bookmarks](bookmarks.md) |

## Benchmark, diff & explore data

| I want to... | Command | Tool |
|--------------|---------|------|
| Benchmark a command | `hyperfine 'cmd'` | [hyperfine](hyperfine.md) |
| Compare two commands | `hyperfine 'cmd-a' 'cmd-b' --warmup 3` | hyperfine |
| Structural diff (AST) | `git dft HEAD~1` | [difftastic](difftastic.md) |
| Explore a JSON payload | `cat file.json \| fx` | [fx](fx.md) |
| Query JSON one-shot (scriptable) | `jq '.field' file.json` | jq |

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
| Persistent terminal session | `zellij attach -c work` | [zellij](zellij.md) |
| Detach from session | `Ctrl+a d` | [zellij](zellij.md) |
| Split panes (Zellij) | `Cmd+D` (right) / `Cmd+Shift+D` (down) | [zellij](zellij.md) |
| Navigate panes (Zellij) | `Ctrl+arrows` | [zellij](zellij.md) |

## Everyday shortcuts

| Shortcut | What it does |
|----------|-------------|
| `ll` | detailed file listing (eza) |
| `lt` | tree view (eza) |
| `cat` | syntax-highlighted viewer (bat) |
| `z dir` | smart cd (zoxide) |
| `y` | file manager (yazi) |
| `gu` | gitui (standalone git TUI) |
| `lzd` | lazydocker |
| `v` | neovim — IDE guide: [neovim-ide.md](neovim-ide.md) |
| `just` | list dotfiles tasks |
| `cheat` | browse all cheatsheets |
| `Ctrl+R` | search history (atuin) |
| `Ctrl+T` | find file (fzf) |
| `Ctrl+F` | find directory (fzf) |

## Links

- Cheatsheets live in this repo: https://github.com/laublet/dotfiles/tree/master/cheatsheets
