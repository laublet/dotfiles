# just — command runner

> **Help:** `just --help` · `just --list`

> Replaces `make` for task running. Clean syntax, no tab issues, great error messages.

## How it works

Create a `justfile` (no extension) in your project root. Run tasks with `just <recipe>`.

```bash
just                                 # run default recipe
just <recipe>                        # run a specific recipe
just -l                              # list available recipes
just --choose                        # fzf picker for recipes
just --evaluate                      # show all variables
just --fmt                           # auto-format the justfile
just --dump                          # print the justfile
```

## Justfile syntax

```just
# Variables
editor := env("EDITOR", "nvim")

# Default recipe (runs when you type `just`)
default:
    @just -l

# Recipe with description (shows in `just -l`)
[doc("Install packages and link dotfiles")]
setup:
    ./bootstrap

# Recipe with arguments
greet name:
    @echo "Hello, {{name}}!"

# Recipe with dependencies
build: lint test
    cargo build --release

# OS-specific recipes
[linux]
install-deps:
    ./packages-linux.sh

[macos]
install-deps:
    brew bundle
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-l` / `--list` | list recipes with descriptions |
| `--choose` | interactive recipe picker (needs fzf) |
| `-n` / `--dry-run` | print commands without running |
| `--fmt` | format the justfile |
| `-f <file>` | use a specific justfile |
| `--set var value` | override a variable |

## Shell completions

```bash
# Already handled by brew (zsh completions installed automatically)
# For manual setup:
just --completions zsh > _just
```

## Links

- Repo: https://github.com/casey/just
- Docs: https://just.systems/man
