# neogit — Magit-style git for Neovim

> In-editor git workflow. Paired with `diffview.nvim` for full diff browsing. Replaces the old lazygit float as the primary git interface inside Neovim.
> Standalone TUI fallback (Cursor, plain shell): `gitui` ([cheatsheets/gitui.md](gitui.md)).

## Launch

| Key | Action |
|-----|--------|
| `<leader>gg` | Neogit status (main window) |
| `<leader>gC` | commit popup directly |
| `<leader>gl` | log view |
| `<leader>gp` | push popup |
| `<leader>gP` | pull popup |
| `<leader>gv` | DiffviewOpen (HEAD vs working tree) |
| `<leader>gV` | DiffviewFileHistory (current file) |
| `<leader>gx` | close Diffview |

Or commands: `:Neogit`, `:Neogit commit`, `:Neogit log`, `:DiffviewOpen`, `:DiffviewFileHistory %`.

## Status buffer

| Key | Action |
|-----|--------|
| `Tab` | toggle section fold |
| `s` | stage item (file / hunk / line in visual) |
| `S` | stage all unstaged |
| `u` | unstage item |
| `U` | unstage everything |
| `x` | discard item (with confirm) |
| `K` | untrack file |
| `Enter` | open file at cursor location |
| `<C-r>r` | refresh |
| `q` | close status |

## Popups (Magit-style transient menus)

Press the letter, then sub-options, then `Enter` to execute.

| Key | Popup |
|-----|-------|
| `c` | Commit (`cc` commit, `ca` amend, `cf` fixup, `cs` squash, `cw` reword) |
| `b` | Branch (`bc` create, `bb` checkout, `bn` checkout new, `br` rename, `bd` delete) |
| `m` | Merge (`mm` merge, `ma` abort) |
| `r` | Rebase (`ri` interactive, `rc` continue, `rs` skip, `ra` abort, `rf` autosquash) |
| `f` | Fetch |
| `F` | Pull |
| `P` | Push |
| `Z` | Stash (`Zz` stash, `Zp` pop, `Za` apply, `ZD` drop) |
| `l` | Log (`ll` current branch, `la` all, `lo` other) |
| `d` | Diff |
| `X` | Reset (`Xm` mixed, `Xs` soft, `Xh` hard) |
| `v` | Revert |
| `t` | Tag |
| `?` | Help (in any popup, lists sub-keys) |

## Commit popup

After `cc`:

1. A new buffer opens with the commit message template
2. Type the message (multi-line OK, supports `gq` to wrap)
3. `:wq` to commit, `:q!` to abort
4. `gitsigns` updates automatically

For amend / fixup / squash:

- `ca` — amend (reuse message or edit)
- `cf` — fixup (squashes into a selected commit, no message change)
- `cs` — squash into selected commit (rewrites message)
- `cw` — reword (no file changes)

## Diffview

Launched via `<leader>gv` / `<leader>gV`.

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | next / prev file in changed list |
| `gf` | go to file in editor |
| `<leader>e` | toggle file panel focus |
| `<leader>b` | toggle file panel visible |
| `g?` | help |
| `:DiffviewClose` or `<leader>gx` | close |

File history (`<leader>gV`):

- Shows all commits that touched the current file
- `<Enter>` on a commit opens the diff for that revision
- Navigate with `Tab`

## Hunk-level operations

Use `gitsigns` ([conf/nvim/lua/plugins/gitsigns.lua](../conf/nvim/lua/plugins/gitsigns.lua)) for inline hunk operations:

- `]h` / `[h` — next / prev hunk
- `<leader>hs` — stage hunk
- `<leader>hr` — reset hunk
- `<leader>hp` — preview hunk
- `<leader>hb` — blame line

Neogit's status buffer handles file-level operations and commit flow. Gitsigns handles in-buffer micro-edits while coding.

## When to use what (full stack)

| Need | Tool |
|------|------|
| Stage a single hunk while editing | gitsigns (`<leader>hs`) |
| Full staging / commit / rebase flow in nvim | neogit (`<leader>gg`) |
| Browse diff of a commit range | diffview (`<leader>gv`) |
| File history | diffview (`<leader>gV`) |
| Outside nvim (Cursor, plain terminal) | gitui (`gu`) |
| Browse / search commits with fuzzy | fzf-lua git commands (`<leader>gc`, `<leader>gb`) |

## Links

- Neogit: https://github.com/NeogitOrg/neogit
- Diffview: https://github.com/sindrets/diffview.nvim
