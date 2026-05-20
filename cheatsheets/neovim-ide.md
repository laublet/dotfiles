# Neovim — standalone IDE (replace Cursor / VSCode)

> Primary editor on macOS + Linux. Cursor is no longer the target for compile links or daily TS work.
> Hub: [keymaps-hub.md](keymaps-hub.md) · Full map: [keyboard-navigation.md](keyboard-navigation.md#neovim-standalone)

## Mason (install once per machine)

```text
typescript-language-server   → ts_ls
eslint-lsp                   → eslint (needs eslint in project package.json)
lua-language-server          → lua_ls
ltex-ls                      → LTeX (grammar, on demand)
prettier / prettierd           → conform format
stylua                       → Lua format
js-debug-adapter             → nvim-dap Node/TS
```

`:Mason` · `:MasonInstall <name>` · `:checkhealth vim.lsp`

## Daily workflow

| Task | Keys / command |
|------|----------------|
| Open file | `<C-p>` or `<leader>pp` |
| Buffers | `<leader>b` |
| Git status | `<leader>gg` (Neogit) |
| Diff repo | `<leader>gv` / close `<leader>gx` |
| Format | `<leader>lf` or format-on-save |
| Lint list | `<leader>ud` (workspace) · `<leader>uD` (buffer) |
| Diagnostics jump | `]d` / `[d` |
| AI agent | `<leader>aa` ask · `<leader>at` sidebar · `<leader>ac` CLI split |
| Inline complete | Tab (Supermaven ghost, then cmp) |
| Clear search | `<leader>nh` |

## Debug (Node / TypeScript)

| Key | Action |
|-----|--------|
| F5 | Continue / launch |
| F10 / F11 / F12 | Step over / into / out |
| `<leader>db` | Toggle breakpoint |
| `<leader>du` | DAP UI |
| `<leader>dt` | Terminate |

`.vscode/launch.json` is read automatically (`:help dap-providers`). Add configs there for attach / npm scripts.

## Tests (Jest or Vitest — auto per repo)

| Key | Action |
|-----|--------|
| `<leader>ct` | Nearest test |
| `<leader>cf` | File |
| `<leader>cS` | Suite (cwd) |
| `<leader>cw` | Watch file |
| `<leader>co` | Output |
| `<leader>cn` / `<leader>cN` | Next / prev failure |
| `<leader>cy` | Summary |

Vitest adapter: `marilari88/neotest-vitest` (not `nvim-neotest/neotest-vitest`).

## WezTerm integration

**Cmd+click** on `src/foo.ts:42:10` in scrollback → `nvim +42` on that file (pane cwd). See [wezterm.md](wezterm.md#hyperliens-cliquables--filelinecol).

## AI layers (no overlap)

| Tool | Role |
|------|------|
| Avante (`<leader>a*`) | Agent / chat sidebar (cursor-agent ACP) |
| Supermaven | Inline ghost in **code** buffers only |
| nvim-cmp | Completion menu + snippets |

Supermaven is off for markdown, Avante buffers, neo-tree, oil.

## Floats stuck?

| Mode | Close floats |
|------|----------------|
| Normal / terminal | `<leader>Ux` |
| Insert | `<M-Esc>` |
| Refocus picker | `<leader>Ur` |

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `:LspInfo` unknown filetype jsx/tsx | Removed from eslint config — use `javascriptreact` / `typescriptreact` |
| ESLint silent | `npm i -D eslint` + config in repo |
| neotest-vitest not installed | `:Lazy sync` — dep is `marilari88/neotest-vitest` |
| Keychain popup on test run | Mac login password to unlock keychain; Git uses SSH / `gh auth`, not GitHub passkey |
| Neo-tree on startup | `persistence` restored session — `<leader>qd` then quit once |

## Next steps (not configured yet)

- **Go**: `gopls` + treesitter `go` + `gofumpt` when you start Go
- **Tasks**: `overseer.nvim` for `npm run …` / `just` from nvim
- **Open in existing nvim** on Cmd+click (remote / socket) — optional UX polish
- **Zed**: evaluate when feature-complete; same keymap hub applies
