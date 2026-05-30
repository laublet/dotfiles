# gitui — standalone git TUI (Rust)

> **Help:** `?` in TUI · `gitui --help`

> Fast, keyboard-first git TUI. Replaces lazygit as the standalone git client in this setup. Alias: `gu`. In-editor git is handled by neogit ([cheatsheets/neogit.md](neogit.md)).

## Launch

```bash
gu                                         # alias
gitui                                      # explicit
gitui -d /path/to/repo                     # specific repo
gitui --bugreport                          # diagnostic info
```

## Tabs (top bar)

| Key | Tab |
|-----|-----|
| `1` | Status (staging) |
| `2` | Log |
| `3` | Files |
| `4` | Stashing |
| `5` | Stashes |
| `Tab` / `Shift+Tab` | next / prev tab |

## Status tab (staging)

| Key | Action |
|-----|--------|
| `Enter` | toggle stage / unstage (file or hunk) |
| `Space` | stage selected hunk / line |
| `D` | discard (with confirm) |
| `s` | stage all |
| `u` | unstage all |
| `c` | open commit popup |
| `Ctrl+s` | quick commit (skip popup) |
| `a` | amend last commit |
| `e` | open file in `$EDITOR` |
| `M` | merge popup |
| `R` | resolve conflicts |

## Commit popup

| Key | Action |
|-----|--------|
| Type the message | edit (multi-line with `Enter`) |
| `Ctrl+Enter` | commit |
| `Esc` | cancel |
| `Ctrl+s` | sign-off commit |

## Log tab

| Key | Action |
|-----|--------|
| `j` / `k` | next / prev commit |
| `Enter` | show commit details |
| `D` | diff against parent |
| `B` | open branches view |
| `R` | reset to selected commit |
| `r` | revert commit |
| `M` | mark for diff (then `M` again on another commit to diff range) |
| `c` | checkout |
| `t` | tag commit |
| `Shift+T` | tags overview |

## Branches (from `B` in log, or `b` global)

| Key | Action |
|-----|--------|
| `Enter` / `Space` | checkout |
| `c` | create new branch |
| `r` | rename |
| `D` | delete |
| `M` | merge into current |
| `R` | rebase current onto selected |
| `Ctrl+r` | remote branches view |

## Stashing

| Key | Action |
|-----|--------|
| `s` | stash (with message) |
| `Ctrl+s` | stash including untracked |
| `Enter` | apply (in stashes tab) |
| `p` | pop |
| `D` | drop |

## General

| Key | Action |
|-----|--------|
| `?` | help / key bindings |
| `/` | search (in log) |
| `q` / `Esc` | back / quit |
| `f` | fetch |
| `P` | push (with options) |
| `p` | pull |
| `h` | help |

## Config

Custom config in `~/.config/gitui/`:

- `key_bindings.ron` — override key bindings (Rust ron syntax)
- `theme.ron` — colors
- `style.ron` — UI density

Generate defaults:

```bash
gitui -p > ~/.config/gitui/key_bindings.ron
```

Note: this dotfiles repo doesn't yet ship a gitui config. Add one in `conf/gitui/` if you customize.

## When to use gitui vs neogit

| Need | Tool |
|------|------|
| Inside Neovim, vim-fluent flow | `neogit` |
| In Cursor / non-nvim terminal | `gitui` |
| Quick stage + commit, no editor open | `gitui` (`gu`) |
| Browse log with rich diff in vim | `neogit` + `:DiffviewOpen` |

## Links

- Repo: https://github.com/extrawurst/gitui
