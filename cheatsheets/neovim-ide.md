# Neovim — standalone IDE (replace Cursor / VSCode)

> **Help:** `:help` · `<leader>?` (all keymaps) · `Space` pause → which-key

> Primary editor on macOS + Linux. Cursor is no longer the target for compile links or daily TS work.
> Hub: [keymaps-hub.md](keymaps-hub.md) · Full map: [keyboard-navigation.md](keyboard-navigation.md#neovim-standalone)

## Mason (install once per machine)

```text
typescript-language-server   → ts_ls
eslint-lsp                   → eslint (needs eslint in project package.json)
lua-language-server          → lua_ls
gopls                        → Go LSP
ltex-ls                      → LTeX (grammar, on demand)
prettier / prettierd           → conform format (TS/JS/JSON/…)
stylua                       → Lua format
gofumpt                      → Go format
js-debug-adapter             → nvim-dap Node/TS
```

`:Mason` · `:MasonInstall <name>` · `:checkhealth vim.lsp` · `:Lazy sync` after dotbot

### Lint (oxlint + ESLint LSP)

| Layer | Role | Install |
|-------|------|---------|
| **oxlint** | Fast lint on save (style / common rules) | `brew install oxlint` · nvim: `lint.lua` |
| **eslint LSP** | Project `eslint.config` rules + code actions | Mason: `eslint-lsp` |
| **ts_ls** | Types (not replaced by oxlint) | Mason: `typescript-language-server` |

Repos without `oxlint.config.*` use oxlint defaults. Duplicate ESLint diagnostics are possible — oxlint is for speed; use ESLint LSP for fixes (`<leader>la` etc.).

First install: `:Lazy sync` (needs network; `nvim-lint` is pinned in `lazy-lock.json`). If clone fails: `cd ~/.local/share/nvim/lazy/nvim-lint && git fetch` or run `nvim --headless "+Lazy! sync" +qa` from a shell with git access.

## Daily workflow

| Task | Keys / command |
|------|----------------|
| Open file | `<C-p>` or `<leader>pp` |
| Buffers | `<leader>b` |
| Git status (full UI) | `<leader>gg` (Neogit) |
| Git status (quick fzf) | `<leader>gs` (fzf-lua) |
| Git hunk next / prev | `<leader>hn` / `<leader>hN` — repeat with `<leader>.` (leader dot) |
| Git hunk (vim repeat) | `]c` / `[c` then `;` / `,` (gitsigns; diff → vim `]c`) |
| Repeat last leader action | `<leader>.` after any wrapped map (gitsigns `h*` today) |
| Diff repo | `<leader>gd` / close `<leader>gx` |
| Format | `<leader>lf` or format-on-save |
| Lint list | `<leader>ud` (workspace) · `<leader>uD` (buffer) |
| Diagnostics jump | `]d` / `[d` |
| Tasks (npm / make) | `<leader>or` · list `<leader>ot` · restart `<leader>oR` |
| AI agent | `<leader>aa` ask · `<leader>at` sidebar · `<leader>ac` CLI split |
| Inline complete | Tab (Supermaven ghost, then cmp) |
| Clear search | `<leader>uc` |
| Yank path (abs / rel) | `<leader>yp` / `<leader>yr` |
| Registers (fzf) | `<leader>vr` — Enter = coller ; Ctrl-x = vider le registre |
| Marks vim (fzf) | `<leader>vm` — Enter = sauter ; Ctrl-x = effacer |
| Keystroke log (analyse) | actif au démarrage ; `<leader>uk` toggle ; `:NvimKeylogDisable` pour couper |

## Keystroke log (habitudes clavier)

Log JSONL : `~/.local/state/nvim-keylog.jsonl` (écriture bufferisée, pas de notif au boot).

| Commande / touche | Action |
|-------------------|--------|
| (démarrage) | Logging actif |
| `<leader>uk` | Toggle on/off |
| `:NvimKeylogDisable` | Stop + flush |
| `:NvimKeylogAnalyze` | Rapport dans une notif |
| `nvim-keylog-analyze` | Même analyse en terminal (`--since 2026-05-20` optionnel) |

> `<leader>vl` ne fait rien ici : `Space+v+lettre` = aide Vim (`v`+`l` = « right »). Pas de conflit avec registers (`vr`) / marks (`vm`).

## Harpoon (fichiers épinglés)

Liste courte par projet (cwd), indépendante de la liste de buffers. Persistée sur disque par repo.

| Key | Action |
|-----|--------|
| `<leader>ma` | Ajouter le fichier courant |
| `<leader>mm` | Menu (réordonner, supprimer une ligne, Enter = ouvrir) |
| `<leader>1` … `<leader>9` | Aller au slot |
| `<leader>mn` / `<leader>mp` | Slot suivant / précédent |

Workflow typique : ouvre 3–5 fichiers du ticket avec `<C-p>`, puis `<leader>ma` sur chacun. Ensuite tu navigues avec `<leader>1` etc. ; le reste des buffers peut être fermé (`<leader>q`) sans perdre tes épingles.

Dans le menu : `<C-v>` / `<C-x>` / `<C-t>` = split vertical / horizontal / tab.

Même convention dans les autres pickers/menus quand dispo (Oil, Neo-tree, ast-grep/fzf).
Création manuelle de split inchangée : `<leader>|` (vertical) et `<leader>-` (horizontal).

## Premier test (Jest ou Vitest)

1. Ouvre un repo avec `package.json` + `jest.config.*` ou `vitest.config.*`.
2. Ouvre un fichier `*.test.ts` (ou place le curseur dans un `it` / `test`).
3. `<leader>ct` — lance le test le plus proche.
4. Si échec : `<leader>co` (output) ou `<leader>cy` (summary) ; `<leader>cn` / `<leader>cN` entre les échecs.
5. Tout le fichier : `<leader>cf` · tout le package : `<leader>cS`.

L’adapter (jest vs vitest) est choisi automatiquement selon la config du repo.

## Tests (raccourcis)

| Key | Action |
|-----|--------|
| `<leader>ct` | Nearest test |
| `<leader>cf` | File |
| `<leader>cS` | Suite (cwd) |
| `<leader>cw` | Watch file |
| `<leader>co` | Output |
| `<leader>cp` | Output panel |
| `<leader>cn` / `<leader>cN` | Next / prev failure |
| `<leader>cy` | Summary |
| `<leader>cD` | Debug nearest test (DAP) |

Vitest adapter: `marilari88/neotest-vitest` (not `nvim-neotest/neotest-vitest`).

## Premier debug (Node / TypeScript)

1. `:MasonInstall js-debug-adapter` si pas déjà fait.
2. Ouvre un `.ts` / `.js` sauvegardé, racine workspace = dossier avec `package.json` ou `tsconfig.json`.
3. `<leader>db` sur une ligne — breakpoint.
4. **F5** ou `<leader>dc` — lance **Launch file** (fichier courant).
5. **F10** / **F11** / **F12** — step over / into / out ; **`<leader>dt`** pour arrêter.

**Attach** (API déjà lancée) : terminal `node --inspect-brk=9229 …`, puis F5 → config **Attach to port 9229**.

**Scripts npm** : ajoute `.vscode/launch.json` à la racine du repo (lu automatiquement par nvim-dap).

## Debug (raccourcis)

| Key | Action |
|-----|--------|
| F5 / `<leader>dc` | Continue / launch |
| F10 / `<leader>do` | Step over |
| F11 / `<leader>di` | Step into |
| F12 / `<leader>dO` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>du` | DAP UI |
| `<leader>dr` | REPL |
| `<leader>dt` | Terminate |
| `<leader>dl` | Re-run last configuration |

## Tasks (overseer)

| Key | Action |
|-----|--------|
| `<leader>or` | Pick & run task (`:OverseerRun`) |
| `<leader>ot` | Task list |
| `<leader>oR` | Restart last task |

Détecte automatiquement les scripts **npm** (`package.json`), **make**, et **`.vscode/tasks.json`**. Pour **just**, expose souvent des recipes via un `Makefile` ou ajoute des tasks VS Code.

## Go

Install toolchain: **macOS** `brew install go` (Brewfile) · **Linux desktop** `golang-go` via `packages-linux.sh desktop`.

| Key / command | Action |
|---------------|--------|
| `:MasonInstall gopls gofumpt` | LSP + formatter (after `go` on PATH) |
| `:TSInstall go` | Treesitter (ou `:TSUpdate`) |
| `<leader>lf` | `gofumpt` on save / manual format |

`gopls` s’attache sur `go.mod` / `go.work`. Binaires installés via `go install` → `$(go env GOPATH)/bin` (déjà dans le PATH zsh).

## Folds (treesitter)

Auto folds on functions/blocks (like VS Code). File opens **unfolded** (`foldlevelstart=99`).

| Key | Action |
|-----|--------|
| `za` | Toggle fold under cursor |
| `zc` / `zo` | Close / open fold |
| `zM` / `zR` | Close all / open all |

Requires treesitter parser for the filetype (`:TSInstall` if missing).

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
| Normal / terminal | `<leader>ux` |
| Insert | `<M-Esc>` |
| Refocus picker | `<leader>ur` |

## Validation (~1 semaine sur un repo pro TS)

Coche mentalement après une vraie journée de travail (pas une démo de 5 min) :

- [ ] LSP : `gd` / `gr`, diagnostics, `<leader>lf`, eslint sur un fichier `.ts`
- [ ] Test : `<leader>ct` sur un test qui passe et un qui échoue ; `<leader>co` pour lire l’erreur
- [ ] Debug : breakpoint + F5 sur un fichier ou test ; step F10/F11
- [ ] Git : `<leader>gg`, diff `<leader>gd`
- [ ] Tasks : `<leader>or` → `npm run test` ou script du repo
- [ ] Optionnel : Avante `<leader>aa` sur une petite refacto
- [ ] WezTerm : Cmd+clic sur une stack trace → bon fichier/ligne

Si un point bloque, note le symptôme dans Troubleshooting ci-dessous avant d’ajouter d’autres plugins.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `:LspInfo` unknown filetype jsx/tsx | Removed from eslint config — use `javascriptreact` / `typescriptreact` |
| ESLint silent | `npm i -D eslint` + config in repo |
| No oxlint diagnostics | `brew install oxlint` · `:Lazy sync` · reopen buffer |
| neotest-vitest not installed | `:Lazy sync` — dep is `marilari88/neotest-vitest` |
| Keychain popup on test run | Mac login password to unlock keychain; Git uses SSH / `gh auth`, not GitHub passkey |
| Neo-tree on startup | `persistence` restored session — `<leader>qd` then quit once |
| Overseer: no tasks | Open repo root with `package.json` or `Makefile` / `.vscode/tasks.json` |
| `<leader>cD` no-op | `:MasonInstall js-debug-adapter` ; jest/vitest adapter needs `dap = { enabled = true }` (already on) |
| gopls missing | `:MasonInstall gopls gofumpt` |
| `<leader>gs` Command failed `…/bob/…/nvim` | fzf-lua: never `multiprocess=false` on git.status (use `1` + `fn_*=false`). Fallback: `<leader>gg` (Neogit) |
| No fold markers | `:TSInstall <lang>` for buffer filetype |

## Optional later

- **Open in existing nvim** on Cmd+click (remote / socket)
- **Zed**: evaluate when feature-complete; same keymap hub applies

## Links

- Repo: https://github.com/neovim/neovim
- Dotfiles config: [`conf/nvim/`](../conf/nvim/)
- which-key spec: [`conf/nvim/lua/plugins/which-key.lua`](../conf/nvim/lua/plugins/which-key.lua)
