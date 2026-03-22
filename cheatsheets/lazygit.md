# lazygit — TUI git client

> Full git TUI. Alias: `lg`. Also available in Neovim via `Space lg`.

## Launch

```bash
lg                       # open lazygit in current repo
lazygit                  # same, no alias
```

In Neovim: `Space lg` opens lazygit in a floating window.

## Panels (navigate with numbers or Tab)

| Key | Panel |
|-----|-------|
| `1` | Status |
| `2` | Files (staging area) |
| `3` | Branches |
| `4` | Commits |
| `5` | Stash |

## Files panel (staging)

| Key | Action |
|-----|--------|
| `Space` | stage/unstage file |
| `a` | stage/unstage all |
| `Enter` | view file diff (then stage hunks) |
| `d` | discard changes |
| `e` | edit file in editor |
| `c` | commit |
| `A` | amend last commit |
| `i` | add to .gitignore |

## Hunk staging (inside file diff)

| Key | Action |
|-----|--------|
| `Space` | stage/unstage hunk |
| `v` | select lines for partial staging |
| `a` | stage/unstage all hunks in file |
| `Tab` | switch between staged/unstaged |

## Branches

| Key | Action |
|-----|--------|
| `n` | new branch |
| `Space` | checkout |
| `M` | merge into current |
| `r` | rebase current onto selected |
| `R` | rename |
| `d` | delete |
| `f` | fetch |
| `p` | pull |
| `P` | push |

## Commits

| Key | Action |
|-----|--------|
| `s` | squash into previous |
| `f` | fixup (squash, discard message) |
| `r` | reword commit message |
| `d` | drop commit |
| `p` | pick (during rebase) |
| `e` | edit commit |
| `c` | cherry-pick |
| `g` | reset to this commit |
| `Enter` | view commit diff |

## Stash

| Key | Action |
|-----|--------|
| `s` | stash (from files panel) |
| `Space` | apply stash |
| `g` | pop stash |
| `d` | drop stash |

## General

| Key | Action |
|-----|--------|
| `?` | help / keybindings |
| `/` | search |
| `+` / `-` | expand / collapse diff context |
| `[` / `]` | cycle through diff views |
| `q` | quit |
| `@` | command log |

## Links

- Repo: https://github.com/jesseduffield/lazygit
