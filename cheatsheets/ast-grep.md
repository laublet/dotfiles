# ast-grep — structural search & replace

> **Help:** `sg --help` · `cheat ast-grep` · [ast-grep.github.io](https://ast-grep.github.io/)

> Search/refactor by **syntax tree**, not regex. Binary: **`sg`**. Install: `brew install ast-grep`.

## Quick picks (this dotfiles setup)

| Where | How |
|-------|-----|
| **Neovim** | `<leader>fs` pattern list → search project · `<leader>fS` → search file dir |
| **Neovim custom** | `<leader>fc` / `<leader>fC` type pattern manually |
| **Terminal** | `sg-pick` · `sg-pick --copy` · `sg-pick --run` |
| **Raycast** | **ast-grep pattern** → dropdown (no fzf) → copies `sg run …` |
| **Edit patterns** | [`conf/nvim/lua/ast-grep-patterns.lua`](../conf/nvim/lua/ast-grep-patterns.lua) |

After `just link`: `~/.local/bin/sg-pick`. Raycast: add script dir [`conf/raycast/scripts`](../conf/raycast/scripts) if not already.

---

## `sg run` — command

```bash
sg run -p '<PATTERN>' -l <LANG> [PATHS...]
```

| Flag | Meaning |
|------|---------|
| `-p` | AST pattern (metavariables below) |
| `-l` | Language: `ts`, `tsx`, `go`, `lua`, `rust`, `python`, `bash`, … |
| `[PATHS...]` | Files/dirs (default `.` = shell cwd) |
| `-r` | Rewrite matched nodes |
| `-i` | Interactive rewrite (confirm each) |
| `-U` | Apply all rewrites |
| `--json=pretty` | JSON output |
| `--files-with-matches` | Paths only (`rg -l` style) |

Example:

```bash
sg run -p 'console.log($$$)' -l ts src/ apps/api/
```

---

## Metavariables (placeholders)

| Syntax | Matches | Example pattern |
|--------|---------|-----------------|
| `$NAME` | **One** AST node (identifier, call, string, …) | `errors.New($MSG)` |
| `$$$` | **Zero or more** nodes (args, statements, …) | `console.log($$$)` |
| `$A, $B` | Several single nodes in fixed positions | `import $A from $B` |

Rules of thumb:

- Metavariable names are **UPPERCASE** (`$X`, `$MOD`, not `$x`).
- `$$$` = “rest of args / body / list”.
- Pattern must be **valid code** in the target language (parser understands structure).
- Literal punctuation (`(`, `{`, `;`) must match exactly.

### Cookbook

| Goal | Pattern | Lang |
|------|---------|------|
| Any `console.log` | `console.log($$$)` | `ts` |
| `fetch(url)` calls | `fetch($URL)` | `ts` |
| `useEffect` hooks | `useEffect($$$)` | `tsx` |
| `import x from 'y'` | `import $$$ from $SRC` | `ts` |
| Go `fmt.Println` | `fmt.Println($$$)` | `go` |
| Go errors | `errors.New($MSG)` | `go` |
| Go defer | `defer $EXPR` | `go` |
| Lua require | `require($MOD)` | `lua` |
| Neovim keymap | `vim.keymap.set($$$)` | `lua` |
| Rust unwrap | `$EXPR.unwrap()` | `rust` |
| Python print | `print($$$)` | `python` |
| Function decl (TS) | `function $NAME($$$) { $$$ }` | `ts` |
| Async function | `async function $NAME($$$) { $$$ }` | `ts` |
| Method call | `$OBJ.$METHOD($$$)` | `ts` |
| String literal only | `"$TEXT"` or `` `$TEXT` `` | `ts` |

### What does **not** match

| Pattern issue | Why |
|---------------|-----|
| Regex `console\.log` | Use text search (`rg`) instead |
| Wrong language `-l go` on `.ts` | Parser mismatch → no / wrong results |
| `$name` lowercase | Use `$NAME` |
| Partial invalid syntax | Pattern must parse as code |

---

## Scoping paths

```bash
sg run -p 'require($MOD)' -l lua conf/nvim/     # one tree
sg run -p 'fmt.Println($$$)' -l go ./...        # from repo root
sg run -p 'console.log($$$)' -l ts src/foo.ts   # one file
```

| Neovim | Scope |
|--------|--------|
| `<leader>fs` | `:pwd` (project cwd) |
| `<leader>fS` | Directory of current file (`%:h`) |
| `<leader>fc` / `fC` | Same scopes, pattern typed manually |

Default language: buffer filetype, else **`ts`**. Library patterns bring their own `lang`.

---

## Pattern library (built-in)

Defined in [`ast-grep-patterns.lua`](../conf/nvim/lua/ast-grep-patterns.lua). Add entries:

```lua
{
  name = "my rule",
  pattern = "someCall($$$)",
  lang = "go",
  desc = "short label in fzf",
},
```

| name | lang | pattern |
|------|------|---------|
| console.log | ts | `console.log($$$)` |
| import | ts | `import $$$ from $SRC` |
| fetch | ts | `fetch($URL)` |
| async fn | ts | `async function $NAME($$$) { $$$ }` |
| fmt.Println | go | `fmt.Println($$$)` |
| errors.New | go | `errors.New($MSG)` |
| context.With | go | `context.With$METHOD($$$)` |
| defer | go | `defer $EXPR` |
| go func | go | `go func($$$) { $$$ }($$$)` |
| require | lua | `require($MOD)` |
| vim.keymap | lua | `vim.keymap.set($$$)` |
| lazy plugin | lua | `{ "$PLUGIN", $$$ }` |
| unwrap | rust | `$EXPR.unwrap()` |
| println! | rust | `println!($$$)` |
| print | python | `print($$$)` |
| def | python | `def $NAME($$$):` |
| export | bash | `export $VAR=$VAL` |

---

## Rewrite (terminal)

```bash
# Preview matches only
sg run -p 'console.log($$$)' -l ts src/

# Interactive replace
sg run -p 'console.log($$$)' -r '' -l ts src/ -i

# Rename call shape
sg run -p 'oldApi($$$)' -r 'newApi($$$)' -l ts src/ -i
```

Neovim integration is **search + jump** only; bulk rewrite stays in the terminal.

---

## Terminal & Raycast

```bash
sg-pick                 # print: sg run --color=never -p '…' -l … .
sg-pick --copy          # copy full command (macOS clipboard)
sg-pick --pattern       # copy pattern only
sg-pick --run           # run and page results
```

**Raycast:** command **ast-grep pattern** — native **dropdown** (not `fzf`; Raycast has no TTY). After editing patterns: `just gen-raycast-sg`, then Raycast → reload script directory.

**Terminal `sg-pick`:** needs WezTerm/iTerm (`fzf`). Do not run via Raycast `fullOutput` — it spins forever.

**Snippets:** static text — duplicate of patterns; use dropdown script instead.

---

## vs ripgrep

| | `rg` (`<leader>ff`) | `sg` (`<leader>fs`) |
|---|---------------------|---------------------|
| Unit | Text / regex | Syntax tree |
| `console.log` in comment | Can match | No (not a call) |
| Speed | Very fast | Heavier (parser) |
| Refactor by shape | Fragile regex | Patterns + `-r` |

---

## Implementation notes

- Logic: [`conf/nvim/lua/utils/ast-grep.lua`](../conf/nvim/lua/utils/ast-grep.lua)
- `sg` output `path:line:text` → normalized to `path:line:col:text` for fzf-lua
- Keymaps live on [`fzf-lua`](../conf/nvim/lua/plugins/fzf-lua.lua) plugin spec

## Links

- [Languages](https://ast-grep.github.io/reference/languages.html)
- [Rule / strictness](https://ast-grep.github.io/guide/rule-config/atomic-rule.html)
- [Editors / LSP](https://ast-grep.github.io/guide/tools/editors.html)
- [ripgrep](ripgrep.md) · [neovim-ide](neovim-ide.md) · [raycast](raycast.md)
