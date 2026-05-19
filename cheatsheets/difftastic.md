# difftastic — structural diff

> AST-aware diff that understands syntax (JS/TS, JSON, YAML, Rust, Python, Go…). Complements `delta` (which prettifies line-based diffs). Use when refactors move blocks around and line-based diffs become noise.

## Standalone usage

```bash
difft fileA.ts fileB.ts                    # compare two files
difft --color=always file.json | bat       # pipe to pager
difft --display=side-by-side a.ts b.ts     # explicit side-by-side
difft --display=inline a.ts b.ts           # inline (default depends on width)
difft --context=2 a.ts b.ts                # show 2 lines of context (default 3)
```

## Git integration

This dotfiles repo defines a `dft` alias in [`conf/git/gitconfig`](../conf/git/gitconfig) that uses difftastic **on demand**, leaving `git diff` powered by delta as before.

```bash
git dft                                    # structural diff vs working tree
git dft --staged                           # structural diff of staged changes
git dft HEAD~1                             # vs previous commit
git dft main..feature                      # range
git dft -- src/                            # restrict to a path
```

Wrap as a tool too if you prefer `git difftool`:

```bash
git config --global diff.tool difftastic
git config --global difftool.difftastic.cmd 'difft "$LOCAL" "$REMOTE"'
git difftool                                # same as `git dft`, opt-in
```

## When to use what

| Situation | Tool |
|-----------|------|
| Daily review of small line edits | `git diff` (uses delta) |
| Big refactor moves blocks around | `git dft` |
| Reading a PR with renames | `git dft` |
| Reviewing JSON/YAML config drift | `git dft` |
| Reviewing a binary file or non-text | neither |

## Useful flags

| Flag | Effect |
|------|--------|
| `--color=always` / `auto` / `never` | force color |
| `--display=side-by-side` / `inline` / `side-by-side-show-both` | layout |
| `--context=N` | lines of context (default 3) |
| `--width=N` | force terminal width |
| `--missing-as-empty` | treat missing file as empty (file added/deleted) |
| `--check-only` | exit code only, no output (for scripts) |
| `--ignore-comments` | ignore comment-only changes |

## Limits

- Slower than delta on huge diffs (it parses an AST)
- Some languages have weaker grammar support — falls back to line-based
- Doesn't replace delta as a pager; delta is still your default

## Links

- Repo: https://github.com/Wilfred/difftastic
- Docs: https://difftastic.wilfred.me.uk/
