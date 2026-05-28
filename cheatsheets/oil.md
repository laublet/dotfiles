# oil.nvim — buffer-based file explorer

> **Help:** `g?` in oil buffer · `:help oil.nvim`

> Complements neo-tree (sidebar tree = orientation). Use oil for **manipulation**: rename, create, move, bulk edits. The directory is a normal Neovim buffer — modify the lines, `:w` to apply.
> No debounced renderer, no race conditions: oil cannot trigger the E95 bug that affects neo-tree's `follow_current_file`.

## Launching

| Key (normal mode) | Action |
|-------------------|--------|
| `g-` | Open Oil at the parent directory of the current buffer (vinegar style) |
| `<leader>O` | Open Oil in a floating window (modal) |
| `:Oil` | Same as `g-` (current file's parent dir) |
| `:Oil --float` | Same as `<leader>O` |
| `:Oil /some/path` | Open a specific directory |

For browsing the project tree visually (orientation), use neo-tree (`<leader>e`). Oil is for **doing things to files**, not for staying open as a panel.

When you launch `nvim <dir>`, Oil hijacks netrw and opens the directory as an Oil buffer.

## Inside Oil

| Key | Action |
|-----|--------|
| `j` / `k` | Move (standard vim) |
| `<CR>` | Open file / descend into directory |
| `<C-v>` | Open in vertical split |
| `<C-x>` | Open in horizontal split |
| `<C-t>` | Open in new tab |
| `<C-p>` | Preview file (toggle) |
| `<C-l>` | Refresh listing |
| `-` | Go to parent directory (only inside an Oil buffer) |
| `_` | Open cwd as Oil listing (only inside an Oil buffer) |
| `` ` `` | `:cd` into current Oil directory (global) |
| `~` | Same but tab-local (`:tcd`) |
| `gs` | Cycle sort order |
| `gx` | Open under cursor with system default (macOS `open`) |
| `g.` | Toggle hidden files |
| `g\` | Toggle trash view (see deleted-to-trash files) |
| `g?` | Show help / list all bindings |
| `q` / `<C-c>` | Close Oil |

## Editing the filesystem like a buffer

This is the killer feature: change the buffer text, then `:w`.

| You do… | Result on save |
|---------|----------------|
| Edit a line `foo.txt` → `bar.txt` | Rename `foo.txt` to `bar.txt` |
| Delete a line | Move to trash (config: `delete_to_trash = true`) |
| Duplicate a line (yank+paste) | Copy that file/dir |
| Add a new line `newfile.ts` | Create empty file `newfile.ts` |
| Add a new line `subdir/` | Create directory `subdir/` |
| Cut a line and paste it in another Oil buffer | Move file between directories |

A confirmation preview is shown before applying (`skip_confirm_for_simple_edits = false`). Cancel with `n`, confirm with `y`.

## Workflow examples

### Rename a file

```text
1. <leader>O          → Oil opens floating
2. Find `oldname.ts`  → press `cw`, type `newname`, `<Esc>`
3. :w                 → preview "rename oldname.ts → newname.ts" → y
```

### Create a nested file

```text
1. <leader>O
2. o (open new line below)
3. Type `src/utils/helper.ts`
4. :w
```

Oil creates intermediate directories automatically.

### Bulk rename (visual block / multi-line)

```text
1. <leader>O on a dir with `IMG_0001.jpg ... IMG_0042.jpg`
2. Visual block: select column 0–4, `c`, type `photo` → applies to all
3. :w
```

That's the kind of refactor neo-tree just cannot do.

### Move files between directories

```text
1. Open Oil in dir A:                <leader>O
2. Visually select lines, yank:      Vjjy
3. Navigate to dir B:                press `-` then <CR> on B
4. Paste:                            p
5. Save:                             :w  → confirms moves
```

## Tips

- The Oil buffer is just a regular buffer — undo (`u`) works on filesystem edits **before** `:w`. After `:w`, use `:OilUndo` (limited; not real fs undo).
- Use `g.` to flip hidden files quickly when you need to edit a `.gitignore` or dotfile.
- Use `<C-p>` preview when scanning unknown files (markdown, JSON, etc.) — closes when you move off.
- For tree-style browsing with previews (images, video thumbnails), use [`yazi`](yazi.md) (`y` in the shell).
- For fuzzy-finding a specific file across the project, use fzf-lua (`<leader>ff`) — Oil is for filesystem manipulation, not picking.

## Links

- Repo: https://github.com/stevearc/oil.nvim
- Why buffer-based file explorers (Tim Pope's vinegar legacy): https://github.com/stevearc/oil.nvim#why-buffer
